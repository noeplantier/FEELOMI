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
                  
                  // Jauge en arc de cercle pour le niveau de stress (style arc-en-ciel)
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Positionnement de l'arc
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 220,
                          child: Stack(
                            children: [
                              // Arc de cercle arrière (grisé)
                              CustomPaint(
                                size: const Size(double.infinity, 220),
                                painter: RainbowArcPainter(
                                  progress: 1.0,
                                  color: Colors.grey.shade300,
                                  strokeWidth: 18,
                                ),
                              ),
                              
                              // Arc de cercle animé (coloré)
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: const Size(double.infinity, 220),
                                    painter: RainbowArcPainter(
                                      progress: _animation.value,
                                      color: _stressLevels[_stressLevel]['color'],
                                      strokeWidth: 18,
                                    ),
                                  );
                                },
                              ),
                              
                              // Labels sur l'arc
                              ...List.generate(_stressLevels.length, (index) {
                                // Calculer la position horizontale pour chaque niveau
                                // Distribuer uniformément de gauche à droite
                                final xPosition = MediaQuery.of(context).size.width * 
                                    (0.15 + (index * 0.7 / (_stressLevels.length - 1)));
                                
                                // Calculer la position verticale (sur l'arc)
                                final yOffset = 160 - (80 * math.sin(index * math.pi / (_stressLevels.length - 1)));
                                
                                final isSelected = index == _stressLevel;
                                
                                return Positioned(
                                  left: xPosition - 20, // Centrer sur la position
                                  bottom: yOffset,
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
                              
                              // Labels de texte sous l'arc
                              ...List.generate(_stressLevels.length, (index) {
                                // Calculer la position horizontale pour chaque niveau
                                final xPosition = MediaQuery.of(context).size.width * 
                                    (0.15 + (index * 0.7 / (_stressLevels.length - 1)));
                                
                                final isSelected = index == _stressLevel;
                                
                                return Positioned(
                                  left: xPosition - 40, // Centrer sur la position
                                  bottom: 10,
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
                        
                        // Niveau actuel au-dessus de l'arc
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  key: ValueKey<int>(_stressLevel),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
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
}

// Painter personnalisé pour dessiner l'arc en arc-en-ciel (du bas vers le haut)
class RainbowArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  
  RainbowArcPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 10,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Créer un rectangle pour l'arc
    final rect = Rect.fromLTWH(
      -size.width * 0.2,          // Décaler à gauche pour agrandir l'arc
      -size.height * 1.8,         // Décaler en haut pour que l'arc commence en bas
      size.width * 1.4,           // Largeur augmentée pour un arc plus large
      size.height * 2.5,          // Hauteur ajustée pour un arc semi-circulaire
    );
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    
    // Dessiner un arc du bas gauche au bas droit en passant par le haut
    // L'arc commence à -pi (côté gauche) et va jusqu'à 0 (côté droit)
    // Le progress détermine jusqu'où l'arc est dessiné
    canvas.drawArc(
      rect,
      -math.pi,                  // Angle de départ (gauche)
      math.pi * progress,        // Angle de balayage (jusqu'à la droite selon progress)
      false,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant RainbowArcPainter oldDelegate) {
    return progress != oldDelegate.progress || 
           color != oldDelegate.color ||
           strokeWidth != oldDelegate.strokeWidth;
  }
}