import 'package:mobile/domain/Tag.dart';
import 'package:mobx/mobx.dart';

part 'ObservableTag.g.dart';

class ObservableTag = _ObservableTag with _$ObservableTag;

abstract class _ObservableTag with Store {
  final Tag tag;

  final String id;

  @observable
  String name;

  _ObservableTag(this.tag)
      : id = tag.id,
        name = tag.name;
}

extension TagExtension on Tag {
  ObservableTag asObservable() {
    return ObservableTag(this);
  }
}
