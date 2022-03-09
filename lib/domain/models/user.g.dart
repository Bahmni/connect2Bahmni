// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uuid: json['uuid'] as String,
      username: json['username'] as String,
      person: Person.fromJson(json['person'] as Map<String, dynamic>),
      userProperties: json['userProperties'] as Map<String, dynamic>?,
      provider: json['provider'] == null
          ? null
          : OmrsProvider.fromJson(json['provider'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'username': instance.username,
      'person': instance.person,
      'userProperties': instance.userProperties,
      'provider': instance.provider,
    };
