import 'package:json_annotation/json_annotation.dart';
part 'omrs_provider.g.dart';

@JsonSerializable()
class OmrsProvider {
  final String uuid;
  final String? identifier;
  final String? display;
  final String? name;
  final List<Map<String, dynamic>>? attributes;

  OmrsProvider({required this.uuid, this.identifier, this.display, this.name, this.attributes});
  factory OmrsProvider.fromJson(Map<String, dynamic> json) => _$OmrsProviderFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsProviderToJson(this);

  List<dynamic> attrValue(String name) {
    if (attributes != null) {
      return List<dynamic>.of(attributes!.where((attr) => name == attr['attributeType']['display']).map((e) => e['value']));
    }
    return [];
  }
}