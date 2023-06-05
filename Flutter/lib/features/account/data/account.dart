import 'package:freezed_annotation/freezed_annotation.dart';

import '../../product/data/product.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  factory Account({
    required String id,
    String? username,
    String? email,
    String? name,
    String? avatar,
    List<String>? products,
    List<String>? saved,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
