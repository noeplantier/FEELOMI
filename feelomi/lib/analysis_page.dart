import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'happy_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  // Contrôleur pour le champ de texte
  final TextEditingController _thoughtsController = TextEditingController();

  // État de l'enregistrement vocal
  bool _isRecording = false;

  // Méthode pour simuler un enregistrement vocal
  void _toggleRecording() {
    // Vibration pour améliorer l'expérience utilisateur
    HapticFeedback.mediumImpact();

    setState(() {
      _isRecording = !_isRecording;
    });

    // Simulation d'enregistrement vocal
    if (_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enregistrement en cours...')),
      );

      // Après 3 secondes, arrête l'enregistrement et ajoute du texte
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isRecording = false;
          });

          // Ajouter le texte reconnu
          final existingText = _thoughtsController.text;
          final newText =
              "Aujourd'hui je me sens un peu stressé(e) mais j'essaie de rester positif(ve).";

          _thoughtsController.text = existingText.isEmpty
              ? newText
              : "$existingText\n\n$newText";

          // Place le curseur à la fin du texte
          _thoughtsController.selection = TextSelection.fromPosition(
            TextPosition(offset: _thoughtsController.text.length),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
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
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                '11',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Analyse personnelle',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Titre principal en violet
                      Text(
                        'Analyse personnelle',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Sous-titre explicatif
                      Text(
                        'Cet espace est entièrement privé. Exprime-toi librement pour mieux te comprendre.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Sous-titre H2
                      Text(
                        'Écris librement tout ce qui te traverse l\'esprit. Je suis là pour t\'écouter.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Champ de texte avec microphone
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          color: Colors.grey.shade50,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: TextField(
                                      controller: _thoughtsController,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Partage tes pensées, sentiments ou réflexions...',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                      maxLines: 10,
                                      minLines: 5,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isRecording
                                        ? Colors.red
                                        : primaryColor,
                                  ),
                                  child: IconButton(
                                    onPressed: _toggleRecording,
                                    icon: Icon(
                                      _isRecording ? Icons.mic : Icons.mic_none,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Conseils et astuces
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purple.shade300,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.tips_and_updates,
                                  color: Colors.purple.shade700,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Astuces pour ton analyse',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Liste de conseils
                            ...List.generate(3, (index) {
                              List<Map<String, dynamic>> tips = [
                                {
                                  'text':
                                      'Exprime-toi sans filtrer tes pensées, personne ne te jugera',
                                  'icon': Icons.sentiment_satisfied,
                                },
                                {
                                  'text':
                                      'Sois honnête avec toi-même, c\'est la clé pour progresser',
                                  'icon': Icons.verified_user,
                                },
                                {
                                  'text':
                                      'Tes données restent confidentielles et sécurisées',
                                  'icon': Icons.lock,
                                },
                              ];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      tips[index]['icon'],
                                      color: Colors.purple.shade600,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        tips[index]['text'],
                                        style: TextStyle(
                                          color: Colors.purple.shade900,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Message sur la confidentialité
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ton espace privé et confidentiel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
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
                    // Enregistrer les pensées de l'utilisateur
                    final thoughts = _thoughtsController.text;
                    if (thoughts.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Analyse enregistrée avec succès'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Aucune analyse à enregistrer'),
                        ),
                      );
                    }

                    // Navigation vers la page du bonheur
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HappyPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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
}
