import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelomi/services/firebase_service.dart';
import 'package:feelomi/models/sleep_model.dart';

class SleepService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static String? get _userId => FirebaseService.userId;

  // Enregistrer les données de sommeil
  static Future<void> saveSleepData(SleepModel sleep) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('sleep_tracking')
        .add(sleep.toMap());
  }

  // Récupérer l'historique du sommeil
  static Future<List<SleepModel>> getSleepHistory({int? limitDays}) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    Query query = _firestore
        .collection('users')
        .doc(_userId)
        .collection('sleep_tracking')
        .orderBy('date', descending: true);

    if (limitDays != null) {
      final startDate = DateTime.now().subtract(Duration(days: limitDays));
      query = query.where('date', isGreaterThanOrEqualTo: startDate);
    }

    final QuerySnapshot snapshot = await query.get();

    return snapshot.docs
        .map((doc) => SleepModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Calculer la qualité moyenne du sommeil
  static Future<double> getAverageSleepQuality(int days) async {
    final sleepData = await getSleepHistory(limitDays: days);

    if (sleepData.isEmpty) return 0.0;

    final sum = sleepData.fold<double>(0, (sum, sleep) => sum + sleep.quality);
    return sum / sleepData.length;
  }
}
