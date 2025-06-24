import 'package:feelomi/custom_back.dart';
import 'package:feelomi/happy_page.dart';
import 'package:feelomi/sleeping_page.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async';

class SpecifyPage extends StatefulWidget {
  final String medicType;

  const SpecifyPage({super.key, required this.medicType});

  @override
  State<SpecifyPage> createState() => _SpecifyPageState();
}

class _SpecifyPageState extends State<SpecifyPage> {
  // Contrôleur pour le champ de texte
  final TextEditingController _medicController = TextEditingController();

  // Instance de Speech to Text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechEnabled = false;
  bool _isRecording = false;
  String _lastWords = '';

  // Base de données simulée de médicaments pour l'auto-suggestion
  final List<String> _medicDatabase = [
    'Doliprane 500mg',
    'Doliprane 1000mg',
    'Efferalgan',
    'Dafalgan',
    'Xanax',
    'Levothyrox',
    'Spasfon',
    'Aspégic',
    'Ventoline',
    'Smecta',
    'Vitamine D',
    'Magnésium',
    'Omega 3',
    'Zinc',
    'Aspirine',
    'Imodium',
    'Gaviscon',
    'Ibuprofène',
    'Paracétamol',
  ];

  // Liste de suggestions
  List<String> _suggestions = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  // Initialisation de la reconnaissance vocale
  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
    setState(() {});
  }

  // Démarrage de l'écoute vocale
  void _startListening() async {
    if (!_speechEnabled) {
      _initSpeech();
    }

    setState(() {
      _isRecording = true;
      _lastWords = '';
    });

    await _speech.listen(
      onResult: _onSpeechResult,
      localeId: 'fr_FR', // Langue française
      listenFor: const Duration(seconds: 30), // Durée maximale d'écoute
      pauseFor: const Duration(seconds: 3), // Pause automatique après silence
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Écoute active, parlez maintenant...')),
    );
  }

  // Arrêt de l'écoute vocale
  void _stopListening() {
    _speech.stop();
    setState(() {
      _isRecording = false;
    });
  }

  // Bascule de l'état d'enregistrement
  void _toggleRecording() {
    if (_isRecording) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  // Traitement du résultat de la reconnaissance vocale
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (result.finalResult) {
      // Ajout du texte reconnu au champ de médicaments
      if (_lastWords.isNotEmpty) {
        _processRecognizedText(_lastWords);
      }
    }
  }

  // Traitement du statut de la reconnaissance vocale
  void _onSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      setState(() {
        _isRecording = false;
      });
    }
  }

  // Gestion des erreurs de reconnaissance vocale
  void _onSpeechError(dynamic error) {
    setState(() {
      _isRecording = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur de reconnaissance vocale: ${error.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Traitement du texte reconnu pour identifier les médicaments
  void _processRecognizedText(String text) {
    // Convertir en minuscules pour la recherche
    final lowerText = text.toLowerCase();

    // Rechercher des correspondances dans la base de données
    List<String> foundMeds = _medicDatabase
        .where((med) => lowerText.contains(med.toLowerCase()))
        .toList();

    // Si aucun médicament trouvé, utiliser le texte brut
    if (foundMeds.isEmpty) {
      // Diviser le texte en mots potentiels pour les médicaments
      final words = lowerText.split(' ');

      // Recherche plus avancée
      for (final word in words) {
        if (word.length >= 4) {
          // Ignorer les mots trop courts
          final possibleMeds = _medicDatabase
              .where((med) => med.toLowerCase().contains(word))
              .toList();

          foundMeds.addAll(possibleMeds);
        }
      }

      // Si toujours rien trouvé, utiliser le texte brut
      if (foundMeds.isEmpty) {
        foundMeds = [text];
      }
    }

    // Ajouter les médicaments identifiés au champ de texte
    final currentText = _medicController.text;
    String newText = foundMeds.join(', ');

    if (currentText.isNotEmpty) {
      newText = '$currentText, $newText';
    }

    setState(() {
      _medicController.text = newText;
    });
  }

  // Recherche de suggestions basée sur le texte saisi
  void _onTextChanged() {
    final text = _medicController.text;

    // Annuler le timer précédent s'il est actif
    _debounceTimer?.cancel();

    // Créer un nouveau timer pour éviter les recherches trop fréquentes
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Obtenir le dernier mot saisi
      final words = text.split(',');
      if (words.isNotEmpty) {
        final lastWord = words.last.trim().toLowerCase();

        if (lastWord.isNotEmpty) {
          // Rechercher des correspondances dans la base de données
          setState(() {
            _suggestions = _medicDatabase
                .where((med) => med.toLowerCase().contains(lastWord))
                .take(5)
                .toList();
          });
        } else {
          setState(() {
            _suggestions = [];
          });
        }
      }
    });
  }

  // Sélection d'une suggestion
  void _selectSuggestion(String suggestion) {
    final words = _medicController.text.split(',');
    words.removeLast();

    String newText = words.join(',');
    if (newText.isNotEmpty) {
      newText = '$newText, $suggestion';
    } else {
      newText = suggestion;
    }

    setState(() {
      _medicController.text = newText;
      _suggestions = [];
    });
  }

  @override
  void dispose() {
    _medicController.dispose();
    _debounceTimer?.cancel();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 150, 95, 186);
    final secondaryColor = const Color.fromARGB(255, 90, 0, 150);

    // Titre dynamique basé sur le type de médicament
    String pageTitle;
    String placeholderText;
    Color medicColor;
    IconData medicIcon;

    switch (widget.medicType) {
      case 'prescrits':
        pageTitle = 'Quels médicaments prends-tu ?';
        placeholderText = 'Ex: Doliprane, Xanax, Levothyrox...';
        medicColor = Colors.orange;
        medicIcon = Icons.medication;
        break;
      case 'supplements':
        pageTitle = 'Quels suppléments prends-tu ?';
        placeholderText = 'Ex: Magnésium, Vitamine D, Omega 3...';
        medicColor = Colors.green;
        medicIcon = Icons.local_pharmacy_outlined;
        break;
      default:
        pageTitle = 'Précise tes médicaments';
        placeholderText = 'Ex: Doliprane, suppléments...';
        medicColor = primaryColor;
        medicIcon = Icons.medication;
    }

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
                          CustomBackButton(
                            iconColor: Theme.of(context).colorScheme.primary,
                          ),
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
                                '8',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Détails',
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
                              builder: (context) => const SleepingPage(),
                            ),
                          );
                        },
                        child: const Text('Passer cette étape'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Barre de progression
                  LinearProgressIndicator(
                    value: 1.04, // 100% de progression
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Titre principal en violet
                      Text(
                        pageTitle,
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
                        'Cette information nous aidera à adapter ton expérience.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Icône du type de médicament
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: medicColor.withOpacity(0.2),
                        ),
                        child: Icon(medicIcon, size: 40, color: medicColor),
                      ),

                      const SizedBox(height: 30),

                      // Champ de texte avec bouton microphone
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
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: TextField(
                                      controller: _medicController,
                                      onChanged: (value) {
                                        _onTextChanged();
                                      },
                                      decoration: InputDecoration(
                                        hintText: placeholderText,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 16),
                                      maxLines: 3,
                                      minLines: 1,
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
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                      child: Icon(
                                        _isRecording
                                            ? Icons.stop
                                            : Icons.mic_none,
                                        key: ValueKey<bool>(_isRecording),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Affichage de la reconnaissance en cours
                            if (_isRecording && _lastWords.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.mic,
                                          size: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _lastWords,
                                        style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Affichage des suggestions
                            if (_suggestions.isNotEmpty)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 8,
                                      ),
                                      child: Text(
                                        'Suggestions:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    ..._suggestions.map(
                                      (suggestion) => InkWell(
                                        onTap: () =>
                                            _selectSuggestion(suggestion),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            suggestion,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Affichage des médicaments identifiés
                            if (_medicController.text.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Médicaments identifiés:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Affichage des médicaments sous forme de chips
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _medicController.text
                                          .split(',')
                                          .map((med) => med.trim())
                                          .where((med) => med.isNotEmpty)
                                          .map(
                                            (med) => Chip(
                                              backgroundColor: medicColor
                                                  .withOpacity(0.2),
                                              labelStyle: TextStyle(
                                                color: medicColor,
                                                fontSize: 14,
                                              ),
                                              label: Text(med),
                                              deleteIconColor: medicColor,
                                              onDeleted: () {
                                                // Supprimer ce médicament de la liste
                                                setState(() {
                                                  List<String> meds =
                                                      _medicController.text
                                                          .split(',')
                                                          .map((m) => m.trim())
                                                          .where(
                                                            (m) =>
                                                                m.isNotEmpty &&
                                                                m != med,
                                                          )
                                                          .toList();
                                                  _medicController.text = meds
                                                      .join(', ');
                                                });
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Message informatif
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.safety_divider,
                              color: Colors.green.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Ces informations sont confidentielles et nous aideront à garantir que nos suggestions ne présentent pas d\'interactions médicamenteuses.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    // Enregistrer les médicaments spécifiés
                    final meds = _medicController.text;

                    // Navigation vers la page finale
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SleepingPage(),
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
