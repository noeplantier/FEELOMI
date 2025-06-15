# Feelomi 🌟

Une application mobile Flutter innovante pour le suivi et l'analyse de votre bien-être émotionnel au quotidien.

## 📱 À propos

Feelomi est une application de tracking d'humeurs, de stress et d'émotions conçue pour vous aider à mieux comprendre votre état émotionnel et améliorer votre bien-être mental. Grâce à une interface intuitive et des fonctionnalités avancées d'analyse, Feelomi vous accompagne dans votre parcours vers un meilleur équilibre émotionnel.

### ✨ Fonctionnalités principales

- **Suivi d'humeur quotidien** - Enregistrez facilement votre état émotionnel
- **Tracker de stress** - Mesurez et analysez vos niveaux de stress
- **Journal émotionnel** - Consignez vos émotions avec des notes détaillées
- **Analyses et statistiques** - Visualisez l'évolution de votre bien-être
- **Rappels personnalisés** - Ne manquez jamais un moment d'introspection
- **Interface adaptative** - Design moderne et accessible

## 🎯 Enjeux du projet

### Problématique
Dans notre société moderne, la santé mentale est devenue un enjeu majeur. De nombreuses personnes peinent à :
- Identifier et comprendre leurs émotions
- Gérer leur stress quotidien
- Maintenir un équilibre émotionnel stable
- Avoir une vision claire de leur évolution psychologique

### Solution Feelomi
Feelomi répond à ces défis en offrant :
- **Accessibilité** : Une application mobile disponible partout, tout le temps
- **Simplicité** : Interface intuitive pour tous les âges
- **Personnalisation** : Adaptation aux besoins spécifiques de chaque utilisateur
- **Insights** : Analyses basées sur les données pour une meilleure auto-compréhension
- **Confidentialité** : Données personnelles sécurisées et privées

## 🛠️ Technologies

- **Framework** : Flutter 3.x
- **Langage** : Dart
- **Base de données** : SQLite (locale) / Firebase (cloud)
- **Architecture** : MVVM avec Provider/Bloc
- **Tests** : Unit tests, Widget tests, Integration tests

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.0 ou supérieure)
- [Dart SDK](https://dart.dev/get-dart) (inclus avec Flutter)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

### Vérification de l'installation
```bash
flutter doctor
```

## 🚀 Installation et lancement

### 1. Cloner le projet
```bash
git clone https://github.com/votre-username/feelomi.git
cd feelomi
```

### 2. Installation des dépendances
```bash
flutter pub get
```

### 3. Configuration de l'environnement

#### Variables d'environnement
Créez un fichier `.env` à la racine du projet :
```env
# Base de données
DB_NAME=feelomi_local.db
DB_VERSION=1

# Configuration API (si applicable)
API_BASE_URL=https://api.feelomi.com
API_KEY=your_api_key_here

# Firebase (si utilisé)
FIREBASE_PROJECT_ID=feelomi-project
```

#### Configuration Firebase (optionnel)
Si vous utilisez Firebase, placez vos fichiers de configuration :
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

### 4. Génération du code (si nécessaire)
```bash
flutter packages pub run build_runner build
```

## 💻 Développement local

### Lancement en mode debug
```bash
# Démarrer l'application
flutter run

# Ou spécifier un appareil
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

### Mode développement avec hot reload
```bash
flutter run --debug
```

### Lancement des tests
```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Tests avec couverture
flutter test --coverage
```

### Outils de développement utiles
```bash
# Analyse du code
flutter analyze

# Formatage du code
dart format .

# Inspection des dépendances
flutter pub deps

# Nettoyage des caches
flutter clean
flutter pub get
```

## 🌐 Déploiement en production

### Build pour Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (recommandé pour Play Store)
flutter build appbundle --release
```

### Build pour iOS
```bash
# Mode release
flutter build ios --release

# Pour distribution App Store
flutter build ipa
```

### Build pour Web
```bash
# Build production web
flutter build web --release

# Avec optimisations supplémentaires
flutter build web --release --web-renderer canvaskit
```

### Déploiement automatisé

#### GitHub Actions (exemple)
```yaml
# .github/workflows/deploy.yml
name: Deploy Feelomi
on:
  push:
    branches: [ main ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
    - run: flutter pub get
    - run: flutter test
    - run: flutter build apk --release
```

## 🧪 Tests et qualité

### Structure des tests
```
test/
├── unit/          # Tests unitaires
├── widget/        # Tests de widgets
└── integration/   # Tests d'intégration
```

### Commandes de test
```bash
# Suite complète de tests
flutter test

# Tests avec rapport détaillé
flutter test --reporter expanded

# Tests de performance
flutter drive --target=test_driver/app.dart
```

### Métriques de qualité
```bash
# Analyse statique
flutter analyze

# Métriques de code
dart pub global activate dart_code_metrics
dart pub global run dart_code_metrics:metrics analyze lib

# Vérification des dépendances obsolètes
flutter pub outdated
```

## 📊 Monitoring et debugging

### Logs et debugging
```bash
# Logs détaillés
flutter run --verbose

# Profiling des performances
flutter run --profile

# Inspector de widgets
flutter inspector
```

### Outils de monitoring
- **Flutter Inspector** : Analyse de l'arbre de widgets
- **Performance Overlay** : Monitoring temps réel
- **Memory Usage** : Surveillance mémoire

## 🤝 Contribution

### Workflow de développement
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Créer une Pull Request

### Standards de code
- Suivre les [conventions Dart](https://dart.dev/guides/language/effective-dart)
- Taux de couverture de tests > 80%
- Documentation des fonctions publiques
- Utilisation de `dart format` avant chaque commit

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🆘 Support

### Documentation
- [Documentation Flutter](https://flutter.dev/docs)
- [API Dart](https://api.dart.dev/)
- [Guide des bonnes pratiques](https://flutter.dev/docs/development/ui/widgets/intro)

### Contact
- **Email** : support@feelomi.com
- **Issues** : [GitHub Issues](https://github.com/noeplantier/feelomi/issues)
- **Discussions** : [GitHub Discussions](https://github.com/votre-username/feelomi/discussions)

---

**Feelomi** - *Votre compagnon digital pour un bien-être émotionnel optimal* 🌈