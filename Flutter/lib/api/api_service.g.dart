// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAccountHash() => r'c36cc621fd7800774e09d9104b11962409f59f3c';

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
String _$fetchProductsHash() => r'20266ff259742f8f32202f38029795e768f13b78';

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
String _$aPIServiceHash() => r'fd51f55e72793fed1f5331c1f742c51a77598866';

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
