import 'package:feelomi/feeling_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class SadTracker extends StatefulWidget {
  const SadTracker({Key? key}) : super(key: key);

  @override
  State<SadTracker> createState() => _SadTrackerState();
}

class _SadTrackerState extends State<SadTracker>
    with SingleTickerProviderStateMixin {
  // Couleurs thématiques
  final Color _primaryColor = const Color.fromARGB(255, 150, 95, 186);
  final Color _accentColor = const Color.fromARGB(255, 90, 0, 150);
  final Color _backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  // Animation pour l'image Feelo
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Valeurs des sliders
  double _activityValue = 5.0;
  double _nutritionValue = 5.0;
  double _sleepValue = 5.0;

  // Contrôleur pour le champ de notes
  final TextEditingController _notesController = TextEditingController();

  // Valeurs sauvegardées
  Map<String, dynamic> _trackerData = {};

  @override
  void initState() {
    super.initState();
    _loadTrackerData();

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
    String? dataString = prefs.getString('sad_tracker_$today');
    if (dataString != null) {
      setState(() {
        _trackerData = json.decode(dataString);
        _activityValue = _trackerData['activity'] ?? 5.0;
        _nutritionValue = _trackerData['nutrition'] ?? 5.0;
        _sleepValue = _trackerData['sleep'] ?? 5.0;
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
      'activity': _activityValue,
      'nutrition': _nutritionValue,
      'sleep': _sleepValue,
      'notes': _notesController.text,
      'date': today,
    };

    // Sauvegarde dans les préférences
    await prefs.setString('sad_tracker_$today', json.encode(_trackerData));

    // Feedback haptique
    HapticFeedback.mediumImpact();

    // Affiche un message de confirmation
  }

  // Méthode pour continuer vers l'écran suivant
  void _continueToNextScreen() {
    _saveTrackerData();
    // Navigation vers l'écran suivant (à implémenter)
    // Par exemple: Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
  }

  // Méthode pour obtenir la description de la valeur des sliders
  String _getActivityDescription(double value) {
    if (value <= 2) return "Très inactive";
    if (value <= 4) return "Inactive";
    if (value <= 6) return "Modérée";
    if (value <= 8) return "Active";
    return "Très active";
  }

  String _getNutritionDescription(double value) {
    if (value <= 2) return "Très mauvaise";
    if (value <= 4) return "Mauvaise";
    if (value <= 6) return "Moyenne";
    if (value <= 8) return "Bonne";
    return "Excellente";
  }

  String _getSleepDescription(double value) {
    if (value <= 2) return "Très mauvais";
    if (value <= 4) return "Mauvais";
    if (value <= 6) return "Moyen";
    if (value <= 8) return "Bon";
    return "Excellent";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Analyser ta tristesse'),
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
          } else if (details.primaryVelocity! < 0) {
            // Glissement vers la gauche, ouvre la page de feeling
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FeelingTracker()),
            );
          }
        },
        child: SingleChildScrollView(
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
                              tag: 'sad_logo',
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
                    const Text(
                      'Comprendre ta tristesse',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Identifie les facteurs qui peuvent influencer ton humeur',
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
                    // Introduction
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
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Pourquoi ces facteurs ?',
                                  style: TextStyle(
                                    color: _accentColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'L\'activité physique, la nutrition et le sommeil sont trois facteurs essentiels qui peuvent influencer ton humeur. Évaluer ces éléments peut t\'aider à identifier des causes potentielles de tristesse.',
                              style: TextStyle(fontSize: 15, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Slider pour l'activité
                    _buildTrackerSection(
                      title: 'Niveau d\'activité physique',
                      icon: Icons.directions_run,
                      sliderValue: _activityValue,
                      description: _getActivityDescription(_activityValue),
                      onChanged: (value) {
                        setState(() {
                          _activityValue = value;
                        });
                      },
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.orange, Colors.green],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Slider pour la nutrition
                    _buildTrackerSection(
                      title: 'Qualité de la nutrition',
                      icon: Icons.restaurant,
                      sliderValue: _nutritionValue,
                      description: _getNutritionDescription(_nutritionValue),
                      onChanged: (value) {
                        setState(() {
                          _nutritionValue = value;
                        });
                      },
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.orange, Colors.green],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Slider pour le sommeil
                    _buildTrackerSection(
                      title: 'Qualité du sommeil',
                      icon: Icons.nightlight,
                      sliderValue: _sleepValue,
                      description: _getSleepDescription(_sleepValue),
                      onChanged: (value) {
                        setState(() {
                          _sleepValue = value;
                        });
                      },
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.orange, Colors.green],
                      ),
                    ),

                    const SizedBox(height: 32),

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
                              'Notes supplémentaires',
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
                                    'Y a-t-il d\'autres facteurs qui influencent ton humeur aujourd\'hui?',
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
                        onPressed: () {
                          Navigator.of(context).pushNamed('/feeling');
                        },
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

  // Widget pour construire une section de tracker avec slider
  Widget _buildTrackerSection({
    required String title,
    required IconData icon,
    required double sliderValue,
    required String description,
    required ValueChanged<double> onChanged,
    required LinearGradient gradient,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: _primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('1'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 8,
                        activeTrackColor: _primaryColor,
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                        overlayColor: _primaryColor.withOpacity(0.2),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 20,
                        ),
                      ),
                      child: Slider(
                        value: sliderValue,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                ),
                const Text('10'),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getColorForValue(sliderValue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Obtient la couleur en fonction de la valeur
  Color _getColorForValue(double value) {
    if (value <= 2) return Colors.red;
    if (value <= 4) return Colors.orange;
    if (value <= 6) return Colors.amber;
    if (value <= 8) return Colors.lightGreen;
    return Colors.green;
  }
}
