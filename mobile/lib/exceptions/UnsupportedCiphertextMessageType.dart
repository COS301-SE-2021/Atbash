//This Exception is thrown if the child class of the CiphertextMessage class is
//not yet supported
class UnsupportedCiphertextMessageType implements Exception {
  String cause;

  UnsupportedCiphertextMessageType(this.cause);
}
