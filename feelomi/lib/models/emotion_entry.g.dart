// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionData _$EmotionDataFromJson(Map<String, dynamic> json) => EmotionData(
      primary: json['primary'] as String,
      secondary: json['secondary'] as String?,
      intensity: (json['intensity'] as num).toInt(),
    );

Map<String, dynamic> _$EmotionDataToJson(EmotionData instance) =>
    <String, dynamic>{
      'primary': instance.primary,
      'secondary': instance.secondary,
      'intensity': instance.intensity,
    };

ContextData _$ContextDataFromJson(Map<String, dynamic> json) => ContextData(
      location: ContextData._geoPointFromJson(
          json['location'] as Map<String, dynamic>?),
      weather: json['weather'] as String?,
      activity: json['activity'] as String?,
      socialContext: json['socialContext'] as String?,
    );

Map<String, dynamic> _$ContextDataToJson(ContextData instance) =>
    <String, dynamic>{
      'location': ContextData._geoPointToJson(instance.location),
      'weather': instance.weather,
      'activity': instance.activity,
      'socialContext': instance.socialContext,
    };

EmotionEntry _$EmotionEntryFromJson(Map<String, dynamic> json) => EmotionEntry(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      timestamp: EmotionEntry._timestampFromJson(json['timestamp']),
      emotion: EmotionData.fromJson(json['emotion'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      triggers: (json['triggers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contextData: json['contextData'] == null
          ? null
          : ContextData.fromJson(json['contextData'] as Map<String, dynamic>),
      associatedHabits: (json['associatedHabits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EmotionEntryToJson(EmotionEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'timestamp': EmotionEntry._timestampToJson(instance.timestamp),
      'emotion': instance.emotion.toJson(),
      'notes': instance.notes,
      'triggers': instance.triggers,
      'contextData': instance.contextData?.toJson(),
      'associatedHabits': instance.associatedHabits,
    };
