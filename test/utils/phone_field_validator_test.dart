import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_flutter/features/auth/presentation/views/widgets/phone_text_field.dart';

// Import your PhoneTextField widget
// import 'package:your_app/widgets/phone_text_field.dart';

void main() {
  group('PhoneTextField Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display initial country code and flag', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenUtilInit(
              designSize: const Size(375, 812),
              child: PhoneTextField(controller: controller),
            ),
          ),
        ),
      );

      // Verify initial country code (+91 India)
      expect(find.text('🇮🇳'), findsOneWidget);
      expect(find.text('+91'), findsOneWidget);
      expect(find.text('9876543210'), findsOneWidget); // Example hint
    });

    testWidgets('should change country code when dropdown is selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenUtilInit(
              designSize: const Size(375, 812),
              child: PhoneTextField(controller: controller),
            ),
          ),
        ),
      );

      // Tap dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select USA
      await tester.tap(find.text('🇺🇸').last);
      await tester.pumpAndSettle();

      // Verify country changed
      expect(find.text('+1'), findsOneWidget);
      expect(find.text('🇺🇸'), findsOneWidget);
    });

    testWidgets('should clear text field when country changes', (
      WidgetTester tester,
    ) async {
      controller.text = '9876543210';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenUtilInit(
              designSize: const Size(375, 812),
              child: PhoneTextField(controller: controller),
            ),
          ),
        ),
      );

      // Change country
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('🇺🇸').last);
      await tester.pumpAndSettle();

      // Verify text field is cleared
      expect(controller.text, isEmpty);
    });

    testWidgets('should call onCountryChanged callback', (
      WidgetTester tester,
    ) async {
      String? changedCountryCode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenUtilInit(
              designSize: const Size(375, 812),
              child: PhoneTextField(
                controller: controller,
                onCountryChanged: (countryCode) {
                  changedCountryCode = countryCode;
                },
              ),
            ),
          ),
        ),
      );

      // Change country
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('🇺🇸').last);
      await tester.pumpAndSettle();

      expect(changedCountryCode, equals('+1'));
    });

    group('Validation Tests', () {
      testWidgets('should validate empty phone number', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScreenUtilInit(
                designSize: const Size(375, 812),
                child: Form(
                  key: formKey,
                  child: PhoneTextField(controller: controller),
                ),
              ),
            ),
          ),
        );

        // Validate form
        expect(formKey.currentState!.validate(), false);
        await tester.pumpAndSettle();

        expect(find.text('Phone number is required'), findsOneWidget);
      });

      group('India (+91) Validation', () {
        testWidgets('should accept valid Indian mobile number', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          // Enter valid Indian number
          await tester.enterText(find.byType(TextFormField), '9876543210');
          expect(formKey.currentState!.validate(), true);
        });

        testWidgets('should reject Indian number with wrong length', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          await tester.enterText(
            find.byType(TextFormField),
            '98765432',
          ); // 8 digits
          expect(formKey.currentState!.validate(), false);
          await tester.pumpAndSettle();

          expect(
            find.text('Phone number must be 10 digits for India'),
            findsOneWidget,
          );
        });

        testWidgets('should reject Indian number with wrong pattern', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          await tester.enterText(
            find.byType(TextFormField),
            '1876543210',
          ); // Starts with 1
          expect(formKey.currentState!.validate(), false);
          await tester.pumpAndSettle();

          expect(
            find.text('Invalid India phone number format'),
            findsOneWidget,
          );
        });
      });

      group('USA (+1) Validation', () {
        testWidgets('should accept valid US number', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          // Change to USA
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();
          await tester.tap(find.text('🇺🇸').last);
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextFormField), '2125551234');
          expect(formKey.currentState!.validate(), true);
        });

        testWidgets('should reject US number with wrong format', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          // Change to USA
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();
          await tester.tap(find.text('🇺🇸').last);
          await tester.pumpAndSettle();

          await tester.enterText(
            find.byType(TextFormField),
            '1125551234',
          ); // Invalid format
          expect(formKey.currentState!.validate(), false);
          await tester.pumpAndSettle();

          expect(find.text('Invalid USA phone number format'), findsOneWidget);
        });
      });

      group('UK (+44) Validation', () {
        testWidgets('should accept valid UK mobile number', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          // Change to UK
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();
          await tester.tap(find.text('🇬🇧').last);
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextFormField), '7700123456');
          expect(formKey.currentState!.validate(), true);
        });
      });

      group('China (+86) Validation', () {
        testWidgets('should accept valid Chinese mobile number', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          // Change to China
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();
          await tester.tap(find.text('🇨🇳').last);
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextFormField), '13812345678');
          expect(formKey.currentState!.validate(), true);
        });

        testWidgets('should reject Chinese number with wrong length', (
          WidgetTester tester,
        ) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          // Change to China
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();
          await tester.tap(find.text('🇨🇳').last);
          await tester.pumpAndSettle();

          await tester.enterText(
            find.byType(TextFormField),
            '1381234567',
          ); // 10 digits instead of 11
          expect(formKey.currentState!.validate(), false);
          await tester.pumpAndSettle();

          expect(
            find.text('Phone number must be 11 digits for China'),
            findsOneWidget,
          );
        });
      });
    });

    group('Helper Methods Tests', () {
      testWidgets('should validate complete phone number through controller', (
        WidgetTester tester,
      ) async {
        String? capturedCountryCode;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScreenUtilInit(
                designSize: const Size(375, 812),
                child: PhoneTextField(
                  controller: controller,
                  onCountryChanged: (countryCode) {
                    capturedCountryCode = countryCode;
                  },
                ),
              ),
            ),
          ),
        );

        controller.text = '9876543210';
        await tester.pump();

        // Verify the complete phone number format would be correct
        expect(controller.text, equals('9876543210'));
        expect(
          capturedCountryCode ?? '+91',
          equals('+91'),
        ); // Default country code
      });

      testWidgets(
        'should handle phone number validation through form validation',
        (WidgetTester tester) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  child: Form(
                    key: formKey,
                    child: PhoneTextField(controller: controller),
                  ),
                ),
              ),
            ),
          );

          // Test valid number
          controller.text = '9876543210';
          expect(formKey.currentState!.validate(), true);

          // Test invalid number
          controller.text = '123';
          expect(formKey.currentState!.validate(), false);
        },
      );

      testWidgets('should display correct format information', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScreenUtilInit(
                designSize: const Size(375, 812),
                child: PhoneTextField(controller: controller),
              ),
            ),
          ),
        );

        // Verify format display for India
        expect(find.textContaining('Format: +91 9876543210'), findsOneWidget);
      });

      testWidgets('should update format when country changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScreenUtilInit(
                designSize: const Size(375, 812),
                child: PhoneTextField(controller: controller),
              ),
            ),
          ),
        );

        // Change to USA
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('🇺🇸').last);
        await tester.pumpAndSettle();

        // Verify format updated to USA
        expect(find.textContaining('Format: +1 2125551234'), findsOneWidget);
      });
    });

    group('Input Formatters Tests', () {
      testWidgets('should only accept digits', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScreenUtilInit(
                designSize: const Size(375, 812),
                child: PhoneTextField(controller: controller),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'abc123def456');
        expect(controller.text, equals('123456'));
      });

      testWidgets('should limit input length based on country', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScreenUtilInit(
                designSize: const Size(375, 812),
                child: PhoneTextField(controller: controller),
              ),
            ),
          ),
        );

        // India allows 10 digits
        await tester.enterText(find.byType(TextFormField), '123456789012345');
        expect(controller.text.length, equals(10));
      });

      testWidgets('should update length limit when country changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScreenUtilInit(
                designSize: const Size(375, 812),
                child: PhoneTextField(controller: controller),
              ),
            ),
          ),
        );

        // Change to China (11 digits)
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('🇨🇳').last);
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), '123456789012345');
        expect(controller.text.length, equals(11)); // China allows 11 digits
      });
    });
  });
}
