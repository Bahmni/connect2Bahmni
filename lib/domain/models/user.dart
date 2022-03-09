import 'package:bahmni_doctor/domain/models/omrs_provider.dart';

import 'person.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String uuid;
  final String username;
  final Person person;
  final Map<String, dynamic>? userProperties;
  OmrsProvider? provider;

  User({required this.uuid, required this.username, required this.person, this.userProperties, this.provider});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}