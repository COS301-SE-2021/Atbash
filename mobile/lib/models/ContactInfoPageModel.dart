import 'package:mobx/mobx.dart';

part 'ContactInfoPageModel.g.dart';

class ContactInfoPageModel = _ContactInfoPageModel with _$ContactInfoPageModel;

abstract class _ContactInfoPageModel with Store {
  @observable
  String contactName = "";

  @observable
  String phoneNumber = "";

  @observable
  String profilePicture = "";

  @observable
  String status = "";

  @observable
  DateTime? birthday;
}
