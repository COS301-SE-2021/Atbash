class Contact {
  final String phoneNumber;
  final String displayName;
  final String status;
  final String profileImage;
  final DateTime? birthday;

  Contact(
      {required this.phoneNumber,
      required this.displayName,
      required this.status,
      required this.profileImage,
      this.birthday});
}
