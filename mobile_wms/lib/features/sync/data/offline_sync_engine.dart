import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/models/sync_queue_model.dart';

class OfflineSyncEngine {
  static Database? _database;
  final Dio _dioClient;
  final String _backendApiUrl;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  OfflineSyncEngine({
    required Dio dioClient,
    String backendApiUrl = 'http://10.0.2.2:3000/api/v1/sync/opname',
  })  : _dioClient = dioClient,
        _backendApiUrl = backendApiUrl;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wms_offline_queue.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE stock_opname_queue (
            client_mutation_id TEXT PRIMARY KEY,
            book_id TEXT NOT NULL,
            isbn TEXT NOT NULL,
            location_id TEXT NOT NULL,
            scanned_quantity INTEGER NOT NULL,
            petugas_id TEXT NOT NULL,
            status TEXT NOT NULL,
            error_message TEXT,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // 1. Inisialisasi Event Listener Perubahan Jaringan (Online / Offline)
  void initNetworkListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      final isOnline = results.any((result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet);

      if (isOnline) {
        print('🌐 Sinyal terhubung kembali! Memulai proses auto-sync...');
        await processSyncQueue();
      }
    });
  }

  // 2. Simpan Transaksi Opname ke Local SQLite DB (Mode Offline)
  Future<void> enqueueOpnameRecord(StockOpnameSyncQueueModel item) async {
    final db = await database;
    await db.insert(
      'stock_opname_queue',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('💾 Opname lokal tersimpan (ID: ${item.clientMutationId}) dengan status PENDING');

    // Coba kirim instan jika sedang online
    processSyncQueue();
  }

  // 3. Eksekusi Pengiriman Batch ke Backend Server
  Future<void> processSyncQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'stock_opname_queue',
        where: 'status = ?',
        whereArgs: [SyncQueueStatus.pending.name],
        orderBy: 'created_at ASC',
        limit: 50, // Batch limit 50 items per sync request
      );

      if (maps.isEmpty) {
        _isSyncing = false;
        return;
      }

      final itemsToSync =
          maps.map((m) => StockOpnameSyncQueueModel.fromMap(m)).toList();
      print('🚀 Mengirim batch ${itemsToSync.length} transaksi opname ke server...');

      // Tandai item sebagai SYNCING
      for (var item in itemsToSync) {
        await db.update(
          'stock_opname_queue',
          {'status': SyncQueueStatus.syncing.name},
          where: 'client_mutation_id = ?',
          whereArgs: [item.clientMutationId],
        );
      }

      // HTTP POST Batch Data ke Backend Gateway
      final response = await _dioClient.post(
        _backendApiUrl,
        data: {
          'batch': itemsToSync.map((item) => item.toMap()).toList(),
        },
        options: Options(timeout: const Duration(seconds: 15)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> syncedIds = response.data['synced_ids'] ?? [];

        for (var item in itemsToSync) {
          if (syncedIds.contains(item.clientMutationId)) {
            // Tandai item sukses tersinkronisasi
            await db.update(
              'stock_opname_queue',
              {'status': SyncQueueStatus.synced.name},
              where: 'client_mutation_id = ?',
              whereArgs: [item.clientMutationId],
            );
          }
        }
        print('✅ Batch sync berhasil diproses oleh Backend');
      }
    } on DioException catch (dioErr) {
      print('⚠️ Gagal terhubung ke backend server: ${dioErr.message}');
      await _rollbackSyncingStatus();
    } catch (e) {
      print('❌ Error tak terduga saat sync: $e');
      await _rollbackSyncingStatus();
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _rollbackSyncingStatus() async {
    final db = await database;
    await db.update(
      'stock_opname_queue',
      {'status': SyncQueueStatus.pending.name},
      where: 'status = ?',
      whereArgs: [SyncQueueStatus.syncing.name],
    );
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
