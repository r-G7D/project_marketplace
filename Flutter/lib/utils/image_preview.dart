import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.filePic,
    this.urlPic,
    this.label,
  });

  final File? filePic;
  final String? urlPic;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label!, style: const TextStyle(fontSize: 16)),
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Builder(builder: (_) {
            if (filePic != null) {
              return Image.file(
                filePic!,
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
        ),
      ],
    );
  }
}
