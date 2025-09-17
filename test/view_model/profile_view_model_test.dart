import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:mvvm_flutter/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mvvm_flutter/features/profile/presentation/providers/providers.dart';
import 'package:mvvm_flutter/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:riverpod/riverpod.dart';

import 'profile_view_model_test.mocks.dart';

// Generate mocks for GetProfileUseCase
@GenerateMocks([GetProfileUseCase])
void main() {
  late MockGetProfileUseCase mockUseCase;
  late ProviderContainer container;
  late ProfileViewModel viewModel;

  setUp(() {
    mockUseCase = MockGetProfileUseCase();
    container = ProviderContainer(
      overrides: [getProfileUseCaseProvider.overrideWithValue(mockUseCase)],
    );
    viewModel = container.read(profileViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is correct', () {
    final state = container.read(profileViewModelProvider);
    expect(state.loading, false);
    expect(state.profile, null);
    expect(state.error, null);
  });

  test('loadProfile sets profile when successful', () async {
    final mockProfile = ProfileEntity(
      name: 'Gasee',
      email: 'gasee@gmail.com',
      clientId: '123',
    );

    when(mockUseCase.call()).thenAnswer((_) async => mockProfile);

    final future = viewModel.loadProfile();
    // loading should be true immediately
    expect(container.read(profileViewModelProvider).loading, true);

    await future;

    final state = container.read(profileViewModelProvider);
    expect(state.loading, false);
    expect(state.profile, mockProfile);
    expect(state.error, null);
  });

  test('loadProfile sets error when exception occurs', () async {
    when(mockUseCase.call()).thenThrow(Exception('Failed'));

    await viewModel.loadProfile();

    final state = container.read(profileViewModelProvider);
    expect(state.loading, false);
    expect(state.profile, null);
    expect(state.error, contains('Failed'));
  });
}
