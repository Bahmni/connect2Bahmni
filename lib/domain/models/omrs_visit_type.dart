class OmrsVisitType {
  String? uuid;
  String? display;

  OmrsVisitType({required this.uuid, this.display});
  OmrsVisitType.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        display = json['display'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'display': display,
  };
}