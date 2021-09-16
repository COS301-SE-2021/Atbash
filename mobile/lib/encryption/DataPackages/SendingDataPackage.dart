class SendingDataPackage {
  final String action;
  final String messageId;
  final String recipientNumber;
  final String encryptedContents;

  SendingDataPackage(this.action, this.messageId, this.recipientNumber,
      this.encryptedContents);

  SendingDataPackage.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        messageId = json['id'],
        recipientNumber = json['recipientPhoneNumber'],
        encryptedContents = json['contents'];

  Map<String, dynamic> toJson() => {
        'action': action,
        'id': messageId,
        'recipientPhoneNumber': recipientNumber,
        'contents': encryptedContents,
      };
}

//Decoding
// Map<String, dynamic> packageMap = jsonDecode(jsonString);
// var package = SendingDataPackage.fromJson(packageMap);

//Encoding
// String json = jsonEncode(package)
