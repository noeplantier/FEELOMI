import 'package:feelomi/mental_page.dart';
import 'package:flutter/material.dart';
import 'physical_page.dart'; // Assurez-vous d'importer la page suivante

class SleepingPage extends StatefulWidget {
  const SleepingPage({super.key});

  @override
  State<SleepingPage> createState() => _SleepingPageState();
}

class _SleepingPageState extends State<SleepingPage> {
  // Variables pour suivre les choix de l'utilisateur
  String _sleepQuality = 'Bien'; // Valeur par défaut pour éviter le null
  String _sleepDuration = '7-8 heures'; // Valeur par défaut pour éviter le null
  String _fallingAsleepTime =
      'Moins de 15 minutes'; // Valeur par défaut pour éviter le null
  bool _hasNightmares = false;
  bool _wakesUpDuringNight = false;

  // Listes d'options
  final List<String> _sleepQualityOptions = [
    'Très bien',
    'Bien',
    'Moyen',
    'Mauvais',
    'Très mauvais',
  ];
  final List<String> _sleepDurationOptions = [
    'Moins de 5 heures',
    '5-6 heures',
    '7-8 heures',
    '9+ heures',
  ];
  final List<String> _fallingAsleepTimeOptions = [
    'Moins de 15 minutes',
    '15-30 minutes',
    '30-60 minutes',
    '60+ minutes',
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barre chronologique en haut avec le bouton "Passer cette étape"
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
                                '9',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Qualité du sommeil',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigation vers la page suivante
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MentalPage(),
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
                    value:
                        0.75, // Ajustez selon la position dans votre workflow
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),

            // Contenu principal avec défilement
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSleepQualitySection(),
                    _buildSleepDurationSection(),
                    _buildFallingAsleepSection(),
                    _buildAdditionalQuestionsSection(),
                    _buildInfoCard(),
                  ],
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
                    // Navigation vers la page suivante
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhysicalPage(),
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

  // Le reste de vos méthodes de construction de widgets reste inchangé
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comment as-tu dormi ?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Dis-nous en plus sur ta qualité de sommeil pour personnaliser ton expérience.',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualitySection() {
    return _buildSection(
      title: 'Qualité du sommeil',
      content: Column(
        children: _sleepQualityOptions.map((option) {
          return _buildRadioOption(
            option,
            _sleepQuality,
            (value) => setState(() => _sleepQuality = value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSleepDurationSection() {
    return _buildSection(
      title: 'Durée du sommeil',
      content: Column(
        children: _sleepDurationOptions.map((option) {
          return _buildRadioOption(
            option,
            _sleepDuration,
            (value) => setState(() => _sleepDuration = value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFallingAsleepSection() {
    return _buildSection(
      title: 'Temps pour s\'endormir',
      content: Column(
        children: _fallingAsleepTimeOptions.map((option) {
          return _buildRadioOption(
            option,
            _fallingAsleepTime,
            (value) => setState(() => _fallingAsleepTime = value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdditionalQuestionsSection() {
    return _buildSection(
      title: 'Questions complémentaires',
      content: Column(
        children: [
          _buildSwitchOption(
            'As-tu fait des cauchemars ?',
            _hasNightmares,
            (value) => setState(() => _hasNightmares = value),
          ),
          const SizedBox(height: 16),
          _buildSwitchOption(
            'T\'es-tu réveillé(e) pendant la nuit ?',
            _wakesUpDuringNight,
            (value) => setState(() => _wakesUpDuringNight = value),
          ),
        ],
      ),
    );
  }

  // Helper methods for building UI components
  Widget _buildSection({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String text,
    String groupValue,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => onChanged(text),
        child: Row(
          children: [
            Radio<String>(
              value: text,
              groupValue: groupValue,
              onChanged: (value) => onChanged(value!),
              activeColor: Theme.of(context).primaryColor,
            ),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(String text, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Le saviez-vous ?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'Un bon sommeil est fondamental pour ta santé mentale. '
                            'Nous adapterons nos recommandations en fonction de ta qualité de sommeil.',
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
          ],
        ),
      ),
    );
  }
}
