import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/controllers/WallpaperPageController.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({Key? key}) : super(key: key);

  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  final controller = WallpaperPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Wallpaper"),
      ),
      body: Observer(
        builder: (_) {
          final image = controller.model.wallpaperImage;

          ImageProvider imageProvider;

          if (image != null) {
            final imageBytes = base64Decode(image);
            imageProvider = MemoryImage(imageBytes);
          } else {
            imageProvider = AssetImage("assets/wallpaper.jpg");
          }

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedImage =
              await ImagePicker().getImage(source: ImageSource.gallery);

          if (pickedImage != null) {
            final imageBytes = await pickedImage.readAsBytes();
            controller.setWallpaper(base64Encode(imageBytes));
          }
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
