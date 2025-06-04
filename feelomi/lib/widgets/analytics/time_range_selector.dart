import 'package:flutter/material.dart';

enum TimeRange {
  day,
  week,
  month,
  year,
  custom
}

class TimeRangeSelector extends StatefulWidget {
  final Function(DateTime start, DateTime end) onRangeSelected;
  final TimeRange initialRange;
  final Color? activeColor;
  final Color? inactiveColor;
  final TextStyle? labelStyle;

  const TimeRangeSelector({
    Key? key,
    required this.onRangeSelected,
    this.initialRange = TimeRange.week,
    this.activeColor,
    this.inactiveColor,
    this.labelStyle, required String selectedRange, required List<String> availableRanges, required void Function(String newRange) onRangeChanged,
  }) : super(key: key);

  @override
  State<TimeRangeSelector> createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  late TimeRange _selectedRange;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
    _updateDateRange();
  }

  void _updateDateRange() {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (_selectedRange) {
      case TimeRange.day:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = now;
        break;
      case TimeRange.week:
        startDate = now.subtract(Duration(days: 7));
        endDate = now;
        break;
      case TimeRange.month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        endDate = now;
        break;
      case TimeRange.year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        endDate = now;
        break;
      case TimeRange.custom:
        if (_customStartDate != null && _customEndDate != null) {
          startDate = _customStartDate!;
          endDate = _customEndDate!;
        } else {
          startDate = now.subtract(const Duration(days: 7));
          endDate = now;
        }
        break;
    }

    widget.onRangeSelected(startDate, endDate);
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _customStartDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end: _customEndDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _selectedRange = TimeRange.custom;
      });
      _updateDateRange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRangeButton('Day', TimeRange.day),
            const SizedBox(width: 8),
            _buildRangeButton('Week', TimeRange.week),
            const SizedBox(width: 8),
            _buildRangeButton('Month', TimeRange.month),
            const SizedBox(width: 8),
            _buildRangeButton('Year', TimeRange.year),
            const SizedBox(width: 8),
            _buildCustomRangeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeButton(String label, TimeRange range) {
    final isSelected = _selectedRange == range;
    final activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final inactiveColor = widget.inactiveColor ?? Colors.grey;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? activeColor : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : inactiveColor,
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? activeColor : inactiveColor,
            width: 1,
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedRange = range;
        });
        _updateDateRange();
      },
      child: Text(
        label,
        style: widget.labelStyle?.copyWith(
          color: isSelected ? Colors.white : inactiveColor,
        ) ?? TextStyle(
          color: isSelected ? Colors.white : inactiveColor,
        ),
      ),
    );
  }

  Widget _buildCustomRangeButton() {
    final isSelected = _selectedRange == TimeRange.custom;
    final activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final inactiveColor = widget.inactiveColor ?? Colors.grey;

    String buttonText = 'Custom';
    if (_customStartDate != null && _customEndDate != null) {
      buttonText = '${_formatDate(_customStartDate!)} - ${_formatDate(_customEndDate!)}';
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? activeColor : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : inactiveColor,
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? activeColor : inactiveColor,
            width: 1,
          ),
        ),
      ),
      onPressed: _showDateRangePicker,
      child: Text(
        buttonText,
        style: widget.labelStyle?.copyWith(
          color: isSelected ? Colors.white : inactiveColor,
        ) ?? TextStyle(
          color: isSelected ? Colors.white : inactiveColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}