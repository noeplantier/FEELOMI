import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 150, 95, 186);
    final secondaryColor = const Color.fromARGB(255, 90, 0, 150);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                
                // Titre principal en violet
                Center(
                  child: Text(
                    'Espace connexion',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Champ email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Adresse Mail',
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Champ mot de passe
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Bouton de connexion
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique de connexion à implémenter
                      debugPrint('Email: ${_emailController.text}');
                      debugPrint('Password: ${_passwordController.text}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Séparateur avec texte
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Ou connectez-vous avec',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Icônes de réseaux sociaux
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Facebook
                    _socialButton(
                      icon: FontAwesomeIcons.facebook,
                      color: const Color(0xFF3b5998),
                      onTap: () {
                        // Connexion Facebook
                      },
                    ),
                    
                    const SizedBox(width: 24),
                    
                    // Google
                    _socialButton(
                      icon: FontAwesomeIcons.google,
                      color: const Color(0xFFDB4437),
                      onTap: () {
                        // Connexion Google
                      },
                    ),
                    
                    const SizedBox(width: 24),
                    
                    // Instagram
                    _socialButton(
                      icon: FontAwesomeIcons.instagram,
                      color: const Color(0xFFE1306C),
                      onTap: () {
                        // Connexion Instagram
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 50),
                
                // Texte pour l'inscription
                Center(
                  child: Text(
                    'Tu n\'as pas de compte ?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Lien vers inscription
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigation vers la page d'inscription
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: secondaryColor,
                    ),
                    child: Text(
                      'Inscris-toi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Mot de passe oublié
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigation vers la page de récupération de mot de passe
                    },
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FaIcon(
            icon,
            color: color,
            size: 28,
          ),
        ),
      ),
    );
  }
}