import 'package:uuid/uuid.dart';

class Book {
  final String id;
  String title;
  String isbn;
  String category;
  int stock;
  int safetyThreshold;
  String publisher;
  String? author;
  String locationZone;
  String locationRack;
  String locationBin;
  double? costPrice;
  double? price;
  int? weightGram;
  String? pages;
  String? size;
  String? photoUrl;
  String? notes;
  DateTime updatedAt;

  Book({
    String? id,
    required this.title,
    this.isbn = '',
    this.category = 'Umum',
    required this.stock,
    this.safetyThreshold = 10,
    this.publisher = 'Darussholah',
    this.author,
    this.locationZone = 'Zona A',
    this.locationRack = 'Rak 01',
    this.locationBin = 'Bin 01',
    this.costPrice,
    this.price,
    this.weightGram,
    this.pages,
    this.size,
    this.photoUrl,
    this.notes,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get isOutOfStock => stock <= 0;
  bool get isLowStock => stock > 0 && stock <= safetyThreshold;
  bool get isStockSafe => stock > safetyThreshold;

  String get locationCode => '$locationZone - $locationRack - $locationBin';

  Book copyWith({
    String? title,
    String? isbn,
    String? category,
    int? stock,
    int? safetyThreshold,
    String? publisher,
    String? author,
    String? locationZone,
    String? locationRack,
    String? locationBin,
    double? costPrice,
    double? price,
    int? weightGram,
    String? pages,
    String? size,
    String? photoUrl,
    String? notes,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      isbn: isbn ?? this.isbn,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      safetyThreshold: safetyThreshold ?? this.safetyThreshold,
      publisher: publisher ?? this.publisher,
      author: author ?? this.author,
      locationZone: locationZone ?? this.locationZone,
      locationRack: locationRack ?? this.locationRack,
      locationBin: locationBin ?? this.locationBin,
      costPrice: costPrice ?? this.costPrice,
      price: price ?? this.price,
      weightGram: weightGram ?? this.weightGram,
      pages: pages ?? this.pages,
      size: size ?? this.size,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isbn': isbn,
      'category': category,
      'stock': stock,
      'safetyThreshold': safetyThreshold,
      'publisher': publisher,
      'author': author,
      'locationZone': locationZone,
      'locationRack': locationRack,
      'locationBin': locationBin,
      'costPrice': costPrice,
      'price': price,
      'weightGram': weightGram,
      'pages': pages,
      'size': size,
      'photoUrl': photoUrl,
      'notes': notes,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'] ?? '',
      isbn: json['isbn'] ?? '',
      category: json['category'] ?? 'Umum',
      stock: json['stock'] ?? 0,
      safetyThreshold: json['safetyThreshold'] ?? 10,
      publisher: json['publisher'] ?? 'Darussholah',
      author: json['author'],
      locationZone: json['locationZone'] ?? 'Zona A',
      locationRack: json['locationRack'] ?? 'Rak 01',
      locationBin: json['locationBin'] ?? 'Bin 01',
      costPrice: json['costPrice'] != null ? (json['costPrice'] as num).toDouble() : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      weightGram: json['weightGram'] != null ? (json['weightGram'] as num).toInt() : null,
      pages: json['pages'],
      size: json['size'],
      photoUrl: json['photoUrl'],
      notes: json['notes'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
