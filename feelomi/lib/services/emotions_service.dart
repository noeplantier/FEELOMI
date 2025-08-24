import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelomi/services/firebase_service.dart';
import 'package:feelomi/models/emotion_model.dart';

class EmotionsService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static String? get _userId => FirebaseService.userId;

  // Enregistrer une émotion
  static Future<void> saveEmotion(EmotionModel emotion) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('emotions')
        .add(emotion.toMap());
  }

  // Récupérer les émotions d'une période
  static Future<List<EmotionModel>> getEmotions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    Query query = _firestore
        .collection('users')
        .doc(_userId)
        .collection('emotions')
        .orderBy('timestamp', descending: true);

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }

    final QuerySnapshot snapshot = await query.get();

    return snapshot.docs
        .map((doc) => EmotionModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Récupérer les émotions de la semaine
  static Future<List<EmotionModel>> getWeeklyEmotions() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return getEmotions(
      startDate: weekStart,
      endDate: now.add(const Duration(days: 1)),
    );
  }
}
