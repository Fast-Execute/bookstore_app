import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class AuthService {
  AuthService._();

  static SupabaseClient get _client => SupabaseService.client;

  static Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: 'io.bookstore.app://reset-password/',
    );
  }

  static Future<void> updatePassword(String password) async {
    await _client.auth.updateUser(
      UserAttributes(password: password),
    );
  }
}
