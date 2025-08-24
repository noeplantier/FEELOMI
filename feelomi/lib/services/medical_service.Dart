import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelomi/services/firebase_service.dart';
import 'package:feelomi/models/medical_model.dart';

class MedicalService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static String? get _userId => FirebaseService.userId;

  // Enregistrer les informations médicales
  static Future<void> saveMedicalInfo(MedicalInfoModel medicalInfo) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('medical_info')
        .doc('current')
        .set(medicalInfo.toMap(), SetOptions(merge: true));
  }

  // Récupérer les informations médicales
  static Future<MedicalInfoModel?> getMedicalInfo() async {
    if (_userId == null) throw 'Utilisateur non connecté';

    final DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('medical_info')
        .doc('current')
        .get();

    if (doc.exists) {
      return MedicalInfoModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Enregistrer les médicaments
  static Future<void> saveMedications(List<String> medications) async {
    if (_userId == null) throw 'Utilisateur non connecté';

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('medical_info')
        .doc('medications')
        .set({
      'medications': medications,
      'lastUpdated': DateTime.now(),
    });
  }
}