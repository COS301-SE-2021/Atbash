import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/encryption/Messagebox.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

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
      keys.add(RSAKeypair.fromRandom(keySize: Constants.RSAKEYSIZE));
    }

    return keys;
  }

  Future<RSAPublicKey?> getServerPublicKey() async {
    final url = Uri.parse(Constants.httpUrl + "messageboxes/serverPublicKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBodyJson = jsonDecode(response.body) as Map<String, dynamic>;

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

    if (serverKey == null) {
      return;
    }

    final keyPairs = generateRSAKeyPairs(numKeys);
    List<Map<String, Object>> blindedPKs = [];

    for (var k in keyPairs) {
      final message = jsonEncode({
        "n": k.publicKey.asPointyCastle.n.toString(),
        "e": k.publicKey.asPointyCastle.publicExponent.toString()
      });
      blindedPKs.add(blindSignatures.blind(message, serverKey));
    }

    final url = Uri.parse(Constants.httpUrl + "messageboxes/createTokens");
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
      int maxMailboxTokenIndex = await getMaxMessageboxTokenIndex() + 1;

      for (var i = 0; i < responseBodyJson.length; i++) {
        print(responseBodyJson[i]);
        final index = responseBodyJson[i]["tokenId"] as int;
        final signedBlindedPK = responseBodyJson[i]["signedPK"] as String;

        //Unblind signed Keys
        final signedPKBigInt = blindSignatures.unblind(BigInt.parse(signedBlindedPK), blindedPKs[index]["r"] as BigInt, serverKey.asPointyCastle.n!);
        final signedPK = signedPKBigInt.toString();

        await storeMessageboxToken(MessageboxToken(
            maxMailboxTokenIndex++, keyPairs[index], BigInt.parse(signedPK)));
        await setMaxMessageboxTokenIndex(maxMailboxTokenIndex);
      }
    } else {
      //Soft fail
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
    }
  }

  Future<String?> createMessageBox(String? number) async {
    var url = Uri.parse(Constants.httpUrl + "messageboxes/create");

    if (await getNumMessageboxTokens() < 2) {
      await getMessageboxKeys(10);
    }

    final MessageboxToken? messageboxToken = await fetchMessageboxToken();
    final RSAPublicKey? serverPublicKey = await getServerPublicKey();

    if (messageboxToken == null) {
      print("Failed to fetch MessageboxToken");
      return null;
    }
    if (serverPublicKey == null) {
      return null;
    }

    var data = {
      "publicKey": {
        "n": messageboxToken.keypair.publicKey.asPointyCastle.n.toString(),
        "e": messageboxToken.keypair.publicKey.asPointyCastle.publicExponent
            .toString()
      },
      "signedToken": messageboxToken.signedPK.toString(),
    };

    var response = await http.post(url, body: jsonEncode(data));

    if (response.statusCode == 200) {
      // final decodedBodyJson = jsonDecode(messageboxToken.keypair.privateKey.decrypt(response.body)) as Map<String, dynamic>;
      final responseBodyJson = jsonDecode(response.body) as Map<String, dynamic>;

      String mid =  messageboxToken.keypair.privateKey.decrypt(responseBodyJson["mid"] as String);
      String randomString = messageboxToken.keypair.privateKey.decrypt(responseBodyJson["random"] as String);

      url = Uri.parse(Constants.httpUrl + "messageboxes/createVerify");

      data = {
        "mid": serverPublicKey.encrypt(mid),
        "random": randomString,
      };

      response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        int expires = jsonDecode(response.body) as int;
        Messagebox messagebox = Messagebox(mid, messageboxToken.keypair, number, null, null, expires);
        storeMessagebox(messagebox);

        //TODO: Send a request to the server to link this devices ConnectionID to the MID (for notifications)

        return messagebox.id;
      } else {
        //Soft fail
        print("Server request was unsuccessful.\nResponse code: " +
            response.statusCode.toString() +
            ".\nReason: " +
            response.body);
      }
    } else {
      //Soft fail
      print("Server request was unsuccessful.\nResponse code: " +
          response.statusCode.toString() +
          ".\nReason: " +
          response.body);
    }
    return null;
  }

  ///--------------- Getters and Setters ---------------

  /// This function records the number of mailbox tokens that have been created
  Future<void> setNumMessageboxTokens(int index) async {
    await _storage.write(key: "num_messagebox_tokens", value: index.toString());
  }

  /// This function retrieves the number of mailbox tokens that have been created
  Future<int> getNumMessageboxTokens() async {
    final indexStr = await _storage.read(key: "num_messagebox_tokens");
    if (indexStr == null) {
      await setNumMessageboxTokens(0);
      return 0;
    } else {
      return int.parse(indexStr);
    }
  }

  /// This function records the max index of mailbox tokens that have been created
  Future<void> setMaxMessageboxTokenIndex(int index) async {
    await _storage.write(
        key: "max_mailbox_token_index", value: index.toString());
  }

  /// This function retrieves the max index of mailbox tokens that have been created
  Future<int> getMaxMessageboxTokenIndex() async {
    final indexStr = await _storage.read(key: "max_mailbox_token_index");
    if (indexStr == null) {
      await setMaxMessageboxTokenIndex(-1);
      return -1;
    } else {
      return int.parse(indexStr);
    }
  }

  ///--------------- Database Functions ---------------

  /// Saves a MessageboxToken to the database and returns.
  Future<void> storeMessageboxToken(MessageboxToken messageboxToken) async {
    final db = await _databaseService.database;

    if (await db.insert(MessageboxToken.TABLE_NAME, messageboxToken.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace) !=
        0) {
      await setNumMessageboxTokens(await getNumMessageboxTokens() + 1);
    }
  }

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

  /// Deletes MessageboxToken from database.
  Future<void> removeMessageboxToken(int messageboxTokenId) async {
    final db = await _databaseService.database;

    if(await db.delete(
      MessageboxToken.TABLE_NAME,
      where: "${MessageboxToken.COLUMN_MT_ID} = ?",
      whereArgs: [messageboxTokenId],
      ) > 0){
      await setNumMessageboxTokens(await getNumMessageboxTokens() - 1);
    }
  }

  /// Saves a Messagebox to the database and returns.
  Future<void> storeMessagebox(Messagebox messagebox) async {
    final db = await _databaseService.database;

    await db.insert(Messagebox.TABLE_NAME, messagebox.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Fetches Messagebox from the database with the given id
  Future<Messagebox?> fetchMessageboxWithID(String id) async {
    final db = await _databaseService.database;
    final response = await db.query(
      Messagebox.TABLE_NAME,
      where: "${Messagebox.COLUMN_M_ID} = ?",
      whereArgs: [id],
    );

    if (response.isNotEmpty) {
      final messagebox = Messagebox.fromMap(response.first);
      return messagebox;
    }
    return null;
  }

  ///Fetches Messagebox from the database with the given number
  Future<Messagebox?> fetchMessageboxForNumber(String number) async {
    final db = await _databaseService.database;
    final response = await db.query(
      Messagebox.TABLE_NAME,
      where: "${Messagebox.COLUMN_NUMBER} = ?",
      whereArgs: [number],
    );

    if (response.isNotEmpty) {
      final messagebox = Messagebox.fromMap(response.first);
      return messagebox;
    }
    return null;
  }

  ///Updates the recipients RSA key for the Messagebox
  Future<void> updateMessageboxRSAKey(String id, RSAPublicKey key) async {
    final db = await _databaseService.database;

    await db.update(
      Messagebox.TABLE_NAME,
      {
        Messagebox.COLUMN_RECIPIENT_KEY: key.toString()
      },
      where:"${Messagebox.COLUMN_M_ID} = ?",
      whereArgs: [id],
      );
  }

  ///Updates the recipients RSA key for the Messagebox with given number
  Future<void> updateMessageboxRSAKeyForNumber(String number, RSAPublicKey key) async {
    final db = await _databaseService.database;

    await db.update(
      Messagebox.TABLE_NAME,
      {
        Messagebox.COLUMN_RECIPIENT_KEY: key.toString()
      },
      where:"${Messagebox.COLUMN_NUMBER} = ?",
      whereArgs: [number],
    );
  }

  // ///Adds recipients MessageboxId to the Messagebox
  // Future<void> addRecipientIdToMessagebox(String id, String recipientId) async {
  //   final db = await _databaseService.database;
  //
  //   await db.update(
  //     Messagebox.TABLE_NAME,
  //     {
  //       Messagebox.COLUMN_RECIPIENT_ID: recipientId
  //     },
  //     where:"${Messagebox.COLUMN_M_ID} = ?",
  //     whereArgs: [id],
  //   );
  // }

  ///Updates the recipients MessageboxId for the Messagebox
  Future<void> updateMessageboxRecipientId(String id, String recipientId) async {
    final db = await _databaseService.database;

    await db.update(
      Messagebox.TABLE_NAME,
      {
        Messagebox.COLUMN_RECIPIENT_ID: recipientId
      },
      where:"${Messagebox.COLUMN_M_ID} = ?",
      whereArgs: [id],
    );
  }

  /// Returns a list of ids for all the messageboxes
  Future<List<String>> getAllMessageboxIds() async {
    final db = await _databaseService.database;
    final response = await db.query(
      Messagebox.TABLE_NAME,
    );

    final list = <String>[];

    response.forEach((element) {
      final messagebox = Messagebox.fromMap(element);
      if (messagebox != null) {
        list.add(messagebox.id);
      }
    });

    return list;
  }
}
