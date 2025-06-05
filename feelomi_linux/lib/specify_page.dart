import 'package:feelomi_linux/sleeping_page.dart';
import 'package:flutter/material.dart';

class SpecifyPage extends StatefulWidget {
  final String medicType;
  
  const SpecifyPage({super.key, required this.medicType});

  @override
  State<SpecifyPage> createState() => _SpecifyPageState();
}

class _SpecifyPageState extends State<SpecifyPage> {
  // Contrôleur pour le champ de texte
  final TextEditingController _medicController = TextEditingController();
  
  // État de l'enregistrement vocal
  bool _isRecording = false;
  
  // Méthode pour simuler un enregistrement vocal
  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    // Simulation d'enregistrement vocal
    if (_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enregistrement en cours...')),
      );
      
      // Après 3 secondes, annule l'enregistrement
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isRecording = false;
          });
          
          // Supposons qu'on a reconnu un médicament
          _medicController.text += _medicController.text.isEmpty 
              ? 'Doliprane 1000mg'
              : ', Doliprane 1000mg';
        }
      });
    }
  }

  @override
  void dispose() {
    _medicController.dispose();
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
                          // Action pour passer l'étape
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Étape ignorée')),
                          );
                          // Navigation vers la page finale
                          Navigator.pop(context);
                          // Ici on pourrait naviguer vers une page finale
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
                        child: Icon(
                          medicIcon,
                          size: 40,
                          color: medicColor,
                        ),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TextField(
                                      controller: _medicController,
                                      decoration: InputDecoration(
                                        hintText: placeholderText,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      maxLines: 3,
                                      minLines: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isRecording ? Colors.red : primaryColor,
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
                                          .map((med) => Chip(
                                            backgroundColor: medicColor.withOpacity(0.2),
                                            labelStyle: TextStyle(
                                              color: medicColor,
                                              fontSize: 14,
                                            ),
                                            label: Text(med),
                                            deleteIconColor: medicColor,
                                            onDeleted: () {
                                              // Supprimer ce médicament de la liste
                                              setState(() {
                                                List<String> meds = _medicController.text
                                                    .split(',')
                                                    .map((m) => m.trim())
                                                    .where((m) => m.isNotEmpty && m != med)
                                                    .toList();
                                                _medicController.text = meds.join(', ');
                                              });
                                            },
                                          ))
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            meds.isEmpty
                                ? 'Aucun médicament spécifié'
                                : 'Médicaments enregistrés: $meds',
                          ),
                        ),
                      );
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