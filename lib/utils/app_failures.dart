class Failure {
  final String message;
  final int? errorCode;
  Failure(this.message, [this.errorCode]);

  @override
  String toString() => message;
}