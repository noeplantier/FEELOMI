import 'package:feelomi/models/emotion_entry.dart' hide EmotionEntry;
import 'package:flutter/foundation.dart';
import '../models/emotion_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class EmotionProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();

  List<EmotionEntry> _emotionEntries = [];
  EmotionAnalytics? _analytics;
  bool _isLoading = false;
  String? _error;
  String? _currentUserId;

  var emotions;

  // Getters
  List<EmotionEntry> get emotionEntries => List.unmodifiable(_emotionEntries);
  EmotionAnalytics? get analytics => _analytics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasEntries => _emotionEntries.isNotEmpty;

  get todaysEmotion => null;

  // Récupération des données
  Future<void> loadEmotionEntries({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    if (_currentUserId == null) return;

    _setLoading(true);
    _clearError();

    try {
      _emotionEntries = await _databaseService.getEmotionEntries(
        userId: _currentUserId!,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );
      
      await _loadAnalytics(startDate: startDate, endDate: endDate);
      
    } catch (e) {
      _setError('Erreur lors du chargement des données: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_currentUserId == null) return;

    try {
      _analytics = await _databaseService.getEmotionAnalytics(
        userId: _currentUserId!,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      debugPrint('Erreur lors du chargement des analytics: $e');
    }
  }

  // Ajout d'une entrée émotionnelle
  Future<bool> addEmotionEntry({
    required EmotionType emotionType,
    required int intensity,
    String? notes,
    List<String> triggers = const [],
    Map<String, dynamic>? contextData,
  }) async {
    if (_currentUserId == null) return false;

    _clearError();

    try {
      final entry = EmotionEntry(
        id: _generateId(),
        timestamp: DateTime.now(),
        emotionType: emotionType,
        intensity: intensity,
        notes: notes,
        triggers: triggers,
        contextData: contextData,
        userId: _currentUserId!,
      );

      await _databaseService.insertEmotionEntry(entry);
      
      // Ajouter à la liste locale
      _emotionEntries.insert(0, entry);
      
      // Mettre à jour les analytics
      await _loadAnalytics();
      
      // Programmer des rappels intelligents si nécessaire
      await _scheduleSmartReminders(entry);
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Erreur lors de l\'enregistrement: $e');
      return false;
    }
  }

  // Mise à jour d'une entrée
  Future<bool> updateEmotionEntry(EmotionEntry updatedEntry) async {
    _clearError();

    try {
      await _databaseService.updateEmotionEntry(updatedEntry);
      
      // Mettre à jour dans la liste locale
      final index = _emotionEntries.indexWhere((e) => e.id == updatedEntry.id);
      if (index != -1) {
        _emotionEntries[index] = updatedEntry;
        await _loadAnalytics();
        notifyListeners();
      }
      
      return true;
      
    } catch (e) {
      _setError('Erreur lors de la mise à jour: $e');
      return false;
    }
  }

  // Suppression d'une entrée
  Future<bool> deleteEmotionEntry(String entryId) async {
    _clearError();

    try {
      await _databaseService.deleteEmotionEntry(entryId);
      
      // Supprimer de la liste locale
      _emotionEntries.removeWhere((entry) => entry.id == entryId);
      
      // Mettre à jour les analytics
      await _loadAnalytics();
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Erreur lors de la suppression: $e');
      return false;
    }
  }

  // Analyse des patterns émotionnels
  Map<String, dynamic> getEmotionalPatterns() {
    if (_analytics == null) return {};

    final patterns = <String, dynamic>{};
    
    // Émotion dominante
    if (_analytics!.emotionCounts.isNotEmpty) {
      final dominantEmotion = _analytics!.emotionCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      patterns['dominantEmotion'] = {
        'type': dominantEmotion.key,
        'count': dominantEmotion.value,
      };
    }

    // Tendance d'intensité
    final recentEntries = _emotionEntries.take(7).toList();
    if (recentEntries.length >= 3) {
      final intensities = recentEntries.map((e) => e.intensity).toList();
      final trend = _calculateTrend(intensities);
      patterns['intensityTrend'] = trend;
    }

    // Déclencheurs fréquents
    patterns['commonTriggers'] = _analytics!.commonTriggers;

    return patterns;
  }

  // Recommandations personnalisées
  List<String> getPersonalizedRecommendations() {
    final recommendations = <String>[];
    final patterns = getEmotionalPatterns();

    if (patterns.isEmpty) {
      return [
        'Continuez à enregistrer vos émotions pour obtenir des recommandations personnalisées',
        'Essayez la méditation de pleine conscience 5 minutes par jour',
        'Tenez un journal de gratitude',
      ];
    }

    // Recommandations basées sur l'émotion dominante
    final dominantEmotion = patterns['dominantEmotion'];
    if (dominantEmotion != null) {
      switch (dominantEmotion['type'] as EmotionType) {
        case EmotionType.anxiety:
        case EmotionType.stressed:
          recommendations.addAll([
            'Pratiquez des exercices de respiration profonde',
            'Essayez la technique de relaxation musculaire progressive',
            'Considérez une promenade en nature',
          ]);
          break;
        case EmotionType.sadness:
        case EmotionType.despair:
          recommendations.addAll([
            'Connectez-vous avec des proches',
            'Pratiquez une activité physique douce',
            'Écoutez de la musique apaisante',
          ]);
          break;
        case EmotionType.anger:
        case EmotionType.frustration:
          recommendations.addAll([
            'Pratiquez des exercices de gestion de la colère',
            'Essayez l\'écriture expressive',
            'Faites une pause avant de réagir',
          ]);
          break;
        default:
          recommendations.add('Maintenez vos habitudes positives actuelles');
      }
    }

    // Recommandations basées sur les déclencheurs
    final commonTriggers = patterns['commonTriggers'] as List<String>?;
    if (commonTriggers != null && commonTriggers.isNotEmpty) {
      recommendations.add('Développez des stratégies pour gérer: ${commonTriggers.first}');
    }

    return recommendations.take(5).toList();
  }

  // Programmation de rappels intelligents
  Future<void> _scheduleSmartReminders(EmotionEntry entry) async {
    // Si l'intensité est élevée (>7) et l'émotion négative
    if (entry.intensity > 7 && _isNegativeEmotion(entry.emotionType)) {
      await _notificationService.scheduleReminder(
        title: 'Prenez soin de vous',
        body: 'Comment vous sentez-vous maintenant ?',
        scheduledDate: DateTime.now().add(const Duration(hours: 2)),
      );
    }

    // Rappel quotidien si pas d'entrée depuis 24h
    final lastEntry = _emotionEntries.isNotEmpty ? _emotionEntries.first : null;
    if (lastEntry == null || 
        DateTime.now().difference(lastEntry.timestamp).inHours > 24) {
      await _notificationService.scheduleReminder(
        title: 'Moment de réflexion',
        body: 'Comment s\'est passée votre journée ?',
        scheduledDate: DateTime.now().add(const Duration(hours: 12)),
      );
    }
  }

  // Méthodes utilitaires
  bool _isNegativeEmotion(EmotionType emotion) {
    const negativeEmotions = [
      EmotionType.sadness,
      EmotionType.anger,
      EmotionType.fear,
      EmotionType.anxiety,
      EmotionType.frustration,
      EmotionType.guilt,
      EmotionType.shame,
      EmotionType.despair,
      EmotionType.stressed,
    ];
    return negativeEmotions.contains(emotion);
  }

  String _calculateTrend(List<int> values) {
    if (values.length < 2) return 'stable';
    
    final first = values.take(values.length ~/ 2).fold(0, (a, b) => a + b) / (values.length ~/ 2);
    final second = values.skip(values.length ~/ 2).fold(0, (a, b) => a + b) / (values.length - values.length ~/ 2);
    
    if (second > first + 1) return 'amélioration';
    if (second < first - 1) return 'détérioration';
    return 'stable';
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           DateTime.now().microsecond.toString();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void setUserId(String userId) {
    _currentUserId = userId;
    _emotionEntries.clear();
    _analytics = null;
    notifyListeners();
  }

  void clear() {
    _emotionEntries.clear();
    _analytics = null;
    _currentUserId = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveEmotionEntry(EmotionEntry emotionEntry) async {}

  Future<void> fetchRecentEmotions() async {}

  Future<void> fetchTodaysEmotion() async {}
}