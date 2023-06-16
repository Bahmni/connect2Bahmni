class OmrsIdentifierType {
  String? uuid;
  String? name;
  bool? required;
  String? description;
  bool? primary;
  List<OmrsIdentifierSource>? identifierSources;

  OmrsIdentifierType({required this.uuid, this.name, this.required, this.description, this.primary, this.identifierSources});
  OmrsIdentifierType.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'] ?? json['display'],
        required = json['required'] as bool?,
        description = json['description'],
        primary = json['primary'] as bool?,
        identifierSources = (json['identifierSources'] as List<dynamic>?)
            ?.map((e) => OmrsIdentifierSource.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'required': required,
    'description': description,
    'primary': primary,
    'identifierSources': identifierSources,
  };
}

class OmrsIdentifierSource {
  String? uuid;
  String? name;
  String? prefix;

  OmrsIdentifierSource({required this.uuid, this.name, this.prefix});
  OmrsIdentifierSource.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        prefix = json['prefix'];
  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'prefix': prefix
  };
}