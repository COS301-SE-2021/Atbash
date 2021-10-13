import 'package:get_it/get_it.dart';
import 'package:mobile/services/RegistrationService.dart';

class VerificationPageController {
  final RegistrationService registrationService = GetIt.I.get();

  Future<bool> register(String phoneNumber, String code) {
    return registrationService.register(phoneNumber, code);
  }

  Future<bool> registerComplete() {
    return registrationService.registerComplete();
  }

  Future<void> clearRegistration(){
    return registrationService.clearEncryptionTables().then((value) => registrationService.setUnregistered());
  }
}