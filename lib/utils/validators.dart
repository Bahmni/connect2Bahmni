String? validateUserName(String? value) {
  if (value == null || value.isEmpty) {
    return "Your username is required";
  }
  RegExp regex = RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
  if (!regex.hasMatch(value)) {
    return "Please provide a valid username";
  }
  return null;
}