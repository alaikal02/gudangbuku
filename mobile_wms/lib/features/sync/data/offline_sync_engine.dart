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
    return await openDatabase(
      join(dbPath, 'wms_offline_queue.db'),
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

  // Auto-Sync saat koneksi jaringan pulih kembali
  void initNetworkListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      final isOnline = results.any((r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile);

      if (isOnline) {
        await processSyncQueue();
      }
    });
  }

  // Simpan transaksi lokal (Mode Offline)
  Future<void> enqueueOpnameRecord(StockOpnameSyncQueueModel item) async {
    final db = await database;
    await db.insert('stock_opname_queue', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    processSyncQueue();
  }

  // Flush Antrean Batch ke Backend Server
  Future<void> processSyncQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'stock_opname_queue',
        where: 'status = ?',
        whereArgs: [SyncQueueStatus.pending.name],
        limit: 50,
      );

      if (maps.isEmpty) {
        _isSyncing = false;
        return;
      }

      final itemsToSync = maps.map((m) => StockOpnameSyncQueueModel.fromMap(m)).toList();

      final response = await _dioClient.post(
        _backendApiUrl,
        data: {'batch': itemsToSync.map((item) => item.toMap()).toList()},
        options: Options(
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> syncedIds = response.data['synced_ids'] ?? [];
        for (var item in itemsToSync) {
          if (syncedIds.contains(item.clientMutationId)) {
            await db.update(
              'stock_opname_queue',
              {'status': SyncQueueStatus.synced.name},
              where: 'client_mutation_id = ?',
              whereArgs: [item.clientMutationId],
            );
          }
        }
      }
    } catch (e) {
      print('Gagal melakukan sync: $e');
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
