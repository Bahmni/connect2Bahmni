class OmrsPersonAttribute {
  String? uuid;
  String? value;
  String? display;
  OmrsPersonAttributeType? attributeType;

  OmrsPersonAttribute({this.uuid, this.value, this.display, this.attributeType});
  OmrsPersonAttribute.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        value = json['value'],
        display = json['display'],
        attributeType = json['attributeType'] != null ? OmrsPersonAttributeType.fromJson(json['attributeType']) : null;

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'value': value,
    'display': display,
    'attributeType': attributeType?.toJson(),
  };
}

class OmrsPersonAttributeType {
  String? uuid;
  String? name;
  String? display;
  String? description;
  String? format;

  OmrsPersonAttributeType({required this.uuid, this.name, this.display, this.description, this.format});
  OmrsPersonAttributeType.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        display = json['display'],
        description = json['description'],
        format = json['format'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'description': description,
    'format': format,
    'display': display,
  };

  static Type? dataType(String? format) {
    if (format == null) return null;
    switch(format) {
      case 'java.lang.String':
        return String;
      case 'java.lang.Boolean':
        return bool;
      case 'java.lang.Integer':
        return int;
      case 'java.lang.Float':
        return double;
      default:
        return null;
    }
  }
}

