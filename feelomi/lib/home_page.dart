import 'package:feelomi/health_tracker.dart';
import 'package:feelomi/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'dart:async';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Couleurs thématiques
  final primaryColor = const Color.fromARGB(255, 150, 95, 186);
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
            // Animation de fond avec particules
            if (_showParticles)
              Positioned.fill(
                child: IgnorePointer(child: _buildBackgroundParticles()),
              ),

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

                    const SizedBox(height: 60),

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
                    AnimatedOpacity(
                      opacity: _readyForInteraction ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Column(
                        children: [
                          const Text(
                            'Vous avez déjà un compte ?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Bouton de connexion
                          TextButton(
                            onPressed: _readyForInteraction
                                ? () {
                                    HapticFeedback.lightImpact();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  }
                                : null,
                            style: TextButton.styleFrom(
                              foregroundColor: secondaryColor,
                            ),
                            child: const Text(
                              'Connectez-vous',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Espace supplémentaire en bas
                    const SizedBox(height: 30),
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

  // Animation de particules en arrière-plan
  Widget _buildBackgroundParticles() {
    return Stack(
      children: [
        // Fond avec effet de particules personnalisé
        CustomPaint(
          painter: ParticlesBackgroundPainter(
            baseColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
          size: Size.infinite,
        ),

        // Effet de flux dynamique
        _showParticles ? _buildFluidAnimation() : const SizedBox.shrink(),
      ],
    );
  }

  // Animation fluide pour l'arrière-plan
  Widget _buildFluidAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FluidAnimationPainter(
            animation: _controller,
            primaryColor: primaryColor.withOpacity(0.2),
            secondaryColor: secondaryColor.withOpacity(0.1),
          ),
          size: Size.infinite,
        );
      },
    );
  }

  // Particules/étoiles autour de Feelo
  List<Widget> _buildStarParticles() {
    final random = math.Random();
    return List.generate(8, (index) {
      final double angle = index * (math.pi * 2) / 8;
      final double distance = 90.0 + random.nextDouble() * 20;
      final double x = math.cos(angle) * distance;
      final double y = math.sin(angle) * distance;

      return Positioned(
        left: 100 + x - 8,
        top: 100 + y - 8,
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
            Icons.star_rounded,
            color: [
              Colors.amber.shade300,
              primaryColor.withOpacity(0.7),
              Colors.purple.shade300,
              Colors.pink.shade200,
            ][random.nextInt(4)],
            size: 8 + random.nextInt(10).toDouble(),
          ),
        ),
      );
    });
  }
}

// Peintre personnalisé pour l'animation de fond avec particules
class ParticlesBackgroundPainter extends CustomPainter {
  final Color baseColor;
  final Color secondaryColor;
  final int particleCount = 80;
  final List<Offset> particles = [];
  final List<double> particleSizes = [];
  final List<Color> particleColors = [];

  ParticlesBackgroundPainter({
    required this.baseColor,
    required this.secondaryColor,
  }) {
    final random = math.Random();
    for (int i = 0; i < particleCount; i++) {
      particles.add(
        Offset(random.nextDouble() * 500, random.nextDouble() * 900),
      );

      particleSizes.add(2 + random.nextDouble() * 5);

      final isBase = random.nextBool();
      final opacity = 0.1 + random.nextDouble() * 0.3;
      particleColors.add(
        isBase
            ? baseColor.withOpacity(opacity)
            : secondaryColor.withOpacity(opacity),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Dessiner les particules
    for (int i = 0; i < particleCount; i++) {
      final paint = Paint()
        ..color = particleColors[i]
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particles[i], particleSizes[i], paint);
    }

    // Dessiner des vagues douces en arrière-plan
    _drawWaves(canvas, size);
  }

  void _drawWaves(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = baseColor.withOpacity(0.07)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Première vague
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);

    // Deuxième vague
    final path2 = Path();
    path2.moveTo(0, size.height * 0.9);
    path2.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.95,
      size.width * 0.5,
      size.height * 0.9,
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.85,
      size.width,
      size.height * 0.9,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    final wavePaint2 = Paint()
      ..color = secondaryColor.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path2, wavePaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Peintre pour l'animation fluide
class FluidAnimationPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;

  FluidAnimationPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final time = animation.value;
    final height = size.height;
    final width = size.width;

    // Première couche fluide
    final path1 = Path();
    path1.moveTo(0, height * 0.5);

    for (double x = 0; x <= width; x += width / 20) {
      final y =
          height * 0.5 +
          math.sin((x / width * 4 * math.pi) + (time * 5)) * 30 +
          math.sin((x / width * 2 * math.pi) + (time * 3)) * 20;
      path1.lineTo(x, y);
    }

    path1.lineTo(width, height);
    path1.lineTo(0, height);
    path1.close();

    final paint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path1, paint1);

    // Deuxième couche fluide
    final path2 = Path();
    path2.moveTo(0, height * 0.6);

    for (double x = 0; x <= width; x += width / 20) {
      final y =
          height * 0.6 +
          math.sin((x / width * 3 * math.pi) - (time * 4)) * 25 +
          math.sin((x / width * 5 * math.pi) - (time * 2)) * 15;
      path2.lineTo(x, y);
    }

    path2.lineTo(width, height);
    path2.lineTo(0, height);
    path2.close();

    final paint2 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(FluidAnimationPainter oldDelegate) => true;
}
