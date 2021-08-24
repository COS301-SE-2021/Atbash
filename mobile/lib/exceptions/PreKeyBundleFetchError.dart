//This Exception is thrown if the getPreKeyBundle method fails
class PreKeyBundleFetchError implements Exception {
  String cause;
  PreKeyBundleFetchError(this.cause);
}