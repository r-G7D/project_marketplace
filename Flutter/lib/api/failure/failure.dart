import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'failure.freezed.dart';
part 'failure.g.dart';

@freezed
class Failure with _$Failure {
  factory Failure({
    int? code,
    String? message,
  }) = _Failure;

  factory Failure.fromJson(ClientException json) =>
      _$FailureFromJson(json.response);
}
