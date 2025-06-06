import 'package:feelomi/help_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  // Poids sélectionné (défaut à 70 kg)
  int _selectedWeight = 70;
  
  // Décimales du poids (0 à 9)
  int _selectedDecimal = 0;

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
                                '4',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Poids',
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
                      // Navigation vers la page d'aide professionnelle
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpPage(),
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
                    value: 0.9, // 90% de progression
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Quel est ton poids ?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Design balance digitale
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Écran de la balance
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$_selectedWeight',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              ),
                              Text(
                                ',$_selectedDecimal',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              ),
                              const Text(
                                ' kg',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Deux sélecteurs côte à côte
                        Row(
                          children: [
                            // Sélecteur kilos
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 120,
                                child: CupertinoPicker(
                                  magnification: 1.2,
                                  squeeze: 1.0,
                                  backgroundColor: Colors.transparent,
                                  itemExtent: 40,
                                  looping: true,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      _selectedWeight = index + 30;
                                    });
                                  },
                                  children: List<Widget>.generate(121, (int index) {
                                    return Center(
                                      child: Text(
                                        '${index + 30}',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: (index + 30) == _selectedWeight 
                                              ? FontWeight.bold 
                                              : FontWeight.normal,
                                          color: (index + 30) == _selectedWeight
                                              ? primaryColor
                                              : Colors.black87,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            
                            const Text(
                              ',',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            // Sélecteur décimales
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 120,
                                child: CupertinoPicker(
                                  magnification: 1.1,
                                  squeeze: 1.0,
                                  backgroundColor: Colors.transparent,
                                  itemExtent: 40,
                                  looping: true,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      _selectedDecimal = index;
                                    });
                                  },
                                  children: List<Widget>.generate(10, (int index) {
                                    return Center(
                                      child: Text(
                                        '$index',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: index == _selectedDecimal 
                                              ? FontWeight.bold 
                                              : FontWeight.normal,
                                          color: index == _selectedDecimal
                                              ? primaryColor
                                              : Colors.black87,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            
                            // Indication kg
                            const Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'kg',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Conseils en bas
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Votre poids aide à personnaliser votre expérience',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
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
      // Enregistrer le poids sélectionné
      final String formattedWeight = '$_selectedWeight,$_selectedDecimal';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Poids choisi : $formattedWeight kg')),
      );
      // Navigation vers la page d'aide professionnelle
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HelpPage(),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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