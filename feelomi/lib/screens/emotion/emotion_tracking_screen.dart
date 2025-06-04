import 'package:feelomi/models/emotion_model.dart' as model;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/emotion_provider.dart';
import '../../models/emotion_entry.dart';

class EmotionTrackingScreen extends StatefulWidget {
  const EmotionTrackingScreen({Key? key}) : super(key: key);

  @override
  State<EmotionTrackingScreen> createState() => _EmotionTrackingScreenState();
}

class _EmotionTrackingScreenState extends State<EmotionTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  
  String _primaryEmotion = '';
  String? _secondaryEmotion;
  int _intensity = 5;
  List<String> _triggers = [];
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  
  // Liste d'émotions disponibles organisées par catégories
  final Map<String, List<String>> _emotionCategories = {
    'Positives': ['Joie', 'Contentement', 'Enthousiasme', 'Fierté', 'Amour', 'Gratitude'],
    'Négatives': ['Tristesse', 'Peur', 'Colère', 'Anxiété', 'Frustration', 'Honte'],
    'Neutres': ['Surprise', 'Curiosité', 'Confusion', 'Calme', 'Ennui', 'Fatigue']
  };
  
  // Liste des déclencheurs communs
  final List<String> _commonTriggers = [
    'Travail', 'Relations', 'Santé', 'Finances', 'Famille', 
    'Sommeil', 'Alimentation', 'Activité physique', 'Stress',
    'Médias sociaux', 'Actualités', 'Météo', 'Solitude'
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _selectEmotion(String emotion, bool isPrimary) {
    setState(() {
      if (isPrimary) {
        _primaryEmotion = emotion;
        // Réinitialisation de l'émotion secondaire si identique à la primaire
        if (_secondaryEmotion == emotion) {
          _secondaryEmotion = null;
        }
      } else {
        _secondaryEmotion = emotion == _primaryEmotion ? null : emotion;
      }
    });
  }

  void _updateIntensity(int intensity) {
    setState(() {
      _intensity = intensity;
    });
  }

  void _toggleTrigger(String trigger) {
    setState(() {
      if (_triggers.contains(trigger)) {
        _triggers.remove(trigger);
      } else {
        _triggers.add(trigger);
      }
    });
  }

  void _addCustomTrigger(String trigger) {
    if (trigger.isNotEmpty && !_triggers.contains(trigger)) {
      setState(() {
        _triggers.add(trigger);
      });
    }
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveEmotionEntry() async {
    if (_primaryEmotion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une émotion primaire')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final emotionEntry = EmotionEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: _selectedDate,
        emotion: EmotionData(
          primary: _primaryEmotion,
          secondary: _secondaryEmotion,
          intensity: _intensity,
        ),
        notes: _notesController.text,
        triggers: _triggers,
      );

      await Provider.of<EmotionProvider>(context, listen: false).saveEmotionEntry(emotionEntry as model.EmotionEntry);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Émotion enregistrée avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment vous sentez-vous ?'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Sélecteur de date
            _buildDateSelector(),
            const SizedBox(height: 24),
            
            // Section émotion primaire
            Text(
              'Émotion primaire',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
        
            
            const SizedBox(height: 24),
            
            // Section émotion secondaire (optionnelle)
            Text(
              'Émotion secondaire (optionnelle)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ressentez-vous une autre émotion en même temps ?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
  
            
            const SizedBox(height: 24),
            
            // Section intensité
            Text(
              'Intensité',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
     
            
            const SizedBox(height: 24),
            
            // Section déclencheurs
            Text(
              'Qu\'est-ce qui a déclenché cette émotion ?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
      
            const SizedBox(height: 24),
            
            // Section notes
            Text(
              'Notes (optionnel)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'Ajoutez des détails sur ce que vous ressentez...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 32),
          
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}