Collecting workspace information# Spécifications techniques pour l'application Feelomi

## Architecture générale

### Frontend
- **Framework**: Flutter
- **Langage**: Dart
- **État**: Provider pour la gestion d'état
- **Interface utilisateur**: Material Design 3 avec design system personnalisé
- **Navigation**: Flutter Navigator 2.0
- **Tests**: Flutter Test pour les tests unitaires et d'intégration

### Backend
- **Runtime**: Node.js
- **Langage**: TypeScript
- **Framework API**: Express.js
- **Tests**: Jest pour les tests unitaires et d'intégration

### Base de données et stockage
- **Base de données primaire**: Firestore pour les données structurées
- **Stockage**: Firebase Storage pour les médias
- **Authentication**: Firebase Authentication

### Services Firebase
- **Cloud Functions**: Pour la logique métier serverless
- **Firebase Analytics**: Pour le suivi des comportements utilisateurs
- **Firebase Crashlytics**: Pour le suivi des erreurs
- **Cloud Messaging**: Pour les notifications push

## Structure de données

### Collection `users`
```typescript
interface User {
  id: string;
  email: string;
  displayName: string;
  createdAt: Timestamp;
  lastLogin: Timestamp;
  isPremium: boolean;
  premiumExpiry?: Timestamp;
  settings: {
    notificationsEnabled: boolean;
    reminderTimes: string[];
    theme: 'light' | 'dark' | 'system';
    language: string;
  };
  metrics: {
    totalEmotionEntries: number;
    totalHabitRecords: number;
    streakDays: number;
    lastEntryDate: Timestamp;
  };
}
```

### Collection `emotionEntries`
```typescript
interface EmotionEntry {
  id: string;
  userId: string;
  timestamp: Timestamp;
  emotion: {
    primary: string;
    secondary?: string;
    intensity: number;
  };
  notes?: string;
  triggers: string[];
  contextData?: {
    location?: GeoPoint;
    weather?: string;
    activity?: string;
    socialContext?: string;
  };
  associatedHabits?: string[];
}
```

### Collection `habits`
```typescript
interface Habit {
  id: string;
  userId: string;
  name: string;
  category: string; 
  createdAt: Timestamp;
  active: boolean;
  frequency: {
    type: 'daily' | 'weekly';
    daysOfWeek?: number[]; 
  };
  trackedMetrics: {
    type: 'duration' | 'boolean' | 'quantity' | 'rating';
    unit?: string;
    range?: {
      min: number;
      max: number;
    };
  }[];
}
```

### Collection `habitRecords`
```typescript
interface HabitRecord {
  id: string;
  userId: string;
  habitId: string;
  date: Timestamp;
  completed: boolean;
  metrics: {
    metricId: string;
    value: any; 
  }[];
  notes?: string;
}
```

### Collection `wellbeingContent`
```typescript
interface WellbeingContent {
  id: string;
  title: string;
  description: string;
  contentType: 'article' | 'video' | 'audio' | 'exercise';
  tags: string[];
  suitableEmotions: string[];
  premium: boolean;
  duration?: number; 
  author?: string;
  thumbnailUrl: string;
  contentUrl: string;
  createdAt: Timestamp;
  metrics: {
    views: number;
    likes: number;
    completions: number;
  };
}
```

### Collection `professionals`
```typescript
interface Professional {
  id: string;
  displayName: string;
  specialties: string[];
  bio: string;
  certifications: string[];
  photoUrl: string;
  availableSlots: {
    day: number; 
    times: string[]; 
  }[];
  pricing: {
    currency: string;
    perSession: number;
  };
  rating: {
    average: number;
    count: number;
  };
  languages: string[];
}
```

### Collection `appointments`
```typescript
interface Appointment {
  id: string;
  userId: string;
  professionalId: string;
  date: Timestamp;
  status: 'scheduled' | 'completed' | 'cancelled';
  meetingLink?: string;
  notes?: {
    user?: string;
    professional?: string;
  };
  payment: {
    amount: number;
    currency: string;
    status: 'pending' | 'completed' | 'refunded';
    transactionId?: string;
  };
}
```

### Collection `recommendations`
```typescript
interface Recommendation {
  id: string;
  userId: string;
  createdAt: Timestamp;
  type: 'content' | 'habit' | 'professional' | 'action';
  itemId?: string;
  reason: string;
  context: {
    triggerEmotion?: string;
    triggerIntensity?: number;
    triggerPatterns?: {
      description: string;
      confidence: number;
    }[];
  };
  action?: {
    title: string;
    description: string;
    duration?: number;
  };
  displayed: boolean;
  interacted: boolean;
  feedback?: {
    helpful: boolean;
    notes?: string;
  };
}
```

## Fonctionnalités principales

### Module Suivi Émotionnel
- Enregistrement quotidien des émotions avec interface visuelle intuitive
- Sélection d'émotion primaire et secondaire optionnelle
- Curseur pour l'intensité (1-10)
- Champ de notes pour détails textuels
- Sélection de déclencheurs émotionnels via tags prédéfinis et personnalisables
- Option pour ajouter des données contextuelles (météo, activité, etc.)
- Visualisation des tendances émotionnelles sur des graphiques temporels

### Module Habitudes de Vie
- Création et suivi d'habitudes personnalisées
- Catégories prédéfinies (sommeil, exercice, nutrition, etc.)
- Configuration de fréquence (quotidienne ou jours spécifiques)
- Différents types de métriques selon l'habitude (durée, booléen, quantité, évaluation)
- Rappels personnalisables par habitude
- Corrélations entre habitudes et bien-être émotionnel
- Visualisation des tendances et impact des habitudes

### Module Recommandations (Premium)
- Moteur d'analyse des patterns émotionnels
- Recommandations personnalisées basées sur l'historique de l'utilisateur
- Suggestions d'habitudes à adopter ou modifier
- Recommandations de contenu bien-être approprié
- Conseils d'actions spécifiques pour améliorer le bien-être
- Rapports hebdomadaires et mensuels sur les progrès

### Module Contenu Bien-être
- Catalogue de contenus catégorisés (articles, vidéos, exercices audio)
- Filtrage par émotion, durée, et type de contenu
- Méthodes de respiration et méditation guidée
- Exercices de pleine conscience
- Articles sur la gestion émotionnelle
- Distinction entre contenus gratuits et premium

### Module Consultations Professionnelles
- Liste de professionnels certifiés (psychologues, coachs, thérapeutes)
- Profils détaillés avec spécialités et certifications
- Système de prise de rendez-vous intégré
- Paiement sécurisé dans l'application
- Consultations par appel vidéo intégré ou redirection
- Système de notation et commentaires

## Intégrations techniques

### API tierces
- **Stripe/PayPal**: Pour les paiements des consultations et abonnements premium
- **Twilio/Agora**: Pour les appels vidéo des consultations
- **OpenWeatherMap**: Pour les données météo associées aux entrées émotionnelles
- **Google Maps API**: Pour les données de localisation (optionnel)
- **Calendrier natif**: Pour l'intégration des rendez-vous

### Sécurité et conformité
- **RGPD**: Conformité complète avec demande de consentement et gestion des données
- **HIPAA**: Conformité pour les données de santé mentale
- **Chiffrement**: Données sensibles chiffrées au repos et en transit
- **Authentification**: Multi-facteurs pour les données sensibles
- **Politique de confidentialité**: Transparente et accessible
- **Export de données**: Possibilité pour l'utilisateur d'exporter ses données

### IA et apprentissage automatique
- **Moteur de recommandations**: Basé sur TensorFlow.js pour calcul côté client
- **Analyse de sentiment**: Pour l'analyse des notes textuelles
- **Patterns émotionnels**: Détection de cycles et tendances
- **Modèle prédictif**: Pour anticiper les changements émotionnels basés sur les habitudes

## Interface utilisateur

### Expérience utilisateur
- **Onboarding**: Guidage initial pour comprendre l'application
- **Design émotionnel**: Interfaces adaptées à l'état émotionnel de l'utilisateur
- **Micro-interactions**: Animations subtiles pour renforcer l'engagement
- **Navigation intuitive**: Structure en onglets avec accès rapide aux fonctions principales
- **Accessibilité**: Conformité WCAG 2.1 niveau AA

### Écrans principaux
1. **Tableau de bord**: Aperçu de l'état émotionnel et habitudes du jour
2. **Suivi émotionnel**: Interface de saisie des émotions
3. **Journal**: Historique des entrées émotionnelles
4. **Habitudes**: Suivi et création d'habitudes
5. **Explorer**: Catalogue de contenu bien-être
6. **Consultations**: Recherche et réservation de professionnels
7. **Profil**: Paramètres et informations personnelles

## Déploiement et CI/CD
- **CI/CD**: GitHub Actions pour l'intégration et le déploiement continus
- **Versionnement**: Semantic versioning (MAJOR.MINOR.PATCH)
- **Environnements**: Développement, Test, Production
- **Monitoring**: Firebase Performance Monitoring

Ce document fournit une base solide pour le développement de l'application Feelomi, en couvrant l'architecture technique, la structure des données et les principales fonctionnalités. Il peut être complété par des documents plus détaillés pour chaque module spécifique.