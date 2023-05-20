// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      sessionId: json['sessionId'] as String?,
      authenticated: json['authenticated'] as bool,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      sessionLocation: json['sessionLocation'] == null
          ? null
          : OmrsLocation.fromJson(
              json['sessionLocation'] as Map<String, dynamic>),
      currentProvider: json['currentProvider'] == null
          ? null
          : OmrsProvider.fromJson(
              json['currentProvider'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'sessionId': instance.sessionId,
      'authenticated': instance.authenticated,
      'user': instance.user,
      'sessionLocation': instance.sessionLocation,
      'currentProvider': instance.currentProvider,
    };
