import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class CheckingPage extends StatefulWidget {
  const CheckingPage({Key? key}) : super(key: key);

  @override
  State<CheckingPage> createState() => _CheckingPageState();
}

class _CheckingPageState extends State<CheckingPage>
    with SingleTickerProviderStateMixin {
  // Couleurs thématiques
  final Color _primaryColor = const Color.fromARGB(255, 150, 95, 186);
  final Color _accentColor = const Color.fromARGB(255, 90, 0, 150);
  final Color _backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  // Animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Données de l'humeur
  double _feelingValue = 0.5;
  bool _hasRecordedFeeling = false;
  String _feelingDescription = "Neutre";

  @override
  void initState() {
    super.initState();
    _checkFeelingRecord();

    // Initialisation des animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Démarrer l'animation après un court délai
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Vérifie si l'utilisateur a enregistré son humeur aujourd'hui
  Future<void> _checkFeelingRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Récupère les données du jour si elles existent
    String? dataString = prefs.getString('feeling_tracker_$today');

    if (dataString != null) {
      final data = json.decode(dataString);
      setState(() {
        _hasRecordedFeeling = true;
        _feelingValue = data['feeling_value'] ?? 0.5;
        _feelingDescription = _getFeelingDescription(_feelingValue);
      });
    } else {
      // Si aucune donnée n'est trouvée, rediriger vers la page feeling
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed('/feeling');
      });
    }
  }

  // Description textuelle de l'humeur
  String _getFeelingDescription(double value) {
    if (value < 0.2) return "Très mal";
    if (value < 0.4) return "Mal";
    if (value < 0.6) return "Neutre";
    if (value < 0.8) return "Bien";
    return "Très bien";
  }

  // Couleur correspondant à l'humeur
  Color _getFeelingColor(double value) {
    if (value < 0.2) return Colors.red;
    if (value < 0.4) return Colors.orange;
    if (value < 0.6) return Colors.amber;
    if (value < 0.8) return Colors.lightGreen;
    return Colors.green;
  }

  // Navigation vers la page suivante (à adapter selon vos besoins)
  void _navigateToNextScreen() {
    Navigator.of(context).pushNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: _hasRecordedFeeling
            ? AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image de Feelo satisfaite
                              Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Container(
                                  width: 180,
                                  height: 180,
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
                                    borderRadius: BorderRadius.circular(90),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          'https://img.freepik.com/vecteurs-premium/ecureuil-mignon-lunettes-mascotte-dessin-anime_138676-2550.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                        // Overlay pour assombrir légèrement l'image et mettre en valeur le texte
                                        Container(
                                          color: Colors.black.withOpacity(0.05),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Bouton avec l'humeur enregistrée
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: _getFeelingColor(
                                    _feelingValue,
                                  ).withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getFeelingColor(
                                        _feelingValue,
                                      ).withOpacity(0.3),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _feelingEmoji(_feelingValue),
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Ton humeur",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          _feelingDescription,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 50),

                              // Texte de confirmation
                              Text(
                                "Enregistrement terminé",
                                style: TextStyle(
                                  color: _accentColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Merci d'avoir partagé ton humeur aujourd'hui",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 60),

                              // Bouton "Voir plus"
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _navigateToNextScreen,
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
                                        'Voir plus',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_ios, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // Emoji correspondant à l'humeur
  String _feelingEmoji(double value) {
    if (value < 0.2) return "😢";
    if (value < 0.4) return "😕";
    if (value < 0.6) return "😐";
    if (value < 0.8) return "🙂";
    return "😁";
  }
}
