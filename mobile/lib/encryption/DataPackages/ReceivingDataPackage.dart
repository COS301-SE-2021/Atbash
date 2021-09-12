class ReceivingDataPackage {
  final String messageId;
  final String senderNumber;
  final int timestamp;
  final String encryptedContents;

  ReceivingDataPackage(this.messageId, this.senderNumber, this.timestamp,
      this.encryptedContents);

  ReceivingDataPackage.fromJson(Map<String, dynamic> json)
      : messageId = json['id'],
        senderNumber = json['senderPhoneNumber'],
        timestamp = json['timestamp'],
        encryptedContents = json['contents'];

  Map<String, dynamic> toJson() => {
        'id': messageId,
        'senderPhoneNumber': senderNumber,
        'timestamp': timestamp,
        'contents': encryptedContents,
      };
}

//Decoding
// Map<String, dynamic> packageMap = jsonDecode(jsonString);
// var package = ReceivingDataPackage.fromJson(packageMap);

//Encoding
// String json = jsonEncode(package)
