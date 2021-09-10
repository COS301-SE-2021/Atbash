import 'dart:convert';

// import 'package:encrypt/encrypt.dart';
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart';
import 'package:mobile/constants.dart';
import 'package:uuid/uuid.dart';

class MediaService {
  Future<MediaUpload?> uploadMedia(String base64Media) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKey();
    final nonce = algorithm.newNonce();

    // Encrypt
    final secretBox = await algorithm.encrypt(
      base64Decode(base64Media),
      secretKey: secretKey,
      nonce: nonce,
    );

    final encryptedMediaBase64 = base64Encode(secretBox.concatenation());
    final mediaId = Uuid().v4();

    final uri = Uri.parse(Constants.httpUrl + "upload");
    final body = {"mediaId": mediaId, "method": "PUT"};
    final response = await post(uri, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final uploadUrl = Uri.parse(response.body);
      final uploadResponse = await put(uploadUrl, body: encryptedMediaBase64);

      if (uploadResponse.statusCode == 200) {
        return MediaUpload(
          mediaId: mediaId,
          secretKeyBase64: base64Encode(await secretKey.extractBytes()),
        );
      } else {
        print("${uploadResponse.statusCode} - ${uploadResponse.body}");
      }
    } else {
      print("${response.statusCode} - ${response.body}");
    }
  }

  Future<String?> fetchMedia(
      String mediaId, String secretKeyBase64) async {

    final algorithm = AesGcm.with256bits();
    final secretKey = SecretKey(base64Decode(secretKeyBase64));

    final uri = Uri.parse(Constants.httpUrl + "upload");
    final body = {"mediaId": mediaId, "method": "GET"};
    final response = await post(uri, body: jsonEncode(body));

    if (response.statusCode == 200) {
      print("received mediaUrl");

      final mediaUrl = Uri.parse(response.body);
      final mediaResponse = await get(mediaUrl);

      if (mediaResponse.statusCode == 200) {
        print("received image");

        final secretBox = SecretBox.fromConcatenation(
          base64Decode(mediaResponse.body),
          nonceLength: algorithm.nonceLength,
          macLength: algorithm.macAlgorithm.macLength,
        );
        
        secretBox.checkMac(macAlgorithm: algorithm.macAlgorithm, secretKey: secretKey, aad: <int>[]);

        // Decrypt
        final decryptedImage = await algorithm.decrypt(
          secretBox,
          secretKey: secretKey,
        );

        return base64Encode(decryptedImage);
      } else {
        print("${response.statusCode} - ${response.body}");
      }
    } else {
      print("${response.statusCode} - ${response.body}");
    }
  }

  // Future<MediaUpload?> uploadMedia(String base64Media) async {
  //   final base16Key = SecureRandom(32).base16;
  //   final base16IV = SecureRandom(16).base16;
  //
  //   final key = Key.fromBase16(base16Key);
  //   final iv = IV.fromBase16(base16IV);
  //
  //   final encryptor = Encrypter(AES(key));
  //
  //   final mediaId = Uuid().v4();
  //   final encryptedMedia = encryptor.encrypt(base64Media, iv: iv);
  //
  //   final uri = Uri.parse(Constants.httpUrl + "upload");
  //   final body = {"mediaId": mediaId, "method": "PUT"};
  //   final response = await post(uri, body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     final uploadUrl = Uri.parse(response.body);
  //     final uploadResponse = await put(uploadUrl, body: encryptedMedia.base64);
  //
  //     if (uploadResponse.statusCode == 200) {
  //       return MediaUpload(
  //         mediaId: mediaId,
  //         base16Key: base16Key,
  //         base16IV: base16IV,
  //       );
  //     } else {
  //       print("${uploadResponse.statusCode} - ${uploadResponse.body}");
  //     }
  //   } else {
  //     print("${response.statusCode} - ${response.body}");
  //   }
  // }
  //
  // Future<String?> fetchMedia(
  //     String mediaId, String base16Key, String base16IV) async {
  //   final key = Key.fromBase16(base16Key);
  //   final iv = IV.fromBase16(base16IV);
  //
  //   final uri = Uri.parse(Constants.httpUrl + "upload");
  //   final body = {"mediaId": mediaId, "method": "GET"};
  //   final response = await post(uri, body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     print("received mediaUrl");
  //
  //     final mediaUrl = Uri.parse(response.body);
  //     final mediaResponse = await get(mediaUrl);
  //
  //     if (mediaResponse.statusCode == 200) {
  //       print("received image");
  //
  //       final encryptor = Encrypter(AES(key));
  //
  //       final decryptedImage = encryptor.decrypt64(mediaResponse.body, iv: iv);
  //
  //       return decryptedImage;
  //     } else {
  //       print("${response.statusCode} - ${response.body}");
  //     }
  //   } else {
  //     print("${response.statusCode} - ${response.body}");
  //   }
  // }
}

class MediaUpload {
  final String mediaId;
  final String secretKeyBase64;

  MediaUpload({
    required this.mediaId,
    required this.secretKeyBase64,
  });
}
