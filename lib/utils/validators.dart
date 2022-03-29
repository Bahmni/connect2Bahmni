String? validateUserName(String? value) {
  if (value == null || value.isEmpty) {
    return "Your username is required";
  }
  RegExp regex = RegExp(r'^(?=[a-zA-Z0-9._]{5,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
  if (!regex.hasMatch(value)) {
    return "Please provide a valid username";
  }
  return null;
}

String? validateUrl(String? value) {
  if (value == null || value.isEmpty) {
    return "URL value is required";
  }
  bool result = Uri.parse(value).isAbsolute;
  return result ? null : 'Please provide a valid URL';
}