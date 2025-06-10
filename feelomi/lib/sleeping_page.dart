import 'package:feelomi/happy_page.dart';
import 'package:feelomi/mental_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feelomi/custom_back.dart';

class SleepingPage extends StatefulWidget {
  const SleepingPage({super.key});

  @override
  State<SleepingPage> createState() => _SleepingPageState();
}

class _SleepingPageState extends State<SleepingPage>
    with SingleTickerProviderStateMixin {
  // Niveau de sommeil sélectionné (0-4)
  int _selectedLevel = 2; // Par défaut à "Raisonnable"

  // Options de qualité de sommeil
  final List<Map<String, dynamic>> _sleepLevels = [
    {
      'level': 0,
      'title': 'Médiocre',
      'description': '< 3h',
      'emoji': '😴',
      'color': Colors.red.shade400,
    },
    {
      'level': 1,
      'title': 'Nulle',
      'description': '3 - 4h',
      'emoji': '🥱',
      'color': Colors.orange.shade400,
    },
    {
      'level': 2,
      'title': 'Raisonnable',
      'description': '5h',
      'emoji': '😐',
      'color': Colors.amber.shade400,
    },
    {
      'level': 3,
      'title': 'Bien',
      'description': '6 - 7h',
      'emoji': '😊',
      'color': Colors.lightGreen.shade400,
    },
    {
      'level': 4,
      'title': 'Excellente',
      'description': '7 - 9h',
      'emoji': '😁',
      'color': Colors.green.shade500,
    },
  ];

  // Animation pour le déplacement du bouton
  late AnimationController _animController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectSleepLevel(int level) {
    // Feedback haptique pour améliorer l'expérience utilisateur
    HapticFeedback.lightImpact();

    // Animer le déplacement du bouton
    _animController.reset();
    final prevLevel = _selectedLevel;
    setState(() {
      _selectedLevel = level;
      // Configurer l'animation pour le déplacement
      final startPos = _getPositionForLevel(prevLevel);
      final endPos = _getPositionForLevel(level);
      _buttonAnimation = Tween<double>(begin: startPos, end: endPos).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
      );
    });
    _animController.forward();
  }

  // Calculer la position verticale pour le niveau de sommeil
  double _getPositionForLevel(int level) {
    // Conversion du niveau (0-4) vers une position (0-1)
    // 0 = bas de l'échelle (médiocre), 1 = haut de l'échelle (excellente)
    return 1.0 - (level / 4.0);
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
                          // Ajout du bouton de retour
                          const CustomBackButton(),
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
                                '9',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sommeil',
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
                          // Navigation vers la page finale
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MentalPage(),
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
                    value: 1.17,
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
                          'Comment évaluerais-tu ta qualité de sommeil ?',
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
                          'Ta qualité de sommeil a un impact important sur ta santé mentale.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Partie principale avec le curseur et les niveaux de sommeil
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculer la hauteur disponible pour le placement des points
                        final availableHeight = constraints.maxHeight - 40;
                        final itemHeight = availableHeight / 5;

                        return Row(
                          children: [
                            const SizedBox(width: 24),

                            // Colonne des niveaux de sommeil (de haut en bas)
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  // Afficher les niveaux dans l'ordre inverse (excellente en haut)
                                  ...List.generate(5, (index) {
                                    final level =
                                        4 -
                                        index; // Inverser l'indice (0 = excellent, 4 = médiocre)
                                    final sleepData = _sleepLevels[level];
                                    final isSelected = level == _selectedLevel;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => _selectSleepLevel(level),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? sleepData['color']
                                                      .withOpacity(0.2)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? sleepData['color']
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Emoji
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: sleepData['color']
                                                      .withOpacity(0.2),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  sleepData['emoji'],
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ),
                                              // Texte du niveau
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      sleepData['title'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: isSelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        color: isSelected
                                                            ? sleepData['color']
                                                            : Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      sleepData['description'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),

                            // Curseur vertical
                            SizedBox(
                              width: 80,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Ligne verticale du curseur
                                      // Bouton de validation - version sans animation
                                      Positioned(
                                        top:
                                            (4 - _selectedLevel) * itemHeight +
                                            20 +
                                            (itemHeight / 2) -
                                            24,
                                        right: -16,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Enregistrer la qualité de sommeil sélectionnée
                                            final sleepQuality =
                                                _sleepLevels[_selectedLevel]['title'];

                                            // Navigation vers la page des symptômes de santé mentale
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MentalPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                _sleepLevels[_selectedLevel]['color'],
                                            foregroundColor: Colors.white,
                                            shape: const CircleBorder(),
                                            padding: const EdgeInsets.all(16),
                                            elevation: 4,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            size: 24,
                                          ),
                                        ),
                                      ),

                                      // Points sur la ligne
                                      ...List.generate(5, (index) {
                                        final level =
                                            4 -
                                            index; // Inverser l'indice (0 = excellent, 4 = médiocre)
                                        final isSelected =
                                            level == _selectedLevel;

                                        // Position précise calculée à partir de la hauteur disponible
                                        final topPosition =
                                            (index * itemHeight) +
                                            20 +
                                            (itemHeight / 2) -
                                            8;

                                        return Positioned(
                                          top: topPosition,
                                          left:
                                              28, // Centrer le point sur la ligne
                                          child: GestureDetector(
                                            onTap: () =>
                                                _selectSleepLevel(level),
                                            child: Container(
                                              width: isSelected ? 24 : 16,
                                              height: isSelected ? 24 : 16,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelected
                                                    ? _sleepLevels[level]['color']
                                                    : Colors.white,
                                                border: Border.all(
                                                  color:
                                                      _sleepLevels[level]['color'],
                                                  width: 2,
                                                ),
                                                boxShadow: isSelected
                                                    ? [
                                                        BoxShadow(
                                                          color:
                                                              _sleepLevels[level]['color']
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                          spreadRadius: 2,
                                                          blurRadius: 4,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),

                                      // Bouton de validation animé - CORRECTION ICI
                                      AnimatedBuilder(
                                        animation: _animController,
                                        builder: (context, child) {
                                          // Calcul précis de la position du bouton en fonction du niveau
                                          int reverseIndex = 4 - _selectedLevel;
                                          double topPosition =
                                              (reverseIndex * itemHeight) +
                                              20 +
                                              (itemHeight / 2) -
                                              24;

                                          return Positioned(
                                            top: topPosition,
                                            right: -16,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Enregistrer la qualité de sommeil sélectionnée
                                                final sleepQuality =
                                                    _sleepLevels[_selectedLevel]['title'];

                                                // Navigation vers la page des symptômes de santé mentale
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MentalPage(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    _sleepLevels[_selectedLevel]['color'],
                                                foregroundColor: Colors.white,
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                elevation: 4,
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward,
                                                size: 24,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 24),
                          ],
                        );
                      },
                    ),
                  ),

                  // Message informatif en bas
                  Padding(
                    padding: const EdgeInsets.all(24.0),
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
                              'Un bon sommeil est fondamental pour ta santé mentale. '
                              'Nous adapterons nos recommandations en fonction de ta qualité de sommeil.',
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
          ],
        ),
      ),
    );
  }
}
