import 'package:flutter/material.dart';
import 'dart:math' as math;

class HowIFeelPage extends StatefulWidget {
  @override
  _HowIFeelPageState createState() => _HowIFeelPageState();
}

class _HowIFeelPageState extends State<HowIFeelPage> {
  int selectedMoodIndex = 2; // Index du point sélectionné (0-4)
  List<String> moodLabels = [
    "Très triste",
    "Triste",
    "Neutre",
    "Heureux",
    "Très heureux",
  ];
  List<String> moodEmojis = ["😢", "😞", "😐", "😊", "😍"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // Header avec bouton retour
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contenu principal
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),

                        // Titre
                        Text(
                          "Comment te sens-tu aujourd'hui ?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 30),

                        // Image questioning.png - chemin corrigé
                        Image.asset(
                          'assets/images/questionning.png',
                          width: 120,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 40),

                        // Label sélectionné (sans emoji)
                        Text(
                          moodLabels[selectedMoodIndex],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 50),

                        // Courbe avec 5 points (plus courbée)
                        Container(
                          width: double.infinity,
                          height: 100,
                          child: CustomPaint(
                            painter: MoodCurvePainter(selectedMoodIndex),
                            child: GestureDetector(
                              onTapDown: (details) {
                                _handleTap(details, context);
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 60),

                        // Bouton Humeur
                        ElevatedButton(
                          onPressed: () {
                            // Navigation vers la page suivante
                            print(
                              "Humeur sélectionnée: ${moodLabels[selectedMoodIndex]}",
                            );
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF8B5CF6),
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 6,
                          ),
                          child: Text(
                            "Humeur",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(TapDownDetails details, BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    double localX = details.localPosition.dx;
    double containerWidth = renderBox.size.width - 60;
    double segmentWidth = containerWidth / 4;

    int newIndex = ((localX - 30) / segmentWidth).round().clamp(0, 4);

    setState(() {
      selectedMoodIndex = newIndex;
    });
  }
}

class MoodCurvePainter extends CustomPainter {
  final int selectedIndex;

  MoodCurvePainter(this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final selectedPointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final selectedBorderPaint = Paint()
      ..color = Color(0xFF8B5CF6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Dessiner la courbe plus courbée vers le bas
    final path = Path();
    final startX = 30.0;
    final endX = size.width - 30;
    final centerY = size.height / 2 - 10;
    final curveDepth = 35.0; // Augmenté pour plus de courbure

    path.moveTo(startX, centerY);
    path.quadraticBezierTo(size.width / 2, centerY + curveDepth, endX, centerY);

    canvas.drawPath(path, linePaint);

    // Dessiner les 5 points (sans smileys)
    for (int i = 0; i < 5; i++) {
      double x = startX + (endX - startX) * (i / 4);
      double t = i / 4.0;
      double y = centerY + curveDepth * (4 * t * (1 - t));

      if (i == selectedIndex) {
        // Point sélectionné - plus grand avec bordure
        canvas.drawCircle(Offset(x, y), 14, selectedPointPaint);
        canvas.drawCircle(Offset(x, y), 14, selectedBorderPaint);
      } else {
        // Points non sélectionnés
        canvas.drawCircle(Offset(x, y), 8, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
