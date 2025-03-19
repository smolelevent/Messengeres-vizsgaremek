import 'package:flutter_test/flutter_test.dart';
void main() {
  group('Registration Tests', () {
    test('Valid registration', () {
      final result = registerUser('validUser', 'validPassword123');
      expect(result, true);
    });

    test('Registration with empty username', () {
      final result = registerUser('', 'validPassword123');
      expect(result, false);
    });

    test('Registration with empty password', () {
      final result = registerUser('validUser', '');
      expect(result, false);
    });

    test('Registration with short password', () {
      final result = registerUser('validUser', '123');
      expect(result, false);
    });

    test('Registration with special characters in username', () {
      final result = registerUser('invalid@User!', 'validPassword123');
      expect(result, false);
    });
  });
}

// Mock function for demonstration purposes
bool registerUser(String username, String password) {
  if (username.isEmpty || password.isEmpty) return false;
  if (password.length < 6) return false;
  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(username)) return false;
  return true;
}
