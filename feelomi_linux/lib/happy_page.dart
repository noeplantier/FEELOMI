import 'package:flutter/material.dart';

class HappyPage extends StatefulWidget {
  const HappyPage({super.key});

  @override
  State<HappyPage> createState() => _HappyPageState();
}

class _HappyPageState extends State<HappyPage> {
  // Contrôleur pour la barre de recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Liste de tous les items disponibles
  final List<Map<String, dynamic>> _allItems = [
    {'text': 'Voyages', 'icon': Icons.flight, 'color': Colors.blue},
    {'text': 'Sport', 'icon': Icons.sports_soccer, 'color': Colors.green},
    {'text': 'Cuisine', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'text': 'Lecture', 'icon': Icons.book, 'color': Colors.brown},
    {'text': 'Musique', 'icon': Icons.music_note, 'color': Colors.purple},
    {'text': 'Cinéma', 'icon': Icons.movie, 'color': Colors.red},
    {'text': 'Animaux', 'icon': Icons.pets, 'color': Colors.amber},
    {'text': 'Art', 'icon': Icons.palette, 'color': Colors.pink},
    {'text': 'Jardinage', 'icon': Icons.eco, 'color': Colors.lightGreen},
    {'text': 'Technologie', 'icon': Icons.computer, 'color': Colors.grey},
    {'text': 'Famille', 'icon': Icons.family_restroom, 'color': Colors.teal},
    {'text': 'Amis', 'icon': Icons.people, 'color': Colors.indigo},
    {'text': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.deepOrange},
    {'text': 'Méditation', 'icon': Icons.self_improvement, 'color': Colors.cyan},
    {'text': 'Nature', 'icon': Icons.forest, 'color': Colors.green.shade800},
    {'text': 'Dialogues', 'icon': Icons.chat, 'color': Colors.blueGrey},
    {'text': 'Évolution', 'icon': Icons.trending_up, 'color': Colors.deepPurple},
    {'text': 'Danse', 'icon': Icons.nightlife, 'color': Colors.pinkAccent},
    {'text': 'Théâtre', 'icon': Icons.theater_comedy, 'color': Colors.amber.shade700},
    {'text': 'Sport nautique', 'icon': Icons.sailing, 'color': Colors.lightBlue},
    {'text': 'Jeux vidéo', 'icon': Icons.sports_esports, 'color': Colors.redAccent},
    {'text': 'Photographie', 'icon': Icons.camera_alt, 'color': Colors.black87},
    {'text': 'Éducation', 'icon': Icons.school, 'color': Colors.blue.shade900},
    {'text': 'Yoga', 'icon': Icons.fitness_center, 'color': Colors.teal.shade300},
    {'text': 'Astronomie', 'icon': Icons.star, 'color': Colors.indigo.shade900},
    {'text': 'Design', 'icon': Icons.design_services, 'color': Colors.deepPurple.shade300},
  ];
  
  // Liste des items filtrés par la recherche
  List<Map<String, dynamic>> _filteredItems = [];
  
  // Liste des items sélectionnés
  final List<Map<String, dynamic>> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    
    // Écouter les changements dans le champ de recherche
    _searchController.addListener(_filterItems);
  }
  
  // Filtrer les items selon le texte de recherche
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        _filteredItems = _allItems
            .where((item) => item['text'].toLowerCase().contains(query))
            .toList();
      }
    });
  }
  
  // Ajouter ou supprimer un item de la sélection
  void _toggleItem(Map<String, dynamic> item) {
    setState(() {
      final isSelected = _selectedItems.any((element) => element['text'] == item['text']);
      
      if (isSelected) {
        _selectedItems.removeWhere((element) => element['text'] == item['text']);
      } else {
        _selectedItems.add(item);
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
                              border: Border.all(
                                color: primaryColor,
                                width: 2,
                              ),
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
                            'Bonheur',
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
                          // Navigation vers la page finale
                          Navigator.pop(context);
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
                          'Quelles sont les choses qui te rendent heureux ?',
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
                          'Sélectionne tout ce qui te fait du bien au quotidien.',
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
                              hintText: 'Rechercher des activités...',
                              prefixIcon: const Icon(Icons.search),
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
                  
                  // Liste des éléments sélectionnés
                  if (_selectedItems.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      color: Colors.grey.shade50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sélectionnés (${_selectedItems.length})',
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
                            children: _selectedItems.map((item) => Chip(
                              avatar: Icon(
                                item['icon'],
                                color: item['color'],
                                size: 18,
                              ),
                              backgroundColor: item['color'].withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: item['color'],
                                fontWeight: FontWeight.w500,
                              ),
                              label: Text(item['text']),
                              deleteIconColor: item['color'],
                              onDeleted: () => _toggleItem(item),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  
                  // Liste des éléments disponibles
                  Expanded(
                    child: _filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun résultat trouvé',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = _selectedItems.any(
                                  (element) => element['text'] == item['text'],
                                );
                                
                                return GestureDetector(
                                  onTap: () => _toggleItem(item),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? item['color'].withOpacity(0.2)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? item['color']
                                            : Colors.grey.shade300,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                item['icon'],
                                                color: item['color'],
                                                size: 24,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                item['text'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: isSelected
                                                      ? item['color']
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: item['color'],
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
                    // Enregistrer les choix sélectionnés
                    final happyThings = _selectedItems.map((item) => item['text']).toList();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          happyThings.isEmpty
                              ? 'Aucun élément sélectionné'
                              : 'Éléments enregistrés: ${happyThings.join(", ")}',
                        ),
                      ),
                    );
                    // Navigation vers la page finale
                    Navigator.pop(context);
                    // Ici vous pourriez naviguer vers une page suivante
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continuer',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
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