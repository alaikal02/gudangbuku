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

      // 1. Respon Getar Haptic
      HapticFeedback.mediumImpact();

      // 2. Callback hasil pemindaian
      widget.onBarcodeScanned(rawValue.trim(), capture.barcodes.first.format.name);

      // 3. Debounce 1.2 Detik (Cegah pemindaian ganda/double trigger)
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showManualInputDialog() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          title: const Text('Input ISBN / SKU Manual', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: textController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Contoh: 9786020324121',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final input = textController.text.trim();
                if (input.isNotEmpty) {
                  Navigator.of(context).pop();
                  widget.onBarcodeScanned(input, 'MANUAL_ENTRY');
                }
              },
              child: const Text('Gunakan'),
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
        title: const Text('Pemindai Barcode Buku & Rak'),
        backgroundColor: const Color(0xFF1E1E2E),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.grey,
            ),
            onPressed: () {
              _scannerController.toggleTorch();
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Live Camera Viewfinder
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcodeCapture,
          ),

          // 2. Reticle Box Center Overlay
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

          // 3. Tombol Fallback Manual Input
          Positioned(
            bottom: 40,
            left: 32,
            right: 32,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E2E),
                foregroundColor: Colors.cyanAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
                ),
              ),
              icon: const Icon(Icons.keyboard_alt_outlined),
              label: const Text('Input SKU / ISBN Manual (Barcode Rusak)'),
              onPressed: widget.onManualInputPressed ?? _showManualInputDialog,
            ),
          ),
        ],
      ),
    );
  }
}
