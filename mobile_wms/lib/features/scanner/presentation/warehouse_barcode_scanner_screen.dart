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
    formats: [
      BarcodeFormat.ean13,
      BarcodeFormat.code128,
      BarcodeFormat.qrCode,
    ],
  );

  bool _isProcessing = false;

  void _handleBarcodeCapture(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final Barcode barcode = barcodes.first;
    final String? rawValue = barcode.rawValue;

    if (rawValue != null && rawValue.trim().isNotEmpty) {
      setState(() {
        _isProcessing = true;
      });

      // 1. Haptic Feedback untuk respon getar seperti physical barcode scanner
      HapticFeedback.mediumImpact();

      // 2. Kirim callback barcode yang terdeteksi
      widget.onBarcodeScanned(rawValue.trim(), barcode.format.name);

      // 3. Delay/Debounce 1.2 detik untuk mencegah double-triggering
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showManualInputDialog() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          title: const Text(
            'Input ISBN / SKU Manual',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: textController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Contoh: 9786020324121',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.cyanAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              onPressed: () {
                final input = textController.text.trim();
                if (input.isNotEmpty) {
                  Navigator.of(context).pop();
                  widget.onBarcodeScanned(input, 'MANUAL_ENTRY');
                }
              },
              child: const Text('Gunakan', style: TextStyle(color: Colors.black)),
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
    final screenSize = MediaQuery.of(context).size;
    final scanAreaWidth = screenSize.width * 0.82;
    const scanAreaHeight = 220.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Pemindai Barcode Buku & Rak',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 2,
        actions: [
          // Senter Flash Toggle
          ValueListenableBuilder(
            valueListenable: _scannerController.torchState,
            builder: (context, state, child) {
              final isTorchOn = state == TorchState.on;
              return IconButton(
                icon: Icon(
                  isTorchOn ? Icons.flash_on : Icons.flash_off,
                  color: isTorchOn ? Colors.yellowAccent : Colors.grey.shade400,
                ),
                onPressed: () => _scannerController.toggleTorch(),
                tooltip: 'Senter / Flash',
              );
            },
          ),
          // Switch Camera Facing (Depan / Belakang)
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () => _scannerController.switchCamera(),
            tooltip: 'Ganti Kamera',
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Live Camera View
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcodeCapture,
          ),

          // 2. Darkened Masking Overlay dengan Cutout di Tengah
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.55),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: scanAreaWidth,
                    height: scanAreaHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Reticle / Focus Overlay Box dengan Animasi Visual Buffer
          Align(
            alignment: Alignment.center,
            child: Container(
              width: scanAreaWidth,
              height: scanAreaHeight,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isProcessing ? Colors.greenAccent : Colors.cyanAccent,
                  width: _isProcessing ? 3.5 : 2.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  if (_isProcessing)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 4. Status Indicator & Instruction Label
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isProcessing ? Icons.sync : Icons.qr_code_scanner,
                      color: _isProcessing ? Colors.greenAccent : Colors.cyanAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isProcessing
                          ? "Membaca Barcode ISBN..."
                          : "Posisikan Barcode ISBN / QR Rak di dalam Kotak",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 5. Fallback Button: Input Manual Barcode Rusak
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
                elevation: 4,
              ),
              icon: const Icon(Icons.keyboard_alt_outlined),
              label: const Text(
                'Input SKU / ISBN Manual (Barcode Rusak)',
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
