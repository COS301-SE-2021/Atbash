import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Child.dart';
import 'package:mobile/models/NewChildPageModel.dart';
import 'package:mobile/services/ChildService.dart';
import 'package:mobile/services/ContactService.dart';

class NewChildPageController {
  final ContactService contactService = GetIt.I.get();
  final ChildService childService = GetIt.I.get();

  final NewChildPageModel model = NewChildPageModel();

  NewChildPageController(){
    contactService.fetchAll().then((contacts) async{
      model.contacts.clear();
      model.contacts.addAll(contacts);
    });
  }

  void addChild(Child child){
    //TODO send pin to see if matches on both phones
    childService.insert(child);
  }
}