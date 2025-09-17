import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error_handling/api_expections.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/model/sign_in_model.dart';
import '../../data/model/sign_up_model.dart';
import '../providers/providers.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final AuthRemoteDataSource _remoteDataSource;

  @override
  AuthState build() {
    _remoteDataSource = ref.read(authRemoteDataSourceProvider);
    return AuthState();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final req = SignInRequestModel(emailAddress: email, password: password);
      await _remoteDataSource.signIn(req);
      state = state.copyWith(loading: false, success: true);
    } catch (e) {
      state = state.copyWith(loading: false, error: _mapError(e));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final req = SignUpRequestModel(
        name: name,
        emailAddress: email,
        password: password,
        phoneNumber: phone,
      );
      await _remoteDataSource.signUp(req);
      state = state.copyWith(loading: false, success: true);
    } catch (e) {
      state = state.copyWith(loading: false, error: _mapError(e));
    }
  }

  String _mapError(Object e) => e is ApiException ? e.detail : e.toString();

  Future<void> signOut() async {
    await SecureStorage.clear();
    state = AuthState();
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);
