import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_preview.dart';
import 'show_choose_image.dart';

class InputImageWithLabel extends StatelessWidget {
  const InputImageWithLabel({
    super.key,
    required this.label,
    required this.previewImage,
    required this.setFunction,
  });

  final String label;
  final dynamic previewImage;
  final void Function(ImageSource) setFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        if (previewImage != null && previewImage is File)
          ImagePreview(filePic: previewImage),
        if (previewImage != null && previewImage is String)
          ImagePreview(
            filePic: null,
            urlPic: previewImage!,
          ),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Choose image",
            suffixIcon: IconButton(
              onPressed: () {
                showChooseImage(context, setFunction);
              },
              icon: const Icon(Icons.camera_alt),
            ),
          ),
        ),
      ],
    );
  }
}
