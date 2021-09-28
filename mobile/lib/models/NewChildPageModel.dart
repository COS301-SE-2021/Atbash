import 'package:mobile/domain/Contact.dart';
import 'package:mobx/mobx.dart';

part 'NewChildPageModel.g.dart';

class NewChildPageModel = _NewChildPageModel with _$NewChildPageModel;

abstract class _NewChildPageModel with Store{
  @observable
  List<Contact> contacts = <Contact>[].asObservable();
}