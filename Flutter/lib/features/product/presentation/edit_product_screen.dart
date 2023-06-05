import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../api/api_service.dart';
import '../../../utils/image_pick_crop.dart';
import '../../../utils/input_image_with_label.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> productData;
  const EditProductScreen({super.key, required this.productData});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  File? arImage;
  List<String?> images = [];
  List<File?> newImages = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.productData['product'].name!;
    _descController.text = widget.productData['product'].desc!;
    images = widget.productData['images'];
    for (var i = 0; i < images.length; i++) {
      newImages.add(null);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    final success = await ref.read(apiServiceProvider).updateProduct(
          id: widget.productData['product'].id!,
          name: _nameController.text,
          desc: _descController.text,
          arImage: arImage,
          image: newImages,
        );
    if (success) {
      Future.delayed(const Duration(microseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated'),
          ),
        );
        context.pop();
        context.pop();
      });
    } else if (!success) {
      Future.delayed(const Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update product'),
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
        title: const Text('Edit Product'),
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
          InputImageWithLabel(
            label: 'Product AR Image',
            previewImage: arImage ?? widget.productData['arImage'],
            setFunction: (source) async {
              CroppedFile? img = await ImagePickCrop.process(
                  source: source, ratio: [CropAspectRatioPreset.square]);

              if (img != null) {
                setState(() {
                  arImage = File(img.path);
                });
              }
            },
          ),
          // const SizedBox(height: 16),
          // InputImageWithLabel(
          //   label: 'Product Image / Thumbnail',
          //   previewImage: images.first ?? widget.productData['images'].first,
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
              padding: EdgeInsets.zero,
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
                            images.removeAt(index);
                            newImages.removeAt(index);
                            // newImages[index] = File(img.path);
                            newImages.insert(0, File(img.path));
                          });
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          if (newImages.isNotEmpty)
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newImages.length - images.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    InputImageWithLabel(
                      label: 'Product Image ${images.length + index + 1}',
                      previewImage: newImages[index],
                      setFunction: (source) async {
                        CroppedFile? img = await ImagePickCrop.process(
                            source: source,
                            ratio: [CropAspectRatioPreset.square]);

                        if (img != null) {
                          setState(() {
                            newImages[index] = File(img.path);
                          });
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 16),
          if (images.length + widget.productData['images'].length < 10)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  newImages.add(null);
                });
              },
              child: const Text('Add More Product Image'),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}
