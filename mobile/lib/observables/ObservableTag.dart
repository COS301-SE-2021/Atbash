import 'package:mobile/domain/Tag.dart';
import 'package:mobx/mobx.dart';

part 'ObservableTag.g.dart';

class ObservableTag = _ObservableTag with _$ObservableTag;

abstract class _ObservableTag with Store {
  final Tag tag;

  String get id => tag.id;

  @computed
  String get name => tag.name;

  set name(String value) => tag.name = value;

  _ObservableTag(this.tag);
}

extension TagExtension on Tag {
  ObservableTag asObservable() {
    return ObservableTag(this);
  }
}
