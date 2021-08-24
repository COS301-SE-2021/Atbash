import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'EncryptionService.dart';

class RegistrationService {
  RegistrationService(this._encryptionService);

  final EncryptionService _encryptionService; // = GetIt.I.get<EncryptionService>();

  final _storage = FlutterSecureStorage();

  Future<bool> register(String phoneNumber, String deviceToken) async {
    // final url = Uri.parse("https://" + baseURL + "accounts/code/$verificationCode");

    final url = Uri.parse(baseURLHttps + "register");

    throwIfNot(Validations().numberIsValid(phoneNumber),
        new InvalidNumberException("Invalid number provided in requestRegistrationCode method"));

    //Todo: Add device token validation

    // final phoneNumber = await getUserPhoneNumber();
    final registrationId = generateRegistrationId(false);
    final aesKey = generateRandomBytes(32);
    final hmacSha256 = Hmac(sha256, aesKey);
    var signalingKeyBytesBuilder = BytesBuilder();

    // final values = List<int>.generate(24, (i) => _random.nextInt(256));
    // final devicePassword = Uint8List.fromList(values);
    //
    // final authTokenEncoded =
    //     _generateAuthenticationToken(phoneNumber, devicePassword);

    final rsaHelper = rsa.RsaKeyHelper();
    final keyPair = await rsaHelper.computeRSAKeyPair(rsaHelper.getSecureRandom());

    final publicKeyStr = rsaHelper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey);
    final privateKeyStr = rsaHelper.encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey);

    //await _encryptionService.generateInitialKeyBundle(registrationId);

    //final identityKeyPair = await _databaseService.fetchIdentityKP();

    // if(identityKeyPair == null){
    //   throw new InvalidNumberException("Failed to acquire IdentityKeyPair from database.");
    // }

    // var data = {
    //   "registrationId": registrationId,
    //   "deviceToken": deviceToken,
    //   "signalingKey": "",
    // };

    var data = {
      "registrationId": registrationId,
      "phoneNumber": phoneNumber,
      "rsaPublicKey": publicKeyStr,
      "deviceToken": deviceToken,
      "signalingKey": "",
    };

    final hmacKey =
        hmacSha256.convert(utf8.encoder.convert(jsonEncode(data))).bytes;

    signalingKeyBytesBuilder.add(aesKey);
    signalingKeyBytesBuilder.add(hmacKey);
    final signalingKey = base64.encode(signalingKeyBytesBuilder.toBytes());

    data["signalingKey"] = signalingKey;

    // final response = await http.put(url,
    //     body: data, headers: {"Authorization": "Basic $authTokenEncoded"});
    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      final responseBodyJson = jsonDecode(response.body);
      final devicePassword = responseBodyJson["password"] as String?;
      final formattedPhoneNumber = responseBodyJson["phoneNumber"] as String?;
      if(devicePassword == null){
        throw new RegistrationErrorException("Server response was in an invalid format. Response body: " + response.body);
      }
      if(formattedPhoneNumber != null){
        phoneNumber = formattedPhoneNumber;
      }

      //Method 1
      final encodedPassword = base64Decode(devicePassword);
      var cipher = new RSAEngine()..init(false, new PrivateKeyParameter<RSAPrivateKey>(keyPair.privateKey as RSAPrivateKey));
      final unencryptedPassword = cipher.process(encodedPassword);

      //Method 2
      // final encryptor = encrypt.Encrypter(encrypt.RSA(
      //     publicKey: keyPair.publicKey as RSAPublicKey,
      //     privateKey: keyPair.privateKey as RSAPrivateKey
      // ));
      // final unencryptedPassword = base64Decode(encryptor.decrypt64(devicePassword));

      final authTokenEncoded = _generateAuthenticationToken(phoneNumber, unencryptedPassword);

      Future.wait([
        //_storage.write(key: "registration_id", value: registrationId.toString()),
        _storage.write(
            key: "device_password_base64",
            value: base64.encode(unencryptedPassword)), //Necessary to convert to base64 here?
        _storage.write(
            key: "device_authentication_token_base64", value: authTokenEncoded),
        _storage.write(key: "rsa_public_key", value: publicKeyStr),
        _storage.write(key: "rsa_private_key", value: privateKeyStr),
        _storage.write(key: "phone_number", value: phoneNumber),
      ]);

      await _encryptionService.generateInitialKeyBundle(registrationId);

      return registerKeys();
    } else {
      print("Server request was unsuccessful.\nResponse code: " + response.statusCode.toString() + ".\nReason: " + response.body);
      throw new RegistrationErrorException("Server request was unsuccessful.\nResponse code: " + response.statusCode.toString() + ".\nReason: " + response.body);
      //return false;
    }
  }














  // Future<bool> requestRegistrationVerificationCode(String phoneNumber) async {
  //   throwIfNot(
  //       Validations().numberIsValid(phoneNumber),
  //       new InvalidNumberException(
  //           "Invalid number provided in requestRegistrationCode method"));
  //
  //   final url =
  //   Uri.parse(baseURLHttps + "accounts/sms/code/$phoneNumber");
  //
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     Future.wait([
  //       _storage.write(key: "phone_number", value: phoneNumber),
  //     ]);
  //
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

}