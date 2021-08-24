class SignedPreKeyPackage {
  final int keyId;
  final String publicKey;
  final String signature;

  SignedPreKeyPackage(this.keyId, this.publicKey, this.signature);

  SignedPreKeyPackage.fromJson(Map<String, dynamic> json)
      : keyId = json['keyId'],
        publicKey = json['publicKey'],
        signature = json['signature'];

}