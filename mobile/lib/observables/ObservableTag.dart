import 'package:mobile/domain/Tag.dart';
import 'package:mobx/mobx.dart';

part 'ObservableTag.g.dart';

class ObservableTag = _ObservableTag with _$ObservableTag;

abstract class _ObservableTag with Store {
  final String id;

  @observable
  String name;

  _ObservableTag(Tag t)
      : id = t.id,
        name = t.name;
}
