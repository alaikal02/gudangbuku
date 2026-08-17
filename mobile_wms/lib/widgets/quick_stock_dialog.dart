import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/stock_movement.dart';

class QuickStockAdjustmentResult {
  final int delta;
  final MovementType type;
  final String? referenceNumber;
  final String? notes;

  QuickStockAdjustmentResult({
    required this.delta,
    required this.type,
    this.referenceNumber,
    this.notes,
  });
}

class QuickStockDialog extends StatefulWidget {
  final Book book;
  final MovementType initialType;

  const QuickStockDialog({
    Key? key,
    required this.book,
    this.initialType = MovementType.inbound,
  }) : super(key: key);

  @override
  State<QuickStockDialog> createState() => _QuickStockDialogState();
}

class _QuickStockDialogState extends State<QuickStockDialog> {
  late MovementType _type;
  int _amount = 10;
  final TextEditingController _amountController = TextEditingController(text: '10');
  final TextEditingController _refController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    if (_type == MovementType.inbound) {
      _refController.text = 'SJ-${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}-01';
      _notesController.text = 'Penerimaan cetakan baru dari percetakan.';
    } else if (_type == MovementType.outbound) {
      _refController.text = 'DO-${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}-01';
      _notesController.text = 'Pengiriman pesanan reseller/distributor.';
    } else {
      _refController.text = 'OPN-${DateTime.now().year}';
      _notesController.text = 'Penyesuaian hasil audit fisik rak.';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _refController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _setAmount(int val) {
    if (val < 1) val = 1;
    setState(() {
      _amount = val;
      _amountController.text = val.toString();
    });
  }

  Color _getTypeColor(ThemeData theme) {
    switch (_type) {
      case MovementType.inbound:
        return Colors.greenAccent;
      case MovementType.outbound:
        return Colors.orangeAccent;
      case MovementType.opnameAdjustment:
        return Colors.cyanAccent;
      case MovementType.relocation:
        return Colors.purpleAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final typeColor = _getTypeColor(theme);

    final currentStock = widget.book.stock;
    int estimatedBalance = currentStock;
    if (_type == MovementType.inbound) {
      estimatedBalance = currentStock + _amount;
    } else if (_type == MovementType.outbound) {
      estimatedBalance = currentStock - _amount;
    } else {
      estimatedBalance = _amount; // Opname set to exact
    }

    final isNegative = estimatedBalance < 0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: typeColor.withOpacity(0.2),
                  child: Icon(
                    _type == MovementType.inbound
                        ? Icons.add_box_rounded
                        : (_type == MovementType.outbound
                            ? Icons.local_shipping_rounded
                            : Icons.tune_rounded),
                    color: typeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _type == MovementType.inbound
                            ? 'Barang Masuk (Inbound)'
                            : (_type == MovementType.outbound
                                ? 'Barang Keluar (Outbound)'
                                : 'Penyesuaian Opname'),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tipe Selector Segmented Buttons
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A3D) : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTypeSegment(
                      title: '+ Masuk',
                      type: MovementType.inbound,
                      selected: _type == MovementType.inbound,
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildTypeSegment(
                      title: '- Keluar',
                      type: MovementType.outbound,
                      selected: _type == MovementType.outbound,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildTypeSegment(
                      title: 'Opname',
                      type: MovementType.opnameAdjustment,
                      selected: _type == MovementType.opnameAdjustment,
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kuantitas & Saldo Preview Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A3D) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isNegative ? Colors.redAccent : typeColor.withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Stok Saat Ini', style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text(
                        '$currentStock eks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_rounded, color: typeColor, size: 20),
                  Column(
                    children: [
                      Text('Estimasi Sisa', style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text(
                        '$estimatedBalance eks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isNegative ? Colors.redAccent : (isDark ? Colors.cyanAccent : Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isNegative) ...[
              const SizedBox(height: 6),
              const Text(
                '⚠️ Kuantitas keluar melebihi stok yang tersedia di rak gudang!',
                style: TextStyle(color: Colors.redAccent, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),

            // Stepper Input
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_amount > 1) _setAmount(_amount - 5);
                  },
                  icon: const Icon(Icons.remove_circle_outline, size: 30),
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF181825) : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null && parsed >= 0) {
                        setState(() => _amount = parsed);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    _setAmount(_amount + 5);
                  },
                  icon: Icon(Icons.add_circle_outline, size: 30, color: typeColor),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Preset Quick Buttons
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              children: [5, 10, 25, 50, 100].map((preset) {
                return ActionChip(
                  backgroundColor: isDark ? const Color(0xFF2A2A3D) : Colors.grey[200],
                  label: Text(
                    '+$preset',
                    style: TextStyle(color: isDark ? Colors.cyanAccent : Colors.teal[800], fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => _setAmount(_amount + preset),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Form No. Referensi & Catatan
            TextField(
              controller: _refController,
              decoration: InputDecoration(
                labelText: 'No. Surat Jalan / Referensi',
                labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                prefixIcon: const Icon(Icons.receipt_long_outlined, size: 20),
                filled: true,
                fillColor: isDark ? const Color(0xFF181825) : Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Keterangan Mutasi',
                labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                prefixIcon: const Icon(Icons.note_alt_outlined, size: 20),
                filled: true,
                fillColor: isDark ? const Color(0xFF181825) : Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Batal', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNegative ? Colors.grey : (_type == MovementType.outbound ? Colors.orangeAccent : Colors.cyanAccent),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: isNegative || _amount <= 0
                        ? null
                        : () {
                            int calculatedDelta = _amount;
                            if (_type == MovementType.outbound) {
                              calculatedDelta = -_amount;
                            } else if (_type == MovementType.opnameAdjustment) {
                              calculatedDelta = _amount - currentStock;
                            }

                            Navigator.pop(
                              context,
                              QuickStockAdjustmentResult(
                                delta: calculatedDelta,
                                type: _type,
                                referenceNumber: _refController.text.trim().isEmpty ? null : _refController.text.trim(),
                                notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                              ),
                            );
                          },
                    child: Text(
                      _type == MovementType.inbound
                          ? 'Simpan Barang Masuk'
                          : (_type == MovementType.outbound
                              ? 'Konfirmasi Pengeluaran'
                              : 'Sesuaikan Opname'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSegment({
    required String title,
    required MovementType type,
    required bool selected,
    required MaterialColor color,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _type = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: color, width: 1.2) : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : color[900]) : Colors.grey,
          ),
        ),
      ),
    );
  }
}
