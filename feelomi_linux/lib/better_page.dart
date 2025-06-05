import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'happy_page.dart';
import 'dart:ui' as ui;

class BetterPage extends StatefulWidget {
  const BetterPage({super.key});

  @override
  State<BetterPage> createState() => _BetterPageState();
}

class _BetterPageState extends State<BetterPage> {
  // Contrôleur pour le dessin
  final List<DrawingPoint?> _points = [];
  Color _selectedColor = Colors.white;
  double _strokeWidth = 5.0;
  bool _showCompletionMessage = false;
  bool _hasDrawnSmile = false;
  
  // Méthode pour effacer le dessin
  void _clearDrawing() {
    setState(() {
      _points.clear();
      _showCompletionMessage = false;
      _hasDrawnSmile = false;
    });
    HapticFeedback.mediumImpact();
  }
  
  // Méthode pour vérifier si un visage souriant a été dessiné (simulation)
  void _checkDrawing() {
    if (_points.length > 10) {
      setState(() {
        _hasDrawnSmile = true;
        _showCompletionMessage = true;
      });
      
      // Vibration pour feedback positif
      HapticFeedback.heavyImpact();
      
      // Message de félicitations après un délai
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Superbe sourire! 😊'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Essaie de dessiner un visage souriant plus complet'),
          backgroundColor: Colors.amber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 90, 0, 150);
    final secondaryColor = const Color.fromARGB(255, 150, 95, 186);
    final backgroundColor = const Color.fromARGB(255, 70, 0, 120);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Barre chronologique en haut
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '12',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Engagement',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Action pour passer l'étape
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Étape ignorée')),
                          );
                          // Navigation vers la page du bonheur
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const HappyPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Passer cette étape',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Barre de progression
                  LinearProgressIndicator(
                    value: 1.0, // 100% de progression
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Titre principal
                      const Text(
                        'Prêt à t\'engager pour une meilleure santé mentale ?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Drapeau avec symbole de santé mentale
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.psychology,
                                color: primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Feelomi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 3,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Santé mentale',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Instructions pour le dessin
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.draw,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Dessine un visage souriant',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Pour symboliser ton engagement, dessine un simple visage souriant ci-dessous. Ce petit geste représente ton premier pas vers un mieux-être.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Zone de dessin
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Zone de dessin
                            GestureDetector(
                              onPanStart: (details) {
                                setState(() {
                                  _points.add(
                                    DrawingPoint(
                                      details.localPosition,
                                      Paint()
                                        ..color = _selectedColor
                                        ..isAntiAlias = true
                                        ..strokeWidth = _strokeWidth
                                        ..strokeCap = StrokeCap.round,
                                    ),
                                  );
                                });
                              },
                              onPanUpdate: (details) {
                                setState(() {
                                  _points.add(
                                    DrawingPoint(
                                      details.localPosition,
                                      Paint()
                                        ..color = _selectedColor
                                        ..isAntiAlias = true
                                        ..strokeWidth = _strokeWidth
                                        ..strokeCap = StrokeCap.round,
                                    ),
                                  );
                                });
                              },
                              onPanEnd: (details) {
                                setState(() {
                                  _points.add(null); // Marquer la fin d'une ligne
                                });
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CustomPaint(
                                  painter: DrawingPainter(_points),
                                  size: Size.infinite,
                                ),
                              ),
                            ),
                            
                            // Instructions au centre si vide
                            if (_points.isEmpty)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      size: 40,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Dessine ici',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            // Message de validation quand sourire détecté
                            if (_showCompletionMessage)
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Sourire détecté!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Barre d'outils de dessin
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bouton pour effacer
                          IconButton(
                            onPressed: _clearDrawing,
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            tooltip: 'Effacer',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Changement de couleur
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Couleur:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ...List.generate(3, (index) {
                                  final colors = [
                                    Colors.white,
                                    Colors.yellow,
                                    Colors.cyan,
                                  ];
                                  
                                  return GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      setState(() {
                                        _selectedColor = colors[index];
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: colors[index],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _selectedColor == colors[index]
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                        boxShadow: _selectedColor == colors[index]
                                            ? [
                                                BoxShadow(
                                                  color: Colors.white.withOpacity(0.5),
                                                  blurRadius: 8,
                                                  spreadRadius: 1,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Bouton pour vérifier
                          IconButton(
                            onPressed: _checkDrawing,
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            tooltip: 'Vérifier le dessin',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Citation inspirante
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.format_quote,
                              color: Colors.white70,
                              size: 24,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Le plus grand voyage commence par un simple pas vers soi-même.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Feelomi',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bouton Continuer en bas
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Vérifier si l'utilisateur a dessiné quelque chose
                    if (_points.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dessine un sourire pour symboliser ton engagement'),
                          backgroundColor: Colors.amber,
                        ),
                      );
                      return;
                    }
                    
                    // Animation de succès
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Félicitations pour ton engagement! 🎉'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    
                    // Navigation vers la page suivante
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HappyPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasDrawnSmile ? Colors.green : secondaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Je m\'engage à aller mieux',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.check,
                          color: _hasDrawnSmile ? Colors.green : secondaryColor,
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
}

// Classe pour les points de dessin
class DrawingPoint {
  final Offset offset;
  final Paint paint;
  
  DrawingPoint(this.offset, this.paint);
}

// Painter personnalisé pour le dessin
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  
  DrawingPainter(this.points);
  
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i]!.offset],
          points[i]!.paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => oldDelegate.points != points;
}