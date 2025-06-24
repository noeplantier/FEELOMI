import 'package:feelomi/custom_back.dart';
import 'package:feelomi/specify_page.dart';
import 'package:flutter/material.dart';

class MedicsPage extends StatefulWidget {
  const MedicsPage({super.key});

  @override
  State<MedicsPage> createState() => _MedicsPageState();
}

class _MedicsPageState extends State<MedicsPage> {
  // Option sélectionnée
  String? _selectedOption;

  // Liste des options de médicaments
  final List<Map<String, dynamic>> _medicOptions = [
    {
      'id': 'prescrits',
      'title': 'Médicaments prescrits',
      'icon': Icons.medication,
      'color': Colors.orange,
    },
    {
      'id': 'supplements',
      'title': 'Suppléments en comptoir',
      'icon': Icons.local_pharmacy_outlined,
      'color': Colors.green,
    },
    {
      'id': 'aucun',
      'title': 'Je n\'en prends pas',
      'icon': Icons.not_interested,
      'color': Colors.blue,
    },
    {
      'id': 'prive',
      'title': 'Je préfère ne pas en parler',
      'icon': Icons.privacy_tip_outlined,
      'color': Colors.grey,
    },
  ];

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
                                '7',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Médicaments',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigation vers la page des médicaments
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SpecifyPage(medicType: 'default'),
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
                  // Barre de progression
                  LinearProgressIndicator(
                    value: 0.91,
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
                        'Prends-tu des médicaments ?',
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
                        'Cette information nous aide à personnaliser au mieux ton expérience.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Grille de cartes pour les options
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: _medicOptions.length,
                        itemBuilder: (context, index) {
                          final option = _medicOptions[index];
                          final isSelected = _selectedOption == option['id'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOption = option['id'];
                              });
                            },
                            child: Card(
                              elevation: isSelected ? 4 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? primaryColor
                                      : Colors.transparent,
                                  width: isSelected ? 2 : 0,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isSelected
                                      ? primaryColor.withOpacity(0.1)
                                      : Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: option['color'].withOpacity(0.2),
                                      ),
                                      child: Icon(
                                        option['icon'],
                                        color: option['color'],
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      option['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? secondaryColor
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Message informatif
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.yellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.yellow.shade700,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.security,
                              color: Colors.yellow.shade800,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Toutes les informations médicales sont strictement confidentielles et ne servent qu\'à améliorer l\'expérience sur l\'application.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.yellow.shade900,
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
                  onPressed: _selectedOption == null
                      ? null // Désactivé si aucune option sélectionnée
                      : () {
                          // Navigation en fonction de l'option sélectionnée
                          if (_selectedOption == 'prescrits' ||
                              _selectedOption == 'supplements') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SpecifyPage(medicType: _selectedOption!),
                              ),
                            );
                          } else if (_selectedOption == 'aucun') {
                            // Pour l'option "Je n'en prends pas", on peut naviguer vers une page spécifique
                            // ou vers la page suivante du workflow
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SpecifyPage(medicType: 'none'),
                              ),
                            );
                          } else if (_selectedOption == 'prive') {
                            // Pour l'option "Je préfère ne pas en parler"
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SpecifyPage(medicType: 'private'),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
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
