import 'dart:convert';

class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final double priceZar;
  final String? coverPath;
  final String? pdfPath;
  final bool published;
  final DateTime? createdAt;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.priceZar,
    this.coverPath,
    this.pdfPath,
    required this.published,
    this.createdAt,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'].toString(),
      title: map['title']?.toString() ?? '',
      author: map['author']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      priceZar: (map['price_zar'] as num?)?.toDouble() ?? 0,
      coverPath: map['cover_path']?.toString(),
      pdfPath: map['pdf_path']?.toString(),
      published: map['published'] == true,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'price_zar': priceZar,
      'cover_path': coverPath,
      'pdf_path': pdfPath,
      'published': published,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Book.fromJson(String source) {
    return Book.fromMap(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}
