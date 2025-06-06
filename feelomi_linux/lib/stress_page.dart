import 'package:feelomi_linux/analysis_page.dart';
import 'package:feelomi_linux/better_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'happy_page.dart';
import 'dart:math' as math;

class StressPage extends StatefulWidget {
  const StressPage({super.key});

  @override
  State<StressPage> createState() => _StressPageState();
}

class _StressPageState extends State<StressPage> with SingleTickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 500),
    );
    
    _animation = Tween<double>(
      begin: 0,
      end: _stressLevel / (_stressLevels.length - 1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
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
      _animation = Tween<double>(
        begin: _stressLevel / (_stressLevels.length - 1),
        end: level / (_stressLevels.length - 1),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));
      
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
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '10',
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
                    value: 1.0, // 100% de progression
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Titre principal en violet
                        Text(
                          'Comment évalues-tu ton niveau de stress ?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Sous-titre explicatif
                        Text(
                          'Le stress peut avoir un impact sur ton bien-être au quotidien.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Nouvelle jauge verticale, moins volumineuse
                  SizedBox(
                    height: 230,
                    width: deviceWidth * 0.85, // Réduire la largeur pour s'adapter à tous les appareils
                    child: Stack(
                      children: [
                        // Ligne de progression en arrière-plan (grise)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 40, // Espace pour les étiquettes de texte
                          top: 0,
                          child: CustomPaint(
                            size: Size(deviceWidth * 0.85, 190),
                            painter: CurvePainter(
                              progress: 1.0, // Toujours 100% pour la ligne de fond
                              color: Colors.grey.shade300,
                              strokeWidth: 8,
                            ),
                          ),
                        ),
                        
                        // Ligne de progression animée (colorée)
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Positioned(
                              left: 0,
                              right: 0,
                              bottom: 40,
                              top: 0,
                              child: CustomPaint(
                                size: Size(deviceWidth * 0.85, 190),
                                painter: CurvePainter(
                                  progress: _animation.value,
                                  color: _stressLevels[_stressLevel]['color'],
                                  strokeWidth: 8,
                                ),
                              ),
                            );
                          },
                        ),
                        
                        // Points de niveau sur la courbe
                        ...List.generate(_stressLevels.length, (index) {
                          // Calculer la position horizontale pour chaque niveau
                          final position = index / (_stressLevels.length - 1);
                          final point = _getCurvePoint(position, Size(deviceWidth * 0.85, 190));
                          final isSelected = index == _stressLevel;
                          
                          return Positioned(
                            left: point.dx - 15, // Centrer sur le point
                            top: point.dy - 15, // Centrer sur le point
                            child: GestureDetector(
                              onTap: () => _setStressLevel(index),
                              child: Container(
                                width: isSelected ? 40 : 30,
                                height: isSelected ? 40 : 30,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? _stressLevels[index]['color']
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _stressLevels[index]['color'],
                                    width: 2,
                                  ),
                                  boxShadow: isSelected 
                                      ? [
                                          BoxShadow(
                                            color: _stressLevels[index]['color'].withOpacity(0.3),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ] 
                                      : null,
                                ),
                                child: Icon(
                                  _stressLevels[index]['icon'],
                                  color: isSelected ? Colors.white : _stressLevels[index]['color'],
                                  size: isSelected ? 20 : 16,
                                ),
                              ),
                            ),
                          );
                        }),
                        
                        // Étiquettes de niveau en bas
                        ...List.generate(_stressLevels.length, (index) {
                          // Calculer la position horizontale pour chaque niveau
                          final position = index / (_stressLevels.length - 1);
                          final curvePoint = _getCurvePoint(position, Size(deviceWidth * 0.85, 190));
                          final isSelected = index == _stressLevel;
                          
                          return Positioned(
                            left: curvePoint.dx - 40, // Centrer sous le point
                            top: 190, // Position en bas
                            width: 80, // Largeur fixe pour le texte
                            child: Column(
                              children: [
                                Text(
                                  _stressLevels[index]['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSelected ? 14 : 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected 
                                        ? _stressLevels[index]['color']
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Niveau actuel avec description
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey<int>(_stressLevel),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: _stressLevels[_stressLevel]['color'].withOpacity(0.1),
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
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _stressLevels[_stressLevel]['color'],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _stressLevels[_stressLevel]['description'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Message informatif
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Un niveau de stress bien géré peut améliorer ton quotidien. '
                              'Nous te proposerons des activités adaptées à ton niveau de stress.',
                              style: TextStyle(
                                fontSize: 14,
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
            
            // Bouton Continuer en bas
            Container(
              padding: const EdgeInsets.all(24.0),
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
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Enregistrer le niveau de stress
                    final stressTitle = _stressLevels[_stressLevel]['title'];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Niveau de stress : $stressTitle')),
                    );
                    
                    // Navigation vers la page d'engagement
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BetterPage(),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
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
  
  // Méthode pour calculer la position d'un point sur la courbe
  Offset _getCurvePoint(double position, Size size) {
    // Calculer la position horizontale (x)
    final x = position * size.width;
    
    // Calculer la position verticale (y) avec une courbe quadratique
    // La courbe monte du bas vers le haut, avec une légère courbure
    final y = size.height - (size.height * math.pow(position, 0.9));
    
    return Offset(x, y);
  }
}

// Nouveau painter personnalisé pour dessiner une courbe ascendante
class CurvePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  
  CurvePainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 8,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    
    final path = Path();
    
    // Démarrer depuis le coin bas gauche
    path.moveTo(0, size.height);
    
    // Dessiner une série de points pour créer une courbe douce
    // qui monte progressivement de gauche à droite
    final totalPoints = 100;
    for (int i = 1; i <= totalPoints * progress; i++) {
      final t = i / totalPoints;
      // Calculer le point sur une courbe légèrement exponentielle
      final point = Offset(
        t * size.width,
        size.height - (size.height * math.pow(t, 0.9)), // Ajuster l'exposant pour changer la forme
      );
      path.lineTo(point.dx, point.dy);
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CurvePainter oldDelegate) {
    return progress != oldDelegate.progress || 
           color != oldDelegate.color ||
           strokeWidth != oldDelegate.strokeWidth;
  }
}