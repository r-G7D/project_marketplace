import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_marketplace/routes/app_route_enum.dart';

import '../../../api/api_service.dart';

class ProductScreen extends ConsumerStatefulWidget {
  // final Map<String, dynamic> productData;
  final String productId;
  const ProductScreen({
    super.key,
    required this.productId,
    // required this.productData,
  });

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  void _save(String id) async {
    final success = await ref.read(apiServiceProvider).updateAccount(saved: id);
    if (success) {
      Future.delayed(const Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product saved to Collection'),
          ),
        );
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save product'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.watch(apiServiceProvider).fetchProduct(widget.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          final productData = snapshot.data as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text(productData['product'].name!),
              actions: [
                productData['product'].user ==
                        ref.read(apiServiceProvider).userId
                    ? IconButton(
                        onPressed: () {
                          context.pushNamed(AppRoute.editProduct.name,
                              extra: productData);
                        },
                        icon: const Icon(Icons.edit),
                      )
                    : IconButton(
                        onPressed: () {
                          _save(productData['product'].id);
                        },
                        icon: const Icon(Icons.bookmark),
                      ),
              ],
            ),
            floatingActionButton: SizedBox(
              height: 50,
              width: 200,
              child: InkWell(
                onTap: () {
                  context.pushNamed(
                    AppRoute.arProduct.name,
                    extra: productData['arImage'],
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue,
                  ),
                  child: const Center(
                      child: Text('Try Virtually',
                          style: TextStyle(fontSize: 20, color: Colors.white))),
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                    ),
                    items: productData['images']
                        .map<Widget>(
                          (item) => Container(
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: item,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Text(productData['product'].desc!,
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Failed to load product'),
            ),
          );
        }
      },
    );
  }
}
