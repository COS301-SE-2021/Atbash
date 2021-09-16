import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

//Services
import 'DatabaseService.dart';
import 'UserService.dart';

//Encryption
import 'package:mobile/encryption/BlindSignatures.dart';
import 'package:mobile/encryption/MessageboxToken.dart';

//RSA Cryptography
import 'package:crypton/crypton.dart';

import '../constants.dart';


class MessageboxService {
  MessageboxService(this._userService, this._databaseService);

  final UserService _userService;
  final DatabaseService _databaseService;

  final _storage = FlutterSecureStorage();

  List<RSAKeypair> generateRSAKeyPairs(int numPairs){
    List<RSAKeypair> keys = [];

    for(var i = 0; i < numPairs; i++){
      keys.add(RSAKeypair.fromRandom(keySize: 4096));
    }

    return keys;
  }

  Future<RSAPublicKey?> getServerPublicKey() async {
    final url = Uri.parse(Constants.httpUrl + "mailbox/serverPublicKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBodyJson = jsonDecode(response.body) as Map<String, Object>;

      BigInt N = BigInt.parse(responseBodyJson["n"] as String);
      BigInt E = BigInt.parse(responseBodyJson["e"] as String);
      RSAPublicKey key = RSAPublicKey(N, E);

      return key;
    } else {
      //Soft fail
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
    }
    return null;
  }

  Future<void> getMessageboxKeys(int numKeys) async {
    final blindSignatures = BlindSignatures();

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
      final int numMailboxTokens = await getNumMessageboxTokens();

      for(var i = 0; i < responseBodyJson.length; i++){
        final index = responseBodyJson[i]["tokenId"] as int;
        final signedPK = responseBodyJson[i]["signedPK"] as String;

        await storeMessageboxToken(MessageboxToken(numMailboxTokens + i, keyPairs[index], BigInt.parse(signedPK)));
      }
    } else {
      //Soft fail
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
    }
  }






  ///--------------- Getters and Setters ---------------


  /// This function records the number of mailbox tokens that have been created
  Future<void> setNumMessageboxTokens(int index) async {
    await _storage.write(key: "num_mailbox_tokens", value: index.toString());
  }

  /// This function retrieves the number of mailbox tokens that have been created
  Future<int> getNumMessageboxTokens() async {
    final indexStr = await _storage.read(key: "num_mailbox_tokens");
    if (indexStr == null) {
      await setNumMessageboxTokens(0);
      return 0;
    } else {
      return int.parse(indexStr);
    }
  }

  ///--------------- Database Functions ---------------

  /// Saves a PreKey to the database and returns.
  Future<void> storeMessageboxToken(MessageboxToken messageboxToken) async {
    final db = await _databaseService.database;

    await db.insert(MessageboxToken.TABLE_NAME, messageboxToken.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
 //SELECT * FROM SAMPLE_TABLE ORDER BY ROWID ASC LIMIT 1

  ///Fetches MessageboxToken from the database
  Future<MessageboxToken?> fetchMessageboxToken() async {
    final db = await _databaseService.database;
    final response = await db.query(
      MessageboxToken.TABLE_NAME,
      orderBy: MessageboxToken.COLUMN_MT_ID + " ASC",
      limit: 1,
    );

    if (response.isNotEmpty) {
      final messageboxToken = MessageboxToken.fromMap(response.first);
      if (messageboxToken != null) {
        return messageboxToken;
      }
    }
    return null;
  }

}
