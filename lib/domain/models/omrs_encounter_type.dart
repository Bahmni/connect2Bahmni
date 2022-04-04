class OmrsEncounterType {
  String? uuid;
  String? display;

  OmrsEncounterType({required this.uuid, this.display});
  OmrsEncounterType.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        display = json['display'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'display': display,
  };
}