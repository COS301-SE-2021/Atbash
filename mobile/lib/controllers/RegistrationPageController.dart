import 'package:get_it/get_it.dart';
import 'package:mobile/services/RegistrationService.dart';

class RegistrationPageController {
  final RegistrationService registrationService = GetIt.I.get();

  Future<bool> register(String phoneNumber) {
    return registrationService.register(phoneNumber, "abc");
  }
}
