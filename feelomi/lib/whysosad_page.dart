import 'package:flutter/material.dart';

class WhySoSadPage extends StatefulWidget {
  @override
  _WhySoSadPageState createState() => _WhySoSadPageState();
}

class _WhySoSadPageState extends State<WhySoSadPage> {
  double activityLevel = 5.0;
  double eatingLevel = 5.0;
  double sleepLevel = 5.0;
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // Header avec titre et settings
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Bouton retour
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              // Titre violet
                              Text(
                                "Partage d'humeur",
                                style: TextStyle(
                                  color: Color(0xFF8B5CF6),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              // Image sad.png
                              Image.asset(
                                'assets/images/sad.png',
                                width: 80,
                                height: 80,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Icon(
                                      Icons.sentiment_very_dissatisfied,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Icône Settings
                        IconButton(
                          onPressed: () {
                            // Navigation vers page settings (à créer)
                            print("Naviguer vers settings");
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contenu principal
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

                        // Titre question
                        Center(
                          child: Text(
                            "Pourquoi vous sentez vous triste ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: 40),

                        // Premier curseur - Activité
                        _buildSliderSection(
                          "Sur une échelle de 1 à 10, comment es-tu actif",
                          activityLevel,
                          (value) {
                            setState(() {
                              activityLevel = value;
                            });
                          },
                        ),

                        SizedBox(height: 30),

                        // Deuxième curseur - Alimentation
                        _buildSliderSection(
                          "Sur une échelle de 1 à 10, as-tu bien mangé ?",
                          eatingLevel,
                          (value) {
                            setState(() {
                              eatingLevel = value;
                            });
                          },
                        ),

                        SizedBox(height: 30),

                        // Troisième curseur - Sommeil
                        _buildSliderSection(
                          "Comment était ton sommeil ?",
                          sleepLevel,
                          (value) {
                            setState(() {
                              sleepLevel = value;
                            });
                          },
                        ),

                        SizedBox(height: 40),

                        // Zone de texte Notes
                        Text(
                          "Notes supplémentaires",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 15),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: notesController,
                            maxLines: 4,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Ajouter des notes...",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(15),
                            ),
                          ),
                        ),

                        SizedBox(height: 50),

                        // Bouton Continuer
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigation vers la page suivante
                              print("Activité: ${activityLevel.round()}");
                              print("Alimentation: ${eatingLevel.round()}");
                              print("Sommeil: ${sleepLevel.round()}");
                              print("Notes: ${notesController.text}");
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 6,
                            ),
                            child: Text(
                              "Continuer",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderSection(
    String question,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: value,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: onChanged,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${value.round()}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "10",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
