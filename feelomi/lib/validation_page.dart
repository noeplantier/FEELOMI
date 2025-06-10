import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feelomi/home_page.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'dart:async';
import 'dart:math' as math;

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage>
    with SingleTickerProviderStateMixin {
  // Controllers pour animations
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _fadeInAnimation;

  // États des animations
  bool _showConfetti = false;
  bool _showQuote = false;
  bool _isExitReady = false;

  // Liste de citations positives
  final List<String> _zenQuotes = [
    "Le plus beau voyage, c'est celui qu'on n'a pas encore fait.",
    "Ce n'est pas parce que les choses sont difficiles que nous n'osons pas, c'est parce que nous n'osons pas qu'elles sont difficiles.",
    "Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte.",
    "La vie est un défi à relever, un bonheur à mériter, une aventure à tenter.",
    "La paix vient de l'intérieur. Ne la cherchez pas à l'extérieur.",
  ];

  // Citation sélectionnée aléatoirement
  late String _selectedQuote;

  // Couleurs thématiques
  final Color _primaryColor = const Color.fromARGB(255, 150, 95, 186);
  final Color _accentColor = const Color.fromARGB(255, 90, 0, 150);
  final Color _backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  get Lottie => null;

  @override
  void initState() {
    super.initState();

    // Choisir une citation aléatoire
    final random = math.Random();
    _selectedQuote = _zenQuotes[random.nextInt(_zenQuotes.length)];

    // Configuration des animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // Démarrer l'animation principale
    _controller.forward();

    // Timing des animations séquentielles
    _scheduleAnimations();
  }

  void _scheduleAnimations() {
    // Animation de confettis après 1 seconde
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showConfetti = true;
        });

        // Vibration pour feedback
        HapticFeedback.mediumImpact();
      }
    });

    // Afficher la citation après 2 secondes
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showQuote = true;
        });
      }
    });

    // Activer le bouton de sortie après 3 secondes
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isExitReady = true;
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
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Barre chronologique en haut
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _accentColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                '✓',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Félicitations',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Barre de progression
                  LinearProgressIndicator(
                    value: 1.0, // 100% de progression
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),

            // Contenu principal
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti animation en arrière-plan
                  if (_showConfetti)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: lottie.Lottie.network(
                          'https://assets2.lottiefiles.com/packages/lf20_fcfjwiyb.json',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  // Contenu
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),

                          // Titre principal avec animation
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
                                  'Bravo !',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                    shadows: [
                                      Shadow(
                                        color: _accentColor.withOpacity(0.3),
                                        offset: const Offset(2, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tu viens de faire le premier pas vers un mieux-être',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: _accentColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Mascotte Feelo avec animation
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

                          const SizedBox(height: 40),

                          // Citation zen avec animation
                          AnimatedOpacity(
                            opacity: _showQuote ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeIn,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: _accentColor.withOpacity(0.1),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    color: _primaryColor.withOpacity(0.7),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _selectedQuote,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _accentColor,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Divider(
                                    color: _primaryColor.withOpacity(0.2),
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nous sommes ravis de t\'accompagner dans ton voyage vers une meilleure santé mentale.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Prochain rendez-vous
                          AnimatedOpacity(
                            opacity: _fadeInAnimation.value,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _primaryColor.withOpacity(0.2),
                                    ),
                                    child: Icon(
                                      Icons.calendar_today_rounded,
                                      color: _primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ton prochain rendez-vous',
                                          style: TextStyle(
                                            color: _accentColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Reviens demain pour continuer ton parcours zen avec Feelo',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bouton de continuer en bas
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isExitReady
                      ? () {
                          // Feedback haptique
                          HapticFeedback.mediumImpact();
                          // Navigation vers la page d'accueil
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    shadowColor: _primaryColor.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Commencer l\'aventure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: _primaryColor,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget animé pour Feelo
  Widget _buildFeeloAnimation() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base de l'écureuil
          Image.network(
            'https://img.freepik.com/vecteurs-premium/ecureuil-mignon-lunettes-mascotte-dessin-anime_138676-2550.jpg',
            height: 150,
            width: 150,
            fit: BoxFit.contain,
          ),

          // Animation de particules/étoiles autour de Feelo
          if (_showConfetti) ..._buildStarParticles(),

          // Animation de battement de coeur
          if (_showConfetti)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: 1.1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return AnimatedScale(
                  scale: value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: child,
                );
              },
              child: Image.network(
                'https://img.freepik.com/vecteurs-premium/ecureuil-mignon-lunettes-mascotte-dessin-anime_138676-2550.jpg',
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }

  // Particules d'étoiles autour de Feelo
  List<Widget> _buildStarParticles() {
    final random = math.Random();
    return List.generate(8, (index) {
      final double angle = index * (math.pi * 2) / 8;
      final double distance = 90.0 + random.nextDouble() * 20;
      final double x = math.cos(angle) * distance;
      final double y = math.sin(angle) * distance;

      return Positioned(
        left: 100 + x - 10,
        top: 100 + y - 10,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + random.nextInt(700)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(scale: value, child: child),
            );
          },
          child: Icon(
            Icons.star,
            color: [
              Colors.yellow,
              Colors.amber,
              _primaryColor,
              Colors.pink.shade300,
            ][random.nextInt(4)],
            size: 10 + random.nextInt(15).toDouble(),
          ),
        ),
      );
    });
  }
}
