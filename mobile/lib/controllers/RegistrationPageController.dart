import 'package:get_it/get_it.dart';
import 'package:mobile/services/RegistrationService.dart';
import 'package:mobile/exceptions/RegistrationErrorException.dart';

class RegistrationPageController {
  final RegistrationService registrationService = GetIt.I.get();

  Future<bool> requestRegistrationCode(String phoneNumber, {bool reregister = false}){
    try {
      return registrationService.requestRegistrationCode(
          phoneNumber, reregister);
    } on RegistrationErrorException catch (e){
      if(reregister){
        throw e;
      } else {
        return Future.value(false);
      }
    }
  }
}
