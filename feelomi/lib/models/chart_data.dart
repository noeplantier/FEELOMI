import 'package:flutter/material.dart';

class ChartData {
  final double x;
  final double y;
  final String label;
  final Color? color;

  const ChartData({
    required this.x,
    required this.y,
    required this.label,
    this.color,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      x: json['x']?.toDouble() ?? 0.0,
      y: json['y']?.toDouble() ?? 0.0,
      label: json['label'] ?? '',
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'label': label,
    'color': color?.value,
  };
}

class PieChartData {
  final double value;
  final String category;
  final Color color;
  final String? label;

  const PieChartData({
    required this.value,
    required this.category,
    required this.color,
    this.label,
  });

  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      value: json['value']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      color: Color(json['color'] ?? 0xFF000000),
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() => {
    'value': value,
    'category': category,
    'color': color.value,
    'label': label,
  };
}

class TimeSeriesData {
  final DateTime timestamp;
  final double value;
  final String? annotation;
  final Color? color;

  const TimeSeriesData({
    required this.timestamp,
    required this.value,
    this.annotation,
    this.color,
  });

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) {
    return TimeSeriesData(
      timestamp: DateTime.parse(json['timestamp']),
      value: json['value']?.toDouble() ?? 0.0,
      annotation: json['annotation'],
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'value': value,
    'annotation': annotation,
    'color': color?.value,
  };
}

class ChartDataSet {
  final List<ChartData> data;
  final String title;
  final Color? seriesColor;
  final bool? showTrendline;

  const ChartDataSet({
    required this.data,
    required this.title,
    this.seriesColor,
    this.showTrendline,
  });

  factory ChartDataSet.fromJson(Map<String, dynamic> json) {
    return ChartDataSet(
      data: (json['data'] as List?)
          ?.map((e) => ChartData.fromJson(e))
          .toList() ?? [],
      title: json['title'] ?? '',
      seriesColor: json['seriesColor'] != null 
          ? Color(json['seriesColor']) 
          : null,
      showTrendline: json['showTrendline'],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'title': title,
    'seriesColor': seriesColor?.value,
    'showTrendline': showTrendline,
  };
}