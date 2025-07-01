import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math' as math;

class CalendaryPage extends StatefulWidget {
  const CalendaryPage({super.key});
  @override
  State<CalendaryPage> createState() => _CalendaryPageState();
}

class _CalendaryPageState extends State<CalendaryPage> {
  final primaryColor = const Color.fromARGB(255, 150, 95, 186);
  final secondaryColor = const Color.fromARGB(255, 90, 0, 150);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Liste des images Feelo disponibles
  final List<String> feeloImages = [
    'assets/images/feelo_happy.png',
    'assets/images/feelo_sad.png',
    'assets/images/feelo_neutral.png',
    'assets/images/feelo_excited.png',
    'assets/images/feelo_tired.png',
  ];

  // Simulation de données d'humeur
  final Map<DateTime, String> _moodEvents = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCalendar(),
            const Spacer(),
            _buildToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Historique',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2024, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: primaryColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (_moodEvents.containsKey(date)) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    feeloImages[math.Random().nextInt(feeloImages.length)],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToolbarButton(Icons.settings, 'Paramètres', () {
            // Action paramètres
          }),
          _buildToolbarButton(Icons.add_circle, 'Ajouter', () {
            // Action ajouter
          }, isMain: true),
          _buildToolbarButton(Icons.edit, 'Modifier', () {
            // Action modifier
          }),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isMain = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMain ? primaryColor : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isMain ? Colors.white : primaryColor,
              size: isMain ? 32 : 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isMain ? primaryColor : Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour ajouter une humeur
  void _addMood(DateTime date, String mood) {
    setState(() {
      _moodEvents[date] = mood;
    });
  }
}
