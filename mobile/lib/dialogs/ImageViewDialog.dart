import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile/util/Utils.dart';

void showImageViewDialog(BuildContext context, Uint8List imageBytes) {
  showDialog(
    context: context,
    builder: (_) => _ImageViewDialog(imageBytes: imageBytes),
  );
}

class _ImageViewDialog extends StatefulWidget {
  final Uint8List imageBytes;

  const _ImageViewDialog({Key? key, required this.imageBytes})
      : super(key: key);

  @override
  __ImageViewDialogState createState() => __ImageViewDialogState();
}

class __ImageViewDialogState extends State<_ImageViewDialog> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Image.memory(widget.imageBytes),
            if (!isSaved)
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _saveImage(widget.imageBytes, context);
                      setState(() {
                        isSaved = true;
                      });
                    },
                    icon: Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _saveImage(Uint8List imageData, BuildContext context) async {
  await ImageGallerySaver.saveImage(
    imageData,
  );
  showSnackBar(context, "Image downloaded.");
}
