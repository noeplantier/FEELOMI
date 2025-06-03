import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emotion_entry.g.dart';

/// Classe représentant les données d'une émotion
@JsonSerializable(explicitToJson: true)
class EmotionData extends Equatable {
  /// Émotion primaire ressentie
  final String primary;
  
  /// Émotion secondaire (optionnelle)
  final String? secondary;
  
  /// Intensité de l'émotion sur une échelle de 1 à 10
  final int intensity;

  /// Constructeur
  const EmotionData({
    required this.primary,
    this.secondary,
    required this.intensity,
  });

  @override
  List<Object?> get props => [primary, secondary, intensity];

  /// Crée une instance d'EmotionData depuis un map
  factory EmotionData.fromJson(Map<String, dynamic> json) => _$EmotionDataFromJson(json);

  /// Convertit l'instance en map
  Map<String, dynamic> toJson() => _$EmotionDataToJson(this);

  /// Crée une copie avec des valeurs modifiées
  EmotionData copyWith({
    String? primary,
    String? secondary,
    int? intensity,
  }) {
    return EmotionData(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      intensity: intensity ?? this.intensity,
    );
  }
}

/// Classe représentant les données contextuelles d'une entrée émotionnelle
@JsonSerializable(explicitToJson: true)
class ContextData extends Equatable {
  /// Localisation où l'émotion a été ressentie (optionnelle)
  @JsonKey(toJson: _geoPointToJson, fromJson: _geoPointFromJson)
  final GeoPoint? location;
  
  /// Météo au moment de l'entrée (optionnelle)
  final String? weather;
  
  /// Activité en cours (optionnelle)
  final String? activity;
  
  /// Contexte social (optionnel)
  final String? socialContext;

  /// Constructeur
  const ContextData({
    this.location,
    this.weather,
    this.activity,
    this.socialContext,
  });

  /// Convertit un GeoPoint en Map pour la sérialisation JSON
  static Map<String, dynamic>? _geoPointToJson(GeoPoint? geoPoint) {
    if (geoPoint == null) return null;
    return {
      'latitude': geoPoint.latitude,
      'longitude': geoPoint.longitude,
    };
  }

  /// Convertit un Map en GeoPoint pour la désérialisation JSON
  static GeoPoint? _geoPointFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return GeoPoint(
      json['latitude'] as double,
      json['longitude'] as double,
    );
  }

  @override
  List<Object?> get props => [location, weather, activity, socialContext];

  /// Crée une instance de ContextData depuis un map
  factory ContextData.fromJson(Map<String, dynamic> json) => _$ContextDataFromJson(json);

  /// Convertit l'instance en map
  Map<String, dynamic> toJson() => _$ContextDataToJson(this);

  /// Crée une copie avec des valeurs modifiées
  ContextData copyWith({
    GeoPoint? location,
    String? weather,
    String? activity,
    String? socialContext,
  }) {
    return ContextData(
      location: location ?? this.location,
      weather: weather ?? this.weather,
      activity: activity ?? this.activity,
      socialContext: socialContext ?? this.socialContext,
    );
  }
  
  /// Vérifie si les données de contexte sont vides
  bool get isEmpty => location == null && weather == null && activity == null && socialContext == null;
}

/// Classe principale représentant une entrée émotionnelle complète
@JsonSerializable(explicitToJson: true)
class EmotionEntry extends Equatable {
  /// Identifiant unique de l'entrée
  final String id;
  
  /// Identifiant de l'utilisateur (optionnel pour les cas de création)
  final String? userId;
  
  /// Horodatage de l'entrée
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime timestamp;
  
  /// Données sur l'émotion
  final EmotionData emotion;
  
  /// Notes textuelles (optionnelles)
  final String? notes;
  
  /// Liste des déclencheurs identifiés
  final List<String> triggers;
  
  /// Données contextuelles (optionnelles)
  final ContextData? contextData;
  
  /// Liste des habitudes associées à cette entrée (optionnelle)
  final List<String>? associatedHabits;

  /// Constructeur
  const EmotionEntry({
    required this.id,
    this.userId,
    required this.timestamp,
    required this.emotion,
    this.notes,
    this.triggers = const [],
    this.contextData,
    this.associatedHabits,
  });

  /// Convertit un Timestamp Firestore en DateTime pour la désérialisation
  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is Map) {
      // Gestion des formats JSON avec secondes et nanosecondes
      return Timestamp(
        timestamp['_seconds'] as int,
        timestamp['_nanoseconds'] as int,
      ).toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    // Valeur par défaut
    return DateTime.now();
  }

  /// Convertit un DateTime en format compatible pour la sérialisation
  static dynamic _timestampToJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        timestamp,
        emotion,
        notes,
        triggers,
        contextData,
        associatedHabits,
      ];

  /// Crée une instance depuis un document Firestore
  factory EmotionEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmotionEntry(
      id: doc.id,
      userId: data['userId'] as String?,
      timestamp: data['timestamp'] is Timestamp 
          ? (data['timestamp'] as Timestamp).toDate() 
          : _timestampFromJson(data['timestamp']),
      emotion: EmotionData.fromJson(data['emotion'] as Map<String, dynamic>),
      notes: data['notes'] as String?,
      triggers: List<String>.from(data['triggers'] ?? []),
      contextData: data['contextData'] != null 
          ? ContextData.fromJson(data['contextData'] as Map<String, dynamic>)
          : null,
      associatedHabits: data['associatedHabits'] != null 
          ? List<String>.from(data['associatedHabits'])
          : null,
    );
  }

  /// Crée une instance depuis un map JSON
  factory EmotionEntry.fromJson(Map<String, dynamic> json) => _$EmotionEntryFromJson(json);

  /// Convertit l'instance en map JSON
  Map<String, dynamic> toJson() => _$EmotionEntryToJson(this);
  
  /// Convertit l'instance en map pour Firestore
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    
    // Supprimer l'ID (géré séparément par Firestore)
    json.remove('id');
    
    // Ne pas inclure les champs nuls ou vides
    if (json['notes'] == null) json.remove('notes');
    if (json['userId'] == null) json.remove('userId');
    if (json['contextData'] == null) json.remove('contextData');
    if (json['associatedHabits'] == null) json.remove('associatedHabits');
    
    return json;
  }

  /// Crée une copie avec des valeurs modifiées
  EmotionEntry copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    EmotionData? emotion,
    String? notes,
    List<String>? triggers,
    ContextData? contextData,
    List<String>? associatedHabits,
  }) {
    return EmotionEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      emotion: emotion ?? this.emotion,
      notes: notes ?? this.notes,
      triggers: triggers ?? this.triggers,
      contextData: contextData ?? this.contextData,
      associatedHabits: associatedHabits ?? this.associatedHabits,
    );
  }
  
  /// Formate l'heure de l'entrée pour l'affichage
  String get formattedTime => '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  
  /// Vérifie si l'entrée a été créée aujourd'hui
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year && 
           timestamp.month == now.month && 
           timestamp.day == now.day;
  }
  
  /// Nombre de jours écoulés depuis cette entrée
  int get daysAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inDays;
  }
  
  /// Vérifie si l'entrée contient un déclencheur spécifique
  bool hasTrigger(String trigger) => triggers.contains(trigger);
  
  /// Vérifie si l'entrée est associée à une habitude spécifique
  bool isAssociatedWithHabit(String habitId) => 
      associatedHabits != null && associatedHabits!.contains(habitId);

  /// Crée une entrée avec un ID généré
  factory EmotionEntry.create({
    required String userId,
    required EmotionData emotion,
    DateTime? timestamp,
    String? notes,
    List<String>? triggers,
    ContextData? contextData,
    List<String>? associatedHabits,
  }) {
    return EmotionEntry(
      id: FirebaseFirestore.instance.collection('emotionEntries').doc().id,
      userId: userId,
      timestamp: timestamp ?? DateTime.now(),
      emotion: emotion,
      notes: notes,
      triggers: triggers ?? [],
      contextData: contextData,
      associatedHabits: associatedHabits,
    );
  }
}

class FirebaseFirestore {
  static var instance;
}