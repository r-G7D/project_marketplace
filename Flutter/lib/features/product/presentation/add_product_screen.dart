import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_marketplace/api/api_service.dart';
import 'package:project_marketplace/utils/input_image_with_label.dart';

import '../../../utils/image_pick_crop.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  File? arImage;
  List<File?> images = [null];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    final success = await ref.read(apiServiceProvider).addProduct(
          name: _nameController.text,
          desc: _descController.text,
          arImage: arImage,
          image: images,
        );
    if (success) {
      Future.delayed(const Duration(microseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added'),
          ),
        );
        context.pop();
      });
    } else if (!success) {
      Future.delayed(const Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add product'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Add Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Product Description',
            ),
          ),
          const SizedBox(height: 16),
          // InputARImage(
          //   label: 'Product AR Image',
          //   previewImage: arImage!,
          //   setFunction: (source) async {
          //     CroppedFile? img = await ImagePickCrop.process(
          //         source: source, ratio: [CropAspectRatioPreset.square]);

          //     if (img != null) {
          //       final ar =
          //           await ref.read(apiServiceProvider).setArImage(img.path);
          //       setState(() {
          //         arImage = File.fromRawPath(ar);
          //       });
          //     }
          //   },
          // ),
          InputImageWithLabel(
            label: 'Product AR Image',
            previewImage: arImage,
            setFunction: (source) async {
              CroppedFile? img = await ImagePickCrop.process(
                  source: source, ratio: [CropAspectRatioPreset.square]);

              if (img != null) {
                // final ar =
                //     await ref.read(apiServiceProvider).setArImage(img.path);
                setState(() {
                  // arImage = File.fromRawPath(ar);
                  arImage = File(img.path);
                });
              }
            },
          ),
          // const SizedBox(height: 16),
          // InputImageWithLabel(
          //   label: 'Product Image / Thumbnail',
          //   previewImage: images.first,
          //   setFunction: (source) async {
          //     CroppedFile? img = await ImagePickCrop.process(
          //         source: source, ratio: [CropAspectRatioPreset.square]);

          //     if (img != null) {
          //       setState(() {
          //         images.first = File(img.path);
          //       });
          //     }
          //   },
          // ),
          if (images.isNotEmpty)
            ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    InputImageWithLabel(
                      label: 'Product Image ${index + 1}',
                      previewImage: images[index],
                      setFunction: (source) async {
                        CroppedFile? img = await ImagePickCrop.process(
                            source: source,
                            ratio: [CropAspectRatioPreset.square]);

                        if (img != null) {
                          setState(() {
                            images[index] = File(img.path);
                          });
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 16),
          if (images.length < 10)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // images.contains(ref.watch(inputImgProvider))
                  //     ? null
                  //     : images.add(ref.watch(inputImgProvider)!);
                  images.add(null);
                });
              },
              child: const Text('Add More Product Image'),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            // onPressed: () {
            //   // images.contains(ref.watch(inputImgProvider))
            //   //     ? null
            //   //     : images.add(ref.watch(inputImgProvider)!);
            //   _submit();
            // },
            onPressed: _submit,
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
