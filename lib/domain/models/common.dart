

enum Gender {
  male,
  female,
  other,
  unknown,
}

Gender? toGenderType(String? gender) {
  var where = Gender.values.where((element) => element.name == gender!.toLowerCase());
  return where.isEmpty ? null : where.first;
}

String toGenderPrefix(Gender gender) {
  return gender.name.substring(0,1).toUpperCase();
}

Gender? fromGenderPrefix(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  var genderPrefix = value.substring(0,1).toUpperCase();
  switch (genderPrefix) {
    case 'M':
      return Gender.male;
    case 'F':
      return Gender.female;
    case 'O':
      return Gender.other;
    default:
      return Gender.unknown;
  }
}