import 'package:feelomi/checking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math' as math;

class FeelingTracker extends StatefulWidget {
  const FeelingTracker({Key? key}) : super(key: key);

  @override
  State<FeelingTracker> createState() => _FeelingTrackerState();
}

class _FeelingTrackerState extends State<FeelingTracker>
    with SingleTickerProviderStateMixin {
  // Couleurs thématiques
  final Color _primaryColor = const Color.fromARGB(255, 150, 95, 186);
  final Color _accentColor = const Color.fromARGB(255, 90, 0, 150);
  final Color _backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  // Animations
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _smileAnimation;

  // Valeur de l'humeur (entre 0.0 et 1.0)
  double _feelingValue = 0.5;

  // Données sauvegardées
  Map<String, dynamic> _trackerData = {};

  // Contrôleur pour le champ de notes
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrackerData();

    // Initialisation de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animation pour l'échelle
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Animation pour le sourire de Feelo
    _smileAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Démarrer l'animation après un court délai
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Charge les données sauvegardées
  Future<void> _loadTrackerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Récupère les données du jour si elles existent
    String? dataString = prefs.getString('feeling_tracker_$today');
    if (dataString != null) {
      setState(() {
        _trackerData = json.decode(dataString);
        _feelingValue = _trackerData['feeling_value'] ?? 0.5;
        _notesController.text = _trackerData['notes'] ?? '';
      });
    }
  }

  // Sauvegarde les données
  Future<void> _saveTrackerData() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mise à jour des données
    _trackerData = {
      'feeling_value': _feelingValue,
      'notes': _notesController.text,
      'date': today,
    };

    // Sauvegarde dans les préférences
    await prefs.setString('feeling_tracker_$today', json.encode(_trackerData));

    // Feedback haptique
    HapticFeedback.mediumImpact();

    // Affiche un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tes émotions ont été enregistrées !'),
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Méthode pour continuer vers l'écran suivant
  void _continueToNextScreen() {
    _saveTrackerData();

    // Animation lors du clic
    _animationController.reset();
    _animationController.forward();

    // Navigation vers l'écran précédent après sauvegarde
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const CheckingPage()));
      }
    });
  }

  // Description textuelle de l'humeur
  String _getFeelingDescription() {
    if (_feelingValue < 0.2) return "Très mal";
    if (_feelingValue < 0.4) return "Mal";
    if (_feelingValue < 0.6) return "Neutre";
    if (_feelingValue < 0.8) return "Bien";
    return "Très bien";
  }

  // Couleur correspondant à l'humeur
  Color _getFeelingColor() {
    if (_feelingValue < 0.2) return Colors.red;
    if (_feelingValue < 0.4) return Colors.orange;
    if (_feelingValue < 0.6) return Colors.amber;
    if (_feelingValue < 0.8) return Colors.lightGreen;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Ton humeur aujourd\'hui'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Glissement vers la droite, retourne à la page précédente
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header avec la mascotte Feelo qui sourit
              Container(
                color: _primaryColor,
                padding: const EdgeInsets.only(bottom: 40, top: 20),
                child: Column(
                  children: [
                    // Image de Feelo avec animation de sourire
                    Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Hero(
                              tag: 'feeling_logo',
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Cercle de fond
                                  Container(
                                    width: 140,
                                    height: 140,
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
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _getFeelingDescription(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Comment te sens-tu aujourd\'hui ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tracker d'humeur en arc de cercle
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ton niveau de bien-être',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _accentColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Expanded(child: _buildEmotionArc()),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Très mal',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      Text(
                                        'Neutre',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      Text(
                                        'Très bien',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _getFeelingColor(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _getFeelingDescription(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Explications
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: _accentColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Pourquoi suivre tes émotions ?',
                                  style: TextStyle(
                                    color: _accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Suivre tes émotions quotidiennement t\'aide à mieux comprendre tes variations d\'humeur et à identifier les facteurs qui influencent ton bien-être.',
                              style: TextStyle(fontSize: 15, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Notes supplémentaires
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes personnelles',
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _notesController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Qu\'est-ce qui influence ton humeur aujourd\'hui ?',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: _primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Bouton Continuer
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _continueToNextScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Enregistrer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.check_circle_outline),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construction de l'arc d'émotion
  Widget _buildEmotionArc() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight * 0.8;

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Fond de l'arc
            CustomPaint(
              size: Size(width, height),
              painter: EmotionArcBackgroundPainter(),
            ),

            // Arc de progression
            CustomPaint(
              size: Size(width, height),
              painter: EmotionArcProgressPainter(_feelingValue),
            ),

            // Curseur interactif
            GestureDetector(
              onPanUpdate: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final position = box.globalToLocal(details.globalPosition);
                final dx = position.dx.clamp(0, width);

                setState(() {
                  _feelingValue = dx / width;
                });
              },
              child: Container(
                width: width,
                height: height,
                color: Colors.transparent,
                child: CustomPaint(
                  size: Size(width, height),
                  painter: EmotionCursorPainter(_feelingValue),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Peintre pour le visage de Feelo
class FeeloFacePainter extends CustomPainter {
  final double smileFactor; // 0.0 = triste, 1.0 = très heureux
  final Color color;

  FeeloFacePainter({required this.smileFactor, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Visage
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Dessiner les yeux
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // Œil gauche
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.1),
      radius * 0.1,
      eyePaint,
    );

    // Œil droit
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.1),
      radius * 0.1,
      eyePaint,
    );

    // Dessiner la bouche (sourire ou tristesse en fonction de smileFactor)
    final smilePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final smileControl = Offset(
      center.dx,
      center.dy + radius * 0.5 * (smileFactor * 2 - 1),
    );

    final path = Path()
      ..moveTo(center.dx - radius * 0.4, center.dy + radius * 0.1)
      ..quadraticBezierTo(
        smileControl.dx,
        smileControl.dy,
        center.dx + radius * 0.4,
        center.dy + radius * 0.1,
      );

    canvas.drawPath(path, smilePaint);

    // Ajout des sourcils (qui changent avec l'humeur)
    final eyebrowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    // Sourcil gauche
    final leftEyebrowStart = Offset(
      center.dx - radius * 0.4,
      center.dy - radius * 0.3,
    );
    final leftEyebrowEnd = Offset(
      center.dx - radius * 0.2,
      center.dy - radius * (0.3 + 0.1 * smileFactor),
    );
    canvas.drawLine(leftEyebrowStart, leftEyebrowEnd, eyebrowPaint);

    // Sourcil droit
    final rightEyebrowStart = Offset(
      center.dx + radius * 0.2,
      center.dy - radius * (0.3 + 0.1 * smileFactor),
    );
    final rightEyebrowEnd = Offset(
      center.dx + radius * 0.4,
      center.dy - radius * 0.3,
    );
    canvas.drawLine(rightEyebrowStart, rightEyebrowEnd, eyebrowPaint);
  }

  @override
  bool shouldRepaint(FeeloFacePainter oldDelegate) {
    return oldDelegate.smileFactor != smileFactor || oldDelegate.color != color;
  }
}

// Peintre pour l'arrière-plan de l'arc d'émotion
class EmotionArcBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Gradient linéaire pour l'arc
    final gradient = LinearGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.amber,
        Colors.lightGreen,
        Colors.green,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    // Création d'un rectangle avec le gradient
    final rect = Rect.fromLTWH(0, height * 0.7, width, height * 0.1);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final arcRect = Rect.fromLTWH(
      0,
      -height * 2 + height * 0.8,
      width,
      height * 2.5,
    );

    // Dessin de l'arc de fond
    canvas.drawArc(arcRect, math.pi, math.pi, true, paint);

    // Ligne grise par-dessus pour délimiter
    final linePaint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(arcRect, math.pi, math.pi, false, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Peintre pour l'arc de progression
class EmotionArcProgressPainter extends CustomPainter {
  final double progress; // 0.0 à 1.0

  EmotionArcProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Récupère la couleur en fonction de la progression
    Color color;
    if (progress < 0.2)
      color = Colors.red;
    else if (progress < 0.4)
      color = Colors.orange;
    else if (progress < 0.6)
      color = Colors.amber;
    else if (progress < 0.8)
      color = Colors.lightGreen;
    else
      color = Colors.green;

    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final arcRect = Rect.fromLTWH(
      0,
      -height * 2 + height * 0.8,
      width,
      height * 2.5,
    );

    // Dessin de l'arc progressif
    canvas.drawArc(arcRect, math.pi, progress * math.pi, true, paint);
  }

  @override
  bool shouldRepaint(covariant EmotionArcProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Peintre pour le curseur de l'arc
class EmotionCursorPainter extends CustomPainter {
  final double position; // 0.0 à 1.0

  EmotionCursorPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Récupère la couleur en fonction de la progression
    Color color;
    if (position < 0.2)
      color = Colors.red;
    else if (position < 0.4)
      color = Colors.orange;
    else if (position < 0.6)
      color = Colors.amber;
    else if (position < 0.8)
      color = Colors.lightGreen;
    else
      color = Colors.green;

    // Cercle pour le curseur
    final cursorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final arcRect = Rect.fromLTWH(
      0,
      -height * 2 + height * 0.8,
      width,
      height * 2.5,
    );

    // Calculer la position du curseur sur l'arc
    final angle = math.pi + position * math.pi;
    final radius = height * 2.5 / 2;
    final center = Offset(width / 2, -height * 2 + height * 0.8 + radius);

    final cursorX = center.dx + radius * math.cos(angle);
    final cursorY = center.dy + radius * math.sin(angle);

    // Dessiner le curseur (cercle avec bordure)
    canvas.drawCircle(Offset(cursorX, cursorY), 15, cursorPaint);
    canvas.drawCircle(Offset(cursorX, cursorY), 15, borderPaint);
  }

  @override
  bool shouldRepaint(covariant EmotionCursorPainter oldDelegate) {
    return oldDelegate.position != position;
  }
}
