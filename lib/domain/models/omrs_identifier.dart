import '../../domain/models/omrs_identifier_type.dart';

class OmrsIdentifier {
  String uuid;
  String identifier;
  OmrsIdentifierType identifierType;

  OmrsIdentifier({required this.uuid, required this.identifier, required this.identifierType});
  OmrsIdentifier.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        identifier = json['identifier'],
        identifierType = OmrsIdentifierType.fromJson(json['identifierType'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'identifier': identifier,
    'identifierType': identifierType
  };
}