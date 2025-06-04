import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../../providers/emotion_provider.dart';
import '../../models/emotion_entry.dart';
import '../../widgets/analytics/time_range_selector.dart';
import '../../widgets/common/custom_app_bar.dart';

class ColorUtils {
  static Color getColorForEmotion(String emotion) {
    final Map<String, Color> colors = {
      'Joie': Colors.yellow.shade600,
      'Contentement': Colors.green.shade400,
      'Enthousiasme': Colors.orange.shade400,
      'Fierté': Colors.amber.shade700,
      'Amour': Colors.pink.shade400,
      'Gratitude': Colors.teal.shade400,
      'Tristesse': Colors.blue.shade700,
      'Peur': Colors.purple.shade700,
      'Colère': Colors.red.shade700,
      'Anxiété': Colors.indigo.shade600,
      'Frustration': Colors.deepOrange.shade700,
      'Honte': Colors.brown.shade600,
      'Surprise': Colors.cyan.shade600,
      'Curiosité': Colors.lightBlue.shade400,
      'Confusion': Colors.blueGrey.shade500,
      'Calme': Colors.lightBlue.shade200,
      'Ennui': Colors.grey.shade500,
      'Fatigue': Colors.grey.shade700,
    };
    
    return colors[emotion] ?? Colors.grey;
  }
  
  static Color getTextColorForBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _selectedTimeRange;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = true;
  List<EmotionEntry> _filteredEmotions = [];
  
  // Data structures for analytics
  Map<String, int> _emotionCounts = {};
  Map<String, double> _emotionIntensities = {};
  Map<String, int> _triggerCounts = {};
  List<BarChartGroupData> _weekdayData = [];
  List<FlSpot> _trendData = [];
  
  final List<String> _timeRanges = ['7 jours', '30 jours', '90 jours', '1 an', 'Personnalisé'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedTimeRange = _timeRanges[0];
    _setDateRange();
    _loadData();
    
    // Add listener for tab changes
    _tabController.addListener(() {
      HapticFeedback.selectionClick();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _setDateRange() {
    final now = DateTime.now();
    
    switch (_selectedTimeRange) {
      case '7 jours':
        _startDate = now.subtract(const Duration(days: 7));
        break;
      case '30 jours':
        _startDate = now.subtract(const Duration(days: 30));
        break;
      case '90 jours':
        _startDate = now.subtract(const Duration(days: 90));
        break;
      case '1 an':
        _startDate = now.subtract(const Duration(days: 365));
        break;
      case 'Personnalisé':
        // Keep existing dates if already set for custom range
        if (_selectedTimeRange != 'Personnalisé') {
          _startDate = now.subtract(const Duration(days: 30));
        }
        _showCustomDateRangePicker();
        break;
    }
    
    _endDate = now;
  }
  
  void _showCustomDateRangePicker() async {
    final initialDateRange = DateTimeRange(
      start: _startDate,
      end: _endDate,
    );
    
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
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
    
    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
        _loadData();
      });
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
      await emotionProvider.fetchEmotionsForDateRange(_startDate, _endDate);
      
      _filteredEmotions = emotionProvider.emotions.where((entry) {
        return entry.timestamp.isAfter(_startDate) && 
               entry.timestamp.isBefore(_endDate.add(const Duration(days: 1)));
      }).toList();
      
      _processData();
      
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
  
  void _processData() {
    // Reset all data structures
    _emotionCounts = {};
    _emotionIntensities = {};
    _triggerCounts = {};
    _weekdayData = List.generate(7, (index) => BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: 0,
          color: Theme.of(context).colorScheme.primary,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        )
      ],
    ));
    
    // Group by day for trend line
    final dailyEmotions = <DateTime, List<EmotionEntry>>{};
    
    for (final entry in _filteredEmotions) {
      // Count emotions
      final primaryEmotion = entry.emotion.primary;
      _emotionCounts[primaryEmotion] = (_emotionCounts[primaryEmotion] ?? 0) + 1;
      
      // Average intensities
      _emotionIntensities[primaryEmotion] = (_emotionIntensities[primaryEmotion] ?? 0) + entry.emotion.intensity;
      
      // Count triggers
      for (final trigger in entry.triggers) {
        _triggerCounts[trigger] = (_triggerCounts[trigger] ?? 0) + 1;
      }
      
      // Weekday data
      final weekday = entry.timestamp.weekday % 7; // 0 = Sunday
      final currentY = _weekdayData[weekday].barRods[0].toY;
      _weekdayData[weekday] = BarChartGroupData(
        x: weekday,
        barRods: [
          BarChartRodData(
            toY: currentY + 1,
            color: Theme.of(context).colorScheme.primary,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          )
        ],
      );
      
      // Group by day for trend line
      final dateOnly = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
      if (!dailyEmotions.containsKey(dateOnly)) {
        dailyEmotions[dateOnly] = [];
      }
      dailyEmotions[dateOnly]!.add(entry);
    }
    
    // Calculate average intensity per emotion
    for (final emotion in _emotionIntensities.keys) {
      _emotionIntensities[emotion] = _emotionIntensities[emotion]! / _emotionCounts[emotion]!;
    }
    
    // Create trend line data
    _trendData = [];
    final dateList = dailyEmotions.keys.toList()..sort();
    
    for (final date in dateList) {
      final entries = dailyEmotions[date]!;
      double avgIntensity = 0;
      for (final entry in entries) {
        avgIntensity += entry.emotion.intensity;
      }
      avgIntensity /= entries.length;
      
      final daysSinceStart = date.difference(_startDate).inDays.toDouble();
      _trendData.add(FlSpot(daysSinceStart, avgIntensity));
    }
  }
  
  void _changeTimeRange(String newRange) {
    setState(() {
      _selectedTimeRange = newRange;
      _setDateRange();
      _loadData();
    });
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Analyse de vos données...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Pas assez de données',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Enregistrez vos émotions régulièrement pour voir apparaître des analyses personnalisées.',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/emotion-tracking'),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une émotion'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    if (_filteredEmotions.isEmpty) return _buildEmptyState();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EmotionChartCard(
          title: 'Tendance d\'intensité émotionnelle',
          subtitle: 'Évolution de l\'intensité moyenne',
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final days = value.toInt();
                      final date = _startDate.add(Duration(days: days));
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('d/M').format(date),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                    interval: _getIntervalForDateRange(),
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                  left: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              minX: 0,
              maxX: _endDate.difference(_startDate).inDays.toDouble(),
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: _trendData,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: _trendData.length < 30),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        EmotionChartCard(
          title: 'Distribution par jour de la semaine',
          subtitle: 'Nombre d\'enregistrements par jour',
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final weekdays = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
                    return BarTooltipItem(
                      '${weekdays[group.x]} : ${rod.toY.toInt()}',
                      TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final weekdays = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];
                      return Text(
                        weekdays[value.toInt()],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _weekdayData,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        TriggerAnalysisCard(triggerCounts: _triggerCounts),
        
        const SizedBox(height: 16),
        
        HabitCorrelationCard(),
      ],
    );
  }
  
  Widget _buildEmotionsTab() {
    if (_filteredEmotions.isEmpty) return _buildEmptyState();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EmotionBreakdownCard(
          emotionCounts: _emotionCounts,
          emotionIntensities: _emotionIntensities,
        ),
        
        const SizedBox(height: 16),
        
        EmotionChartCard(
          title: 'Journal de vos émotions',
          subtitle: 'Entrées émotionnelles récentes',
          height: 400,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _filteredEmotions.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final entry = _filteredEmotions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: ColorUtils.getColorForEmotion(entry.emotion.primary),
                  child: Text(
                    entry.emotion.primary.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: ColorUtils.getTextColorForBackground(
                        ColorUtils.getColorForEmotion(entry.emotion.primary)
                      ),
                    ),
                  ),
                ),
                title: Text(entry.emotion.primary),
                subtitle: Text(
                  entry.notes?.isNotEmpty == true ? entry.notes! : 'Intensité: ${entry.emotion.intensity}/10',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  DateFormat('dd/MM/yy HH:mm').format(entry.timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  // Navigate to detail view
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildInsightsTab() {
    if (_filteredEmotions.isEmpty) return _buildEmptyState();
    
    // IA-powered insights would go here
    // This is a placeholder for more advanced analytics
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline),
                    const SizedBox(width: 8),
                    Text(
                      'Insights personnalisés',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.insights, color: Colors.white),
                  ),
                  title: Text('Tendance positive détectée'),
                  subtitle: Text('Votre bien-être émotionnel s\'est amélioré de 15% cette semaine'),
                ),
                const Divider(),
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.water_drop_outlined, color: Colors.white),
                  ),
                  title: Text('Corrélation habitude détectée'),
                  subtitle: Text('Dormir 7h+ semble réduire votre niveau d\'anxiété'),
                ),
                const Divider(),
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.psychology_outlined, color: Colors.white),
                  ),
                  title: Text('Déclencheur fréquent'),
                  subtitle: Text('Le travail est associé à 65% de vos moments de stress'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_objects_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Recommandations personnalisées',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Essayez la méditation',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '5 minutes chaque matin pourraient réduire votre anxiété',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Plus d\'activité physique',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Les jours où vous êtes actif montrent une amélioration de 30% de votre humeur',
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
        ),
      ],
    );
  }
  
  double _calculateMaxY() {
    double maxY = 1; // Default minimum
    for (final data in _weekdayData) {
      if (data.barRods.isNotEmpty && data.barRods[0].toY > maxY) {
        maxY = data.barRods[0].toY;
      }
    }
    return maxY + (maxY * 0.1); // Add 10% padding
  }
  
  double _getIntervalForDateRange() {
    final days = _endDate.difference(_startDate).inDays;
    if (days <= 7) return 1;
    if (days <= 14) return 2;
    if (days <= 30) return 5;
    if (days <= 90) return 15;
    return 30;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Analyse de vos émotions',
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Export or share analytics functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TimeRangeSelector(
            selectedRange: _selectedTimeRange,
            availableRanges: _timeRanges,
            onRangeChanged: _changeTimeRange,
            onRangeSelected: (start, end) {
              setState(() {
                _startDate = start;
                _endDate = end;
                _loadData();
              });
            },
          ),
          
          // Date range display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Du ${DateFormat('d MMM', 'fr_FR').format(_startDate)} au ${DateFormat('d MMM yyyy', 'fr_FR').format(_endDate)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            tabs: const [
              Tab(text: 'Tendances'),
              Tab(text: 'Émotions'),
              Tab(text: 'Insights'),
            ],
          ),
          
          Expanded(
            child: _isLoading
                ? _buildLoadingIndicator()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTrendsTab(),
                      _buildEmotionsTab(),
                      _buildInsightsTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class TriggerAnalysisCard extends StatelessWidget {
  final Map<String, int> triggerCounts;
  
  const TriggerAnalysisCard({Key? key, required this.triggerCounts}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final sortedTriggers = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analyse des déclencheurs', 
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (sortedTriggers.isEmpty)
              const Center(child: Text('Aucun déclencheur identifié'))
            else
              Column(
                children: sortedTriggers.take(5).map((entry) {
                  final percent = entry.value / sortedTriggers.map((e) => e.value).reduce((a, b) => a + b) * 100;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(entry.key, overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: entry.value / (sortedTriggers[0].value * 1.2),
                                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                color: Theme.of(context).colorScheme.primary,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${entry.value} fois (${percent.toStringAsFixed(1)}%)',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class HabitCorrelationCard extends StatelessWidget {
  const HabitCorrelationCard({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Corrélation avec les habitudes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.query_stats_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Données insuffisantes', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('Suivez vos habitudes pour voir leurs effets sur vos émotions',
                      style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmotionChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final Widget child;
  
  const EmotionChartCard({
    Key? key, 
    required this.title, 
    required this.subtitle, 
    required this.height, 
    required this.child
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          SizedBox(
            height: height,
            child: child,
          ),
        ],
      ),
    );
  }
}

class EmotionBreakdownCard extends StatelessWidget {
  final Map<String, int> emotionCounts;
  final Map<String, double> emotionIntensities;
  
  const EmotionBreakdownCard({
    Key? key, 
    required this.emotionCounts, 
    required this.emotionIntensities
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final sortedEmotions = emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Répartition des émotions', 
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (sortedEmotions.isEmpty)
              const Center(child: Text('Aucune émotion enregistrée'))
            else
              Column(
                children: sortedEmotions.take(5).map((entry) {
                  final percent = entry.value / sortedEmotions.map((e) => e.value).reduce((a, b) => a + b) * 100;
                  final intensity = emotionIntensities[entry.key]?.toStringAsFixed(1) ?? '0';
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: ColorUtils.getColorForEmotion(entry.key),
                          child: Text(
                            entry.key.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: ColorUtils.getTextColorForBackground(
                                ColorUtils.getColorForEmotion(entry.key)
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.key, overflow: TextOverflow.ellipsis),
                              Text(
                                '${entry.value} fois (${percent.toStringAsFixed(1)}%)',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.speed, size: 14),
                                  const SizedBox(width: 4),
                                  Text('Intensité: $intensity/10'),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: double.parse(intensity) / 10,
                                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                color: ColorUtils.getColorForEmotion(entry.key),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

extension on EmotionProvider {
  Future<void> fetchEmotionsForDateRange(DateTime startDate, DateTime endDate) async {
    // Cette méthode sera implémentée dans votre EmotionProvider
    // Pour le moment, on utilise une implémentation vide pour résoudre l'erreur
    await Future.delayed(const Duration(milliseconds: 300));
  }
  
  List<EmotionEntry> get emotions {
    // Cette propriété sera implémentée dans votre EmotionProvider
    // Pour le moment, on retourne une liste vide pour résoudre l'erreur
    return [];
  }
}