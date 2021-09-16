import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Encryption
import 'package:mobile/encryption/BlindSignatures.dart';
import 'package:mobile/encryption/MailboxKeyDBRecord.dart';

//RSA Cryptography
import 'package:crypton/crypton.dart';


class MessageboxService {
  MessageboxService();

  final _storage = FlutterSecureStorage();

  List<RSAKeypair> generateRSAKeyPairs(int numPairs){
    List<RSAKeypair> keys = [];

    for(var i = 0; i < numPairs; i++){
      keys.add(RSAKeypair.fromRandom(keySize: 4096));
    }

    return keys;
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