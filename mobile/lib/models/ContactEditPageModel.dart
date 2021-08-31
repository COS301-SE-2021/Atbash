import 'package:mobx/mobx.dart';

part 'ContactEditPageModel.g.dart';

class ContactEditPageModel = _ContactEditPageModel with _$ContactEditPageModel;

abstract class _ContactEditPageModel with Store {
  @observable
  String contactName = "";

  @observable
  DateTime? contactBirthday;
}