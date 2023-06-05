import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_marketplace/api/api_service.dart';
import '../../../routes/app_route_enum.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoute.profile.name);
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () async {
            context.pushNamed(AppRoute.addProduct.name);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 14,
          ),
        ),
      ),
      body: ListView(
        children: [
          productList(),
        ],
      ),
    );
  }

  Widget productList() {
    return Consumer(
      builder: (context, ref, child) {
        final productAsync = ref.watch(fetchProductsProvider);
        return productAsync.when(data: (products) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.desc),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final imgList = await ref
                      .read(apiServiceProvider)
                      .fetchImages(product.id);
                  final arImg = await ref
                      .read(apiServiceProvider)
                      .fetchArImage(product.id);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      context.pushNamed(
                        AppRoute.product.name,
                        extra: {
                          'product': product,
                          'arImage': arImg,
                          'images': imgList,
                        },
                      );
                    }
                  });
                },
              );
            },
          );
        }, error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
      },
    );
  }
}
