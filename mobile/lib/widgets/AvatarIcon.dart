import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AvatarIcon extends StatelessWidget {
  final String? _imageData;

  AvatarIcon(this._imageData);

  @override
  Widget build(BuildContext context) {
    final imageData = _imageData;
    if (imageData != null && imageData.isNotEmpty) {
      final image = _buildAvatarImage(base64Decode(imageData));
      return CircleAvatar(radius: 16.0, backgroundImage: image);
    } else {
      return CircleAvatar(radius: 16.0, child: Icon(Icons.account_circle));
    }
  }

}
