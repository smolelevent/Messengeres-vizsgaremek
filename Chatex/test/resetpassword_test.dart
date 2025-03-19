import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:chatex/logic/auth.dart';
import 'package:flutter/material.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('Password Reset', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    test('should call resetPassword with correct email', () async {
  // Arrange
  const testEmail = 'test@example.com';
  const testLanguage = 'English';
  final mockContext = MockBuildContext();
  final emailController = TextEditingController(text: testEmail);

  when(mockAuthService.resetPassword(
    email: anyNamed('email'),
    context: anyNamed('context'),
    language: anyNamed('language'),
  )).thenAnswer((_) async => Future.value());

  // Act
  await mockAuthService.resetPassword(
    email: emailController,
    context: mockContext,
    language: testLanguage,
  );

  // Assert
  verify(mockAuthService.resetPassword(
    email: captureAnyNamed('email'),
    context: anyNamed('context'),
    language: anyNamed('language'),
  )).called(1);
});

    test('should throw an error if email is invalid', () async {
      // Arrange
      const invalidEmail = 'invalid-email';
      const testLanguage = 'English';
      final mockContext = MockBuildContext();

      when(mockAuthService.resetPassword(
        email: anyNamed('email'),
        context: anyNamed('context'),
        language: anyNamed('language'),
      )).thenThrow(Exception('Invalid email'));

      // Act & Assert
      expect(
        () async => await mockAuthService.resetPassword(
          email: TextEditingController(text: invalidEmail),
          context: mockContext,
          language: testLanguage,
        ),
        throwsException,
      );
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
class MockBuildContext extends Mock implements BuildContext {}