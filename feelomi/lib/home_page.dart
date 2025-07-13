import 'package:feelomi/health_tracker.dart';
import 'package:feelomi/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Couleurs thématiques
  final Color primaryColor = const Color(0xFF8B5CF6);
  final secondaryColor = const Color.fromARGB(255, 90, 0, 150);
  final backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  // Contrôleur d'animation
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _buttonAnimation;

  // Contrôleur pour l'animation de fond
  late AnimationController _backgroundController;

  // États des animations
  bool _showParticles = false;
  bool _showWelcomeText = false;
  bool _readyForInteraction = false;

  get child => null;

  @override
  void initState() {
    super.initState();

    // Configuration des animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Démarrer l'animation
    _controller.forward();

    // Programmer les animations séquentielles
    _scheduleAnimations();
  }

  void _scheduleAnimations() {
    // Afficher les particules après un court délai
    Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showParticles = true;
        });
        HapticFeedback.lightImpact();
      }
    });

    // Afficher le texte d'accueil
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _showWelcomeText = true;
        });
      }
    });

    // Activer l'interactivité complète
    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _readyForInteraction = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenu principal
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Titre principal animé
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Bienvenue à toi !',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              shadows: [
                                Shadow(
                                  color: secondaryColor.withOpacity(0.3),
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Sous-titre animé
                          AnimatedOpacity(
                            opacity: _showWelcomeText ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeIn,
                            child: const Text(
                              'Je suis Feelo, ton compagnon IA personnalisé, prêt pour l\'aventure ?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Image de mascotte animée
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: _buildFeeloAnimation(),
                    ),

                    const SizedBox(height: 80),

                    // Bouton Commencer avec animation
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - _buttonAnimation.value)),
                          child: Opacity(
                            opacity: _buttonAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _readyForInteraction
                              ? () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HealthTracker(),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                            shadowColor: primaryColor.withOpacity(0.4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Commencer',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Texte de connexion avec animation de fondu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Vous avez déjà un compte ?',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Connectez vous',

                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour animer Feelo
  Widget _buildFeeloAnimation() {
    return Hero(
      tag: 'feelomi_mascot',
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              child: Image(
                image: const AssetImage('assets/images/hello.png'),
                width: 160,
                height: 160,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
