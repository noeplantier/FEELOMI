import 'dart:io';
import 'package:feelomi/humor_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as charts;
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final Color primaryColor = const Color(0xFF8B5CF6);
final Color lightPurple = const Color(0x8B5CF6);

class _ProfilePageState extends State<ProfilePage> {
  String? _profileImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24.0),
                _buildSearchBar(),
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HumorPage()),
                    );
                  },
                  child: Text(
                    "Comment te sens-tu aujourd'hui ?",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildFeelingCard(),
                const SizedBox(height: 24.0),
                _buildMentalHealthMetrics(),
                const SizedBox(height: 24.0),
                _buildFeeloAICard(),
                const SizedBox(height: 24.0),
                _buildHealthProfessionalsTitle(),
                const SizedBox(height: 16.0),
                SizedBox(height: 300, child: _buildHealthProfessionalsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _pickProfileImage,
          child: CircleAvatar(
            radius: 30.0,
            backgroundImage: _profileImagePath != null
                ? FileImage(File(_profileImagePath!))
                : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
            backgroundColor: Colors.grey[300],
            child: _profileImagePath == null
                ? Icon(Icons.add_a_photo, color: Colors.grey[600])
                : null,
          ),
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 30.0),
              onPressed: () {
                // Action quand on clique sur la cloche de notification
              },
            ),
            Container(
              width: 10.0,
              height: 10.0,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Recherche n'importe quoi",
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildFeelingCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/thinking.png', width: 80.0, height: 80.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 8.0),
                Text(
                  "Comment te sens-tu aujourd'hui ?",
                  style: TextStyle(fontSize: 17.0, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentalHealthMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Métriques de santé mentale",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(child: _buildStressCard()),
            const SizedBox(width: 16.0),
            Expanded(child: _buildSleepCard()),
          ],
        ),
        const SizedBox(height: 16.0),
        _buildMentalHealthChart(_DummyUserData()),
      ],
    );
  }

  Widget _buildStressCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stress",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            "Niveau actuel",
            style: TextStyle(
              fontSize: 14.0,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 16.0),
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.orange[100],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              const Text("70%", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sommeil",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 147, 30, 173),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            "Qualité",
            style: TextStyle(fontSize: 14.0, color: Colors.black54),
          ),
          const SizedBox(height: 16.0),
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 0.5,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const Text("50%", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMentalHealthChart(dynamic userData) {
    final data = [
      _MentalHealthData('Lun', 60, 40),
      _MentalHealthData('Mar', 70, 50),
      _MentalHealthData('Mer', 80, 60),
      _MentalHealthData('Jeu', 65, 55),
      _MentalHealthData('Ven', 75, 70),
      _MentalHealthData('Sam', 50, 80),
      _MentalHealthData('Dim', 40, 90),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateTime.now().toString().split(' ')[0],
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Salut Enzo',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Évolution hebdomadaire",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: charts.BarChart(
                    charts.BarChartData(
                      barGroups: [
                        // Créer des groupes de barres à partir de vos données
                        for (int i = 0; i < data.length; i++)
                          charts.BarChartGroupData(
                            x: i,
                            barRods: [
                              charts.BarChartRodData(
                                toY: data[i].stress.toDouble(),
                                color: const Color(0xFFFF9800), // Orange
                                width: 15,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                              charts.BarChartRodData(
                                toY: data[i].sleep.toDouble(),
                                color: const Color(0xFF2196F3), // Bleu
                                width: 15,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          ),
                      ],
                      titlesData: charts.FlTitlesData(
                        bottomTitles: charts.AxisTitles(
                          sideTitles: charts.SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(data[value.toInt()].day),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeloAICard() {
    return InkWell(
      onTap: () {
        // Action pour ouvrir la discussion avec Feelo.AI
        _openFeeloAIChat();
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.purple[50],
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.purple.shade200),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/hello.png', width: 80.0, height: 80.0),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Discutes avec Feelo.AI",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Une IA super performante pour t'accompagner",
                    style: TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: Colors.purple[400],
            ),
          ],
        ),
      ),
    );
  }

  void _openFeeloAIChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/hello.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        "Feelo.AI",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: const [
                  _AIMessageBubble(
                    message:
                        "Bonjour ! Je suis Feelo.AI. Comment puis-je t'aider aujourd'hui ?",
                    isUser: false,
                  ),
                  SizedBox(height: 16.0),
                  _AIMessageBubble(
                    message: "J'aimerais parler de mon stress au travail",
                    isUser: true,
                  ),
                  SizedBox(height: 16.0),
                  _AIMessageBubble(
                    message:
                        "Je comprends. Le stress au travail est très commun. Pourrais-tu me décrire ce qui te stresse particulièrement ?",
                    isUser: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Écris ton message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        // Envoyer le message
                      },
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

  Widget _buildHealthProfessionalsTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Professionnels de santé",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            // Action pour voir tous les professionnels
          },
          child: const Text("Voir tous"),
        ),
      ],
    );
  }

  Widget _buildHealthProfessionalsList() {
    final professionals = [
      {
        'name': 'Dr. Sophie Martin',
        'specialty': 'Psychologue',
        'rating': 4.8,
        'image': 'assets/images/profile.png',
        'distance': '2.5 km',
      },
      {
        'name': 'Dr. Jean Dupont',
        'specialty': 'Psychiatre',
        'rating': 4.5,
        'image': 'assets/images/profile.png',
        'distance': '3.8 km',
      },
      {
        'name': 'Dr. Marie Robert',
        'specialty': 'Thérapeute',
        'rating': 5.0,
        'image': 'assets/images/profile.png',
        'distance': '1.2 km',
      },
    ];

    return ListView.builder(
      itemCount: professionals.length,
      itemBuilder: (context, index) {
        final professional = professionals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage(professional['image'] as String),
            ),
            title: Text(
              professional['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                Text(professional['specialty'] as String),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    _buildRatingStars(professional['rating'] as double),
                    const SizedBox(width: 8.0),
                    Text('${professional['rating']}'),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  'À ${professional['distance']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Action pour contacter le professionnel
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Contacter'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16.0);
        } else if (index == rating.floor() && rating % 1 > 0) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16.0);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16.0);
        }
      }),
    );
  }
}

class Series {}

class _MentalHealthData {
  final String day;
  final int stress;
  final int sleep;

  _MentalHealthData(this.day, this.stress, this.sleep);
}

class _DummyUserData {
  final String firstName = 'User';
}

class _AIMessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const _AIMessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!isUser)
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.purple[100],
            child: Image.asset(
              'assets/images/hello.png',
              width: 20,
              height: 20,
            ),
          ),
        const SizedBox(width: 8.0),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isUser ? Colors.purple[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isUser ? Colors.purple[900] : Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        if (isUser)
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
      ],
    );
  }
}
