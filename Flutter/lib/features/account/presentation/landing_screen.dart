import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_marketplace/api/api_service.dart';
import 'package:project_marketplace/routes/app_route_enum.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  @override
  void initState() {
    ref.read(apiServiceProvider).isAuth ? null : tryLogin();
    debugPrint('isAuth: ${ref.read(apiServiceProvider).isAuth.toString()}');
    super.initState();
  }

  void tryLogin() async {
    final success = await ref.read(apiServiceProvider).tryAutoLogin();
    debugPrint('tryLogin: $success');
    if (success) {
      Future.delayed(const Duration(microseconds: 500), () {
        context.goNamed(AppRoute.dashboard.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRoute.login.name);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRoute.register.name);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
