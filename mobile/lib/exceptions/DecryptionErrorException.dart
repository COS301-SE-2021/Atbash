//This Exception is thrown if an error is encountered in the decryption process
class DecryptionErrorException implements Exception {
  String cause;

  DecryptionErrorException(this.cause);
}
