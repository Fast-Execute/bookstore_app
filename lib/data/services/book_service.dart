import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/book.dart';
import 'storage_service.dart';
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

    if (response == null) return null;

    return Book.fromMap(Map<String, dynamic>.from(response));
  }

  Future<Book> createBook({
    required String title,
    required String author,
    required String category,
    required String description,
    required double priceZar,
    required String pdfPath,
    String? coverPath,
    bool published = true,
  }) async {
    final response = await _client
        .from('books')
        .insert({
          'title': title.trim(),
          'author': author.trim(),
          'category': category,
          'description': description.trim(),
          'price_zar': priceZar,
          'cover_path': coverPath,
          'pdf_path': pdfPath,
          'published': published,
        })
        .select()
        .single();

    return Book.fromMap(Map<String, dynamic>.from(response));
  }

  Future<String> getBookPdfUrl(String pdfPath) {
    return StorageService.createBookPdfSignedUrl(path: pdfPath);
  }
}
