import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelomi/services/firebase_service.dart';
import 'package:feelomi/models/stress_model.dart';

class StressService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static String? get _userId => FirebaseService.userId;

  // Enregistrer le niveau de stress
  static Future<void> saveStressLevel(StressModel stress) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('stress_tracking')
        .add(stress.toMap());
  }

  // Récupérer l'historique du stress
  static Future<List<StressModel>> getStressHistory({int? limitDays}) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    Query query = _firestore
        .collection('users')
        .doc(_userId)
        .collection('stress_tracking')
        .orderBy('timestamp', descending: true);

    if (limitDays != null) {
      final startDate = DateTime.now().subtract(Duration(days: limitDays));
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    final QuerySnapshot snapshot = await query.get();

    return snapshot.docs
        .map((doc) => StressModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Calculer le stress moyen sur une période
  static Future<double> getAverageStress(int days) async {
    final stressData = await getStressHistory(limitDays: days);

    if (stressData.isEmpty) return 0.0;

    final sum = stressData.fold<int>(0, (sum, stress) => sum + stress.level);
    return sum / stressData.length;
  }
}
