import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feelomi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 150, 95, 186),
          secondary: const Color.fromARGB(255, 90, 0, 150),
        ),
        fontFamily: 'Poppins',
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
  // Émotion sélectionnée par l'utilisateur
  String? _selectedMood;
  // Mots-clés sélectionnés
  final List<String> _selectedKeywords = [];
  // Texte libre
  final TextEditingController _notesController = TextEditingController();
  
  // Liste des émotions disponibles avec leurs émojis
  final List<Map<String, dynamic>> _moods = [
    {'name': 'Joyeux', 'emoji': '😄'},
    {'name': 'Calme', 'emoji': '😌'},
    {'name': 'Triste', 'emoji': '😢'},
    {'name': 'Énergique', 'emoji': '⚡'},
    {'name': 'Fatigué', 'emoji': '😴'},
    {'name': 'Anxieux', 'emoji': '😰'},
    {'name': 'En colère', 'emoji': '😡'},
  ];
  
  // Liste des mots-clés pour décrire l'état émotionnel
  final List<String> _keywords = [
    'Reconnaissant', 'Dépassé', 'Inspiré', 'Frustré', 
    'Solitaire', 'Productif', 'Confiant', 'Confus',
    'Nostalgique', 'Enthousiaste', 'Apaisé', 'Stressé',
    'Mélancolique', 'Épanoui', 'Vulnérable', 'Déterminé'
  ];
  
  void _saveMoodEntry() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une humeur')),
      );
      return;
    }

    // Ici vous pourriez sauvegarder l'entrée dans une base de données
    final moodEntry = {
      'mood': _selectedMood,
      'keywords': _selectedKeywords,
      'notes': _notesController.text,
      'timestamp': DateTime.now().toString(),
    };
    
    // Afficher une confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enregistré : $_selectedMood')),
    );
    
    // Remettre à zéro le formulaire
    setState(() {
      _selectedMood = null;
      _selectedKeywords.clear();
      _notesController.clear();
    });
    
  }
  

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
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
            Container(
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
            
            // Bouton d'enregistrement
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
    );
  }
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}