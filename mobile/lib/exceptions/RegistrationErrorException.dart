//This Exception is thrown if an error is encountered in the registration process
class RegistrationErrorException implements Exception {
  String cause;

  RegistrationErrorException(this.cause);
}
