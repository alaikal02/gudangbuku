import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/stock_movement.dart';
import '../services/warehouse_stock_service.dart';
import '../widgets/quick_stock_dialog.dart';

class WarehouseRackScreen extends StatefulWidget {
  final WarehouseStockService stockService;

  const WarehouseRackScreen({
    Key? key,
    required this.stockService,
  }) : super(key: key);

  @override
  State<WarehouseRackScreen> createState() => _WarehouseRackScreenState();
}

class _WarehouseRackScreenState extends State<WarehouseRackScreen> {
  String _selectedZone = 'Zona A';

  final Map<String, String> _zoneDescriptions = {
    'Zona A': 'Khusus Kitab Fiqih & Fatwa Syariah (Syafi\'iyyah)',
    'Zona B': 'Khusus Kitab Ilmu Alat (Nahwu, Sharaf & Kaidah Bahasa Arab)',
    'Zona C': 'Khusus Kitab Tasawuf & Pembinaan Akhlak Santri',
    'Zona D': 'Khusus Kitab Tauhid, Aqidah & Ushuluddin',
    'Zona E': 'Khusus Kitab Sastra Arab, Balaghoh & Umum',
  };

  void _showQuickStockDialog(Book book, MovementType type) async {
    final result = await showDialog<QuickStockAdjustmentResult>(
      context: context,
      builder: (context) => QuickStockDialog(book: book, initialType: type),
    );

    if (result != null) {
      widget.stockService.adjustStock(
        bookId: book.id,
        delta: result.delta,
        type: result.type,
        referenceNumber: result.referenceNumber,
        notes: result.notes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final zones = ['Zona A', 'Zona B', 'Zona C', 'Zona D', 'Zona E'];
    final booksInZone = widget.stockService.allBooks
        .where((b) => b.locationZone == _selectedZone)
        .toList();

    final totalZoneStock = booksInZone.fold(0, (sum, b) => sum + b.stock);

    // Group books by rack
    final Map<String, List<Book>> rackGroups = {};
    for (var b in booksInZone) {
      if (!rackGroups.containsKey(b.locationRack)) {
        rackGroups[b.locationRack] = [];
      }
      rackGroups[b.locationRack]!.add(b);
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF13131F) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        elevation: 1,
        title: Text(
          'Denah & Lokasi Rak Gudang',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // Zone Switcher Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: zones.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final zone = zones[index];
                  final isSelected = _selectedZone == zone;
                  return ChoiceChip(
                    label: Text(zone),
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                      color: isSelected
                          ? Colors.black87
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.cyanAccent,
                    backgroundColor: isDark ? const Color(0xFF2A2A3D) : Colors.grey[200],
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedZone = zone);
                    },
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Zone Header Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF1E1E2E), const Color(0xFF2A2A3D)]
                            : [Colors.teal.shade50, Colors.teal.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? Colors.cyanAccent.withOpacity(0.2) : Colors.teal.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.grid_view_rounded, color: Colors.cyanAccent, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedZone,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.cyan.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$totalZoneStock eks tersimpan',
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _zoneDescriptions[_selectedZone] ?? 'Sektor penataan inventaris buku.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Racks List
                  const Text(
                    'Daftar Rak & Kompartemen Bin',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  if (rackGroups.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(Icons.inventory_outlined, size: 48, color: Colors.grey[500]),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada buku yang ditempatkan di $_selectedZone.',
                              style: TextStyle(color: Colors.grey[400], fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...rackGroups.entries.map((entry) {
                      final rackName = entry.key;
                      final books = entry.value;
                      return _buildRackCard(rackName, books, isDark);
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRackCard(String rackName, List<Book> books, bool isDark) {
    final rackTotalStock = books.fold(0, (sum, b) => sum + b.stock);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.transparent : Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rack Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A3D) : Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.table_rows_rounded, size: 18, color: Colors.amberAccent),
                    const SizedBox(width: 8),
                    Text(
                      '$_selectedZone / $rackName',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$rackTotalStock eks (${books.length} Judul)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Items inside this rack
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: books.map((book) {
                final isOut = book.isOutOfStock;
                final isLow = book.isLowStock;
                final statusColor = isOut ? Colors.redAccent : (isLow ? Colors.orangeAccent : Colors.greenAccent);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF13131F) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (isOut || isLow) ? statusColor.withOpacity(0.4) : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.locationBin,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ISBN: ${book.isbn.isNotEmpty ? book.isbn : "Tanpa Barcode"}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${book.stock} eks',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          Text(
                            isOut ? 'Habis' : (isLow ? 'Stok Kritis' : 'Aman'),
                            style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.greenAccent),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Restock Cepat',
                        onPressed: () => _showQuickStockDialog(book, MovementType.inbound),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
