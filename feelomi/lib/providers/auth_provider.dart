import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  Map<String, dynamic>? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _currentUser?['id'];
  String? get userName => _currentUser?['name'];
  String? get userEmail => _currentUser?['email'];

  // Initialisation - Vérification de la session
  Future<void> initializeAuth() async {
    _setLoading(true);
    
    try {
      final userId = await _secureStorage.read(key: 'user_id');
      final userEmail = await _secureStorage.read(key: 'user_email');
      
      if (userId != null && userEmail != null) {
        // Vérifier si l'utilisateur existe toujours en base
        final user = await _databaseService.authenticateUser(userEmail, '');
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
        } else {
          await _clearStoredCredentials();
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation de l\'authentification: $e');
      await _clearStoredCredentials();
    } finally {
      _setLoading(false);
    }
  }

  // Connexion
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _databaseService.authenticateUser(email, password);
      
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        
        // Sauvegarder les informations de session
        await _saveCredentials(user['id'], email);
        
        notifyListeners();
        return true;
      } else {
        _setError('Email ou mot de passe incorrect');
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Inscription
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Vérifier si l'email existe déjà
      final existingUser = await _databaseService.authenticateUser(email, '');
      if (existingUser != null) {
        _setError('Cet email est déjà utilisé');
        return false;
      }

      // Créer le nouvel utilisateur
      final userId = await _databaseService.createUser(
        email: email,
        password: password,
        name: name,
      );

      // Connecter automatiquement l'utilisateur
      final user = await _databaseService.authenticateUser(email, password);
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        
        // Sauvegarder les informations de session
        await _saveCredentials(userId, email);
        
        notifyListeners();
        return true;
      } else {
        _setError('Erreur lors de la création du compte');
        return false;
      }
    } catch (e) {
      _setError('Erreur lors de l\'inscription: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Déconnexion
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _clearStoredCredentials();
      _currentUser = null;
      _isAuthenticated = false;
      _clearError();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Mise à jour du profil
  Future<bool> updateProfile({
    String? name,
    String? email, File? profileImage, required String displayName,
  }) async {
    if (!_isAuthenticated || _currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // Note: Ici vous pourriez ajouter une méthode updateUser dans DatabaseService
      // Pour l'instant, on simule la mise à jour locale
      
      if (name != null) {
        _currentUser!['name'] = name;
      }
      
      if (email != null) {
        _currentUser!['email'] = email;
        await _secureStorage.write(key: 'user_email', value: email);
      }
      
      _currentUser!['updated_at'] = DateTime.now().toIso8601String();
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Erreur lors de la mise à jour: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Changement de mot de passe
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!_isAuthenticated || _currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // Vérifier le mot de passe actuel
      final user = await _databaseService.authenticateUser(
        _currentUser!['email'],
        currentPassword,
      );
      
      if (user == null) {
        _setError('Mot de passe actuel incorrect');
        return false;
      }

      // Note: Ici vous devriez ajouter une méthode updatePassword dans DatabaseService
      // Pour l'instant, on simule le changement
      
      return true;
      
    } catch (e) {
      _setError('Erreur lors du changement de mot de passe: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Suppression du compte
  Future<bool> deleteAccount(String password) async {
    if (!_isAuthenticated || _currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // Vérifier le mot de passe
      final user = await _databaseService.authenticateUser(
        _currentUser!['email'],
        password,
      );
      
      if (user == null) {
        _setError('Mot de passe incorrect');
        return false;
      }

      // Note: Ici vous devriez ajouter une méthode deleteUser dans DatabaseService
      // qui supprime l'utilisateur et toutes ses données associées
      
      await logout();
      return true;
      
    } catch (e) {
      _setError('Erreur lors de la suppression du compte: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Validation des données
  String? validateEmail(String email) {
    if (email.isEmpty) return 'L\'email est requis';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Le mot de passe est requis';
    if (password.length < 8) return 'Le mot de passe doit contenir au moins 8 caractères';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      return 'Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre';
    }
    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) return 'Le nom est requis';
    if (name.length < 2) return 'Le nom doit contenir au moins 2 caractères';
    return null;
  }

  // Méthodes utilitaires privées
  Future<void> _saveCredentials(String userId, String email) async {
    await _secureStorage.write(key: 'user_id', value: userId);
    await _secureStorage.write(key: 'user_email', value: email);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('last_login', DateTime.now().toIso8601String());
  }

  Future<void> _clearStoredCredentials() async {
    await _secureStorage.deleteAll();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('last_login');
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

  // Réinitialisation pour les tests
  void reset() {
    _currentUser = null;
    _isAuthenticated = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  Future signInWithEmailAndPassword(String trim, String text) async {}

  Future<void> loadUserProfile() async {}

  Future<void> signOut() async {}
}