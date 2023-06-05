import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:project_marketplace/api/failure/failure.dart';
import 'package:project_marketplace/features/account/data/account.dart';
import 'package:project_marketplace/features/product/data/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'pref/pref_keys.dart';

part 'api_service.g.dart';

final pb = PocketBase(dotenv.env['BASE_URL']!);

final apiServiceProvider = Provider<APIService>((ref) {
  return APIService();
});

dynamic authModel;

@Riverpod(keepAlive: true)
class APIService extends _$APIService {
  @override
  FutureOr<void> build() {}

  Future register({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required String name,
  }) async {
    final body = {
      'email': email,
      'username': username,
      'password': password,
      'passwordConfirm': confirmPassword,
      'name': name,
    };
    try {
      await pb.collection('users').create(body: body);
      debugPrint('User created');
      return true;
    } on ClientException catch (e) {
      debugPrint('Register failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  Future login(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      debugPrint('Logged in | id: ${pb.authStore.model.id}');
      authModel = pb.authStore.model.toJson();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(PrefKeys.accessTokenPrefsKey, pb.authStore.token);
      prefs.setString(
          PrefKeys.accessModelPrefsKey, pb.authStore.model.id ?? '');
      prefs.setString(PrefKeys.accessNamePrefsKey, authModel['username'] ?? '');
      return true;
    } on ClientException catch (e) {
      debugPrint('Login failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  Future updateAccount({
    String? name,
    String? saved,
  }) async {
    final Map<String, dynamic> body = {};
    try {
      if (name != null) body['name'] = name;
      if (saved != null) body['saved'] = authModel['saved']..add(saved);
      await pb.collection('users').update(
            pb.authStore.model.id,
            body: body,
          );
      debugPrint('Saved Product added');
      return true;
    } on ClientException catch (e) {
      debugPrint('Add Saved Product failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  Future logout() async {
    try {
      pb.authStore.clear();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(PrefKeys.accessTokenPrefsKey);
      prefs.remove(PrefKeys.accessModelPrefsKey);
      prefs.remove(PrefKeys.accessNamePrefsKey);
      debugPrint('Logged out');
      return true;
    } on ClientException catch (e) {
      debugPrint('Logout failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  String get userId {
    return pb.authStore.model.id ?? '';
  }

  bool get isAuth {
    return pb.authStore.isValid && pb.authStore.token.isNotEmpty;
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      pb.authStore.save(prefs.getString(PrefKeys.accessTokenPrefsKey) ?? '',
          prefs.getString(PrefKeys.accessModelPrefsKey) ?? '');
      if (!pb.authStore.isValid) {
        return false;
      }
      state = const AsyncData(null);
      return true;
    } catch (e) {
      debugPrint('Login failed');
      return false;
    }
  }

  Future<dynamic> fetchProduct(String id) async {
    try {
      final res = await pb.collection('products').getOne(id);
      debugPrint('Product fetched');
      final product = Product.fromJson(res.toJson());
      final productAr = res.getListValue<String>('ar_image');
      final productArUrl = pb.files.getUrl(res, productAr.first).toString();
      final productImage = res.getListValue<String>('image');
      final productImageUrls =
          productImage.map((e) => pb.files.getUrl(res, e).toString()).toList();
      return {
        'product': product,
        'arImage': productArUrl,
        'images': productImageUrls,
      };
    } on ClientException catch (e) {
      debugPrint('Fetch Product failed | ${e.response.toString()}');
      return Failure.fromJson(e);
    }
  }

  Future<String> fetchArImage(String id) async {
    try {
      final res = await pb.collection('products').getOne(id);
      debugPrint('AR Image fetched');
      final arImage = res.getStringValue('ar_image');
      final url = pb.files.getUrl(res, arImage).toString();
      return url;
    } on ClientException catch (e) {
      debugPrint('Fetch AR Image failed | ${e.response.toString()}');
      return '';
    }
  }

  Future<List<String>> fetchImages(String id) async {
    try {
      final res = await pb.collection('products').getOne(id);
      debugPrint('Images fetched');
      final imgList = res.getListValue<String>('image');
      final url =
          imgList.map((e) => pb.files.getUrl(res, e).toString()).toList();
      return url;
    } on ClientException catch (e) {
      debugPrint('Fetch Images failed | ${e.response.toString()}');
      return [];
    }
  }

  Future addProduct({
    required String name,
    required String desc,
    required File? arImage,
    required List<File?>? image,
  }) async {
    final body = {
      'name': name,
      'desc': desc,
      'user': pb.authStore.model.id,
    };
    final files = [
      await http.MultipartFile.fromPath(
        'ar_image',
        arImage!.path,
        filename: arImage.toString(),
      ),
      for (var i = 0; i < image!.length; i++)
        await http.MultipartFile.fromPath(
          'image',
          image[i]!.path,
          filename: image[i]!.toString(),
        ),
    ];
    try {
      await pb.collection('products').create(body: body, files: files);
      debugPrint('Product added');
      return true;
    } on ClientException catch (e) {
      debugPrint('Add Product failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  Future updateProduct({
    required String id,
    String? name,
    String? desc,
    File? arImage,
    List<File?>? image,
  }) async {
    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (desc != null) body['desc'] = desc;
    final files = [
      if (arImage != null)
        await http.MultipartFile.fromPath(
          'ar_image',
          arImage.path,
          filename: arImage.toString(),
        ),
      if (image!.contains(null) == false)
        for (var i = 0; i < image.length; i++)
          await http.MultipartFile.fromPath(
            'image',
            image[i]!.path,
            filename: image[i].toString(),
          ),
    ];
    try {
      files == []
          ? await pb.collection('products').update(id, body: body)
          : await pb
              .collection('products')
              .update(id, body: body, files: files);
      debugPrint('Product updated');
      return true;
    } on ClientException catch (e) {
      debugPrint('Update Product failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  Future deleteProduct(String id) async {
    try {
      await pb.collection('products').delete(id);
      debugPrint('Product deleted');
      return true;
    } on ClientException catch (e) {
      debugPrint('Delete Product failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  Future authRefresh() async {
    try {
      await pb.collection('users').authRefresh();
      debugPrint('Refreshed | id: ${pb.authStore.model.id}');
      return true;
    } on ClientException catch (e) {
      debugPrint('Refresh failed | ${e.response.toString()}');
      // return Failure.fromJson(e);
      return false;
    }
  }

  Future loginAdmin() async {
    try {
      await pb.admins.authWithPassword(
          dotenv.env['ADMIN_USERNAME']!, dotenv.env['ADMIN_PASSWORD']!);
      debugPrint('Admin Logged in | id: ${pb.authStore.model.id}');
    } on ClientException catch (e) {
      debugPrint('Admin Login failed | ${e.response.toString()}');
      return Failure.fromJson(e);
    }
  }

  Future<Uint8List> setArImage(String path) async {
    var request = http.MultipartRequest('POST', Uri.parse(dotenv.env['AR']!));
    request.files.add(await http.MultipartFile.fromPath('image_file', path));
    request.headers.addAll({dotenv.env['AR_XKEY']!: dotenv.env['AR_KEY']!});
    final response = await request.send();
    if (response.statusCode == 200) {
      http.Response res = await http.Response.fromStream(response);
      return res.bodyBytes;
    } else {
      throw Exception('Error with ${response.statusCode}');
    }
  }
}

@riverpod
Future<dynamic> fetchAccount(FetchAccountRef ref) async {
  try {
    final id = pb.authStore.model.id!;
    final res = await pb.collection('users').getOne(id);
    debugPrint('Account fetched | id: $id');
    return Account.fromJson(res.toJson());
  } on ClientException catch (e) {
    debugPrint('Fetch Account failed | ${e.response.toString()}');
    return Failure.fromJson(e);
  }
}

@riverpod
Future<dynamic> fetchProducts(FetchProductsRef ref) async {
  try {
    final res = await pb.collection('products').getFullList();
    final productList = res.map((e) => Product.fromJson(e.toJson())).toList();
    debugPrint('${productList.length} products fetched');
    return productList;
  } on ClientException catch (e) {
    debugPrint('Fetch Product List failed | ${e.response.toString()}');
    return Failure.fromJson(e);
  }
}
