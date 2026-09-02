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
}
