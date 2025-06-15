import 'package:flutter/material.dart';
import 'dart:math' as math;

class FeelingPage extends StatefulWidget {
  const FeelingPage({Key? key}) : super(key: key);

  @override
  _FeelingPageState createState() => _FeelingPageState();
}

class _FeelingPageState extends State<FeelingPage> {
  // État de l'humeur actuelle (0.0 à 1.0)
  double _feelingValue = 0.5;

  // Définition des niveaux d'humeur
  final List<String> _moodLabels = [
    'Terrible',
    'Mauvais',
    'Médiocre',
    'Neutre',
    'Bien',
    'Très bien',
    'Excellent',
  ];
  final List<Color> _moodColors = [
    Colors.red[900]!,
    Colors.red[400]!,
    Colors.orange,
    Colors.grey,
    Colors.lightGreen,
    Colors.green,
    Colors.green[900]!,
  ];

  // Fonction pour obtenir la couleur correspondant à l'humeur actuelle
  Color _getFeelingColor() {
    if (_feelingValue < 0.17) {
      return _moodColors[0];
    } else if (_feelingValue < 0.34) {
      return _moodColors[1];
    } else if (_feelingValue < 0.5) {
      return _moodColors[2];
    } else if (_feelingValue < 0.67) {
      return _moodColors[3];
    } else if (_feelingValue < 0.84) {
      return _moodColors[4];
    } else if (_feelingValue < 0.95) {
      return _moodColors[5];
    } else {
      return _moodColors[6];
    }
  }

  // Fonction pour obtenir la description de l'humeur actuelle
  String _getFeelingDescription() {
    if (_feelingValue < 0.17) {
      return _moodLabels[0];
    } else if (_feelingValue < 0.34) {
      return _moodLabels[1];
    } else if (_feelingValue < 0.5) {
      return _moodLabels[2];
    } else if (_feelingValue < 0.67) {
      return _moodLabels[3];
    } else if (_feelingValue < 0.84) {
      return _moodLabels[4];
    } else if (_feelingValue < 0.95) {
      return _moodLabels[5];
    } else {
      return _moodLabels[6];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment vous sentez-vous?'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Feelo avec expression faciale qui change
              Container(
                height: 150,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Arrière-plan blanc avec ombre
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    // Visage de Feelo
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: FeeloFacePainter(
                        smileFactor: _feelingValue,
                        color: _getFeelingColor(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Description de l'humeur
              Text(
                _getFeelingDescription(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getFeelingColor(),
                ),
              ),

              const SizedBox(height: 40),

              // Curseur d'humeur arqué
              Container(
                height: 110,
                child: MoodArcSlider(
                  value: _feelingValue,
                  colors: _moodColors,
                  onChange: (value) {
                    setState(() {
                      _feelingValue = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Boutons de notes rapides sur l'humeur
              const Text(
                "Qu'est-ce qui vous fait vous sentir ainsi ?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),

              // Grille de tags
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildMoodTag("Travail"),
                    _buildMoodTag("Famille"),
                    _buildMoodTag("Amis"),
                    _buildMoodTag("Santé"),
                    _buildMoodTag("Finances"),
                    _buildMoodTag("Loisirs"),
                    _buildMoodTag("Amour"),
                    _buildMoodTag("Études"),
                    _buildMoodTag("Autre"),
                  ],
                ),
              ),

              // Bouton de sauvegarde
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Sauvegarder l'humeur
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Humeur enregistrée!')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodTag(String label) {
    return FilterChip(
      label: Text(label),
      labelStyle: const TextStyle(fontSize: 14),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (bool selected) {
        // Gérer la sélection du tag
      },
    );
  }
}

class MoodArcSlider extends StatefulWidget {
  final double value;
  final Function(double) onChange;
  final List<Color> colors;

  const MoodArcSlider({
    Key? key,
    required this.value,
    required this.onChange,
    required this.colors,
  }) : super(key: key);

  @override
  _MoodArcSliderState createState() => _MoodArcSliderState();
}

class _MoodArcSliderState extends State<MoodArcSlider> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 100),
      painter: MoodArcPainter(colors: widget.colors),
      child: GestureDetector(
        onPanUpdate: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.globalToLocal(details.globalPosition);
          final width = renderBox.size.width;

          double value = (position.dx / width).clamp(0.0, 1.0);
          widget.onChange(value);
        },
        child: CustomPaint(
          painter: MoodArcHandlePainter(
            value: widget.value,
            color: widget
                .colors[((widget.value * (widget.colors.length - 1)).round())],
          ),
        ),
      ),
    );
  }
}

class MoodArcPainter extends CustomPainter {
  final List<Color> colors;

  MoodArcPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final gradient = LinearGradient(
      colors: colors,
      stops: List.generate(
        colors.length,
        (index) => index / (colors.length - 1),
      ),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Dessiner un arc légèrement courbé
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 2),
        width: size.width * 0.95,
        height: size.height * 2,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Ajouter des marqueurs pour les différents niveaux
    final markerPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2;

    for (int i = 0; i <= 6; i++) {
      final angle = math.pi + (math.pi * i / 6);

      final startPoint = Offset(
        size.width / 2 + (size.width * 0.475 - 10) * math.cos(angle),
        size.height * 2 + (size.height * 2) * math.sin(angle),
      );

      final endPoint = Offset(
        size.width / 2 + (size.width * 0.475 + 5) * math.cos(angle),
        size.height * 2 + (size.height * 2) * math.sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, markerPaint);
    }
  }

  @override
  bool shouldRepaint(MoodArcPainter oldDelegate) =>
      colors != oldDelegate.colors;
}

class MoodArcHandlePainter extends CustomPainter {
  final double value;
  final Color color;

  MoodArcHandlePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Position du curseur sur l'arc
    final angle = math.pi + (math.pi * value);
    final center = Offset(
      size.width / 2 + (size.width * 0.475) * math.cos(angle),
      size.height * 2 + (size.height * 2) * math.sin(angle),
    );

    // Dessiner le cercle du curseur
    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Ombre
    canvas.drawCircle(
      center.translate(0, 2),
      15,
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    // Cercle blanc extérieur
    canvas.drawCircle(center, 14, Paint()..color = Colors.white);

    // Cercle coloré intérieur
    canvas.drawCircle(center, 10, handlePaint);
  }

  @override
  bool shouldRepaint(MoodArcHandlePainter oldDelegate) =>
      value != oldDelegate.value || color != oldDelegate.color;
}

class FeeloFacePainter extends CustomPainter {
  final double smileFactor; // 0.0 à 1.0 (triste à heureux)
  final Color color;

  FeeloFacePainter({required this.smileFactor, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Dessiner le visage rond
    final facePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, facePaint);

    // Dessiner les yeux
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Yeux
    final eyeRadius = radius * 0.15;
    final eyeOffsetX = radius * 0.3;
    final eyeOffsetY = radius * 0.1;

    canvas.drawCircle(
      Offset(centerX - eyeOffsetX, centerY - eyeOffsetY),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(centerX + eyeOffsetX, centerY - eyeOffsetY),
      eyeRadius,
      eyePaint,
    );

    // Pupilles
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final pupilRadius = eyeRadius * 0.5;
    canvas.drawCircle(
      Offset(centerX - eyeOffsetX, centerY - eyeOffsetY),
      pupilRadius,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(centerX + eyeOffsetX, centerY - eyeOffsetY),
      pupilRadius,
      pupilPaint,
    );

    // Dessiner la bouche (qui varie selon le niveau d'humeur)
    final mouthPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round;

    // Calculer le type de sourire basé sur le facteur de sourire
    final mouthWidth = radius * 1.2;
    final mouthHeight = radius * 0.6 * (smileFactor * 2 - 1); // -0.6 à +0.6

    final mouthRect = Rect.fromCenter(
      center: Offset(centerX, centerY + radius * 0.3),
      width: mouthWidth,
      height: mouthHeight.abs(),
    );

    final startAngle = mouthHeight > 0 ? 0.0 : math.pi;
    final sweepAngle = math.pi;

    canvas.drawArc(
      mouthRect,
      startAngle,
      sweepAngle.toDouble(),
      false,
      mouthPaint,
    );
  }

  @override
  bool shouldRepaint(FeeloFacePainter oldDelegate) =>
      smileFactor != oldDelegate.smileFactor || color != oldDelegate.color;
}
