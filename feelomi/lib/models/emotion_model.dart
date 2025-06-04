
class EmotionEntry {
  final String id;
  final DateTime timestamp;
  final EmotionType emotionType;
  final int intensity; // 1-10
  final String? notes;
  final List<String> triggers;
  final Map<String, dynamic>? contextData;
  final String userId;

  const EmotionEntry({
    required this.id,
    required this.timestamp,
    required this.emotionType,
    required this.intensity,
    this.notes,
    required this.triggers,
    this.contextData,
    required this.userId,
  });

  factory EmotionEntry.fromJson(Map<String, dynamic> json) {
    return EmotionEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      emotionType: EmotionType.fromString(json['emotionType'] as String),
      intensity: json['intensity'] as int,
      notes: json['notes'] as String?,
      triggers: List<String>.from(json['triggers'] as List),
      contextData: json['contextData'] as Map<String, dynamic>?,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'emotionType': emotionType.toString(),
      'intensity': intensity,
      'notes': notes,
      'triggers': triggers,
      'contextData': contextData,
      'userId': userId,
    };
  }

  EmotionEntry copyWith({
    String? id,
    DateTime? timestamp,
    EmotionType? emotionType,
    int? intensity,
    String? notes,
    List<String>? triggers,
    Map<String, dynamic>? contextData,
    String? userId,
  }) {
    return EmotionEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      emotionType: emotionType ?? this.emotionType,
      intensity: intensity ?? this.intensity,
      notes: notes ?? this.notes,
      triggers: triggers ?? this.triggers,
      contextData: contextData ?? this.contextData,
      userId: userId ?? this.userId,
    );
  }
}

enum EmotionType {
  joy,
  sadness,
  anger,
  fear,
  disgust,
  surprise,
  anxiety,
  excitement,
  contentment,
  frustration,
  love,
  guilt,
  shame,
  pride,
  jealousy,
  gratitude,
  hope,
  despair,
  calm,
  stressed;

  static EmotionType fromString(String value) {
    return EmotionType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => EmotionType.contentment,
    );
  }

  String get displayName {
    switch (this) {
      case EmotionType.joy:
        return 'Joie';
      case EmotionType.sadness:
        return 'Tristesse';
      case EmotionType.anger:
        return 'Colère';
      case EmotionType.fear:
        return 'Peur';
      case EmotionType.disgust:
        return 'Dégoût';
      case EmotionType.surprise:
        return 'Surprise';
      case EmotionType.anxiety:
        return 'Anxiété';
      case EmotionType.excitement:
        return 'Excitation';
      case EmotionType.contentment:
        return 'Contentement';
      case EmotionType.frustration:
        return 'Frustration';
      case EmotionType.love:
        return 'Amour';
      case EmotionType.guilt:
        return 'Culpabilité';
      case EmotionType.shame:
        return 'Honte';
      case EmotionType.pride:
        return 'Fierté';
      case EmotionType.jealousy:
        return 'Jalousie';
      case EmotionType.gratitude:
        return 'Gratitude';
      case EmotionType.hope:
        return 'Espoir';
      case EmotionType.despair:
        return 'Désespoir';
      case EmotionType.calm:
        return 'Calme';
      case EmotionType.stressed:
        return 'Stress';
    }
  }

  String get emoji {
    switch (this) {
      case EmotionType.joy:
        return '😊';
      case EmotionType.sadness:
        return '😢';
      case EmotionType.anger:
        return '😠';
      case EmotionType.fear:
        return '😨';
      case EmotionType.disgust:
        return '🤢';
      case EmotionType.surprise:
        return '😲';
      case EmotionType.anxiety:
        return '😰';
      case EmotionType.excitement:
        return '🤩';
      case EmotionType.contentment:
        return '😌';
      case EmotionType.frustration:
        return '😤';
      case EmotionType.love:
        return '🥰';
      case EmotionType.guilt:
        return '😔';
      case EmotionType.shame:
        return '😳';
      case EmotionType.pride:
        return '😎';
      case EmotionType.jealousy:
        return '😒';
      case EmotionType.gratitude:
        return '🙏';
      case EmotionType.hope:
        return '🌟';
      case EmotionType.despair:
        return '😞';
      case EmotionType.calm:
        return '😇';
      case EmotionType.stressed:
        return '😩';
    }
  }
}

class EmotionAnalytics {
  final Map<EmotionType, int> emotionCounts;
  final double averageIntensity;
  final List<String> commonTriggers;
  final Map<String, double> dailyAverages;
  final DateTime startDate;
  final DateTime endDate;

  const EmotionAnalytics({
    required this.emotionCounts,
    required this.averageIntensity,
    required this.commonTriggers,
    required this.dailyAverages,
    required this.startDate,
    required this.endDate,
  });

  factory EmotionAnalytics.fromEntries(List<EmotionEntry> entries) {
    if (entries.isEmpty) {
      return EmotionAnalytics(
        emotionCounts: {},
        averageIntensity: 0.0,
        commonTriggers: [],
        dailyAverages: {},
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );
    }

    final emotionCounts = <EmotionType, int>{};
    final allTriggers = <String>[];
    final dailyIntensities = <String, List<int>>{};
    double totalIntensity = 0;

    for (final entry in entries) {
      emotionCounts[entry.emotionType] = 
          (emotionCounts[entry.emotionType] ?? 0) + 1;
      
      allTriggers.addAll(entry.triggers);
      totalIntensity += entry.intensity;
      
      final dayKey = entry.timestamp.toIso8601String().split('T')[0];
      dailyIntensities.putIfAbsent(dayKey, () => []);
      dailyIntensities[dayKey]!.add(entry.intensity);
    }

    final triggerCounts = <String, int>{};
    for (final trigger in allTriggers) {
      triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
    }

    final commonTriggers = triggerCounts.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value))
        ..take(5);

    final dailyAverages = <String, double>{};
    for (final entry in dailyIntensities.entries) {
      dailyAverages[entry.key] = 
          entry.value.reduce((a, b) => a + b) / entry.value.length;
    }

    return EmotionAnalytics(
      emotionCounts: emotionCounts,
      averageIntensity: totalIntensity / entries.length,
      commonTriggers: commonTriggers.map((e) => e.key).toList(),
      dailyAverages: dailyAverages,
      startDate: entries.map((e) => e.timestamp).reduce(
          (a, b) => a.isBefore(b) ? a : b),
      endDate: entries.map((e) => e.timestamp).reduce(
          (a, b) => a.isAfter(b) ? a : b),
    );
  }
}