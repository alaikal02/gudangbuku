import 'package:flutter/foundation.dart';
import '../models/book.dart';

class BookService extends ChangeNotifier {
  final List<Book> _books = [
    Book(
      id: 'b1',
      title: 'Laskar Pelangi',
      stock: 45,
      publisher: 'Bentang Pustaka',
      author: 'Andrea Hirata',
      price: 85000,
      notes: 'Novel best seller nusantara',
    ),
    Book(
      id: 'b2',
      title: 'Bumi Manusia',
      stock: 12,
      publisher: 'Lentera Dipantara',
      author: 'Pramoedya Ananta Toer',
      price: 110000,
    ),
    Book(
      id: 'b3',
      title: 'Filosofi Teras',
      stock: 3, // Low stock demo
      publisher: 'Kompas',
      author: 'Henry Manampiring',
      price: 98000,
    ),
    Book(
      id: 'b4',
      title: 'Atomic Habits (Edisi Bahasa Indonesia)',
      stock: 28,
      publisher: 'Gramedia Pustaka Utama',
      author: 'James Clear',
      price: 108000,
    ),
  ];

  String _searchQuery = '';

  List<Book> get books {
    if (_searchQuery.trim().isEmpty) {
      return List.unmodifiable(_books);
    }
    final q = _searchQuery.toLowerCase();
    return _books.where((b) {
      final matchesTitle = b.title.toLowerCase().contains(q);
      final matchesPublisher = b.publisher.toLowerCase().contains(q);
      final matchesAuthor = b.author?.toLowerCase().contains(q) ?? false;
      return matchesTitle || matchesPublisher || matchesAuthor;
    }).toList();
  }

  String get searchQuery => _searchQuery;

  int get totalTitles => _books.length;

  int get totalStock => _books.fold(0, (sum, item) => sum + item.stock);

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addBook(Book book) {
    _books.insert(0, book);
    notifyListeners();
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((b) => b.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  void deleteBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  bool adjustStock(String bookId, int delta) {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index == -1) return false;

    final currentBook = _books[index];
    final newStock = currentBook.stock + delta;

    if (newStock < 0) {
      return false; // Prevent negative stock
    }

    _books[index] = currentBook.copyWith(stock: newStock);
    notifyListeners();
    return true;
  }
}
