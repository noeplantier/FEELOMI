class EmotionModel {
  final String id;
  final int emotionValue; // 1-5 scale
  final String emotionType;
  final DateTime timestamp;
  final String? notes;
  final List<String>? keywords;

  EmotionModel({
    required this.id,
    required this.emotionValue,
    required this.emotionType,
    required this.timestamp,
    this.notes,
    this.keywords,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotionValue': emotionValue,
      'emotionType': emotionType,
      'timestamp': timestamp,
      'notes': notes,
      'keywords': keywords ?? [],
    };
  }

  factory EmotionModel.fromMap(Map<String, dynamic> map) {
    return EmotionModel(
      id: map['id'],
      emotionValue: map['emotionValue'],
      emotionType: map['emotionType'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      notes: map['notes'],
      keywords: List<String>.from(map['keywords'] ?? []),
    );
  }
}
