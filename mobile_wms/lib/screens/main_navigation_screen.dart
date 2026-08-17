import 'package:flutter/material.dart';
import '../services/warehouse_stock_service.dart';
import '../services/theme_service.dart';
import '../features/scanner/presentation/warehouse_barcode_scanner_screen.dart';
import '../models/stock_movement.dart';
import '../widgets/quick_stock_dialog.dart';
import 'stock_monitoring_dashboard_screen.dart';
import 'inventory_catalog_screen.dart';
import 'warehouse_rack_screen.dart';
import 'stock_movement_history_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final WarehouseStockService stockService;
  final ThemeService themeService;

  const MainNavigationScreen({
    Key? key,
    required this.stockService,
    required this.themeService,
  }) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.stockService.addListener(_onStockServiceChanged);
    widget.themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    widget.stockService.removeListener(_onStockServiceChanged);
    widget.themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onStockServiceChanged() {
    if (mounted) setState(() {});
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openBarcodeScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WarehouseBarcodeScannerScreen(
          onBarcodeScanned: (barcode, format) {
            Navigator.of(context).pop(); // Close scanner
            _handleScannedBarcode(barcode);
          },
        ),
      ),
    );
  }

  void _handleScannedBarcode(String barcode) {
    final book = widget.stockService.findBookByIsbnOrBarcode(barcode);

    if (book != null) {
      showDialog<QuickStockAdjustmentResult>(
        context: context,
        builder: (context) => QuickStockDialog(book: book, initialType: MovementType.inbound),
      ).then((result) {
        if (result != null) {
          widget.stockService.adjustStock(
            bookId: book.id,
            delta: result.delta,
            type: result.type,
            referenceNumber: result.referenceNumber,
            notes: result.notes,
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mutasi stok scan "${book.title}" berhasil dicatat!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Buku dengan barcode/ISBN "$barcode" tidak ditemukan di katalog gudang.'),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pages = [
      StockMonitoringDashboardScreen(
        stockService: widget.stockService,
        themeService: widget.themeService,
        onNavigateToTab: _navigateToTab,
        onOpenScanner: _openBarcodeScanner,
      ),
      InventoryCatalogScreen(stockService: widget.stockService),
      WarehouseRackScreen(stockService: widget.stockService),
      StockMovementHistoryScreen(stockService: widget.stockService),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.inventory_2_outlined),
                  if (widget.stockService.lowStockCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.inventory_2_rounded),
              label: 'Inventaris',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Denah Rak',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'Riwayat Mutasi',
            ),
          ],
        ),
      ),
    );
  }
}
