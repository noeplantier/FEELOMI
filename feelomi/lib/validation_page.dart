import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feelomi/home_page.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'dart:async';
import 'dart:math' as math;
import 'custom_back.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'calendary_page.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage>
    with SingleTickerProviderStateMixin {
  // Controllers pour animations
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _fadeInAnimation;

  // États des animations
  bool _showConfetti = false;
  bool _showQuote = false;
  bool _isExitReady = false;

  // État pour la prise de rendez-vous
  bool _showAppointmentOptions = false;
  bool _showWebView = false;
  String _selectedSpecialty = '';
  String _doctolibUrl = '';
  WebViewController? _webViewController;

  // Liste des spécialités médicales
  final List<Map<String, dynamic>> _specialties = [
    {
      'name': 'Psychologue',
      'icon': Icons.psychology,
      'url': 'https://www.doctolib.fr/psychologue',
      'color': const Color(0xFF5F93E5),
    },
    {
      'name': 'Psychiatre',
      'icon': Icons.medical_services,
      'url': 'https://www.doctolib.fr/psychiatre',
      'color': const Color(0xFF6C63FF),
    },
    {
      'name': 'Médecin généraliste',
      'icon': Icons.local_hospital,
      'url': 'https://www.doctolib.fr/medecin-generaliste',
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Nutritionniste',
      'icon': Icons.restaurant_menu,
      'url': 'https://www.doctolib.fr/nutritionniste',
      'color': const Color(0xFFFF9800),
    },
    {
      'name': 'Coach bien-être',
      'icon': Icons.self_improvement,
      'url': 'https://www.doctolib.fr/osteopathe',
      'color': const Color(0xFFE91E63),
    },
  ];

  // Liste de citations positives
  final List<String> _zenQuotes = [
    "Le plus beau voyage, c'est celui qu'on n'a pas encore fait.",
    "Ce n'est pas parce que les choses sont difficiles que nous n'osons pas, c'est parce que nous n'osons pas qu'elles sont difficiles.",
    "Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte.",
    "La vie est un défi à relever, un bonheur à mériter, une aventure à tenter.",
    "La paix vient de l'intérieur. Ne la cherchez pas à l'extérieur.",
  ];

  // Citation sélectionnée aléatoirement
  late String _selectedQuote;

  // Couleurs thématiques
  final Color primaryColor = const Color(0xFF8B5CF6);
  final Color _accentColor = const Color.fromARGB(255, 90, 0, 150);
  final Color _backgroundColor = const Color.fromARGB(255, 250, 245, 255);

  get Lottie => null;

  @override
  void initState() {
    super.initState();

    // Choisir une citation aléatoire
    final random = math.Random();
    _selectedQuote = _zenQuotes[random.nextInt(_zenQuotes.length)];

    // Configuration des animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // Démarrer l'animation principale
    _controller.forward();

    // Timing des animations séquentielles
    _scheduleAnimations();
  }

  void _scheduleAnimations() {
    // Animation de confettis après 1 seconde
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showConfetti = true;
        });

        // Vibration pour feedback
        HapticFeedback.mediumImpact();
      }
    });

    // Afficher la citation après 2 secondes
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showQuote = true;
        });
      }
    });

    // Activer le bouton de sortie après 3 secondes
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isExitReady = true;
        });
      }
    });
  }

  // Méthode pour ouvrir Doctolib avec le spécialiste choisi
  void _openDoctolibAppointment(String specialty, String url) {
    setState(() {
      _selectedSpecialty = specialty;
      _doctolibUrl = url;
      _showWebView = true;
    });
  }

  // Fermer la WebView
  void _closeWebView() {
    setState(() {
      _showWebView = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showWebView) {
      return _buildDoctolibWebView();
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Barre chronologique en haut
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _accentColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                          const CustomBackButton(iconColor: Colors.white),
                          const SizedBox(width: 8),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                '✓',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Félicitations',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Barre de progression
                  LinearProgressIndicator(
                    value: 1.0, // 100% de progression
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),

            // Contenu principal
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti animation en arrière-plan

                  // Contenu
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),

                          // Titre principal avec animation
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _opacityAnimation.value,
                                child: Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: child,
                                ),
                              );
                            },

                            child: Column(
                              children: [
                                Text(
                                  'Bravo !',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                    shadows: [
                                      Shadow(
                                        color: _accentColor.withOpacity(0.3),
                                        offset: const Offset(2, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tu viens de faire le premier pas vers un mieux-être',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: _accentColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Mascotte Feelo avec animation
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: child,
                              );
                            },
                            child: _buildFeeloAnimation(),
                          ),

                          const SizedBox(height: 40),

                          // Citation zen avec animation
                          AnimatedOpacity(
                            opacity: _showQuote ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeIn,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: _accentColor.withOpacity(0.1),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    color: _primaryColor.withOpacity(0.7),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _selectedQuote,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _accentColor,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Divider(
                                    color: _primaryColor.withOpacity(0.2),
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nous sommes ravis de t\'accompagner dans ton voyage vers une meilleure santé mentale.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Prochain rendez-vous
                          AnimatedOpacity(
                            opacity: _fadeInAnimation.value,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _primaryColor.withOpacity(0.2),
                                        ),
                                        child: Icon(
                                          Icons.calendar_today_rounded,
                                          color: _primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Prends rendez-vous',
                                              style: TextStyle(
                                                color: _accentColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Pour aller plus loin, consulte un spécialiste',
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showAppointmentOptions =
                                            !_showAppointmentOptions;
                                      });
                                      HapticFeedback.lightImpact();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.search, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          _showAppointmentOptions
                                              ? 'Masquer les spécialistes'
                                              : 'Chercher un spécialiste',
                                          style: const TextStyle(
                                            fontSize: 16,
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

                          // Options de spécialistes via Doctolib
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _showAppointmentOptions
                                ? _buildSpecialistOptions()
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bouton de continuer en bas
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isExitReady
                      ? () {
                          // Feedback haptique
                          HapticFeedback.mediumImpact();
                          // Navigation vers la page d'accueil
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalendaryPage(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Commencer l'aventure",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: _primaryColor,
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

  // Widget pour la WebView de Doctolib
  Widget _buildDoctolibWebView() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rendez-vous $_selectedSpecialty'),
        backgroundColor: _primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _closeWebView,
        ),
        actions: [
          // Bouton pour rafraîchir la page
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController?.reload();
            },
          ),
          // Bouton pour ouvrir dans le navigateur externe
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              final Uri url = Uri.parse(_doctolibUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: _doctolibUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onProgress: (progress) {
          // Vous pourriez ajouter un indicateur de progression ici
        },
        navigationDelegate: (request) {
          // Vous pouvez gérer les redirections ici si nécessaire
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  // Liste des spécialistes disponibles
  Widget _buildSpecialistOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Spécialistes disponibles via Doctolib',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _accentColor,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _specialties.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.1),
                indent: 70,
              ),
              itemBuilder: (context, index) {
                final specialty = _specialties[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: specialty['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      specialty['icon'],
                      color: specialty['color'],
                      size: 24,
                    ),
                  ),
                  title: Text(
                    specialty['name'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: _primaryColor,
                    size: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _openDoctolibAppointment(
                      specialty['name'],
                      specialty['url'],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Powered by Doctolib',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget animé pour Feelo avec image ronde
  Widget _buildFeeloAnimation() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base de l'écureuil avec borderRadius à 50%
          ClipRRect(
            borderRadius: BorderRadius.circular(100), // 50% de 200
            child: Image.network(
              '/assets/images/happy.png',
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),

          // Animation de battement de coeur
        ],
      ),
    );
  }

  WebView({
    required String initialUrl,
    required javascriptMode,
    required Null Function(dynamic controller) onWebViewCreated,
    required Null Function(dynamic progress) onProgress,
    required NavigationDecision Function(dynamic request) navigationDelegate,
  }) {}
}

class JavascriptMode {
  static const JavascriptMode unrestricted = JavascriptMode._();

  const JavascriptMode._();
}
