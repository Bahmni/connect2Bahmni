class OmrsConceptDescription {
  String? uuid;
  String? display;
  OmrsConceptDescription({this.uuid, this.display});

  OmrsConceptDescription.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        display = json['display'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'display': display
  };
}