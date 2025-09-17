import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dio: ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  );
});

final signInUseCaseProvider = Provider(
  (ref) => SignInUseCase(ref.read(authRepositoryProvider)),
);
final signUpUseCaseProvider = Provider(
  (ref) => SignUpUseCase(ref.read(authRepositoryProvider)),
);

class AuthState {
  final bool loading;
  final String? error;
  final bool success;

  AuthState({this.loading = false, this.error, this.success = false});

  AuthState copyWith({bool? loading, String? error, bool? success}) =>
      AuthState(
        loading: loading ?? this.loading,
        error: error,
        success: success ?? this.success,
      );
}
