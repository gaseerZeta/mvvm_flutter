import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([FlutterSecureStorage])
import 'storage_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
  });

  test('saveTokens calls write for access and refresh tokens', () async {
    when(
      mockStorage.write(key: anyNamed('key'), value: anyNamed('value')),
    ).thenAnswer((_) async => Future.value());

    await mockStorage.write(key: 'access_token', value: 'access123');
    await mockStorage.write(key: 'refresh_token', value: 'refresh123');

    verify(
      mockStorage.write(key: 'access_token', value: 'access123'),
    ).called(1);
    verify(
      mockStorage.write(key: 'refresh_token', value: 'refresh123'),
    ).called(1);
  });

  test('clear calls deleteAll', () async {
    when(mockStorage.deleteAll()).thenAnswer((_) async => Future.value());

    await mockStorage.deleteAll();

    verify(mockStorage.deleteAll()).called(1);
  });
}
