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
                  
                  // Jauge en arc de cercle pour le niveau de stress
                  SizedBox(
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cadre d'arc
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade50,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        
                        // Arc de cercle arrière (grisé)
                        CustomPaint(
                          size: const Size(240, 240),
                          painter: ArcPainter(
                            sweepAngle: math.pi,
                            color: Colors.grey.shade300,
                            strokeWidth: 15,
                          ),
                        ),
                        
                        // Arc de cercle animé (coloré)
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(240, 240),
                              painter: ArcPainter(
                                sweepAngle: _animation.value * math.pi,
                                color: _stressLevels[_stressLevel]['color'],
                                strokeWidth: 15,
                              ),
                            );
                          },
                        ),
                        
                        // Labels sur l'arc
                        ...List.generate(_stressLevels.length, (index) {
                          final angle = index * (math.pi / (_stressLevels.length - 1));
                          final isSelected = index == _stressLevel;
                          
                          return Positioned(
                            left: 120 + 100 * math.cos(angle),
                            top: 120 - 100 * math.sin(angle),
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
                        
                        // Niveau actuel au centre
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Text(
                                  _stressLevels[_stressLevel]['title'],
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: _stressLevels[_stressLevel]['color'],
                                  ),
                                );
                              }
                            ),
                            const SizedBox(height: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _stressLevels[_stressLevel]['description'],
                                key: ValueKey<int>(_stressLevel),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sélecteur de niveau de stress sous forme de boutons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: List.generate(_stressLevels.length, (index) {
                        final isSelected = index == _stressLevel;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _setStressLevel(index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? _stressLevels[index]['color'].withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected 
                                      ? _stressLevels[index]['color']
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _stressLevels[index]['icon'],
                                    color: _stressLevels[index]['color'],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _stressLevels[index]['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                      color: isSelected 
                                          ? _stressLevels[index]['color']
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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
                    
                    // Navigation vers la page suivante
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
}

// Painter personnalisé pour dessiner l'arc de cercle
class ArcPainter extends CustomPainter {
  final double sweepAngle;
  final Color color;
  final double strokeWidth;
  
  ArcPainter({
    required this.sweepAngle,
    required this.color,
    this.strokeWidth = 10,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    
    // L'arc commence en haut (- math.pi/2) et va vers la droite
    canvas.drawArc(
      rect, 
      -math.pi/2, 
      sweepAngle,
      false, 
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return sweepAngle != oldDelegate.sweepAngle || 
           color != oldDelegate.color ||
           strokeWidth != oldDelegate.strokeWidth;
  }
}