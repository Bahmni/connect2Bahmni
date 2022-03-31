class OmrsIdentifierType {
  String? uuid;
  String? name;

  OmrsIdentifierType({required this.uuid, this.name});
  OmrsIdentifierType.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'] ?? json['display'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
  };
}