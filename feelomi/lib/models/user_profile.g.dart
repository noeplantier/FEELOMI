// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************






Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'createdAt': UserProfile._timestampToJson(instance.createdAt),
      'lastLogin': UserProfile._timestampToJson(instance.lastLogin),
      'isPremium': instance.isPremium,
      'premiumExpiry':
          UserProfile._nullableTimestampToJson(instance.premiumExpiry),
      'settings': instance.settings.toJson(),
      'metrics': instance.metrics.toJson(),
    };
