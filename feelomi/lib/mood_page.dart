import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'feeling_page.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key}) : super(key: key);

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage>
    with SingleTickerProviderStateMixin {
  // Couleurs thématiques
  final Color primaryColor = const Color(0xFF8B5CF6);
  final Color _accentColor = const Color.fromARGB(255, 90, 0, 150);
  final Color _backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Périodes disponibles
  final List<String> _periods = [
    '1 jour',
    '1 semaine',
    '1 mois',
    '1 an',
    'De tout',
  ];
  String _selectedPeriod = '1 semaine';

  // Données des humeurs
  List<Map<String, dynamic>> _moodData = [];
  bool _isLoading = true;

  // Recommandations IA générées
  List<String> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadMoodData();

    // Initialisation de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Charge les données d'humeur depuis SharedPreferences
  Future<void> _loadMoodData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Récupération des données existantes
      List<Map<String, dynamic>> moodEntries = [];
      final allKeys = prefs.getKeys();

      for (String key in allKeys) {
        // Recherche des clés liées aux données d'humeur
        if (key.startsWith('feeling_tracker_')) {
          String? dataString = prefs.getString(key);
          if (dataString != null) {
            Map<String, dynamic> data = json.decode(dataString);
            // Extraction de la date de la clé (format: feeling_tracker_YYYY-MM-DD)
            String dateStr = key.substring('feeling_tracker_'.length);

            // Ajout à la liste des entrées
            moodEntries.add({
              'date': dateStr,
              'feeling_value': data['feeling_value'] ?? 0.5,
              'notes': data['notes'] ?? '',
            });
          }
        }
      }

      // Tri des entrées par date
      moodEntries.sort((a, b) => a['date'].compareTo(b['date']));

      // Filtrage selon la période sélectionnée
      moodEntries = _filterEntriesByPeriod(moodEntries, _selectedPeriod);

      setState(() {
        _moodData = moodEntries;
        _isLoading = false;
      });

      // Génération des recommandations basées sur les données
      _generateRecommendations(moodEntries);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _moodData = []; // Données vides en cas d'erreur
      });

      // Génération de recommandations par défaut
      _generateRecommendations([]);
    }
  }

  // Filtre les entrées selon la période choisie
  List<Map<String, dynamic>> _filterEntriesByPeriod(
    List<Map<String, dynamic>> entries,
    String period,
  ) {
    final now = DateTime.now();
    DateTime cutoffDate;

    switch (period) {
      case '1 jour':
        cutoffDate = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 1));
        break;
      case '1 semaine':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case '1 mois':
        cutoffDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case '1 an':
        cutoffDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case 'De tout':
      default:
        return entries; // Retourne toutes les entrées
    }

    return entries.where((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return entryDate.isAfter(cutoffDate) ||
          entryDate.isAtSameMomentAs(cutoffDate);
    }).toList();
  }

  // Génère des recommandations basées sur les données d'humeur
  void _generateRecommendations(List<Map<String, dynamic>> entries) {
    // Analyse des données pour des tendances
    List<String> recommendations = [];

    // S'il n'y a pas assez de données
    if (entries.isEmpty || entries.length < 3) {
      recommendations = [
        "Continue à suivre ton humeur régulièrement pour obtenir des recommandations personnalisées.",
        "Le simple fait de noter ton humeur peut améliorer ton bien-être mental.",
        "Essaie de méditer 5 minutes chaque jour pour mieux comprendre tes émotions.",
      ];
    } else {
      // Calcul de la moyenne d'humeur
      double avgMood =
          entries
              .map((e) => e['feeling_value'] as double)
              .reduce((a, b) => a + b) /
          entries.length;

      // Tendance de l'humeur (en hausse, en baisse ou stable)
      double firstHalfAvg = 0;
      double secondHalfAvg = 0;

      int midPoint = entries.length ~/ 2;
      for (int i = 0; i < midPoint; i++) {
        firstHalfAvg += entries[i]['feeling_value'] as double;
      }
      firstHalfAvg = firstHalfAvg / midPoint;

      for (int i = midPoint; i < entries.length; i++) {
        secondHalfAvg += entries[i]['feeling_value'] as double;
      }
      secondHalfAvg = secondHalfAvg / (entries.length - midPoint);

      double trend = secondHalfAvg - firstHalfAvg;

      if (trend > 0.1) {
        recommendations.add(
          "Ton humeur s'améliore ! Continue ce que tu fais actuellement.",
        );
      } else if (trend < -0.1) {
        recommendations.add(
          "Ton humeur semble diminuer. Essaie de prévoir des activités qui te font du bien.",
        );
      } else {
        recommendations.add(
          "Ton humeur est stable. C'est un bon signe de constance émotionnelle.",
        );
      }

      // Recommandations basées sur le niveau moyen d'humeur
      if (avgMood < 0.3) {
        recommendations.add(
          "Ton niveau d'humeur est bas. Envisage de parler à un professionnel si cela persiste.",
        );
        recommendations.add(
          "Essaie des activités relaxantes comme une promenade ou un bain chaud.",
        );
      } else if (avgMood < 0.6) {
        recommendations.add(
          "Pratique la gratitude en notant 3 choses positives chaque jour.",
        );
        recommendations.add(
          "Un peu d'exercice physique pourrait améliorer ton humeur.",
        );
      } else {
        recommendations.add(
          "Tu sembles avoir une bonne humeur générale. Partage ta positivité avec les autres !",
        );
        recommendations.add(
          "Essaie de noter ce qui te rend heureux pour le reproduire à l'avenir.",
        );
      }
    }

    // Ajoute une recommandation générale
    recommendations.add(
      "N'oublie pas de bien t'hydrater et de dormir suffisamment.",
    );

    setState(() {
      _recommendations = recommendations;
    });
  }

  // Change la période sélectionnée
  void _changePeriod(String period) {
    if (_selectedPeriod != period) {
      setState(() {
        _selectedPeriod = period;
      });
      _loadMoodData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Suivi de ton humeur'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header avec titre
                  Container(
                    color: primaryColor,
                    padding: const EdgeInsets.only(bottom: 30, top: 10),
                    child: const Center(
                      child: Text(
                        'Ton évolution émotionnelle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Graphique de l'humeur
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Graphique d\'humeur',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _accentColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : _moodData.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Aucune donnée disponible pour cette période',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : _buildMoodChart(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sélecteur de période
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _periods.map((period) {
                            final isSelected = _selectedPeriod == period;
                            return InkWell(
                              onTap: () => _changePeriod(period),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recommandations de l'IA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      color: primaryColor.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.psychology,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Recommandations de l\'IA',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_recommendations.isEmpty)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _recommendations.map((rec) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '• ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            rec,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Bouton de retour au menu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const FeelingTracker(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.arrow_back, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Retourner au menu',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Construction du graphique d'humeur
  Widget _buildMoodChart() {
    if (_moodData.isEmpty) {
      return const Center(child: Text('Aucune donnée disponible'));
    }

    return CustomPaint(
      painter: MoodChartPainter(
        moodData: _moodData,
        primaryColor: primaryColor,
      ),
      size: const Size(double.infinity, 200),
    );
  }
}

class FeelingTracker extends StatefulWidget {
  const FeelingTracker({Key? key}) : super(key: key);

  @override
  State<FeelingTracker> createState() => _FeelingTrackerState();
}

class _FeelingTrackerState extends State<FeelingTracker> {
  @override
  Widget build(BuildContext context) {
    // Return your feeling tracker widget UI here
    return Scaffold(
      appBar: AppBar(title: const Text('Tracker d\'humeur')),
      body: const Center(child: Text('Contenu du tracker d\'humeur')),
    );
  }
}

// Peintre personnalisé pour créer le graphique d'humeur
class MoodChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> moodData;
  final Color primaryColor;

  MoodChartPainter({required this.moodData, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final bottom = height * 0.85; // Espace pour les étiquettes en bas

    // Nombre d'entrées à afficher
    final int dataPoints = moodData.length;
    if (dataPoints < 2) return; // Pas assez de données pour une ligne

    // Peintre pour les lignes
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Peintre pour la zone sous la courbe
    final areaPaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Peintre pour les points
    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Peintre pour le texte des dates
    final textPainter = TextPainter(textAlign: TextAlign.center);

    final textStyle = TextStyle(color: Colors.grey[700], fontSize: 10);

    // Chemin pour la ligne
    final path = Path();

    // Chemin pour la zone sous la courbe
    final areaPath = Path();

    // Calcul des pas entre les points
    final double step = width / (dataPoints - 1);

    // Dessiner les points et la ligne
    for (int i = 0; i < dataPoints; i++) {
      final double x = i * step;
      final double y =
          bottom - (bottom * 0.8 * (moodData[i]['feeling_value'] as double));

      // Déplacer au premier point ou ajouter une ligne aux points suivants
      if (i == 0) {
        path.moveTo(x, y);
        areaPath.moveTo(x, bottom);
        areaPath.lineTo(x, y);
      } else {
        // Crée une courbe entre les points au lieu d'une ligne droite
        final prevX = (i - 1) * step;
        final prevY =
            bottom -
            (bottom * 0.8 * (moodData[i - 1]['feeling_value'] as double));

        final controlX1 = prevX + (x - prevX) / 2;
        final controlX2 = x - (x - prevX) / 2;

        path.cubicTo(controlX1, prevY, controlX2, y, x, y);
        areaPath.cubicTo(controlX1, prevY, controlX2, y, x, y);
      }

      // Dessine un point à chaque position de données
      canvas.drawCircle(Offset(x, y), 4, dotPaint);

      // Affiche la date sous chaque point (uniquement certaines dates pour éviter l'encombrement)
      if (dataPoints <= 7 ||
          i % (dataPoints ~/ 5) == 0 ||
          i == dataPoints - 1) {
        String dateStr = moodData[i]['date'];
        DateTime date = DateTime.parse(dateStr);

        // Format de date court
        String formattedDate = DateFormat('dd/MM').format(date);

        textPainter.text = TextSpan(text: formattedDate, style: textStyle);

        textPainter.layout(minWidth: 0, maxWidth: width);

        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, bottom + 5),
        );
      }
    }

    // Complète le chemin de la zone sous la courbe
    areaPath.lineTo(width, bottom);
    areaPath.close();

    // Dessine la zone sous la courbe
    canvas.drawPath(areaPath, areaPaint);

    // Dessine la ligne
    canvas.drawPath(path, linePaint);

    // Dessine des lignes horizontales de référence
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final y = bottom - (i * bottom * 0.2);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodChartPainter oldDelegate) {
    return oldDelegate.moodData != moodData ||
        oldDelegate.primaryColor != primaryColor;
  }
}
