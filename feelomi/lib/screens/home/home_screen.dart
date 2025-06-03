import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/emotion_provider.dart';
import '../../utils/routes.dart';
import '../../widgets/home/emotion_summary_card.dart';
import '../../widgets/home/habit_tracker_widget.dart';
import '../../widgets/home/wellbeing_content_list.dart';
import '../../widgets/home/quick_action_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../models/emotion_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<void> _initDataFuture;

  @override
  void initState() {
    super.initState();
    _initDataFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
    await emotionProvider.fetchTodaysEmotion();
    await emotionProvider.fetchRecentEmotions();
    // Autres initialisations de données nécessaires
  }

  void _handleAddEmotion() {
    Navigator.pushNamed(context, Routes.emotionTracking)
      .then((_) => _refreshData());
  }

  void _refreshData() {
    setState(() {
      _initDataFuture = _loadInitialData();
    });
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    setState(() => _selectedIndex = index);
    
    switch (index) {
      case 1:
        Navigator.pushNamed(context, Routes.analytics);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.emotionTracking);
        break;
      case 4:
        Navigator.pushNamed(context, Routes.profile);
        break;
    }
  }

  Widget _buildGreeting() {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.currentUser?.displayName ?? 'à Feelomi';
    
    String greeting;
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Bonjour';
    } else if (hour < 18) {
      greeting = 'Bon après-midi';
    } else {
      greeting = 'Bonsoir';
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $username',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now()),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions rapides',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickActionButton(
                icon: Icons.add_reaction_outlined,
                label: 'Ajouter une émotion',
                color: Theme.of(context).colorScheme.primary,
                onTap: _handleAddEmotion,
              ),
              QuickActionButton(
                icon: Icons.checklist_rounded,
                label: 'Mes habitudes',
                color: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  // Navigation vers le suivi des habitudes
                },
              ),
              QuickActionButton(
                icon: Icons.support_agent_outlined,
                label: 'Consulter',
                color: Theme.of(context).colorScheme.tertiary,
                onTap: () {
                  // Navigation vers les consultations
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyEmotionCard() {
    final emotionProvider = Provider.of<EmotionProvider>(context);
    final todaysEmotion = emotionProvider.todaysEmotion;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Votre humeur aujourd\'hui',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          todaysEmotion != null
              ? EmotionSummaryCard(emotion: todaysEmotion)
              : _buildNoEmotionCard(),
        ],
      ),
    );
  }

  Widget _buildNoEmotionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.mood_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Vous n\'avez pas encore enregistré votre humeur aujourd\'hui',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleAddEmotion,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Ajouter mon humeur'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitTracker() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suivi de vos habitudes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          HabitTrackerWidget(),
        ],
      ),
    );
  }

  Widget _buildWellbeingContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contenus recommandés',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          WellbeingContentList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Image.asset('assets/images/logo_horizontal.png', height: 30),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Afficher les notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: FutureBuilder(
          future: _initDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                _buildGreeting(),
                _buildQuickActions(),
                _buildDailyEmotionCard(),
                _buildHabitTracker(),
                _buildWellbeingContent(),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            activeIcon: Icon(Icons.insert_chart),
            label: 'Analyses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 30),
            activeIcon: Icon(Icons.add_circle, size: 30),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}