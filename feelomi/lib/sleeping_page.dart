import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qualité de sommeil'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSleepQualitySection(),
            _buildSleepDurationSection(),
            _buildFallingAsleepSection(),
            _buildAdditionalQuestionsSection(),
            _buildInfoCard(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comment as-tu dormi ?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tes réponses nous aideront à personnaliser ton expérience',
            style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualitySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Qualité du sommeil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: _sleepQualityOptions.map((quality) {
              return ChoiceChip(
                label: Text(quality),
                selected: _sleepQuality == quality,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _sleepQuality = quality;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepDurationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Durée du sommeil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: _sleepDurationOptions.map((duration) {
              return ChoiceChip(
                label: Text(duration),
                selected: _sleepDuration == duration,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _sleepDuration = duration;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFallingAsleepSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Temps pour s\'endormir',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: _fallingAsleepTimeOptions.map((time) {
              return ChoiceChip(
                label: Text(time),
                selected: _fallingAsleepTime == time,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _fallingAsleepTime = time;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalQuestionsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Problèmes supplémentaires',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            title: const Text('J\'ai des cauchemars'),
            value: _hasNightmares,
            onChanged: (value) {
              setState(() {
                _hasNightmares = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Je me réveille plusieurs fois dans la nuit'),
            value: _wakesUpDuringNight,
            onChanged: (value) {
              setState(() {
                _wakesUpDuringNight = value ?? false;
              });
            },
          ),
        ],
      ),
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

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          onPressed: () {
            // Enregistrer les réponses et naviguer à la page suivante
            Navigator.pop(context, {
              'sleepQuality': _sleepQuality,
              'sleepDuration': _sleepDuration,
              'fallingAsleepTime': _fallingAsleepTime,
              'hasNightmares': _hasNightmares,
              'wakesUpDuringNight': _wakesUpDuringNight,
            });
          },
          child: const Text(
            'Valider',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
