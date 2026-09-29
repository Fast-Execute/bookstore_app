import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class StorageService {
  StorageService._();

  static SupabaseClient get _client => SupabaseService.client;

  static const booksBucket = 'books';

  static Future<String> uploadBookPdf({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('You must be signed in to upload a book.');
    }

    final safeName = fileName
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    final path =
        userId + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '_' + safeName;

    await _client.storage.from(booksBucket).uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'application/pdf',
        upsert: false,
      ),
    );

    return path;
  }

  static Future<void> deleteBookPdf(String path) async {
    if (path.trim().isEmpty) return;
    await _client.storage.from(booksBucket).remove([path]);
  }

  static Future<String> createBookPdfSignedUrl({
    required String path,
    int expiresInSeconds = 3600,
  }) {
    return _client.storage
        .from(booksBucket)
        .createSignedUrl(path, expiresInSeconds);
  }
}
