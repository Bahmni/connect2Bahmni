class AppConstants {
  static AppMessages messages = const AppMessages();
  static NetworkError networkError = const NetworkError();
}

class AppMessages {
  const AppMessages();
  String get previous => 'Previous';
  String get next => 'Next';
}


class NetworkError {
  const NetworkError();
  String get unauthorized => 'Session expired please re-login.';
  String get forbidden => 'Access denied. You may not have required privileges.';
  String get badRequest => 'Error occurred. Invalid or malformed request to server.';
  String get notFound => 'Error occurred. Requested resource not found.';
  String get notAcceptable => 'Error occurred. Request was not accepted by server';
  String get internalServerError => 'Server error. Please try again later.';
  String get gatewayError => 'Gateway Error. Please try again later.';
  String get gatewayTimeout => 'Proxy or Gateway timeout. Please try again later.';
  String get unknown => 'Network error. Please try again later.';
}