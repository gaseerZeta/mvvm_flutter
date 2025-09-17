import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_flutter/core/error_handling/api_expections.dart';
import 'package:mvvm_flutter/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:mvvm_flutter/features/auth/presentation/providers/providers.dart';
import 'package:mvvm_flutter/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:riverpod/riverpod.dart';

import 'auth_view_model_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRemoteDataSource mockRemoteDataSource;
  late ProviderContainer container;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    container = ProviderContainer(
      overrides: [
        authRemoteDataSourceProvider.overrideWithValue(mockRemoteDataSource),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('signIn success updates state correctly', () async {
    // Arrange
    when(
      mockRemoteDataSource.signIn(any),
    ).thenAnswer((_) async => Future.value());

    final viewModel = container.read(authViewModelProvider.notifier);

    // Act
    await viewModel.signIn(email: 'test@mail.com', password: '123456');

    // Assert
    final state = container.read(authViewModelProvider);
    expect(state.loading, false);
    expect(state.success, true);
    expect(state.error, null);

    verify(mockRemoteDataSource.signIn(any)).called(1);
  });

  test('signIn failure sets error in state', () async {
    when(
      mockRemoteDataSource.signIn(any),
    ).thenThrow(ApiException(detail: 'Invalid credentials', title: ''));

    final viewModel = container.read(authViewModelProvider.notifier);

    await viewModel.signIn(email: 'test@mail.com', password: 'wrong');

    final state = container.read(authViewModelProvider);
    expect(state.loading, false);
    expect(state.success, false);
    expect(state.error, 'Invalid credentials');
  });

  test('signUp success updates state correctly', () async {
    when(
      mockRemoteDataSource.signUp(any),
    ).thenAnswer((_) async => Future.value());

    final viewModel = container.read(authViewModelProvider.notifier);

    await viewModel.signUp(
      name: 'User',
      email: 'user@mail.com',
      password: '123456',
      phone: '1234567890',
    );

    final state = container.read(authViewModelProvider);
    expect(state.loading, false);
    expect(state.success, true);
    expect(state.error, null);
  });

  test('signOut clears state', () async {
    final viewModel = container.read(authViewModelProvider.notifier);

    await viewModel.signOut();

    final state = container.read(authViewModelProvider);
    expect(state.loading, false);
    expect(state.success, false);
    expect(state.error, null);
  });
}
