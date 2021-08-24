import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'EncryptionService.dart';

class RegistrationService {
  RegistrationService(this._encryptionService);

  final EncryptionService _encryptionService; // = GetIt.I.get<EncryptionService>();

  final _storage = FlutterSecureStorage();

  Future<bool> requestRegistrationVerificationCode(String phoneNumber) async {
    throwIfNot(
        Validations().numberIsValid(phoneNumber),
        new InvalidNumberException(
            "Invalid number provided in requestRegistrationCode method"));

    final url =
    Uri.parse(baseURLHttps + "accounts/sms/code/$phoneNumber");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Future.wait([
        _storage.write(key: "phone_number", value: phoneNumber),
      ]);

      return true;
    } else {
      return false;
    }
  }

}