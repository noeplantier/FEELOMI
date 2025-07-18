import 'package:feelomi/custom_back.dart';
import 'package:flutter/material.dart';
import 'medics_page.dart';

class PhysicalPage extends StatefulWidget {
  const PhysicalPage({super.key});

  @override
  State<PhysicalPage> createState() => _PhysicalPageState();
}

class _PhysicalPageState extends State<PhysicalPage>
    with SingleTickerProviderStateMixin {
  // Option sélectionnée (null, 'oui', 'non')
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF8B5CF6);
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
                      // Numéro d'étape et titre
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
                                '6',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Physique',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
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
                              builder: (context) => const MedicsPage(),
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
                    value: 0.78,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),

            // Contenu principal
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
                        'As-tu une détresse physique ?',
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
                        'Cette information nous aide à mieux cerner tes besoins.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Options avec leur description
                      // Option Oui
                      _buildOptionCard(
                        title: 'Oui une ou plusieurs',
                        description:
                            'Je ressens une douleur physique à différents endroits sur mon corps.',
                        icon: Icons.check_circle_outline,
                        option: 'oui',
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                      ),

                      const SizedBox(height: 16),

                      // Option Non
                      _buildOptionCard(
                        title: 'Pas de douleur physique du tout',
                        description:
                            'Je me sens bien physiquement, pas de douleur particulière.',
                        icon: Icons.cancel_outlined,
                        option: 'non',
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                      ),

                      const SizedBox(height: 40),

                      // Message informatif
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Si tu as une douleur physique importante, nous te recommandons de consulter un professionnel de santé en parallèle de l\'utilisation de l\'application.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade900,
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
                          // Navigation vers la page des médicaments
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MedicsPage(),
                            ),
                          );
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

  // Widget pour construire une carte d'option réutilisable
  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required String option,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final bool isSelected = _selectedOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et icône
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? primaryColor : Colors.grey.shade600,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? secondaryColor : Colors.black87,
                    ),
                    // Empêcher le débordement du texte
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
