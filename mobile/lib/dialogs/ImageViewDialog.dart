import 'dart:typed_data';

import 'package:flutter/material.dart';

void showImageViewDialog(BuildContext context, Uint8List imageBytes) {
  showDialog(
    context: context,
    builder: (_) => _ImageViewDialog(imageBytes: imageBytes),
  );
}

class _ImageViewDialog extends StatelessWidget {
  final Uint8List imageBytes;

  const _ImageViewDialog({Key? key, required this.imageBytes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        padding: const EdgeInsets.all(8),
        child: Image.memory(imageBytes),
      ),
    );
  }
}
