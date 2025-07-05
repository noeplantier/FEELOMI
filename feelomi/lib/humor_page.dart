import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'howifeel_page.dart';

class HumorPage extends StatefulWidget {
  @override
  _HumorPageState createState() => _HumorPageState();
}

class _HumorPageState extends State<HumorPage> {
  String currentMood = "😊";
  List<Map<String, dynamic>> weekMoods = [
    {"day": "Lun", "mood": "😊", "value": 4},
    {"day": "Mar", "mood": "😐", "value": 3},
    {"day": "Mer", "mood": "😢", "value": 2},
    {"day": "Jeu", "mood": "😊", "value": 4},
    {"day": "Ven", "mood": "😍", "value": 5},
    {"day": "Sam", "mood": "😊", "value": 4},
    {"day": "Dim", "mood": "😐", "value": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section violette du haut
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Header avec Feelo et icône settings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          // Personnage Feelo
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text("🤖", style: TextStyle(fontSize: 30)),
                            ),
                          ),
                          // Icône Settings
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      // Titre
                      Text(
                        "Mon Humeur",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Humeur actuelle
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Aujourd'hui",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(currentMood, style: TextStyle(fontSize: 60)),
                              Text(
                                _getMoodText(currentMood),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bouton + central
            Transform.translate(
              offset: Offset(0, -25),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HowIFeelPage()),
                  );
                },
                backgroundColor: Colors.white,
                child: Icon(Icons.add, color: Color(0xFF8B5CF6), size: 30),
                elevation: 8,
              ),
            ),
            // Section blanche du bas
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Cette semaine",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Graphique des humeurs
                  Expanded(child: _buildMoodChart()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodChart() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: weekMoods.map((dayMood) {
          return Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Barre verticale avec smiley
                AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  width: 30,
                  height: (dayMood["value"] as int) * 20.0,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFF8B5CF6).withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF8B5CF6).withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      dayMood["mood"],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Jour de la semaine
                Text(
                  dayMood["day"],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getMoodText(String mood) {
    switch (mood) {
      case "😢":
        return "Un peu triste";
      case "😐":
        return "Neutre";
      case "🙂":
        return "Ça va bien";
      case "😊":
        return "Je suis heureux";
      case "😍":
        return "C'est génial !";
      default:
        return "Bonne journée";
    }
  }
}
