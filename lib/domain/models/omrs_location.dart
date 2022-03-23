class OmrsLocation {
  final String uuid;
  String? name;

  OmrsLocation({required this.uuid, this.name});
  OmrsLocation.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'] ?? json['display'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
  };
}