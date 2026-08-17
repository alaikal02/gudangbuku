import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../services/warehouse_stock_service.dart';

class StockMovementHistoryScreen extends StatefulWidget {
  final WarehouseStockService stockService;

  const StockMovementHistoryScreen({
    Key? key,
    required this.stockService,
  }) : super(key: key);

  @override
  State<StockMovementHistoryScreen> createState() => _StockMovementHistoryScreenState();
}

class _StockMovementHistoryScreenState extends State<StockMovementHistoryScreen> {
  String _selectedFilter = 'Semua'; // 'Semua', 'Inbound', 'Outbound', 'Opname'

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$min WIB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final allMovements = widget.stockService.movements;
    final filteredMovements = allMovements.where((m) {
      if (_selectedFilter == 'Inbound') return m.type == MovementType.inbound;
      if (_selectedFilter == 'Outbound') return m.type == MovementType.outbound;
      if (_selectedFilter == 'Opname') return m.type == MovementType.opnameAdjustment;
      return true;
    }).toList();

    final totalInboundQty = allMovements
        .where((m) => m.type == MovementType.inbound)
        .fold(0, (sum, m) => sum + m.quantity);

    final totalOutboundQty = allMovements
        .where((m) => m.type == MovementType.outbound)
        .fold(0, (sum, m) => sum + m.quantity);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF13131F) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        elevation: 1,
        title: Text(
          'Riwayat Mutasi Stok (Audit Log)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // Quick Summary Cards for Inbound & Outbound
          Container(
            padding: const EdgeInsets.all(14),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_downward_rounded, color: Colors.greenAccent, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Masuk (Cetak)', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                                Text('+$totalInboundQty eks', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_upward_rounded, color: Colors.orangeAccent, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Keluar (Kirim)', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                                Text('-$totalOutboundQty eks', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter Buttons
                Row(
                  children: [
                    _buildFilterTab('Semua', isDark),
                    _buildFilterTab('Inbound', isDark),
                    _buildFilterTab('Outbound', isDark),
                    _buildFilterTab('Opname', isDark),
                  ],
                ),
              ],
            ),
          ),

          // Log List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredMovements.length} Transaksi Tercatat',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
                ),
                Text(
                  'Urutan Terbaru',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.cyanAccent : Colors.teal),
                ),
              ],
            ),
          ),

          // Movements List View
          Expanded(
            child: filteredMovements.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 48, color: Colors.grey[500]),
                        const SizedBox(height: 8),
                        Text(
                          'Belum ada transaksi mutasi dalam kategori ini.',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    itemCount: filteredMovements.length,
                    itemBuilder: (context, index) {
                      final m = filteredMovements[index];
                      return _buildMovementCard(m, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isDark) {
    final isSelected = _selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
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
            label,
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
  }

  Widget _buildMovementCard(StockMovement m, bool isDark) {
    final isInbound = m.type == MovementType.inbound;
    final isOutbound = m.type == MovementType.outbound;
    final badgeColor = isInbound
        ? Colors.greenAccent
        : (isOutbound ? Colors.orangeAccent : Colors.cyanAccent);

    final sign = isInbound ? '+' : (isOutbound ? '-' : '±');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.transparent : Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Type badge & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeColor.withOpacity(0.6)),
                ),
                child: Text(
                  m.type.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
              Text(
                _formatDateTime(m.timestamp),
                style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Main Info: Title & Quantity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.bookTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (m.isbn != null && m.isbn!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'ISBN: ${m.isbn}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$sign${m.quantity} eks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                  Text(
                    'Saldo: ${m.balanceAfter} eks',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 8),
          const SizedBox(height: 4),

          // Footer: Reference & Notes & Petugas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (m.referenceNumber != null && m.referenceNumber!.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.receipt_outlined, size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            m.referenceNumber!,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.cyanAccent : Colors.teal[800]),
                          ),
                        ],
                      ),
                    if (m.notes != null && m.notes!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        m.notes!,
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                'Oleh: ${m.petugasName}',
                style: TextStyle(fontSize: 10, color: Colors.grey[500], fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
