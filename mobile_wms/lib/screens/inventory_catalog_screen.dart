import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/stock_movement.dart';
import '../services/warehouse_stock_service.dart';
import '../widgets/quick_stock_dialog.dart';
import 'add_edit_book_screen.dart';

class InventoryCatalogScreen extends StatefulWidget {
  final WarehouseStockService stockService;

  const InventoryCatalogScreen({
    Key? key,
    required this.stockService,
  }) : super(key: key);

  @override
  State<InventoryCatalogScreen> createState() => _InventoryCatalogScreenState();
}

class _InventoryCatalogScreenState extends State<InventoryCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.stockService.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatRupiah(double? amount) {
    if (amount == null) return '-';
    final intVal = amount.toInt();
    final str = intVal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  void _openAddBookScreen() async {
    final newBook = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (context) => const AddEditBookScreen()),
    );

    if (newBook != null) {
      widget.stockService.addBook(newBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buku "${newBook.title}" berhasil didaftarkan ke gudang!'),
            backgroundColor: Colors.green,
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
      widget.stockService.updateBook(updatedBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data buku "${updatedBook.title}" berhasil diperbarui.'),
            backgroundColor: Colors.cyan,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showQuickStockDialog(Book book, MovementType type) async {
    final result = await showDialog<QuickStockAdjustmentResult>(
      context: context,
      builder: (context) => QuickStockDialog(book: book, initialType: type),
    );

    if (result != null) {
      final success = widget.stockService.adjustStock(
        bookId: book.id,
        delta: result.delta,
        type: result.type,
        referenceNumber: result.referenceNumber,
        notes: result.notes,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Mutasi stok "${book.title}" berhasil disimpan!'
                  : 'Gagal! Stok tidak boleh bernilai negatif.',
            ),
            backgroundColor: success ? Colors.green : Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showBookDetailModal(Book book, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Penulis: ${book.author ?? "-"} | Penerbit: ${book.publisher}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStockBadgeColor(book).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getStockBadgeColor(book)),
                        ),
                        child: Text(
                          '${book.stock} eks',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getStockBadgeColor(book),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Detail Specifications Grid
                  _buildDetailRow('ISBN / Barcode', book.isbn.isNotEmpty ? book.isbn : 'TANPA-BARCODE', isDark),
                  _buildDetailRow('Kategori Kitab', book.category, isDark),
                  _buildDetailRow('Lokasi Rak Gudang', book.locationCode, isDark),
                  _buildDetailRow('Batas Stok Minimum', '${book.safetyThreshold} eks', isDark),
                  _buildDetailRow('Harga Jual (HET)', _formatRupiah(book.price), isDark),
                  _buildDetailRow('Harga Pokok Cetak (HPP)', _formatRupiah(book.costPrice), isDark),
                  _buildDetailRow('Berat Buku', '${book.weightGram ?? 0} gram', isDark),
                  _buildDetailRow('Dimensi & Halaman', '${book.size ?? "-"} • ${book.pages ?? "-"}', isDark),
                  if (book.notes != null && book.notes!.isNotEmpty)
                    _buildDetailRow('Catatan Gudang', book.notes!, isDark),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.add_box_rounded),
                          label: const Text('+ Masuk Cetak', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.pop(context);
                            _showQuickStockDialog(book, MovementType.inbound);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.local_shipping_rounded),
                          label: const Text('- Keluar Kirim', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.pop(context);
                            _showQuickStockDialog(book, MovementType.outbound);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white70 : Colors.black87,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Informasi Buku'),
                    onPressed: () {
                      Navigator.pop(context);
                      _openEditBookScreen(book);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600])),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStockBadgeColor(Book book) {
    if (book.isOutOfStock) return Colors.redAccent;
    if (book.isLowStock) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final books = widget.stockService.filteredBooks;
    final categories = widget.stockService.categories;
    final selectedCategory = widget.stockService.selectedCategory;
    final selectedStatus = widget.stockService.selectedStatusFilter;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF13131F) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        elevation: 1,
        title: Text(
          'Inventaris Stok Buku',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Tambah Judul Buku Baru',
            onPressed: _openAddBookScreen,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add),
        label: const Text('Buku Baru', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _openAddBookScreen,
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Instant Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) => widget.stockService.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Cari Judul, Penulis, ISBN, atau Rak...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              widget.stockService.setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF13131F) : Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Status Filter Tabs
                Row(
                  children: ['Semua', 'Aman', 'Menipis', 'Habis'].map((status) {
                    final isSelected = selectedStatus == status;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.stockService.setSelectedStatusFilter(status),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? Colors.cyanAccent.withOpacity(0.2) : Colors.teal.withOpacity(0.15))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(color: isDark ? Colors.cyanAccent : Colors.teal, width: 1.2)
                                : null,
                          ),
                          child: Text(
                            status,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? (isDark ? Colors.cyanAccent : Colors.teal[900])
                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // Category Filter Pills Horizontal Scroll
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.black87
                              : (isDark ? Colors.grey[300] : Colors.grey[700]),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.cyanAccent,
                        backgroundColor: isDark ? const Color(0xFF2A2A3D) : Colors.grey[200],
                        onSelected: (selected) {
                          if (selected) widget.stockService.setSelectedCategory(cat);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Count summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menampilkan ${books.length} Judul Buku',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
                Text(
                  'Total: ${books.fold(0, (sum, b) => sum + b.stock)} eks',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.cyanAccent : Colors.teal,
                  ),
                ),
              ],
            ),
          ),

          // Books List View
          Expanded(
            child: books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[500]),
                        const SizedBox(height: 10),
                        Text(
                          'Tidak ada buku yang cocok dengan filter.',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return _buildBookCard(book, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book, bool isDark) {
    final badgeColor = _getStockBadgeColor(book);
    String stockStatusText = '${book.stock} eks';
    if (book.isOutOfStock) {
      stockStatusText = 'HABIS';
    } else if (book.isLowStock) {
      stockStatusText = '${book.stock} eks (Kritis)';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (book.isLowStock || book.isOutOfStock)
              ? badgeColor.withOpacity(0.5)
              : (isDark ? Colors.transparent : Colors.grey[200]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showBookDetailModal(book, isDark),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Title & Stock Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Karya: ${book.author ?? "Redaksi Darussholah"}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: badgeColor, width: 1),
                    ),
                    child: Text(
                      stockStatusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Middle Row: Tags (Category, Rack Location, ISBN)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _buildTag(book.category, Icons.label_outline, Colors.blue, isDark),
                  _buildTag(book.locationCode, Icons.place_outlined, Colors.amber, isDark),
                  if (book.isbn.isNotEmpty)
                    _buildTag(book.isbn, Icons.qr_code_2_rounded, Colors.grey, isDark),
                ],
              ),
              const SizedBox(height: 12),

              // Bottom Actions Row: Price & +/- Quick Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatRupiah(book.price),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.cyanAccent : Colors.teal[800],
                    ),
                  ),
                  Row(
                    children: [
                      // Outbound quick button
                      InkWell(
                        onTap: () => _showQuickStockDialog(book, MovementType.outbound),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orangeAccent),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.remove, size: 14, color: Colors.orangeAccent),
                              SizedBox(width: 4),
                              Text('Keluar', style: TextStyle(fontSize: 11, color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Inbound quick button
                      InkWell(
                        onTap: () => _showQuickStockDialog(book, MovementType.inbound),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.greenAccent),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.add, size: 14, color: Colors.greenAccent),
                              SizedBox(width: 4),
                              Text('Masuk', style: TextStyle(fontSize: 11, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, IconData icon, MaterialColor color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A3D) : Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: isDark ? Colors.grey[400] : Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
