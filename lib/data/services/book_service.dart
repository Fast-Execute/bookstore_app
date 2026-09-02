import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/book.dart';
import 'supabase_service.dart';

class BookService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<Book>> getPublishedBooks() async {
    final response = await _client
        .from('books')
        .select()
        .eq('published', true)
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (row) => Book.fromMap(
            Map<String, dynamic>.from(row),
          ),
        )
        .toList();
  }

  Future<Book?> getBookById(String id) async {
    final response = await _client
        .from('books')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Book.fromMap(
      Map<String, dynamic>.from(response),
    );
  }
}
