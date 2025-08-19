import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result_status.freezed.dart';

@freezed
sealed class ApiResultStatus<T> with _$ApiResultStatus<T> {
  const factory ApiResultStatus.initial() = Initial<T>;

  const factory ApiResultStatus.loading() = Loging<T>;

  const factory ApiResultStatus.data({required T data}) = Data<T>;

  const factory ApiResultStatus.error({required Exception error}) = Error<T>;
}
