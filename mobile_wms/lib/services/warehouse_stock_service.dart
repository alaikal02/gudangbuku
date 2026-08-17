import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../models/stock_movement.dart';

class WarehouseStockService extends ChangeNotifier {
  final List<Book> _books = [
    Book(
      id: 'ds-01',
      title: 'Nadham Qaidah Sharfiyyah (Saku)',
      isbn: '978-602-0853-20-4',
      category: 'Nahwu, Sharaf & Alat',
      stock: 350,
      safetyThreshold: 30,
      publisher: 'Darussholah',
      author: 'K.H. M. Anwar',
      locationZone: 'Zona B',
      locationRack: 'Rak 01',
      locationBin: 'Bin A',
      price: 55000,
      costPrice: 22000,
      weightGram: 120,
      pages: '96 Halaman',
      size: '10 x 14 cm (Saku)',
      coverType: 'Softcover',
      notes: 'Buku saku hafalan santri Ibtidaiyah/Dasar.',
    ),
    Book(
      id: 'ds-02',
      title: 'Trjmh F.Qorib Zaman Now (Saku)',
      isbn: '978-602-0853-21-1',
      category: 'Fiqih & Syariah',
      stock: 18, // STOK MENIPIS (< 25)
      safetyThreshold: 25,
      publisher: 'Darussholah',
      author: 'Tim Redaksi Darussholah',
      locationZone: 'Zona A',
      locationRack: 'Rak 01',
      locationBin: 'Bin B',
      price: 60000,
      costPrice: 25000,
      weightGram: 180,
      pages: '180 Halaman',
      size: '10 x 14 cm (Saku)',
      coverType: 'Softcover',
      notes: 'Terjemah fikih kontemporer populer. Perlu jadwal cetak ulang.',
    ),
    Book(
      id: 'ds-03',
      title: 'Fiqih Populer Saku (Trjmh F.Mu\'in)',
      isbn: '978-602-0853-22-8',
      category: 'Fiqih & Syariah',
      stock: 120,
      safetyThreshold: 15,
      publisher: 'Darussholah',
      author: 'K.H. Hamim Djazuli',
      locationZone: 'Zona A',
      locationRack: 'Rak 02',
      locationBin: 'Bin A',
      price: 120000,
      costPrice: 48000,
      weightGram: 250,
      pages: '310 Halaman',
      size: '11 x 15 cm (Saku)',
      coverType: 'Softcover',
      notes: 'Rujukan santri Aliyah/Senior.',
    ),
    Book(
      id: 'ds-04',
      title: 'Fiqih Populer: Terjemah Fathul Mu\'in 1,2,3',
      isbn: '978-602-0853-23-5',
      category: 'Fiqih & Syariah',
      stock: 45,
      safetyThreshold: 10,
      publisher: 'Darussholah',
      author: 'Lembaga Kajian Fikih Darussholah',
      locationZone: 'Zona A',
      locationRack: 'Rak 03',
      locationBin: 'Bin C',
      price: 200000,
      costPrice: 85000,
      weightGram: 1200,
      pages: '750 Halaman',
      size: '15 x 23 cm (B5)',
      coverType: 'Hardcover Lux',
      notes: 'Edisi 3 Jilid lengkap rujukan madzhab Syafi\'i.',
    ),
    Book(
      id: 'ds-05',
      title: 'Terjemah Bidayatul Hidayah',
      isbn: '978-602-0853-24-2',
      category: 'Akhlak & Tasawuf',
      stock: 4, // STOK KRITIS (< 15)
      safetyThreshold: 15,
      publisher: 'Darussholah',
      author: 'Imam Al-Ghazali (Terjemah)',
      locationZone: 'Zona C',
      locationRack: 'Rak 01',
      locationBin: 'Bin A',
      price: 200000,
      costPrice: 80000,
      weightGram: 350,
      pages: '290 Halaman',
      size: '14 x 21 cm (A5)',
      coverType: 'Hardcover',
      notes: 'Stok menipis drastis karena pemesanan grosir pesantren.',
    ),
    Book(
      id: 'ds-06',
      title: 'Terjemah Matan Ummul Barahin (Aqidah Sanusiyyah)',
      isbn: '978-602-0853-25-9',
      category: 'Aqidah & Tauhid',
      stock: 240,
      safetyThreshold: 20,
      publisher: 'Darussholah',
      author: 'Imam As-Sanusi',
      locationZone: 'Zona D',
      locationRack: 'Rak 01',
      locationBin: 'Bin B',
      price: 45000,
      costPrice: 18000,
      weightGram: 110,
      pages: '88 Halaman',
      size: '10 x 14 cm (Saku)',
      coverType: 'Softcover',
      notes: 'Kitab tauhid dasar 20 sifat wajib Allah.',
    ),
    Book(
      id: 'ds-07',
      title: 'Terjemah Jauharul Maknun (Ilmu Balaghoh)',
      isbn: '978-602-0853-26-6',
      category: 'Sastra & Balaghoh',
      stock: 0, // STOK HABIS
      safetyThreshold: 10,
      publisher: 'Darussholah',
      author: 'Syaikh Abdurrahman Al-Akhdhari',
      locationZone: 'Zona E',
      locationRack: 'Rak 01',
      locationBin: 'Bin A',
      price: 95000,
      costPrice: 38000,
      weightGram: 260,
      pages: '210 Halaman',
      size: '14 x 21 cm (A5)',
      coverType: 'Softcover',
      notes: 'Stok habis, dalam antrean cetak pabrik.',
    ),
  ];

  final List<StockMovement> _movements = [
    StockMovement(
      id: 'm-101',
      bookId: 'ds-01',
      bookTitle: 'Nadham Qaidah Sharfiyyah (Saku)',
      isbn: '978-602-0853-20-4',
      type: MovementType.inbound,
      quantity: 200,
      balanceAfter: 350,
      referenceNumber: 'SJ-CETAK-2026/08/01',
      notes: 'Penerimaan batch cetak baru dari workshop percetakan Pemalang.',
      petugasName: 'Pak Fauzi (Gudang)',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
    ),
    StockMovement(
      id: 'm-102',
      bookId: 'ds-05',
      bookTitle: 'Terjemah Bidayatul Hidayah',
      isbn: '978-602-0853-24-2',
      type: MovementType.outbound,
      quantity: 50,
      balanceAfter: 4,
      referenceNumber: 'ORD-B2B-PW-092',
      notes: 'Pengiriman paket grosir Pesantren Al-Hikmah.',
      petugasName: 'Admin Logistik',
      timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 40)),
    ),
    StockMovement(
      id: 'm-103',
      bookId: 'ds-02',
      bookTitle: 'Trjmh F.Qorib Zaman Now (Saku)',
      isbn: '978-602-0853-21-1',
      type: MovementType.outbound,
      quantity: 20,
      balanceAfter: 18,
      referenceNumber: 'WA-RETAIL-4412',
      notes: 'Penjualan retail direct sales WhatsApp Hotline.',
      petugasName: 'Admin Toko',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    StockMovement(
      id: 'm-104',
      bookId: 'ds-04',
      bookTitle: 'Fiqih Populer: Terjemah Fathul Mu\'in 1,2,3',
      isbn: '978-602-0853-23-5',
      type: MovementType.opnameAdjustment,
      quantity: 5,
      balanceAfter: 45,
      referenceNumber: 'OPN-2026-W3',
      notes: 'Penyesuaian audit fisik rak Zona A-03.',
      petugasName: 'Tim Audit Fisik',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'Semua Kategori';
  String _selectedStatusFilter = 'Semua'; // 'Semua', 'Aman', 'Menipis', 'Habis'
  String _selectedZone = 'Semua Zona';

  // --- GETTERS & METRICS ---

  List<Book> get allBooks => List.unmodifiable(_books);

  List<StockMovement> get movements => List.unmodifiable(_movements);

  int get totalTitles => _books.length;

  int get totalPhysicalStock => _books.fold(0, (sum, b) => sum + b.stock);

  double get totalInventoryAssetValue => _books.fold(0.0, (sum, b) => sum + (b.stock * (b.price ?? 0)));

  double get totalInventoryCostValue => _books.fold(0.0, (sum, b) => sum + (b.stock * (b.costPrice ?? 0)));

  int get lowStockCount => _books.where((b) => b.isLowStock).length;

  int get outOfStockCount => _books.where((b) => b.isOutOfStock).length;

  int get safeStockCount => _books.where((b) => b.isStockSafe).length;

  List<Book> get lowStockBooks => _books.where((b) => b.isLowStock).toList();

  List<Book> get outOfStockBooks => _books.where((b) => b.isOutOfStock).toList();

  List<Book> get alertBooks => _books.where((b) => b.isLowStock || b.isOutOfStock).toList();

  List<String> get categories => [
        'Semua Kategori',
        'Fiqih & Syariah',
        'Nahwu, Sharaf & Alat',
        'Akhlak & Tasawuf',
        'Aqidah & Tauhid',
        'Sastra & Balaghoh',
        'Umum',
      ];

  List<String> get zones => [
        'Semua Zona',
        'Zona A',
        'Zona B',
        'Zona C',
        'Zona D',
        'Zona E',
      ];

  Map<String, int> get categoryStockDistribution {
    final Map<String, int> result = {};
    for (var b in _books) {
      result[b.category] = (result[b.category] ?? 0) + b.stock;
    }
    return result;
  }

  Map<String, int> get zoneStockDistribution {
    final Map<String, int> result = {};
    for (var b in _books) {
      result[b.locationZone] = (result[b.locationZone] ?? 0) + b.stock;
    }
    return result;
  }

  // --- FILTERED LIST ---

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedZone => _selectedZone;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setSelectedZone(String zone) {
    _selectedZone = zone;
    notifyListeners();
  }

  List<Book> get filteredBooks {
    return _books.where((book) {
      // 1. Search filter (Judul, ISBN, Penulis, Lokasi)
      final q = _searchQuery.trim().toLowerCase();
      final matchQuery = q.isEmpty ||
          book.title.toLowerCase().contains(q) ||
          book.isbn.toLowerCase().contains(q) ||
          (book.author?.toLowerCase().contains(q) ?? false) ||
          book.locationCode.toLowerCase().contains(q);

      // 2. Category filter
      final matchCategory = _selectedCategory == 'Semua Kategori' || book.category == _selectedCategory;

      // 3. Zone filter
      final matchZone = _selectedZone == 'Semua Zona' || book.locationZone == _selectedZone;

      // 4. Status filter
      bool matchStatus = true;
      if (_selectedStatusFilter == 'Aman') {
        matchStatus = book.isStockSafe;
      } else if (_selectedStatusFilter == 'Menipis') {
        matchStatus = book.isLowStock;
      } else if (_selectedStatusFilter == 'Habis') {
        matchStatus = book.isOutOfStock;
      }

      return matchQuery && matchCategory && matchZone && matchStatus;
    }).toList();
  }

  // --- STOCK ACTIONS & MUTATIONS ---

  bool adjustStock({
    required String bookId,
    required int delta,
    required MovementType type,
    String? referenceNumber,
    String? notes,
    String petugasName = 'Owner / Admin',
  }) {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index == -1) return false;

    final currentBook = _books[index];
    final newStock = currentBook.stock + delta;

    if (newStock < 0) {
      return false; // Cegah stok bernilai negatif
    }

    _books[index] = currentBook.copyWith(stock: newStock);

    // Catat riwayat mutasi
    final movement = StockMovement(
      bookId: currentBook.id,
      bookTitle: currentBook.title,
      isbn: currentBook.isbn,
      type: type,
      quantity: delta.abs(),
      balanceAfter: newStock,
      referenceNumber: referenceNumber,
      notes: notes,
      petugasName: petugasName,
      timestamp: DateTime.now(),
    );

    _movements.insert(0, movement);
    notifyListeners();
    return true;
  }

  void addBook(Book newBook) {
    _books.insert(0, newBook);

    // Catat mutasi awal jika stok > 0
    if (newBook.stock > 0) {
      _movements.insert(
        0,
        StockMovement(
          bookId: newBook.id,
          bookTitle: newBook.title,
          isbn: newBook.isbn,
          type: MovementType.inbound,
          quantity: newBook.stock,
          balanceAfter: newBook.stock,
          referenceNumber: 'INIT-CATALOG',
          notes: 'Pencatatan stok awal judul baru.',
          petugasName: 'Owner / Admin',
          timestamp: DateTime.now(),
        ),
      );
    }

    notifyListeners();
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((b) => b.id == updatedBook.id);
    if (index != -1) {
      final oldStock = _books[index].stock;
      _books[index] = updatedBook;

      if (updatedBook.stock != oldStock) {
        final diff = updatedBook.stock - oldStock;
        _movements.insert(
          0,
          StockMovement(
            bookId: updatedBook.id,
            bookTitle: updatedBook.title,
            isbn: updatedBook.isbn,
            type: MovementType.opnameAdjustment,
            quantity: diff.abs(),
            balanceAfter: updatedBook.stock,
            referenceNumber: 'EDIT-INFO',
            notes: 'Penyesuaian manual saat pembaruan data buku.',
            petugasName: 'Owner / Admin',
            timestamp: DateTime.now(),
          ),
        );
      }

      notifyListeners();
    }
  }

  void deleteBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  Book? findBookByIsbnOrBarcode(String code) {
    try {
      return _books.firstWhere(
        (b) => b.isbn.replaceAll('-', '').trim() == code.replaceAll('-', '').trim() ||
            b.id.toLowerCase() == code.toLowerCase() ||
            b.title.toLowerCase().contains(code.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }
}
