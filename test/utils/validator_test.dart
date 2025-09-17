import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_flutter/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('returns error if email is null', () {
        final result = Validators.validateEmail(null);
        expect(result, 'Email is required');
      });

      test('returns error if email is empty', () {
        final result = Validators.validateEmail('');
        expect(result, 'Email is required');
      });

      test('returns error if email is invalid', () {
        final result = Validators.validateEmail('invalidemail');
        expect(result, 'Enter a valid email address');
      });

      test('returns null if email is valid', () {
        final result = Validators.validateEmail('test@example.com');
        expect(result, null);
      });
    });

    // Password Tests
    group('validatePassword', () {
      test('returns error if password is null', () {
        final result = Validators.validatePassword(null);
        expect(result, 'Password is required');
      });

      test('returns error if password is empty', () {
        final result = Validators.validatePassword('');
        expect(result, 'Password is required');
      });

      test('returns error if password is less than 6 chars', () {
        final result = Validators.validatePassword('12345');
        expect(result, 'Password must be at least 6 characters');
      });

      test('returns null if password is valid', () {
        final result = Validators.validatePassword('123456');
        expect(result, null);
      });
    });

    // Phone Tests
    group('validatePhone', () {
      test('returns error if phone is null', () {
        final result = Validators.validatePhone(null);
        expect(result, 'Phone number is required');
      });

      test('returns error if phone is empty', () {
        final result = Validators.validatePhone('');
        expect(result, 'Phone number is required');
      });

      test('returns error if phone has less than 7 digits', () {
        final result = Validators.validatePhone('123456');
        expect(result, 'Enter a valid phone number');
      });

      test('returns error if phone has more than 15 digits', () {
        final result = Validators.validatePhone('1234567890123456');
        expect(result, 'Enter a valid phone number');
      });

      test('returns error if phone contains non-digit characters', () {
        final result = Validators.validatePhone('+919191919191');
        expect(result, 'Enter a valid phone number');
      });

      test('returns null if phone is valid', () {
        final result = Validators.validatePhone('919191919191');
        expect(result, null);
      });
    });
  });
}
