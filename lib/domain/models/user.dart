import 'person.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String username;
  final Person person;
  final Map<String, dynamic>? userProperties;

  User({required this.username, required this.person, this.userProperties});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}