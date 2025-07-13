import 'package:feelomi/sad_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class EmotionsTracker extends StatefulWidget {
  const EmotionsTracker({Key? key}) : super(key: key);

  @override
  State<EmotionsTracker> createState() => _EmotionsTrackerState();
}

class _EmotionsTrackerState extends State<EmotionsTracker>
    with SingleTickerProviderStateMixin {
  // Couleurs thématiques
  final Color primaryColor = const Color(0xFF8B5CF6);
  final Color _accentColor = const Color.fromARGB(255, 90, 0, 150);
  final Color _backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  // Date d'inscription
  DateTime? _registrationDate;

  // Données des émotions
  Map<String, int> _weeklyEmotions = {};

  // Animation pour l'image Feelo
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Liste des émotions disponibles
  final List<Map<String, dynamic>> _emotions = [
    {'name': 'Très heureux', 'value': 5, 'emoji': '😁', 'color': Colors.green},
    {'name': 'Heureux', 'value': 4, 'emoji': '🙂', 'color': Colors.lightGreen},
    {'name': 'Neutre', 'value': 3, 'emoji': '😐', 'color': Colors.amber},
    {'name': 'Triste', 'value': 2, 'emoji': '🙁', 'color': Colors.orange},
    {'name': 'Très triste', 'value': 1, 'emoji': '😢', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Initialisation de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Démarrer l'animation après un court délai
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  // Charge les données utilisateur depuis SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Récupération de la date d'inscription
    String? regDateStr = prefs.getString('registration_date');
    if (regDateStr == null) {
      // Si aucune date n'est enregistrée, on utilise la date d'aujourd'hui
      _registrationDate = DateTime.now();
      await prefs.setString(
        'registration_date',
        _registrationDate!.toIso8601String(),
      );
    } else {
      _registrationDate = DateTime.parse(regDateStr);
    }

    // Récupération des émotions enregistrées
    String? emotionsData = prefs.getString('weekly_emotions');
    if (emotionsData != null) {
      Map<String, dynamic> jsonData = json.decode(emotionsData);
      _weeklyEmotions = jsonData.map(
        (key, value) => MapEntry(key, value as int),
      );
    }

    // Initialisation de la semaine actuelle si nécessaire
    _initializeCurrentWeek();

    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Initialise les données pour la semaine actuelle
  void _initializeCurrentWeek() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    // Pour chacun des 7 derniers jours
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = formatter.format(date);

      // Si aucune émotion n'est enregistrée pour ce jour, on laisse vide (null)
      if (!_weeklyEmotions.containsKey(dateStr)) {
        _weeklyEmotions[dateStr] = 0; // 0 signifie pas d'enregistrement
      }
    }
  }

  // Sauvegarde l'émotion sélectionnée
  Future<void> _saveEmotion(int emotionValue) async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    setState(() {
      _weeklyEmotions[today] = emotionValue;
    });

    // Sauvegarde dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('weekly_emotions', json.encode(_weeklyEmotions));

    // Feedback haptique
    HapticFeedback.mediumImpact();

    // Ferme le modal de sélection d'émotion
    Navigator.of(context).pop();
  }

  // Calcule le nombre de jours depuis l'inscription
  int get _daysSinceRegistration {
    final now = DateTime.now();
    return now.difference(_registrationDate!).inDays +
        1; // +1 pour inclure le jour d'inscription
  }

  // Ouvre le modal de sélection d'émotion
  void _openEmotionSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildEmotionModal(),
    );
  }

  // Construit le widget de modal pour sélectionner une émotion
  Widget _buildEmotionModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Barre de poignée
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Comment te sens-tu aujourd'hui ?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _accentColor,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _emotions.length,
              itemBuilder: (context, index) {
                final emotion = _emotions[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: emotion['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      emotion['emoji'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(
                    emotion['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _saveEmotion(emotion['value']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Récupère l'émoji correspondant à la valeur d'émotion
  String _getEmotionEmoji(int value) {
    if (value == 0) return '❓'; // Pas d'enregistrement
    for (var emotion in _emotions) {
      if (emotion['value'] == value) {
        return emotion['emoji'];
      }
    }
    return '❓';
  }

  // Récupère la couleur correspondant à la valeur d'émotion
  Color _getEmotionColor(int value) {
    if (value == 0) return Colors.grey; // Pas d'enregistrement
    for (var emotion in _emotions) {
      if (emotion['value'] == value) {
        return emotion['color'];
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Ton bien-être'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _registrationDate == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Remplacé GestureDetector par SingleChildScrollView
              child: Column(
                children: [
                  // Header avec la mascotte Feelo
                  Container(
                    color: _primaryColor,
                    padding: const EdgeInsets.only(bottom: 30, top: 20),
                    child: Column(
                      children: [
                        // Image de Feelo avec animation
                        Center(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Hero(
                                  tag: 'logo',
                                  child: Container(
                                    width: 120,
                                    height: 120,
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.network(
                                        'https://img.freepik.com/vecteurs-premium/ecureuil-mignon-lunettes-mascotte-dessin-anime_138676-2550.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Jour $_daysSinceRegistration',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'de ton voyage bien-être',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Traceur d'émotions hebdomadaire
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ton historique',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _accentColor,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _openEmotionSelector,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryColor,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildWeeklyEmotionsChart(),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            Text(
                              'Tendance de la semaine',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _accentColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildWeeklyTrend(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Statistiques et conseils
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Conseils du jour',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _accentColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDailyTip(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SadTracker(),
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
                            Text(
                              'Continuer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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

  // Construit le graphique des émotions de la semaine
  Widget _buildWeeklyEmotionsChart() {
    final now = DateTime.now();
    final dateFormat = DateFormat('E'); // Format court du jour (Lun, Mar, etc.)

    // Catégories d'émotions pour le graphique
    final emotionCategories = [
      {
        "name": "Heureux",
        "values": [4, 5],
        "color": Colors.green,
      },
      {
        "name": "Neutre",
        "values": [3],
        "color": Colors.amber,
      },
      {
        "name": "Déprimé",
        "values": [1, 2],
        "color": Colors.red,
      },
    ];

    return Column(
      children: [
        // Graphique avec barres empilées
        AspectRatio(
          aspectRatio: 1.6,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth / 7 * 0.7;
                return Stack(
                  children: [
                    // Lignes de grille horizontales
                    ...List.generate(4, (index) {
                      return Positioned(
                        left: 0,
                        right: 0,
                        bottom: constraints.maxHeight * (index / 3),
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      );
                    }),

                    // Jours de la semaine et barres
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) {
                        final date = now.subtract(Duration(days: 6 - index));
                        final dateStr = DateFormat('yyyy-MM-dd').format(date);
                        final dayName = dateFormat.format(date);
                        final emotionValue = _weeklyEmotions[dateStr] ?? 0;
                        final isToday = index == 6;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // La barre graphique
                            Container(
                              width: barWidth,
                              height: emotionValue > 0
                                  ? constraints.maxHeight *
                                        0.8 *
                                        (emotionValue / 5)
                                  : 0,
                              decoration: BoxDecoration(
                                color: _getEmotionColor(emotionValue),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                            // Le jour
                            Text(
                              dayName,
                              style: TextStyle(
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isToday
                                    ? _accentColor
                                    : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            // Indicateur pour aujourd'hui
                            if (isToday)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _accentColor,
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Légende du graphique
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: emotionCategories.map((category) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: category["color"] as Color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      category["name"] as String,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Construit le widget de tendance hebdomadaire
  Widget _buildWeeklyTrend() {
    // Calculer la tendance hebdomadaire
    int totalValue = 0;
    int count = 0;

    _weeklyEmotions.forEach((date, value) {
      if (value > 0) {
        // Ignorer les jours sans enregistrement
        totalValue += value;
        count++;
      }
    });

    if (count == 0) {
      return _buildEmptyTrend();
    }

    double average = totalValue / count;
    String message;
    IconData icon;
    Color color;

    if (average >= 4.5) {
      message = "Excellente semaine! Continue comme ça!";
      icon = Icons.sentiment_very_satisfied;
      color = Colors.green;
    } else if (average >= 3.5) {
      message = "Bonne semaine! Tu es sur la bonne voie.";
      icon = Icons.sentiment_satisfied;
      color = Colors.lightGreen;
    } else if (average >= 2.5) {
      message = "Semaine moyenne. Essaie de prendre soin de toi.";
      icon = Icons.sentiment_neutral;
      color = Colors.amber;
    } else if (average >= 1.5) {
      message = "Semaine difficile. N'oublie pas de te reposer.";
      icon = Icons.sentiment_dissatisfied;
      color = Colors.orange;
    } else {
      message = "Semaine très difficile. Prends du temps pour toi.";
      icon = Icons.sentiment_very_dissatisfied;
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Score moyen: ${average.toStringAsFixed(1)}/5",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget à afficher quand il n'y a pas de données
  Widget _buildEmptyTrend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600], size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pas encore assez de données",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enregistre ton humeur quotidiennement pour voir ta tendance",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Construit le conseil du jour
  Widget _buildDailyTip() {
    final tips = [
      {
        'title': 'Prends 5 minutes pour respirer',
        'description':
            'La respiration profonde peut réduire le stress et améliorer ta concentration.',
        'icon': Icons.air,
        'color': Colors.blue,
      },
      {
        'title': 'Bois de l\'eau régulièrement',
        'description':
            'L\'hydratation est essentielle pour ton bien-être physique et mental.',
        'icon': Icons.water_drop,
        'color': Colors.cyan,
      },
      {
        'title': 'Fais une pause active',
        'description':
            'Lève-toi et étire-toi pendant quelques minutes toutes les heures.',
        'icon': Icons.directions_run,
        'color': Colors.orange,
      },
      {
        'title': 'Pratique la gratitude',
        'description':
            'Note trois choses pour lesquelles tu es reconnaissant aujourd\'hui.',
        'icon': Icons.favorite,
        'color': Colors.pink,
      },
      {
        'title': 'Limite ton temps d\'écran',
        'description':
            'Prends des pauses régulières loin des écrans pour reposer tes yeux.',
        'icon': Icons.phone_android,
        'color': Colors.purple,
      },
    ];

    // Sélectionne un conseil aléatoire basé sur le jour
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final tip = tips[dayOfYear % tips.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tip['color'] as Color..withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (tip['color'] as Color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (tip['color'] as Color).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(tip['icon'] as IconData, color: tip['color'] as Color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tip['color'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip['description'] as String,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
