import 'package:uuid/uuid.dart';

enum MovementType {
  inbound, // Masuk dari percetakan / re-print
  outbound, // Keluar untuk pesanan toko / reseller / B2B
  opnameAdjustment, // Penyesuaian hasil audit fisik
  relocation, // Pindah posisi rak fisik
}

extension MovementTypeExt on MovementType {
  String get label {
    switch (this) {
      case MovementType.inbound:
        return 'Barang Masuk (Cetak)';
      case MovementType.outbound:
        return 'Barang Keluar (Kirim)';
      case MovementType.opnameAdjustment:
        return 'Koreksi Opname';
      case MovementType.relocation:
        return 'Relokasi Rak';
    }
  }

  String get shortCode {
    switch (this) {
      case MovementType.inbound:
        return 'INBOUND';
      case MovementType.outbound:
        return 'OUTBOUND';
      case MovementType.opnameAdjustment:
        return 'OPNAME';
      case MovementType.relocation:
        return 'RELOKASI';
    }
  }
}

class StockMovement {
  final String id;
  final String bookId;
  final String bookTitle;
  final String? isbn;
  final MovementType type;
  final int quantity; // Positif untuk inbound, negatif untuk outbound
  final int balanceAfter; // Sisa stok setelah mutasi
  final String? referenceNumber; // No. Surat Jalan / No. Resi / No. Nota
  final String? locationFrom;
  final String? locationTo;
  final String? notes;
  final String petugasName;
  final DateTime timestamp;

  StockMovement({
    String? id,
    required this.bookId,
    required this.bookTitle,
    this.isbn,
    required this.type,
    required this.quantity,
    required this.balanceAfter,
    this.referenceNumber,
    this.locationFrom,
    this.locationTo,
    this.notes,
    this.petugasName = 'Owner / Admin',
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'isbn': isbn,
      'type': type.name,
      'quantity': quantity,
      'balanceAfter': balanceAfter,
      'referenceNumber': referenceNumber,
      'locationFrom': locationFrom,
      'locationTo': locationTo,
      'notes': notes,
      'petugasName': petugasName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'],
      bookId: json['bookId'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      isbn: json['isbn'],
      type: MovementType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => MovementType.inbound,
      ),
      quantity: json['quantity'] ?? 0,
      balanceAfter: json['balanceAfter'] ?? 0,
      referenceNumber: json['referenceNumber'],
      locationFrom: json['locationFrom'],
      locationTo: json['locationTo'],
      notes: json['notes'],
      petugasName: json['petugasName'] ?? 'Owner / Admin',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }
}
