enum SyncQueueStatus {
  pending,
  syncing,
  synced,
  failed,
}

class StockOpnameSyncQueueModel {
  final String clientMutationId; // UUID v4 idempotency key
  final String bookId;
  final String isbn;
  final String locationId; // Zone-Rack-Bin ID
  final int scannedQuantity;
  final String petugasId;
  final SyncQueueStatus status;
  final String? errorMessage;
  final DateTime createdAt;

  StockOpnameSyncQueueModel({
    required this.clientMutationId,
    required this.bookId,
    required this.isbn,
    required this.locationId,
    required this.scannedQuantity,
    required this.petugasId,
    this.status = SyncQueueStatus.pending,
    this.errorMessage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'client_mutation_id': clientMutationId,
      'book_id': bookId,
      'isbn': isbn,
      'location_id': locationId,
      'scanned_quantity': scannedQuantity,
      'petugas_id': petugasId,
      'status': status.name,
      'error_message': errorMessage,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory StockOpnameSyncQueueModel.fromMap(Map<String, dynamic> map) {
    return StockOpnameSyncQueueModel(
      clientMutationId: map['client_mutation_id'] as String,
      bookId: map['book_id'] as String,
      isbn: map['isbn'] as String,
      locationId: map['location_id'] as String,
      scannedQuantity: map['scanned_quantity'] as int,
      petugasId: map['petugas_id'] as String,
      status: SyncQueueStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SyncQueueStatus.pending,
      ),
      errorMessage: map['error_message'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  StockOpnameSyncQueueModel copyWith({
    SyncQueueStatus? status,
    String? errorMessage,
  }) {
    return StockOpnameSyncQueueModel(
      clientMutationId: clientMutationId,
      bookId: bookId,
      isbn: isbn,
      locationId: locationId,
      scannedQuantity: scannedQuantity,
      petugasId: petugasId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt,
    );
  }
}
