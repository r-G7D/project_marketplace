import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_marketplace/api/api_service.dart';
import 'package:project_marketplace/features/account/data/account.dart';

import '../../../routes/app_route_enum.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _logout() {
    ref.read(apiServiceProvider).logout();
    context.goNamed(AppRoute.landing.name);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(fetchAccountProvider);
    return profileAsync.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name, style: const TextStyle(fontSize: 20)),
                Text(data.email, style: const TextStyle(fontSize: 20)),
                data.products.length == 0
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text('Products:',
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.products.length,
                            itemBuilder: (context, index) {
                              final product = data.products[index];
                              return FutureBuilder(
                                future: ref
                                    .read(apiServiceProvider)
                                    .fetchProduct(product),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return ListTile(
                                    title: Text(snapshot.data.name),
                                    subtitle: Text(snapshot.data.desc),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      context.pushNamed(AppRoute.product.name,
                                          extra: snapshot.data);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                data.saved.length == 0
                    ? const SizedBox()
                    : Column(
                        children: [
                          const Text('Collection:',
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.saved.length,
                            itemBuilder: (context, index) {
                              final saved = data.saved[index];
                              return FutureBuilder(
                                future: ref
                                    .read(apiServiceProvider)
                                    .fetchProduct(saved),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return ListTile(
                                    title: Text(snapshot.data['product'].name),
                                    subtitle:
                                        Text(snapshot.data['product'].desc),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      context.pushNamed(AppRoute.product.name,
                                          extra: snapshot.data);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                Center(
                  child: ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (err, trace) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(err.toString()),
              ],
            ),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
