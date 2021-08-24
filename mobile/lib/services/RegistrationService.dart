import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'EncryptionService.dart';

class RegistrationService {
  RegistrationService(this._encryptionService);

  final EncryptionService _encryptionService; // = GetIt.I.get<EncryptionService>();

  final _storage = FlutterSecureStorage();



}