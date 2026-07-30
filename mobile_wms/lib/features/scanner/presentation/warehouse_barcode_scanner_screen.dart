import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class WarehouseBarcodeScannerScreen extends StatefulWidget {
  final Function(String barcode, String format) onBarcodeScanned;
  final VoidCallback? onManualInputPressed;

  const WarehouseBarcodeScannerScreen({
    Key? key,
    required this.onBarcodeScanned,
    this.onManualInputPressed,
  }) : super(key: key);

  @override
  State<WarehouseBarcodeScannerScreen> createState() =>
      _WarehouseBarcodeScannerScreenState();
}

class _WarehouseBarcodeScannerScreenState
    extends State<WarehouseBarcodeScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.ean13, BarcodeFormat.code128, BarcodeFormat.qrCode],
  );

  bool _isProcessing = false;
  bool _isTorchOn = false;

  void _handleBarcodeCapture(BarcodeCapture capture) async {
    if (_isProcessing || capture.barcodes.isEmpty) return;

    final String? rawValue = capture.barcodes.first.rawValue;

    if (rawValue != null && rawValue.trim().isNotEmpty) {
      setState(() => _isProcessing = true);

      // Respon Getar Haptic
      HapticFeedback.mediumImpact();

      // Callback hasil pemindaian
      widget.onBarcodeScanned(rawValue.trim(), capture.barcodes.first.format.name);

      // Jeda 1.2 Detik untuk mencegah pemindaian ganda
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showManualInputDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController qtyController = TextEditingController(text: '1');
    final TextEditingController barcodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.camera_alt_outlined, color: Colors.cyanAccent),
              SizedBox(width: 10),
              Text(
                'Input Buku (Tanpa Barcode)',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buku tidak memiliki barcode fisik? Foto dan semua detail di bawah bersifat opsional (opsional).',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),

                // Mock Area Foto Sampul / Tumpukan Buku
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto sampul buku berhasil diambil!')),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.4), style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo_outlined, color: Colors.cyanAccent, size: 32),
                        SizedBox(height: 6),
                        Text('Ambil Foto Buku (Opsional)', style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Form Judul (Opsional)
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Judul Buku (Opsional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Contoh: Sejarah Nusantara',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Form Jumlah Fisik (Opsional)
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Exemplar / Fisik (Opsional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: '1',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Form Kode SKU/ISBN Manual (Opsional)
                TextField(
                  controller: barcodeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Kode SKU / Nomor (Opsional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Contoh: 9786020324121',
                    border: OutlineInputBorder(),
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
              ),
              icon: const Icon(Icons.check),
              label: const Text('Simpan Buku', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                final kode = barcodeController.text.trim().isNotEmpty
                    ? barcodeController.text.trim()
                    : 'TANPA-BARCODE-${DateTime.now().millisecondsSinceEpoch}';
                Navigator.of(context).pop();
                widget.onBarcodeScanned(kode, 'TANPA_BARCODE_FOTO');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanAreaWidth = MediaQuery.of(context).size.width * 0.82;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Pemindai Kamera & Foto Buku'),
        backgroundColor: const Color(0xFF1E1E2E),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.grey,
            ),
            onPressed: () {
              _scannerController.toggleTorch();
              setState(() => _isTorchOn = !_isTorchOn);
            },
            tooltip: 'Lampu Senter',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Kamera Pemindai Live
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcodeCapture,
          ),

          // Kotak Retikel Fokus Kamera
          Align(
            alignment: Alignment.center,
            child: Container(
              width: scanAreaWidth,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isProcessing ? Colors.greenAccent : Colors.cyanAccent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Petunjuk Bahasa Indonesia
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isProcessing
                      ? "Sedang Membaca Kode Buku..."
                      : "Arahkan Kamera ke Barcode / Gunakan Tombol di Bawah",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),

          // Tombol Input Utama: Buku Tanpa Barcode (Foto & Detail Opsional)
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E2E),
                foregroundColor: Colors.cyanAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
                ),
                elevation: 6,
              ),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text(
                'Input Buku Tanpa Barcode / Ambil Foto',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              onPressed: widget.onManualInputPressed ?? _showManualInputDialog,
            ),
          ),
        ],
      ),
    );
  }
}
