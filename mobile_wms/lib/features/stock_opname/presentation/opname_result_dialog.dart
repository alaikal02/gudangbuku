import 'package:flutter/material.dart';
import '../../sync/domain/models/sync_queue_model.dart';
import '../../sync/data/offline_sync_engine.dart';
import 'package:uuid/uuid.dart';

class OpnameResultDialog extends StatefulWidget {
  final String barcodeStr;
  final String scanFormat;
  final OfflineSyncEngine syncEngine;

  const OpnameResultDialog({
    Key? key,
    required this.barcodeStr,
    required this.scanFormat,
    required this.syncEngine,
  }) : super(key: key);

  @override
  State<OpnameResultDialog> createState() => _OpnameResultDialogState();
}

class _OpnameResultDialogState extends State<OpnameResultDialog> {
  final TextEditingController _qtyController = TextEditingController(text: '1');
  bool _isSaving = false;

  void _saveOpnameRecord() async {
    final qty = int.tryParse(_qtyController.text.trim()) ?? 0;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuantitas fisik harus lebih dari 0')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final record = StockOpnameSyncQueueModel(
      clientMutationId: const Uuid().v4(),
      bookId: 'BK-8801', // Mock matching book ID
      isbn: widget.barcodeStr,
      locationId: 'Z-01-R-04-B',
      scannedQuantity: qty,
      petugasId: 'PETUGAS-LAPANGAN-01',
      status: SyncQueueStatus.pending,
    );

    await widget.syncEngine.enqueueOpnameRecord(record);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade800,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Opname ISBN ${widget.barcodeStr} ($qty exemplar) tersimpan!'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.inventory_2_outlined, color: Colors.cyanAccent),
          SizedBox(width: 10),
          Text('Hasil Scan Stock Opname', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Detail Buku
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Clean Architecture & High Scale WMS', style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('ISBN: ${widget.barcodeStr}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  Text('Format: ${widget.scanFormat}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Lokasi Rak:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Z-01-R-04-B', style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Stok Sistem:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('145 exemplar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form Input Jumlah Hasil Opname Fisik
            const Text('Input Jumlah Fisik Hasil Hitung:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calculate, color: Colors.cyanAccent),
                suffixText: 'exemplar',
                filled: true,
                fillColor: Colors.black26,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: _isSaving
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.save),
          label: const Text('Simpan Opname', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: _isSaving ? null : _saveOpnameRecord,
        ),
      ],
    );
  }
}
