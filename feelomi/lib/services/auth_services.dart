import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelomi/services/firebase_service.dart';
import 'package:feelomi/models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseService.auth;
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Inscription avec email/mot de passe
  static Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Création du compte Firebase
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Création du profil utilisateur dans Firestore
      await _createUserProfile(credential.user!, fullName);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Connexion avec email/mot de passe
  static Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Déconnexion
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Création du profil utilisateur
  static Future<void> _createUserProfile(User user, String fullName) async {
    final userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      fullName: fullName,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
  }

  // Gestion des erreurs d'authentification
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'email-already-in-use':
        return 'Cette adresse email est déjà utilisée.';
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cette adresse email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      default:
        return 'Une erreur est survenue: ${e.message}';
    }
  }
}
