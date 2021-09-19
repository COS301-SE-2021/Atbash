//This Exception is thrown if invalid parameters are passed to a method
class InvalidParametersException implements Exception {
  String cause;

  InvalidParametersException(this.cause);
}
