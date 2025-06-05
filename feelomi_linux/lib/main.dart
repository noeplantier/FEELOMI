import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'health_tracker.dart';
import 'gender_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feelomi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 150, 95, 186),
          secondary: const Color.fromARGB(255, 90, 0, 150),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key, required this.title});

  final String title;

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  // Variables d'état
  String? _selectedMood;
  final List<String> _selectedKeywords = [];
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  
  // Liste des émotions avec émojis
  final List<Map<String, dynamic>> _moods = const [
    {'name': 'Joyeux', 'emoji': '😄'},
    {'name': 'Calme', 'emoji': '😌'},
    {'name': 'Triste', 'emoji': '😢'},
    {'name': 'Énergique', 'emoji': '⚡'},
    {'name': 'Fatigué', 'emoji': '😴'},
    {'name': 'Anxieux', 'emoji': '😰'},
    {'name': 'En colère', 'emoji': '😡'},
  ];
  
  // Liste des mots-clés émotionnels
  final List<String> _keywords = const [
    'Reconnaissant', 'Dépassé', 'Inspiré', 'Frustré', 
    'Solitaire', 'Productif', 'Confiant', 'Confus',
    'Nostalgique', 'Enthousiaste', 'Apaisé', 'Stressé',
    'Mélancolique', 'Épanoui', 'Vulnérable', 'Déterminé'
  ];
  
  // Enregistrement de l'état émotionnel avec API
  Future<void> _saveMoodEntry() async {
    // Vérification de la sélection d'humeur
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une humeur')),
      );
      return;
    }

    // Préparation des données
    final moodEntry = {
      'mood': _selectedMood,
      'keywords': _selectedKeywords,
      'notes': _notesController.text,
      'timestamp': DateTime.now().toString(),
      'userId': 'user123', // À remplacer par l'ID utilisateur réel
    };
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Envoi des données à l'API Node.js/Express
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/mood-entries'), // URL à configurer
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer token123', // À remplacer par JWT réel
        },
        body: jsonEncode(moodEntry),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Enregistré : $_selectedMood')),
          );
          
          // Redirection vers HealthTracker
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HealthTracker()),
              );
            }
          });
        }
      } else {
        // Gestion des erreurs HTTP
        setState(() {
          _errorMessage = 'Erreur ${response.statusCode}: ${response.reasonPhrase}';
        });
        _showErrorSnackbar();
      }
    } catch (e) {
      // Gestion des exceptions
      setState(() {
        _errorMessage = 'Impossible de se connecter au serveur. Mode hors-ligne activé.';
      });
      _showErrorSnackbar();
      
      // Mode hors-ligne: Sauvegarde locale et navigation
      if (mounted) {
        // Simuler la sauvegarde locale puis naviguer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enregistré localement : $_selectedMood')),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HealthTracker()),
            );
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _showErrorSnackbar() {
    if (mounted && _errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
    }
  }

  // Gestion des mots-clés
  void _toggleKeyword(String keyword) {
    setState(() {
      if (_selectedKeywords.contains(keyword)) {
        _selectedKeywords.remove(keyword);
      } else {
        if (_selectedKeywords.length < 5) { // Limite à 5 mots-clés
          _selectedKeywords.add(keyword);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 5 mots-clés')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Barre chronologique
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
                        // Étape 1 active
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            border: Border.all(color: primaryColor, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Humeur',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Étape 2 inactive
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Objectif',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    // Bouton pour passer l'étape
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HealthTracker(),
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
                  value: 0.5, // 50% de progression
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
          
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Comment vous sentez-vous aujourd'hui ?",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Sélection d'émotions avec émojis
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _moods.length,
                      itemBuilder: (context, index) {
                        final mood = _moods[index];
                        final isSelected = _selectedMood == mood['name'];
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMood = mood['name'];
                            });
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Theme.of(context).colorScheme.primaryContainer 
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected 
                                  ? Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ) 
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  mood['emoji'],
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mood['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sélection de mots-clés
                  const Text(
                    "Sélectionnez jusqu'à 5 mots-clés :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _keywords.map((keyword) {
                      final isSelected = _selectedKeywords.contains(keyword);
                      return FilterChip(
                        label: Text(keyword),
                        selected: isSelected,
                        selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                        onSelected: (_) => _toggleKeyword(keyword),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Notes personnelles
                  const Text(
                    "Décrivez votre journée (optionnel) :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Qu'est-ce qui a influencé votre humeur aujourd'hui ?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Indicateur de chargement
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  
                  // Bouton d'enregistrement
                  if (!_isLoading)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _saveMoodEntry,
                        icon: const Icon(Icons.save_outlined),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            "Enregistrer mon humeur",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}