import 'package:flutter/material.dart';
import 'dart:math' as math;

class ReasonsPage extends StatefulWidget {
  @override
  _ReasonsPageState createState() => _ReasonsPageState();
}

class _ReasonsPageState extends State<ReasonsPage> {
  double moodValue = 0.5; // Valeur entre 0 et 1

  List<String> moodEmojis = ["😢", "😐", "🙂", "😊", "😍"];
  List<String> moodLabels = ["Triste", "Neutre", "Bien", "Heureux", "Génial"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          ),
        ),
        child: SafeArea(
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

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Titre
                      Text(
                        "Comment te sens-tu aujourd'hui ?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 40),

                      // Image chill.png
                      Image.asset(
                        '/assets/images/chill.png',
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(
                              Icons.mood,
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 60),

                      // Emoji actuel
                      Text(_getCurrentEmoji(), style: TextStyle(fontSize: 60)),

                      SizedBox(height: 20),

                      Text(
                        _getCurrentLabel(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 40),

                      // Courbe horizontale avec curseur
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: CustomPaint(
                          painter: MoodCurvePainter(moodValue),
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              RenderBox renderBox =
                                  context.findRenderObject() as RenderBox;
                              double localX = details.localPosition.dx;
                              double containerWidth = renderBox.size.width - 60;
                              double newValue = (localX - 30) / containerWidth;

                              setState(() {
                                moodValue = newValue.clamp(0.0, 1.0);
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 60),

                      // Bouton Humeur
                      ElevatedButton(
                        onPressed: () {
                          // Navigation vers une autre page (à définir)
                          print(
                            "Naviguer vers la page suivante avec humeur: ${_getCurrentLabel()}",
                          );
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
                          elevation: 5,
                        ),
                        child: Text(
                          "Humeur",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
    );
  }

  String _getCurrentEmoji() {
    int index = (moodValue * (moodEmojis.length - 1)).round();
    return moodEmojis[index];
  }

  String _getCurrentLabel() {
    int index = (moodValue * (moodLabels.length - 1)).round();
    return moodLabels[index];
  }
}

class MoodCurvePainter extends CustomPainter {
  final double moodValue;

  MoodCurvePainter(this.moodValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final cursorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Dessiner la courbe
    final path = Path();
    final startX = 30.0;
    final endX = size.width - 30;
    final centerY = size.height / 2;
    final curveHeight = 20.0;

    // Courbe arquée
    path.moveTo(startX, centerY + curveHeight);
    path.quadraticBezierTo(
      size.width / 2,
      centerY - curveHeight,
      endX,
      centerY + curveHeight,
    );

    canvas.drawPath(path, paint);

    // Position du curseur sur la courbe
    double cursorX = startX + (endX - startX) * moodValue;
    double t = moodValue;
    double cursorY = centerY + curveHeight * (1 - 4 * t * (1 - t));

    // Dessiner le curseur
    canvas.drawCircle(Offset(cursorX, cursorY), 12, cursorPaint);

    // Contour du curseur
    canvas.drawCircle(
      Offset(cursorX, cursorY),
      12,
      Paint()
        ..color = Color(0xFF8B5CF6)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
