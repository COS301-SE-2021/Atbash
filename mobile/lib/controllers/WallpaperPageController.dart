import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
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

  Future<bool> confirmPop(BuildContext context) async {
    final currentlyDisplayedWallpaper = model.wallpaperImage;
    final savedWallpaper = await settingsService.getWallpaperImage();

    if (currentlyDisplayedWallpaper != savedWallpaper &&
        currentlyDisplayedWallpaper != null) {
      final confirmation = await showConfirmDialog(context,
          "You have not saved your wallpaper. Are you sure you want to leave?");

      return confirmation == true;
    } else {
      return true;
    }
  }
}
