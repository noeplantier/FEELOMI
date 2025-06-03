import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/// Enum des langues disponibles dans l'application
enum AppLanguage {
  french,
  english,
  spanish,
  german,
  italian;
  
  /// Récupérer le code de langue pour l'internationalisation
  String get languageCode {
    switch (this) {
      case AppLanguage.french: return 'fr';
      case AppLanguage.english: return 'en';
      case AppLanguage.spanish: return 'es';
      case AppLanguage.german: return 'de';
      case AppLanguage.italian: return 'it';
    }
  }
  
  /// Obtenir le nom localisé de la langue
  String get displayName {
    switch (this) {
      case AppLanguage.french: return 'Français';
      case AppLanguage.english: return 'English';
      case AppLanguage.spanish: return 'Español';
      case AppLanguage.german: return 'Deutsch';
      case AppLanguage.italian: return 'Italiano';
    }
  }
  
  /// Créer depuis le code de langue
  static AppLanguage fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'fr': return AppLanguage.french;
      case 'es': return AppLanguage.spanish;
      case 'de': return AppLanguage.german;
      case 'it': return AppLanguage.italian;
      default: return AppLanguage.english;
    }
  }
}

/// Enum des thèmes disponibles dans l'application
enum AppThemeMode {
  system,
  light,
  dark;
  
  /// Obtenir le nom lisible du thème
  String get displayName {
    switch (this) {
      case AppThemeMode.system: return 'Système';
      case AppThemeMode.light: return 'Clair';
      case AppThemeMode.dark: return 'Sombre';
    }
  }
}

/// Structure des paramètres utilisateur
@JsonSerializable(explicitToJson: true)
class UserSettings extends Equatable {
  /// Activer/désactiver les notifications
  final bool notificationsEnabled;
  
  /// Heures pour les rappels quotidiens (format 24h: "08:00", "21:00", etc.)
  final List<String> reminderTimes;
  
  /// Thème préféré de l'application
  @JsonKey(
    toJson: _themeToJson,
    fromJson: _themeFromJson,
  )
  final AppThemeMode theme;
  
  /// Langue préférée
  @JsonKey(
    toJson: _languageToJson,
    fromJson: _languageFromJson,
  )
  final AppLanguage language;
  
  /// Activer/désactiver le mode privé (données sensibles masquées)
  final bool privateMode;
  
  /// Convertir le thème en chaîne
  static String _themeToJson(AppThemeMode theme) => theme.name;
  
  /// Créer le thème à partir d'une chaîne
  static AppThemeMode _themeFromJson(String value) {
    return AppThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
  
  /// Convertir la langue en code
  static String _languageToJson(AppLanguage language) => language.languageCode;
  
  /// Créer la langue à partir d'un code
  static AppLanguage _languageFromJson(String value) => AppLanguage.fromCode(value);
  
  /// Constructeur
  const UserSettings({
    this.notificationsEnabled = true,
    this.reminderTimes = const ['09:00', '21:00'],
    this.theme = AppThemeMode.system,
    this.language = AppLanguage.french,
    this.privateMode = false,
  });
  
  /// Paramètres par défaut
  factory UserSettings.defaultSettings() => const UserSettings();

  @override
  List<Object?> get props => [
    notificationsEnabled,
    reminderTimes,
    theme,
    language,
    privateMode,
  ];
  
  /// Crée une copie avec des valeurs modifiées
  UserSettings copyWith({
    bool? notificationsEnabled,
    List<String>? reminderTimes,
    AppThemeMode? theme,
    AppLanguage? language,
    bool? privateMode,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      privateMode: privateMode ?? this.privateMode,
    );
  }
  
  /// Conversion depuis JSON
  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
  
  /// Conversion vers JSON
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
  
  Map<String, dynamic> _$UserSettingsToJson(UserSettings userSettings) {}
}

class _$UserSettingsFromJson {
  _$UserSettingsFromJson(Map<String, dynamic> json);
}

/// Structure des métriques de l'utilisateur
@JsonSerializable(explicitToJson: true)
class UserMetrics extends Equatable {
  /// Nombre total d'entrées émotionnelles
  final int totalEmotionEntries;
  
  /// Nombre total d'enregistrements d'habitudes
  final int totalHabitRecords;
  
  /// Jours consécutifs d'utilisation
  final int streakDays;
  
  /// Date de la dernière entrée
  @JsonKey(
    toJson: _dateTimeToJson,
    fromJson: _dateTimeFromJson,
  )
  final DateTime lastEntryDate;
  
  /// Convertir DateTime en Timestamp
  static Timestamp _dateTimeToJson(DateTime date) => Timestamp.fromDate(date);
  
  /// Créer DateTime à partir de Timestamp ou autre format
  static DateTime _dateTimeFromJson(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is Map) {
      // Gestion des formats JSON avec secondes et nanosecondes
      return Timestamp(
        value['_seconds'] as int,
        value['_nanoseconds'] as int,
      ).toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    }
    // Valeur par défaut
    return DateTime.now();
  }
  
  /// Constructeur
  const UserMetrics({
    this.totalEmotionEntries = 0,
    this.totalHabitRecords = 0,
    this.streakDays = 0,
    DateTime? lastEntryDate,
  }) : lastEntryDate = lastEntryDate ?? DateTime.now();
  
  /// Métriques par défaut
  factory UserMetrics.defaultMetrics() => UserMetrics();
  
  @override
  List<Object?> get props => [
    totalEmotionEntries,
    totalHabitRecords,
    streakDays,
    lastEntryDate,
  ];
  
  /// Crée une copie avec des valeurs modifiées
  UserMetrics copyWith({
    int? totalEmotionEntries,
    int? totalHabitRecords,
    int? streakDays,
    DateTime? lastEntryDate,
  }) {
    return UserMetrics(
      totalEmotionEntries: totalEmotionEntries ?? this.totalEmotionEntries,
      totalHabitRecords: totalHabitRecords ?? this.totalHabitRecords,
      streakDays: streakDays ?? this.streakDays,
      lastEntryDate: lastEntryDate ?? this.lastEntryDate,
    );
  }
  
  /// Mettre à jour les métriques lors d'une nouvelle entrée émotionnelle
  UserMetrics incrementEmotionEntry() {
    final now = DateTime.now();
    final dayDiff = now.difference(lastEntryDate).inDays;
    
    // Calculer la nouvelle streak en fonction de la date de la dernière entrée
    int newStreak = streakDays;
    if (dayDiff <= 1) {
      // Maintenir ou incrémenter la streak si l'entrée est pour aujourd'hui
      // ou si la dernière entrée était hier
      final isLastEntryToday = lastEntryDate.year == now.year && 
                              lastEntryDate.month == now.month && 
                              lastEntryDate.day == now.day;
      if (!isLastEntryToday) {
        newStreak += 1;
      }
    } else {
      // Reset streak si plus d'un jour d'inactivité
      newStreak = 1;
    }
    
    return copyWith(
      totalEmotionEntries: totalEmotionEntries + 1,
      streakDays: newStreak,
      lastEntryDate: now,
    );
  }
  
  /// Mettre à jour les métriques lors d'un nouvel enregistrement d'habitude
  UserMetrics incrementHabitRecord() {
    return copyWith(
      totalHabitRecords: totalHabitRecords + 1,
    );
  }
  
  /// Conversion depuis JSON
  factory UserMetrics.fromJson(Map<String, dynamic> json) => _$UserMetricsFromJson(json);
  
  /// Conversion vers JSON
  Map<String, dynamic> toJson() => _$UserMetricsToJson(this);
}

Map<String, dynamic> _$UserMetricsToJson(UserMetrics userMetrics) {
  return {
    'totalEmotionEntries': userMetrics.totalEmotionEntries,
    'totalHabitRecords': userMetrics.totalHabitRecords,
    'streakDays': userMetrics.streakDays,
    'lastEntryDate': UserMetrics._dateTimeToJson(userMetrics.lastEntryDate),
  };
}

/// Classe principale du profil utilisateur
@JsonSerializable(explicitToJson: true)
class UserProfile extends Equatable {
  /// Identifiant unique de l'utilisateur
  final String id;
  
  /// Adresse email de l'utilisateur
  final String email;
  
  /// Nom d'affichage de l'utilisateur
  final String? displayName;
  
  /// URL de la photo de profil
  final String? photoUrl;
  
  /// Date de création du compte
  @JsonKey(toJson: _timestampToJson, fromJson: _timestampFromJson)
  final DateTime createdAt;
  
  /// Dernière connexion
  @JsonKey(toJson: _timestampToJson, fromJson: _timestampFromJson)
  final DateTime lastLogin;
  
  /// Statut premium
  final bool isPremium;
  
  /// Date d'expiration de l'abonnement premium
  @JsonKey(toJson: _nullableTimestampToJson, fromJson: _nullableTimestampFromJson)
  final DateTime? premiumExpiry;
  
  /// Paramètres utilisateur
  final UserSettings settings;
  
  /// Métriques utilisateur
  final UserMetrics metrics;

  /// Convertir DateTime en Timestamp
  static Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
  
  /// Convertir DateTime nullable en Timestamp nullable
  static Timestamp? _nullableTimestampToJson(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }
  
  /// Créer DateTime à partir de Timestamp ou autre format
  static DateTime _timestampFromJson(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is Map) {
      // Gestion des formats JSON avec secondes et nanosecondes
      return Timestamp(
        value['_seconds'] as int,
        value['_nanoseconds'] as int,
      ).toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    }
    // Valeur par défaut
    return DateTime.now();
  }
  
  /// Créer DateTime nullable à partir de Timestamp ou autre format
  static DateTime? _nullableTimestampFromJson(dynamic value) {
    if (value == null) return null;
    return _timestampFromJson(value);
  }
  
  /// Constructeur
  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.lastLogin,
    this.isPremium = false,
    this.premiumExpiry,
    UserSettings? settings,
    UserMetrics? metrics,
  }) : 
    settings = settings ?? const UserSettings(),
    metrics = metrics ?? UserMetrics();
  
  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    createdAt,
    lastLogin,
    isPremium,
    premiumExpiry,
    settings,
    metrics,
  ];
  
  /// Crée une copie avec des valeurs modifiées
  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isPremium,
    DateTime? premiumExpiry,
    UserSettings? settings,
    UserMetrics? metrics,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
      settings: settings ?? this.settings,
      metrics: metrics ?? this.metrics,
    );
  }
  
  /// Création d'un nouveau profil à partir d'une authentification
  factory UserProfile.create({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName ?? email.split('@').first,
      photoUrl: photoUrl,
      createdAt: now,
      lastLogin: now,
    );
  }
  
  /// Mise à jour de la connexion
  UserProfile updateLogin() {
    return copyWith(lastLogin: DateTime.now());
  }
  
  /// Activation du statut premium
  UserProfile activatePremium(Duration duration) {
    final expiry = DateTime.now().add(duration);
    return copyWith(
      isPremium: true,
      premiumExpiry: expiry,
    );
  }
  
  /// Vérifier si le premium est actif
  bool get isPremiumActive {
    if (!isPremium) return false;
    if (premiumExpiry == null) return true; // Premium à vie sans expiration
    return premiumExpiry!.isAfter(DateTime.now());
  }
  
  /// Jours restants de l'abonnement premium
  int? get remainingPremiumDays {
    if (!isPremium || premiumExpiry == null) return null;
    final diff = premiumExpiry!.difference(DateTime.now());
    return diff.isNegative ? 0 : diff.inDays + 1; // +1 pour inclure le jour actuel
  }
  
  /// Créer une instance depuis un document Firestore
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      createdAt: data['createdAt'] is Timestamp 
          ? (data['createdAt'] as Timestamp).toDate() 
          : _timestampFromJson(data['createdAt']),
      lastLogin: data['lastLogin'] is Timestamp 
          ? (data['lastLogin'] as Timestamp).toDate() 
          : _timestampFromJson(data['lastLogin']),
      isPremium: data['isPremium'] as bool? ?? false,
      premiumExpiry: data['premiumExpiry'] != null 
          ? (data['premiumExpiry'] is Timestamp 
              ? (data['premiumExpiry'] as Timestamp).toDate() 
              : _nullableTimestampFromJson(data['premiumExpiry']))
          : null,
      settings: data['settings'] != null 
          ? UserSettings.fromJson(data['settings'] as Map<String, dynamic>)
          : null,
      metrics: data['metrics'] != null 
          ? UserMetrics.fromJson(data['metrics'] as Map<String, dynamic>)
          : null,
    );
  }
  
  /// Conversion depuis JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  
  /// Conversion vers JSON
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
  
  /// Conversion vers format Firestore
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    
    // Supprimer l'ID (géré séparément par Firestore)
    json.remove('id');
    
    return json;
  }
  
  /// Obtenir les initiales de l'utilisateur pour l'avatar
  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    
    final parts = displayName!.split(' ');
    if (parts.length >= 2) {
      return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
    } else {
      return parts.first.substring(0, 1).toUpperCase();
    }
  }
  
  /// Mettre à jour les métriques pour une nouvelle entrée émotionnelle
  UserProfile addEmotionEntry() {
    return copyWith(
      metrics: metrics.incrementEmotionEntry(),
    );
  }
  
  /// Mettre à jour les métriques pour un nouvel enregistrement d'habitude
  UserProfile addHabitRecord() {
    return copyWith(
      metrics: metrics.incrementHabitRecord(),
    );
  }
  
  /// Vérifie si l'utilisateur est actif récemment
  bool get isActiveRecently {
    final daysSinceLastLogin = DateTime.now().difference(lastLogin).inDays;
    return daysSinceLastLogin < 7;
  }
}