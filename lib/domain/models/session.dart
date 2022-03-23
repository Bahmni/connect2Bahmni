import 'user.dart';
import 'package:json_annotation/json_annotation.dart';

import './omrs_location.dart';
import './omrs_provider.dart';
part 'session.g.dart';

@JsonSerializable()
class Session {
  final String sessionId;
  final bool authenticated;
  final User user;
  OmrsLocation? sessionLocation;
  OmrsProvider? currentProvider;

  Session({required this.sessionId, required this.authenticated, required this.user, this.sessionLocation, this.currentProvider});
  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}