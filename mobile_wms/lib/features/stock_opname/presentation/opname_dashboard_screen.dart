import 'package:flutter/material.dart';
import '../../scanner/presentation/warehouse_barcode_scanner_screen.dart';
import '../../sync/data/offline_sync_engine.dart';
import '../../catalog/presentation/book_catalog_screen.dart';
import 'opname_result_dialog.dart';
import 'package:dio/dio.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({Key? key}) : super(key: key);

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const OpnameDashboardScreen(),
          const BookCatalogScreen(),
          WarehouseBarcodeScannerScreen(
            onBarcodeScanned: (barcode, format) {
              setState(() => _currentIndex = 0);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E1E2E),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Audit Stok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Katalog Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
            label: 'Pindai & Foto',
          ),
        ],
      ),
    );
  }
}

class OpnameDashboardScreen extends StatefulWidget {
  const OpnameDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OpnameDashboardScreen> createState() => _OpnameDashboardScreenState();
}

class _OpnameDashboardScreenState extends State<OpnameDashboardScreen> {
  late final OfflineSyncEngine _syncEngine;
  int _pendingSyncCount = 0;

  @override
  void initState() {
    super.initState();
    _syncEngine = OfflineSyncEngine(dioClient: Dio());
    _syncEngine.initNetworkListener();
    _refreshSyncQueueCount();
  }

  void _refreshSyncQueueCount() async {
    final db = await _syncEngine.database;
    final result = await db.rawQuery("SELECT COUNT(*) as count FROM stock_opname_queue WHERE status = 'pending'");
    final count = result.first['count'] as int? ?? 0;

    if (mounted) {
      setState(() {
        _pendingSyncCount = count;
      });
    }
  }

  void _openCameraScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WarehouseBarcodeScannerScreen(
          onBarcodeScanned: (barcode, format) {
            _showOpnameDialog(barcode, format);
          },
        ),
      ),
    );
  }

  void _showOpnameDialog(String barcode, String format) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OpnameResultDialog(
        barcodeStr: barcode,
        scanFormat: format,
        syncEngine: _syncEngine,
      ),
    ).then((_) => _refreshSyncQueueCount());
  }

  @override
  void dispose() {
    _syncEngine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gudang Buku Penerbit - Mandiri'),
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.cyanAccent),
            tooltip: 'Kirim Data Terikat (Sinkronisasi)',
            onPressed: () async {
              await _syncEngine.processSyncQueue();
              _refreshSyncQueueCount();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proses sinkronisasi data sedang berjalan...')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Status Koneksi & Jaringan (Offline-First)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Sistem Offline Otomatis Aktif',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _pendingSyncCount > 0 ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_pendingSyncCount Data Menunggu',
                      style: TextStyle(
                        color: _pendingSyncCount > 0 ? Colors.orangeAccent : Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Utama: Pindai Barcode / Foto Buku
            InkWell(
              onTap: _openCameraScanner,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 34),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Pindai / Foto Buku Baru',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Scan barcode atau foto buku tanpa barcode',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Kartu Ringkasan
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Buku Di-Audit Hari Ini',
                    value: '128 Judul',
                    icon: Icons.check_box_outlined,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Lokasi Rak Aktif',
                    value: 'Rak Utama A-04',
                    icon: Icons.place_outlined,
                    color: Colors.yellowAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Riwayat Aktivitas Audit
            const Text(
              'Aktivitas Pendataan Terakhir',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              title: 'Panduan Penerbitan & Cetak',
              isbn: '978-602-03-2412-1',
              qty: '145 Exemplar',
              time: '11:02 WIB',
              location: 'Rak A-01-B',
              isSynced: true,
            ),
            _buildActivityItem(
              title: 'Kumpulan Puisi (Foto Sampul)',
              isbn: 'TANPA-BARCODE-001',
              qty: '8 Exemplar',
              time: '10:45 WIB',
              location: 'Rak B-02-A',
              isSynced: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String isbn,
    required String qty,
    required String time,
    required String location,
    required bool isSynced,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.book, color: Colors.cyanAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('Kode: $isbn | $location', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(qty, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isSynced ? Icons.cloud_done : Icons.cloud_upload_outlined,
                    size: 14,
                    color: isSynced ? Colors.greenAccent : Colors.orangeAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isSynced ? 'TERKIRIM' : 'MENUNGGU',
                    style: TextStyle(
                      color: isSynced ? Colors.greenAccent : Colors.orangeAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
