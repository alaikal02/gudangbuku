import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/stock_movement.dart';
import '../services/warehouse_stock_service.dart';
import '../services/theme_service.dart';
import '../widgets/quick_stock_dialog.dart';
import 'stock_movement_history_screen.dart';

class StockMonitoringDashboardScreen extends StatelessWidget {
  final WarehouseStockService stockService;
  final ThemeService themeService;
  final Function(int tabIndex)? onNavigateToTab;
  final VoidCallback? onOpenScanner;

  const StockMonitoringDashboardScreen({
    Key? key,
    required this.stockService,
    required this.themeService,
    this.onNavigateToTab,
    this.onOpenScanner,
  }) : super(key: key);

  String _formatRupiah(double amount) {
    // Simple format without external intl dependency: Rp 74.850.000
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

  void _showQuickStockDialog(BuildContext context, Book book, MovementType type) async {
    final result = await showDialog<QuickStockAdjustmentResult>(
      context: context,
      builder: (context) => QuickStockDialog(book: book, initialType: type),
    );

    if (result != null) {
      final success = stockService.adjustStock(
        bookId: book.id,
        delta: result.delta,
        type: result.type,
        referenceNumber: result.referenceNumber,
        notes: result.notes,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Mutasi stok "${book.title}" berhasil dicatat!'
                  : 'Gagal! Stok tidak mencukupi untuk pengurangan ini.',
            ),
            backgroundColor: success ? Colors.green : Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final totalTitles = stockService.totalTitles;
    final totalStock = stockService.totalPhysicalStock;
    final totalAsset = stockService.totalInventoryAssetValue;
    final lowStockCount = stockService.lowStockCount;
    final outOfStockCount = stockService.outOfStockCount;
    final alertBooks = stockService.alertBooks;
    final categoryDist = stockService.categoryStockDistribution;
    final recentMovements = stockService.movements.take(4).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF13131F) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warehouse_rounded, color: Colors.cyanAccent, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Gudang Darussholah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              'Monitoring Inventaris & Distribusi Buku',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => themeService.toggleTheme(),
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amberAccent : Colors.blueGrey,
            ),
            tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Hub & Offline Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.cyanAccent.withOpacity(0.2) : Colors.teal.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sistem Inventaris Gudang Aktif (Pusat Pemalang)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'OFFLINE READY',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 4 KPI SUMMARY CARDS ---
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'Total Fisik Stok',
                    value: '$totalStock eks',
                    subtitle: 'Siap Distribusi',
                    icon: Icons.inventory_2_rounded,
                    color: Colors.cyanAccent,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Total Judul Buku',
                    value: '$totalTitles Judul',
                    subtitle: 'Katalog Aktif',
                    icon: Icons.menu_book_rounded,
                    color: Colors.purpleAccent,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'Estimasi Nilai Aset',
                    value: _formatRupiah(totalAsset),
                    subtitle: 'Nilai HET Inventaris',
                    icon: Icons.monetization_on_rounded,
                    color: Colors.greenAccent,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Peringatan Stok',
                    value: '${lowStockCount + outOfStockCount} Judul',
                    subtitle: '$lowStockCount Menipis • $outOfStockCount Habis',
                    icon: Icons.warning_amber_rounded,
                    color: (lowStockCount + outOfStockCount) > 0 ? Colors.orangeAccent : Colors.grey,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- QUICK ACTION BUTTONS ---
            const Text(
              'Aksi Cepat Gudang',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.add_circle_outline_rounded,
                    label: '+ Barang Masuk',
                    color: Colors.green,
                    isDark: isDark,
                    onTap: () {
                      if (stockService.allBooks.isNotEmpty) {
                        _showQuickStockDialog(
                          context,
                          stockService.allBooks.first,
                          MovementType.inbound,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.local_shipping_outlined,
                    label: '- Barang Keluar',
                    color: Colors.orange,
                    isDark: isDark,
                    onTap: () {
                      if (stockService.allBooks.isNotEmpty) {
                        _showQuickStockDialog(
                          context,
                          stockService.allBooks.first,
                          MovementType.outbound,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan Barcode',
                    color: Colors.cyan,
                    isDark: isDark,
                    onTap: onOpenScanner ?? () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- CRITICAL / LOW STOCK ALERTS ---
            if (alertBooks.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.orangeAccent, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Perlu Cetak Ulang Segera (${alertBooks.length})',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      stockService.setSelectedStatusFilter('Menipis');
                      if (onNavigateToTab != null) onNavigateToTab!(1); // Buka Tab Inventaris
                    },
                    child: const Text('Lihat Semua', style: TextStyle(fontSize: 12, color: Colors.cyanAccent)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...alertBooks.map((book) => _buildAlertBookItem(context, book, isDark)).toList(),
              const SizedBox(height: 20),
            ],

            // --- REKAP DISTRIBUSI STOK PER KATEGORI ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Distribusi Stok per Kategori Kitab',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    if (onNavigateToTab != null) onNavigateToTab!(2); // Buka Tab Denah Rak
                  },
                  child: const Text('Denah Rak →', style: TextStyle(fontSize: 12, color: Colors.cyanAccent)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: categoryDist.entries.map((entry) {
                  final percentage = totalStock > 0 ? (entry.value / totalStock) : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              '${entry.value} eks (${(percentage * 100).toStringAsFixed(1)}%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.cyanAccent : Colors.teal[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 8,
                            backgroundColor: isDark ? const Color(0xFF2A2A3D) : Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getCategoryColor(entry.key),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // --- AKTIVITAS MUTASI TERAKHIR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aktivitas Mutasi Terkini',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    if (onNavigateToTab != null) onNavigateToTab!(3); // Buka Tab Mutasi
                  },
                  child: const Text('Semua Log →', style: TextStyle(fontSize: 12, color: Colors.cyanAccent)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (recentMovements.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Belum ada riwayat mutasi stok tercatat.'),
                ),
              )
            else
              ...recentMovements.map((m) => _buildMovementMiniItem(m, isDark)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertBookItem(BuildContext context, Book book, bool isDark) {
    final isOut = book.isOutOfStock;
    final badgeColor = isOut ? Colors.redAccent : Colors.orangeAccent;
    final badgeText = isOut ? 'STOK HABIS' : 'SISA ${book.stock} eks (Batas: ${book.safetyThreshold})';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isOut ? Icons.block_rounded : Icons.low_priority_rounded,
              color: badgeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${book.locationCode}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _showQuickStockDialog(context, book, MovementType.inbound),
            child: const Text('+ Restock', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementMiniItem(StockMovement m, bool isDark) {
    final isInbound = m.type == MovementType.inbound;
    final color = isInbound
        ? Colors.greenAccent
        : (m.type == MovementType.outbound ? Colors.orangeAccent : Colors.cyanAccent);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              isInbound ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.bookTitle,
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
                  '${m.type.label} • ${m.notes ?? "-"}',
                  style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isInbound ? "+" : "-"}${m.quantity} eks',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'Sisa: ${m.balanceAfter}',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Fiqih & Syariah':
        return const Color(0xFF10B981);
      case 'Nahwu, Sharaf & Alat':
        return Colors.indigoAccent;
      case 'Akhlak & Tasawuf':
        return Colors.amberAccent;
      case 'Aqidah & Tauhid':
        return Colors.cyanAccent;
      case 'Sastra & Balaghoh':
        return Colors.purpleAccent;
      default:
        return Colors.tealAccent;
    }
  }
}
