import 'package:feelomi/analysis_page.dart';
import 'package:feelomi/better_page.dart';
import 'package:feelomi/custom_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'happy_page.dart';
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'package:fl_chart/fl_chart.dart';

class StressPage extends StatefulWidget {
  const StressPage({super.key});

  @override
  State<StressPage> createState() => _StressPageState();
}

class _StressPageState extends State<StressPage>
    with SingleTickerProviderStateMixin {
  // Niveau de stress (0: Inexistant, 1: Faible, 2: Modéré, 3: Important)
  int _stressLevel = 1; // Par défaut à "Faible"

  // Animation controller pour l'animation de la jauge
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Niveaux de stress disponibles
  final List<Map<String, dynamic>> _stressLevels = [
    {
      'level': 0,
      'title': 'Inexistant',
      'color': Colors.green.shade400,
      'icon': Icons.sentiment_very_satisfied,
      'description': 'Je me sens détendu et calme',
    },
    {
      'level': 1,
      'title': 'Faible',
      'color': Colors.lightGreen.shade400,
      'icon': Icons.sentiment_satisfied,
      'description': 'Légères inquiétudes occasionnelles',
    },
    {
      'level': 2,
      'title': 'Modéré',
      'color': Colors.amber.shade600,
      'icon': Icons.sentiment_neutral,
      'description': 'Stress régulier mais gérable',
    },
    {
      'level': 3,
      'title': 'Important',
      'color': Colors.deepOrange.shade600,
      'icon': Icons.sentiment_very_dissatisfied,
      'description': 'Anxiété constante, difficulté à se détendre',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation =
        Tween<double>(
          begin: 0,
          end: _stressLevel / (_stressLevels.length - 1),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fonction pour changer le niveau de stress
  void _setStressLevel(int level) {
    if (level == _stressLevel) return;

    HapticFeedback.lightImpact();

    setState(() {
      _animation =
          Tween<double>(
            begin: _stressLevel / (_stressLevels.length - 1),
            end: level / (_stressLevels.length - 1),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            ),
          );

      _stressLevel = level;
    });

    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 150, 95, 186);
    final secondaryColor = const Color.fromARGB(255, 90, 0, 150);
    final deviceWidth = MediaQuery.of(context).size.width;
    // Define a stressLevel value to use in the chart
    final stressLevel =
        _stressLevel * 25.0; // Scale value appropriately for the chart

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barre chronologique en haut
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
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
                          CustomBackButton(
                            iconColor: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                '11',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Stress',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigation vers la page du bonheur
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HappyPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Passer cette étape',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Barre de progression
                  LinearProgressIndicator(
                    value: 1.43,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),

                          // Titre principal en violet
                          Text(
                            'Comment évalues-tu ton niveau de stress ?',
                            style: TextStyle(
                              fontSize: 24, // Taille réduite
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          // Sous-titre explicatif
                          Text(
                            'Le stress peut avoir un impact sur ton bien-être au quotidien.',
                            style: TextStyle(
                              fontSize: 14, // Taille réduite
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Remplacer le widget CircularPercentIndicator par:
                    Container(
                      height: 200,
                      padding: EdgeInsets.all(16),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(
                                  0,
                                  stressLevel,
                                ), // Utiliser la valeur existante
                                FlSpot(1, stressLevel * 0.8),
                                FlSpot(2, stressLevel * 0.9),
                                FlSpot(3, stressLevel),
                              ],
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF9C27B0), // Violet foncé
                                  Color(0xFFE1BEE7), // Violet clair
                                ],
                              ),
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF9C27B0).withOpacity(0.3),
                                    Color(0xFFE1BEE7).withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          minX: 0,
                          maxX: 3,
                          minY: 0,
                          maxY: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Réduit de 20 à 10
                    // Niveau actuel avec description
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey<int>(_stressLevel),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ), // Réduit vertical de 12 à 10
                        decoration: BoxDecoration(
                          color: _stressLevels[_stressLevel]['color']
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _stressLevels[_stressLevel]['color'],
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _stressLevels[_stressLevel]['title'],
                              style: TextStyle(
                                fontSize: 20, // Réduit de 24 à 20
                                fontWeight: FontWeight.bold,
                                color: _stressLevels[_stressLevel]['color'],
                              ),
                            ),
                            const SizedBox(height: 4), // Réduit de 8 à 4
                            Text(
                              _stressLevels[_stressLevel]['description'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13, // Réduit de 14 à 13
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Message informatif
                    Padding(
                      padding: const EdgeInsets.all(16), // Réduit de 24 à 16
                      child: Container(
                        padding: const EdgeInsets.all(12), // Réduit de 16 à 12
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.blue.shade700,
                              size: 20, // Réduit de 24 à 20
                            ),
                            const SizedBox(width: 10), // Réduit de 12 à 10
                            Expanded(
                              child: Text(
                                'Un niveau de stress bien géré peut améliorer ton quotidien. '
                                'Nous te proposerons des activités adaptées à ton niveau de stress.',
                                style: TextStyle(
                                  fontSize: 12, // Réduit de 14 à 12
                                  color: Colors.blue.shade900,
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
            ),

            // Bouton Continuer en bas
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ), // Réduit vertical de 24 à 16
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Enregistrer le niveau de stress
                    final stressTitle = _stressLevels[_stressLevel]['title'];

                    // Navigation vers la page d'engagement
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HappyPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _stressLevels[_stressLevel]['color'],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continuer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 15),
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

  CircleProgressPainter({
    required double progress,
    required Color color,
    required int strokeWidth,
  }) {
    return CircleGaugePainter(
      progress: progress,
      color: color,
      strokeWidth: strokeWidth.toDouble(),
    );
  }
}

// Painter personnalisé pour dessiner une jauge circulaire
class CircleGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircleGaugePainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Centre et rayon du cercle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - (strokeWidth / 2);

    // Angle de départ (-90 degrés = haut du cercle)
    const startAngle = -math.pi / 2;

    // Angle de fin basé sur la progression (2*pi = tour complet)
    final sweepAngle = 2 * math.pi * progress;

    // Dessiner l'arc de cercle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false, // Ne pas remplir le centre
      paint,
    );

    // Ajouter des segments pour un effet numérique
    if (progress > 0) {
      const segmentCount = 40; // Nombre de segments pour un cercle complet
      final segmentsToShow = (segmentCount * progress).floor();

      // Calculer l'angle entre chaque segment
      final segmentAngle = 2 * math.pi / segmentCount;

      // Espace entre les segments
      const segmentGap = 0.05;

      // Modifier la couleur et l'épaisseur pour les segments
      final segmentPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth * 1.2; // Légèrement plus épais

      for (int i = 0; i < segmentsToShow; i++) {
        // Calculer l'angle de début et de fin de ce segment
        final segStart = startAngle + i * segmentAngle;
        final segEnd = segStart + segmentAngle * (1 - segmentGap);

        // Dessiner ce segment
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          segStart,
          segmentAngle * (1 - segmentGap),
          false,
          segmentPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CircleGaugePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
