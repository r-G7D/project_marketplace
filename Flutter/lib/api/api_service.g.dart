// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAccountHash() => r'50eba8c6c4ad7220c9b4450444171a5d86835b97';

/// See also [fetchAccount].
@ProviderFor(fetchAccount)
final fetchAccountProvider = AutoDisposeFutureProvider<dynamic>.internal(
  fetchAccount,
  name: r'fetchAccountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchAccountRef = AutoDisposeFutureProviderRef<dynamic>;
String _$fetchProductsHash() => r'bf7c58eb344bdcb3be2f3349b2c7e4a524c9658e';

/// See also [fetchProducts].
@ProviderFor(fetchProducts)
final fetchProductsProvider = AutoDisposeFutureProvider<dynamic>.internal(
  fetchProducts,
  name: r'fetchProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchProductsRef = AutoDisposeFutureProviderRef<dynamic>;
String _$aPIServiceHash() => r'5c25a2e89c3c1b04eb9e8303d11d5d6198504439';

/// See also [APIService].
@ProviderFor(APIService)
final aPIServiceProvider = AsyncNotifierProvider<APIService, void>.internal(
  APIService.new,
  name: r'aPIServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aPIServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$APIService = AsyncNotifier<void>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
