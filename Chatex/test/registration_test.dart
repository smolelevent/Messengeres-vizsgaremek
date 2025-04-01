import 'package:flutter_test/flutter_test.dart';
void main() {
  group('Registration Tests', () {
    test('Valid registration', () {
      final result = registerUser('validEmail', 'validPassword123');
      expect(result, true);
    });

    test('Registration with empty email', () {
      final result = registerUser('', 'validPassword123');
      expect(result, false);
    });

    test('Registration with empty password', () {
      final result = registerUser('validEmail', '');
      expect(result, false);
    });

    test('Registration with short password', () {
      final result = registerUser('validEmail', '123');
      expect(result, false);
    });

    test('Registration with special characters in password', () {
      final result = registerUser('validEmail', '@nval!dPassword123)');
      expect(result, true);
    });
  });
}

// Mock function for demonstration purposes
bool registerUser(String email, String password) {
  if (email.isEmpty || password.isEmpty) return false;
  if (password.length < 6) return false;
  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(email)) return false;
  return true;
}
