import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // Add your API call or Firebase Auth logic here to send the password reset email
      // For example:
      // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // If successful, return true
      return true;
    } catch (error) {
      // If there's an error, return false
      return false;
    }
  }
}
