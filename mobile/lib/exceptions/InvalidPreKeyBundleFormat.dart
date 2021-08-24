//This Exception is thrown if the PreKeyBundle has an incorrect format
class InvalidPreKeyBundleFormat implements Exception {
  String cause;
  InvalidPreKeyBundleFormat(this.cause);
}