import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/theme_service.dart';
import 'add_edit_book_screen.dart';
import '../widgets/quick_stock_dialog.dart';

class BookListScreen extends StatefulWidget {
  final BookService bookService;
  final ThemeService themeService;

  const BookListScreen({
    super.key,
    required this.bookService,
    required this.themeService,
  });

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.bookService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    widget.bookService.removeListener(_onServiceUpdate);
    _searchController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    setState(() {});
  }

  void _openAddBookScreen() async {
    final newBook = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (context) => const AddEditBookScreen()),
    );

    if (newBook != null) {
      widget.bookService.addBook(newBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buku "${newBook.title}" berhasil ditambahkan!'),
            backgroundColor: Colors.greenAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openEditBookScreen(Book book) async {
    final updatedBook = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen(bookToEdit: book)),
    );

    if (updatedBook != null) {
      widget.bookService.updateBook(updatedBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rincian buku "${updatedBook.title}" berhasil diperbarui.'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openStockDialog(Book book, bool isSaleMode) async {
    final delta = await showDialog<int>(
      context: context,
      builder: (context) => QuickStockDialog(book: book, isSaleMode: isSaleMode),
    );

    if (delta != null && delta != 0) {
      final success = widget.bookService.adjustStock(book.id, delta);
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal! Stok tidak boleh kurang dari 0.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (mounted) {
        final actionText = isSaleMode ? 'terjual ($delta)' : 'ditambahkan (+$delta)';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok "${book.title}" $actionText.'),
            backgroundColor: isSaleMode ? Colors.orangeAccent : Colors.greenAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final books = widget.bookService.books;
    final totalTitles = widget.bookService.totalTitles;
    final totalStock = widget.bookService.totalStock;

    // Adaptive colors
    final surfaceColor = colorScheme.surface;
    final cardBgColor = isDark ? const Color(0xFF2A2A3D) : const Color(0xFFEDF2F7);
    final textPrimary = colorScheme.onSurface;
    final textSecondary = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_stories, color: colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              'Gudang Buku',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          // TOMBOL GANTI TEMA
          IconButton(
            onPressed: () {
              widget.themeService.toggleTheme();
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                color: isDark ? Colors.amberAccent : Colors.blueGrey,
              ),
            ),
            tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // SUMMARY CARD & SEARCH HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Quick KPI Summary
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.menu_book, color: colorScheme.primary, size: 24),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Judul Buku', style: TextStyle(color: textSecondary, fontSize: 11)),
                                Text(
                                  '$totalTitles Judul',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.inventory_2, color: colorScheme.secondary, size: 24),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Stok', style: TextStyle(color: textSecondary, fontSize: 11)),
                                Text(
                                  '$totalStock pcs',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Search Bar Input
                TextField(
                  controller: _searchController,
                  style: TextStyle(color: textPrimary),
                  onChanged: (val) {
                    widget.bookService.setSearchQuery(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari judul, penerbit, atau penulis...',
                    hintStyle: TextStyle(color: textSecondary, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              widget.bookService.setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF181825) : const Color(0xFFF0F3F8),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST VIEW BUKU
          Expanded(
            child: books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: textSecondary),
                        const SizedBox(height: 12),
                        Text(
                          'Buku tidak ditemukan',
                          style: TextStyle(color: textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final isLowStock = book.stock <= 5;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        color: surfaceColor,
                        elevation: isDark ? 2 : 1,
                        shadowColor: isDark ? Colors.black54 : Colors.grey.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isLowStock
                                ? Colors.orange.withValues(alpha: 0.5)
                                : (isDark ? Colors.transparent : Colors.grey.withValues(alpha: 0.15)),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ROW 1: FOTO/ICON + JUDUL & INFO + BADGE STOK
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Cover / Avatar
                                  Container(
                                    width: 48,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        book.title.isNotEmpty ? book.title[0].toUpperCase() : 'B',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Judul & Penerbit/Penulis
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          style: TextStyle(
                                            color: textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (book.publisher != null || book.author != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            [
                                              if (book.publisher != null) book.publisher,
                                              if (book.author != null) book.author,
                                            ].join(' • '),
                                            style: TextStyle(color: textSecondary, fontSize: 13),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Badge Stok
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isLowStock
                                          ? Colors.orangeAccent.withValues(alpha: 0.15)
                                          : Colors.greenAccent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${book.stock} pcs',
                                      style: TextStyle(
                                        color: isLowStock ? Colors.orangeAccent : Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(height: 24, color: theme.dividerColor),

                              // ROW 2: CONTROL BUTTONS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Tombol Edit Rincian Buku
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: textSecondary,
                                      side: BorderSide(color: textSecondary.withValues(alpha: 0.3)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    ),
                                    onPressed: () => _openEditBookScreen(book),
                                    icon: const Icon(Icons.edit_note, size: 18),
                                    label: const Text('Edit Rincian', style: TextStyle(fontSize: 12)),
                                  ),

                                  // Quick Stok Adjustment Controls
                                  Row(
                                    children: [
                                      // Tombol - Terjual / Kurang
                                      InkWell(
                                        onTap: () {
                                          if (book.stock > 0) {
                                            widget.bookService.adjustStock(book.id, -1);
                                          }
                                        },
                                        onLongPress: () => _openStockDialog(book, true),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.orangeAccent.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.remove, color: Colors.orangeAccent, size: 18),
                                        ),
                                      ),

                                      // Label Stok Indicator
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          'Stok: ${book.stock}',
                                          style: TextStyle(
                                            color: textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      // Tombol + Tambah
                                      InkWell(
                                        onTap: () {
                                          widget.bookService.adjustStock(book.id, 1);
                                        },
                                        onLongPress: () => _openStockDialog(book, false),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(Icons.add, color: colorScheme.primary, size: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // FAB: TAMBAH BUKU BARU
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: isDark ? Colors.black : Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Buku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _openAddBookScreen,
      ),
    );
  }
}
