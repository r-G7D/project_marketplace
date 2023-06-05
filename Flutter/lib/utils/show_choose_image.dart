import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showChooseImage(BuildContext context, Function fnc) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      return Container(
        margin: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      fnc(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: Colors.blue,
                        ),
                        Text('Camera',
                            style: TextStyle(
                              fontSize: 16,
                            ))
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      fnc(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          size: 48,
                          color: Colors.blue,
                        ),
                        Text('Gallery',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
