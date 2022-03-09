import 'package:json_annotation/json_annotation.dart';
part 'omrs_provider.g.dart';

@JsonSerializable()
class OmrsProvider {
  final String uuid;
  final String? identifier;
  final List<Map<String, dynamic>>? attributes;

  OmrsProvider({required this.uuid, this.identifier, this.attributes});
  factory OmrsProvider.fromJson(Map<String, dynamic> json) => _$OmrsProviderFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsProviderToJson(this);
}