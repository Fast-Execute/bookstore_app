import '../models/book.dart';
import '../services/book_service.dart';

class BookRepository {
  final BookService _bookService;

  BookRepository({
    BookService? bookService,
  }) : _bookService = bookService ?? BookService();

  Future<List<Book>> getPublishedBooks() {
    return _bookService.getPublishedBooks();
  }

  Future<Book?> getBookById(String id) {
    return _bookService.getBookById(id);
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
  }) {
    return _bookService.createBook(
      title: title,
      author: author,
      category: category,
      description: description,
      priceZar: priceZar,
      pdfPath: pdfPath,
      coverPath: coverPath,
      published: published,
    );
  }

  Future<String> getBookPdfUrl(String pdfPath) {
    return _bookService.getBookPdfUrl(pdfPath);
  }
}
