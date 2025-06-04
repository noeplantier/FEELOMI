import 'package:flutter/material.dart';

/// Classe de constantes pour l'application Feelomi
class Constants {
  // Empêcher l'instanciation
  Constants._();

  /// Nom de l'application
  static const String appName = "Feelomi";
  
  /// Version de l'application
  static const String appVersion = "1.0.0";
  
  /// Informations légales
  static const String copyright = "© 2025 Feelomi";
  
  /// URL et endpoints
  static const String baseApiUrl = "https://api.feelomi.com";
  static const String privacyPolicyUrl = "https://feelomi.com/privacy";
  static const String termsOfServiceUrl = "https://feelomi.com/terms";
  static const String supportEmail = "support@feelomi.com";
  
  /// Collection Firestore
  static const String usersCollection = "users";
  static const String emotionEntriesCollection = "emotionEntries";
  static const String habitsCollection = "habits";
  static const String habitRecordsCollection = "habitRecords";
  static const String wellbeingContentCollection = "wellbeingContent";
  static const String professionalsCollection = "professionals";
  static const String appointmentsCollection = "appointments";
  
  /// Paramètres de l'application
  static const int maxEmotionIntensity = 10;
  static const int minEmotionIntensity = 1;
  static const int maxRecentEmotions = 30;
  static const int defaultChartDays = 7;
  
  /// Durées
  static const Duration splashScreenDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration toastDuration = Duration(seconds: 3);
  static const Duration refreshInterval = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 1);
  
  /// Délais
  static const Duration debounceTime = Duration(milliseconds: 500);
  static const Duration autoSaveInterval = Duration(seconds: 30);
  static const Duration apiTimeout = Duration(seconds: 10);
  
  /// Valeurs limites
  static const int maxNotesLength = 500;
  static const int maxTriggers = 5;
  static const int maxCustomTriggerLength = 30;
  static const int maxHabits = 20;
  static const int maxActiveAlarms = 5;
  
  /// Paramètres de mise en page
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double buttonHeight = 56.0;
  static const double cardBorderRadius = 16.0;
  static const double avatarSize = 120.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 18.0;
  static const double largeIconSize = 32.0;
  
  /// Tailles d'écran responsive
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  /// Chemins d'assets
  static const String loadingAnimation = "assets/animations/loading.json";
  static const String successAnimation = "assets/animations/success.json";
  static const String errorAnimation = "assets/animations/error.json";
  static const String emptyAnimation = "assets/animations/empty.json";

    /// Constantes pour les assets

  static getEmotionColor(param0) {}
  }
  
  /// Classe pour les constantes d'assets
 
  /// Classe pour les constantes de préférences
  class _PrefKeysConstants {
    // Empêcher l'instanciation
    const _PrefKeysConstants();
  }
  
  /// Clés pour les arguments de navigation
  class NavArgs {
    // Empêcher l'instanciation
    NavArgs._();
    
    static const String emotionId = "emotion_id";
    static const String isEditing = "is_editing";
    static const String initialTab = "initial_tab";
  }
  
  /// Clés pour l'analytique
  class AnalyticsEvents {
    // Empêcher l'instanciation
    AnalyticsEvents._();
    
    // Événements d'authentification
    static const String login = "login";
    static const String signup = "signup";
    static const String logout = "logout";
    static const String passwordReset = "password_reset";
    
    // Événements d'émotion
    static const String addEmotion = "add_emotion";
    static const String editEmotion = "edit_emotion";
    static const String deleteEmotion = "delete_emotion";
    static const String viewContent = "view_content";
    static const String favoriteContent = "favorite_content";
    static const String shareContent = "share_content";
    static const String completeAppointment = "complete_appointment";
    
    // Événements d'abonnement
    static const String viewSubscription = "view_subscription";
    static const String startSubscription = "start_subscription";
    static const String cancelSubscription = "cancel_subscription";
  }

  /// Classe privée pour les valeurs prédéfinies
  class _Presets {
    // Empêcher l'instanciation
    const _Presets();
  }

  /// Listes de valeurs prédéfinies
  class Presets {
    // Empêcher l'instanciation
    Presets._();
    
    // Émotions primaires par catégorie
    static const Map<String, List<String>> emotionCategories = {
      'Positives': [
        'Joie', 'Contentement', 'Enthousiasme', 'Fierté', 'Amour', 
        'Gratitude', 'Soulagement', 'Sérénité', 'Espoir'
      ],
      'Négatives': [
        'Tristesse', 'Peur', 'Colère', 'Anxiété', 'Frustration', 
        'Honte', 'Déception', 'Culpabilité', 'Jalousie'
      ],
      'Neutres': [
        'Surprise', 'Curiosité', 'Confusion', 'Calme', 'Ennui', 
        'Fatigue', 'Nostalgie', 'Anticipation', 'Indifférence'
      ]
    };
    
    // Déclencheurs communs d'émotions
    static const List<String> commonTriggers = [
      'Travail', 'Relations', 'Santé', 'Finances', 'Famille', 
      'Sommeil', 'Alimentation', 'Activité physique', 'Stress',
      'Médias sociaux', 'Actualités', 'Météo', 'Solitude',
      'Réussite', 'Échec', 'Conflit', 'Voyage', 'Transport',
      'Rencontre', 'Musique', 'Art', 'Nature'
    ];
    
    // Catégories d'habitudes
    static const List<String> habitCategories = [
      'Sommeil', 'Exercice', 'Alimentation', 'Méditation', 'Lecture',
      'Hydratation', 'Relations', 'Loisirs', 'Productivité', 'Santé',
      'Créativité', 'Nature', 'Apprentissage'
    ];
    
    // Types de métriques pour les habitudes
    static const Map<String, String> habitMetricTypes = {
      'duration': 'Durée',
      'boolean': 'Fait/Non fait',
      'quantity': 'Quantité',
      'rating': 'Évaluation'
    };
    
    // Spécialités des professionnels
    static const List<String> professionalSpecialties = [
      'Psychologue', 'Psychothérapeute', 'Coach de vie', 
      'Coach en bien-être', 'Conseiller en santé mentale',
      'Psychiatre', 'Thérapeute familial', 'Méditateur',
      'Nutritionniste', 'Préparateur mental'
    ];
  }
  
  /// Correspondances entre émotions et couleurs
  final Map<String, Color> emotionColors = {
    'Joie': Colors.yellow.shade600,
    'Contentement': Colors.green.shade300,
    'Enthousiasme': Colors.orange.shade300,
    'Fierté': Colors.purple.shade300,
    'Amour': Colors.pink.shade300,
    'Gratitude': Colors.teal.shade300,
    'Tristesse': Colors.blue.shade700,
    'Peur': Colors.indigo.shade700,
    'Colère': Colors.red.shade700,
    'Anxiété': Colors.amber.shade700,
    'Frustration': Colors.deepOrange.shade700,
    'Surprise': Colors.cyan.shade500,
    'Curiosité': Colors.lightGreen.shade500,
    'Confusion': Colors.deepPurple.shade400,
    'Calme': Colors.lightBlue.shade200,
    'Ennui': Colors.grey.shade400,
    'Fatigue': Colors.blueGrey.shade400,
    'Honte': Colors.brown.shade700,
    'Déception': Colors.grey.shade700,
    'Culpabilité': Colors.brown.shade500,
    'Espoir': Colors.lightBlue.shade400,
    'Jalousie': Colors.green.shade900,
    'Sérénité': Colors.cyan.shade200,
    'Nostalgie': Colors.amber.shade200,
    'Anticipation': Colors.orange.shade400,
    'Indifférence': Colors.grey.shade500,
    'Soulagement': Colors.teal.shade200,
  };
