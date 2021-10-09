//This Exception is thrown if an error is encountered in the registration process
class VerificationErrorException implements Exception {
  String cause;

  VerificationErrorException(this.cause);
}