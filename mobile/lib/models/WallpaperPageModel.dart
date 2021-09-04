import 'package:mobx/mobx.dart';

part 'WallpaperPageModel.g.dart';

class WallpaperPageModel = _WallpaperPageModel with _$WallpaperPageModel;

abstract class _WallpaperPageModel with Store {
  @observable
  String? wallpaperImage;
}
