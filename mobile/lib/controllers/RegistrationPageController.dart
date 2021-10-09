import 'package:get_it/get_it.dart';
import 'package:mobile/services/RegistrationService.dart';
import 'package:mobile/exceptions/RegistrationErrorException.dart';

class RegistrationPageController {
  final RegistrationService registrationService = GetIt.I.get();

  Future<bool> requestRegistrationCode(String phoneNumber, {bool reregister = false}) async {
    try {
      var result = await registrationService.requestRegistrationCode(
          phoneNumber, reregister);
      return result;
    } on RegistrationErrorException catch (e){
      if(reregister){
        print(e.cause);
        throw e;
      } else {
        return Future.value(false);
      }
    }
  }
}
