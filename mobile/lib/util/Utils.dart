String cullToE164(String phoneNumber) {
  return phoneNumber.replaceAll(RegExp("(\s|[^0-9]|^0*)"), "");
}
