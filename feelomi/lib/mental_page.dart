import 'package:feelomi/stress_page.dart';
import 'package:flutter/material.dart';
import 'happy_page.dart';

class MentalPage extends StatefulWidget {
  const MentalPage({super.key});

  @override
  State<MentalPage> createState() => _MentalPageState();
}

class _MentalPageState extends State<MentalPage> {
  // Contrôleur pour la barre de recherche
  final TextEditingController _searchController = TextEditingController();

  // Liste de tous les symptômes disponibles
  final List<Map<String, dynamic>> _allSymptoms = [
    {'text': 'Tristesse', 'color': Colors.blue.shade700},
    {'text': 'Anxiété', 'color': Colors.orange.shade700},
    {'text': 'Isolement', 'color': Colors.purple.shade700},
    {'text': 'Retrait social', 'color': Colors.indigo.shade700},
    {'text': 'Insomnie', 'color': Colors.teal.shade700},
    {'text': 'Fatigue', 'color': Colors.grey.shade700},
    {'text': 'Irritabilité', 'color': Colors.red.shade700},
    {'text': 'Problèmes de concentration', 'color': Colors.amber.shade700},
    {'text': 'Stress', 'color': Colors.pink.shade700},
    {'text': 'Perte d\'intérêt', 'color': Colors.brown.shade700},
    {'text': 'Panique', 'color': Colors.orange.shade900},
    {'text': 'Cauchemars', 'color': Colors.indigo.shade900},
    {'text': 'Hypersensibilité', 'color': Colors.deepPurple.shade700},
    {'text': 'Colère', 'color': Colors.red.shade900},
    {'text': 'Perte d\'appétit', 'color': Colors.green.shade700},
    {'text': 'Pensées négatives', 'color': Colors.blueGrey.shade700},
    {'text': 'Impulsivité', 'color': Colors.deepOrange.shade700},
    {'text': 'Culpabilité', 'color': Colors.cyan.shade700},
    {'text': 'Confusion', 'color': Colors.lightBlue.shade700},
    {'text': 'Désespoir', 'color': Colors.grey.shade800},
    {'text': 'Phobie', 'color': Colors.lime.shade800},
    {'text': 'Obsession', 'color': Colors.purple.shade900},
    {'text': 'Hyperactivité', 'color': Colors.amber.shade900},
    {'text': 'Apathie', 'color': Colors.teal.shade900},
    {'text': 'Procrastination', 'color': Colors.deepOrange.shade900},
    {'text': 'Rumination', 'color': Colors.indigo.shade800},
    {'text': 'Troubles de l\'humeur', 'color': Colors.brown.shade800},
    {'text': 'Perfectionnisme', 'color': Colors.deepPurple.shade800},
  ];

  // Liste des symptômes filtrés
  List<Map<String, dynamic>> _filteredSymptoms = [];

  // Liste des symptômes sélectionnés
  final List<Map<String, dynamic>> _selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    _filteredSymptoms = List.from(_allSymptoms);

    // Écouter les changements dans le champ de recherche
    _searchController.addListener(_filterSymptoms);
  }

  // Filtrer les symptômes selon le texte de recherche
  void _filterSymptoms() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredSymptoms = List.from(_allSymptoms);
      } else {
        _filteredSymptoms = _allSymptoms
            .where((symptom) => symptom['text'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // Ajouter ou supprimer un symptôme de la sélection
  void _toggleSymptom(Map<String, dynamic> symptom) {
    setState(() {
      final isSelected = _selectedSymptoms.any(
        (element) => element['text'] == symptom['text'],
      );

      if (isSelected) {
        _selectedSymptoms.removeWhere(
          (element) => element['text'] == symptom['text'],
        );
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                                '10',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Santé mentale',
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
                    value: 1.3,
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
                          'As-tu d\'autres symptômes de santé mentale ?',
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
                          'Aide-nous à mieux comprendre tes défis pour te proposer un accompagnement adapté.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        // Barre de recherche
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade100,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Rechercher des symptômes...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Liste des symptômes sélectionnés
                  if (_selectedSymptoms.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      color: Colors.grey.shade50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Symptômes sélectionnés (${_selectedSymptoms.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedSymptoms
                                .map(
                                  (symptom) => Chip(
                                    backgroundColor: symptom['color']
                                        .withOpacity(0.1),
                                    labelStyle: TextStyle(
                                      color: symptom['color'],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    label: Text(symptom['text']),
                                    deleteIconColor: symptom['color'],
                                    onDeleted: () => _toggleSymptom(symptom),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                  // Liste des symptômes disponibles
                  Expanded(
                    child: _filteredSymptoms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun symptôme correspondant',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 12,
                              children: _filteredSymptoms.map((symptom) {
                                final isSelected = _selectedSymptoms.any(
                                  (element) =>
                                      element['text'] == symptom['text'],
                                );

                                return GestureDetector(
                                  onTap: () => _toggleSymptom(symptom),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? symptom['color'].withOpacity(0.1)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: isSelected
                                            ? symptom['color']
                                            : Colors.grey.shade300,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isSelected)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 6.0,
                                            ),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: symptom['color'],
                                              size: 18,
                                            ),
                                          ),
                                        Text(
                                          symptom['text'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? symptom['color']
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ],
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
                    // Enregistrer les symptômes sélectionnés
                    final symptoms = _selectedSymptoms
                        .map((item) => item['text'])
                        .toList();

                    // Message selon le cas
                    String message;
                    if (symptoms.isEmpty) {
                      message = 'Aucun symptôme sélectionné';
                    } else if (symptoms.length == 1) {
                      message = 'Symptôme enregistré: ${symptoms[0]}';
                    } else {
                      message = '${symptoms.length} symptômes enregistrés';
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));

                    // Navigation vers la page de stress au lieu de happy_page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StressPage(),
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
