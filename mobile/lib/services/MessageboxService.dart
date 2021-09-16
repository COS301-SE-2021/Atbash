import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

//Services
import 'UserService.dart';

//Encryption
import 'package:mobile/encryption/BlindSignatures.dart';
import 'package:mobile/encryption/MailboxKeyDBRecord.dart';

//RSA Cryptography
import 'package:crypton/crypton.dart';

import '../constants.dart';


class MessageboxService {
  MessageboxService(this._userService);

  final UserService _userService;

  final _storage = FlutterSecureStorage();

  List<RSAKeypair> generateRSAKeyPairs(int numPairs){
    List<RSAKeypair> keys = [];

    for(var i = 0; i < numPairs; i++){
      keys.add(RSAKeypair.fromRandom(keySize: 4096));
    }

    return keys;
  }

  Future<RSAPublicKey?> getServerPublicKey() async {
    return Future.value(null);
  }

  Future<void> getMessageboxKeys(int numKeys) async {
    final blindSignatures = BlindSignatures();
    List<MailboxTokenDBRecord> tokens = [];

    RSAPublicKey? serverKey = await getServerPublicKey();

    if(serverKey == null){
      return;
    }

    final keyPairs = generateRSAKeyPairs(numKeys);
    List<Map<String, Object>> blindedPKs = [];

    for(var k in keyPairs){
      final message = jsonEncode({
        "n": k.publicKey.asPointyCastle.n.toString(),
        "e": k.publicKey.asPointyCastle.publicExponent.toString()
      });
      blindedPKs.add(blindSignatures.blind(message, serverKey));
    }

    final url = Uri.parse(Constants.httpUrl + "mailbox/createTokens");
    final phoneNumber = await _userService.getPhoneNumber();
    final authTokenEncoded = await _userService.getDeviceAuthTokenEncoded();

    List<Map<String, Object>> blindedPKArr = [];
    for (var i = 0; i < blindedPKs.length; i++) {
      blindedPKArr.add({
        "keyId": i,
        "blindedKey": (blindedPKs[i]["blinded"] as BigInt).toString()
      });
    }

    var data = {
      "authorization": "Bearer $authTokenEncoded",
      "phoneNumber": phoneNumber,
      "blindedPKs": blindedPKArr,
    };

    final response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      final responseBodyJson = jsonDecode(response.body) as List;
      final int numMailboxTokens = await getNumMailboxTokens();

      for(var i = 0; i < responseBodyJson.length; i++){
        final index = responseBodyJson[i]["tokenId"] as int;
        final signedPK = responseBodyJson[i]["signedPK"] as String;

        tokens.add(MailboxTokenDBRecord(numMailboxTokens + i, keyPairs[index], BigInt.parse(signedPK)));
      }

      return tokens;
    } else {
      //Soft fail
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
      return tokens; // Empty list
    }
  }






  ///--------------- Getters and Setters ---------------


  /// This function records the number of mailbox tokens that have been created
  Future<void> setNumMailboxTokens(int index) async {
    await _storage.write(key: "num_mailbox_tokens", value: index.toString());
  }

  /// This function retrieves the number of mailbox tokens that have been created
  Future<int> getNumMailboxTokens() async {
    final indexStr = await _storage.read(key: "num_mailbox_tokens");
    if (indexStr == null) {
      await setNumMailboxTokens(0);
      return 0;
    } else {
      return int.parse(indexStr);
    }
  }

}

class _userService {
}