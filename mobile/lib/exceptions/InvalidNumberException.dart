//This Exception is thrown if the provided cell number is not a valid cell number
class InvalidNumberException implements Exception {
  String cause;

  InvalidNumberException(this.cause);
}
