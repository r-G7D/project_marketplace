import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'show_choose_image.dart';

class InputARImage extends StatelessWidget {
  final String label;
  final Uint8List? previewImage;
  final void Function(ImageSource) setFunction;

  const InputARImage({
    super.key,
    required this.label,
    required this.previewImage,
    required this.setFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        if (previewImage != null) imagePreview(context, filePic: previewImage),
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

  Widget imagePreview(BuildContext context,
      {Uint8List? filePic, String? urlPic, String? label}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Builder(builder: (_) {
        if (filePic != null) {
          // return Image.file(
          //   filePic!,
          //   fit: BoxFit.fitHeight,
          //   height: 200,
          // );
          return Image.memory(
            filePic,
            fit: BoxFit.fitHeight,
            height: 200,
          );
        } else {
          return Image.network(
            urlPic!,
            fit: BoxFit.fitHeight,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('[$label], Error: $error');
              return const SizedBox(
                height: 200,
                child: Icon(
                  Icons.error_outline,
                  color: Colors.black,
                ),
              );
            },
          );
        }
      }),
    );
  }
}
