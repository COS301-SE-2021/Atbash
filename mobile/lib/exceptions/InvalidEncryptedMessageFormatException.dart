//This Exception is thrown if the decrypted message is formatted incorrectly
class InvalidEncryptedMessageFormatException implements Exception {
  String cause;
  InvalidEncryptedMessageFormatException(this.cause);
}