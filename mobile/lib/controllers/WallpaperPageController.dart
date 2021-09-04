import 'package:get_it/get_it.dart';
import 'package:mobile/models/WallpaperPageModel.dart';
import 'package:mobile/services/SettingsService.dart';

class WallpaperPageController {
  final SettingsService settingsService = GetIt.I.get();

  WallpaperPageController() {
    settingsService
        .getWallpaperImage()
        .then((value) => model.wallpaperImage = value);
  }

  final model = WallpaperPageModel();

  void setWallpaper(String wallpaperImage) {
    model.wallpaperImage = wallpaperImage;
  }

  void saveChosenWallpaper() {
    final chosenWallpaper = model.wallpaperImage;
    if (chosenWallpaper != null) {
      settingsService.setWallpaperImage(chosenWallpaper);
    }
  }
}
