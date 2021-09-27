import 'package:get_it/get_it.dart';
import 'package:mobile/services/ChildrenService.dart';
import 'package:mobile/services/CommunicationService.dart';

class ParentalSettingsPageController{
  final CommunicationService communicationService = GetIt.I.get();
  final ChildrenService childrenService = GetIt.I.get();
}