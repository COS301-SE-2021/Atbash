class PreKeyPackage {
  final int keyId;
  final String publicKey;

  PreKeyPackage(this.keyId, this.publicKey);

  PreKeyPackage.fromJson(Map<String, dynamic> json)
      : keyId = json['keyId'],
        publicKey = json['publicKey'];

}