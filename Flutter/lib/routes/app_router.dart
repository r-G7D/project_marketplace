import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_marketplace/features/account/presentation/landing_screen.dart';
import 'package:project_marketplace/features/account/presentation/login_screen.dart';
import 'package:project_marketplace/features/account/presentation/profile_screen.dart';
import 'package:project_marketplace/features/account/presentation/register_screen.dart';
import 'package:project_marketplace/features/dashboard/presentation/dashboard_screen.dart';
import 'package:project_marketplace/features/product/presentation/add_product_screen.dart';
import 'package:project_marketplace/features/product/presentation/ar_screen.dart';
import 'package:project_marketplace/features/product/presentation/edit_product_screen.dart';
import 'package:project_marketplace/features/product/presentation/product_screen.dart';
import 'app_route_enum.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey2 = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/landing',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/landing',
        name: AppRoute.landing.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const LandingScreen(),
        ),
        routes: [
          GoRoute(
            path: 'login',
            name: AppRoute.login.name,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LoginScreen(),
            ),
          ),
          GoRoute(
            path: 'register',
            name: AppRoute.register.name,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const RegisterScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRoute.dashboard.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
          path: '/product',
          name: AppRoute.product.name,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: ProductScreen(
                  // productData: state.extra as Map<String, dynamic>,
                  productId: state.extra as String,
                ),
              ),
          routes: [
            GoRoute(
              path: 'add_product',
              name: AppRoute.addProduct.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const AddProductScreen(),
              ),
            ),
            GoRoute(
              path: 'edit_product',
              name: AppRoute.editProduct.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: EditProductScreen(
                  productData: state.extra as Map<String, dynamic>,
                ),
              ),
            ),
            GoRoute(
              path: 'ar_product',
              name: AppRoute.arProduct.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: ProductARScreen(url: state.extra as String),
              ),
            ),
          ]),
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
    ],
  );
});
