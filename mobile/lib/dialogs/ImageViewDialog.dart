import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile/util/Utils.dart';

void showImageViewDialog(
    BuildContext context, Uint8List imageBytes, bool blockSaveMedia) {
  showDialog(
    context: context,
    builder: (_) => _ImageViewDialog(
      imageBytes: imageBytes,
      blockSaveMedia: blockSaveMedia,
    ),
  );
}

class _ImageViewDialog extends StatefulWidget {
  final Uint8List imageBytes;
  final bool blockSaveMedia;

  const _ImageViewDialog(
      {Key? key, required this.imageBytes, this.blockSaveMedia = false})
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
      content: Wrap(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Image.memory(widget.imageBytes),
                if (!isSaved && !widget.blockSaveMedia)
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
                          Icons.download,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
