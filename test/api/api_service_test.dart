import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_flutter/core/error_handling/api_expections.dart';
import 'package:mvvm_flutter/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:mvvm_flutter/features/auth/data/model/sign_in_model.dart';
import 'package:mvvm_flutter/features/auth/data/model/sign_up_model.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  group('signIn', () {
    final tRequest = SignInRequestModel(
      emailAddress: 'test@mail.com',
      password: '123456',
    );
    final tResponseData = {
      "authToken": "token123",
      "refreshToken": "refresh123",
    };

    test('returns AuthResponseModel on 200 response', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/account/signin'),
          statusCode: 200,
          data: tResponseData,
        ),
      );

      // act
      final result = await dataSource.signIn(tRequest);

      // assert
      expect(result.authToken, tResponseData['authToken']);
      expect(result.refreshToken, tResponseData['refreshToken']);
      verify(
        mockDio.post('/api/v1/account/signin', data: tRequest.toJson()),
      ).called(1);
    });

    test('throws ApiException on DioException with response', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/account/signin'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/account/signin'),
            statusCode: 400,
            data: {"title": "Bad Request", "detail": "Invalid credentials"},
          ),
        ),
      );

      expect(() => dataSource.signIn(tRequest), throwsA(isA<ApiException>()));
    });
  });

  group('signUp', () {
    final tRequest = SignUpRequestModel(
      name: 'User',
      emailAddress: 'user@mail.com',
      password: '123456',
      phoneNumber: '1234567890',
    );
    final tResponseData = {
      "authToken": "signupToken123",
      "refreshToken": "signupRefresh123",
    };

    test('returns AuthResponseModel on 201 response', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/account/signup'),
          statusCode: 201,
          data: tResponseData,
        ),
      );

      final result = await dataSource.signUp(tRequest);

      expect(result.authToken, tResponseData['authToken']);
      expect(result.refreshToken, tResponseData['refreshToken']);
      verify(
        mockDio.post('/api/v1/account/signup', data: tRequest.toJson()),
      ).called(1);
    });

    test('throws ApiException on DioException with response', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/account/signup'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/account/signup'),
            statusCode: 400,
            data: {"title": "Bad Request", "detail": "Invalid payload"},
          ),
        ),
      );

      expect(() => dataSource.signUp(tRequest), throwsA(isA<ApiException>()));
    });
  });
}
