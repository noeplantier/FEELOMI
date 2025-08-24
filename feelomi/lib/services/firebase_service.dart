import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialisation Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Configuration de sécurité
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Getters pour accéder aux services
  static FirebaseFirestore get firestore => _firestore;
  static FirebaseAuth get auth => _auth;
  static User? get currentUser => _auth.currentUser;
  static String? get userId => _auth.currentUser?.uid;
}
