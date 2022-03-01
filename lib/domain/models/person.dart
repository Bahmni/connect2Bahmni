import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';

@JsonSerializable()
class Person {
  final String uuid;
  final String display;
  final String? gender;
  final DateTime? birthdate;

  Person({required this.uuid, required this.display, this.gender, this.birthdate});
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);

}