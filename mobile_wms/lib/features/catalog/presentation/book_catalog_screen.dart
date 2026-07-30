import 'package:flutter/material.dart';

class BookCatalogScreen extends StatefulWidget {
  const BookCatalogScreen({Key? key}) : super(key: key);

  @override
  State<BookCatalogScreen> createState() => _BookCatalogScreenState();
}

class _BookCatalogScreenState extends State<BookCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua Kategori';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _dummyCatalog = [
    {
      'id': 'BK-8801',
      'title': 'Panduan Penerbitan & Cetak Buku',
      'isbn': '978-602-03-2412-1',
      'author': 'Tim Redaksi Penerbit',
      'publisher': 'Penerbit Aksara Utama',
      'category': 'Penerbitan & Edukasi',
      'stock': 142,
      'safety_threshold': 10,
      'location': 'Rak A-01-B',
      'cover_color': Colors.blueAccent,
      'has_barcode': true,
    },
    {
      'id': 'BK-8802',
      'title': 'Kumpulan Puisi Nusantara (Cetakan Khusus)',
      'isbn': 'TANPA-BARCODE-001',
      'author': 'Sastrawan Muda',
      'publisher': 'Penerbit Mandiri',
      'category': 'Sastra & Seni',
      'stock': 8, // Stok Menipis
      'safety_threshold': 10,
      'location': 'Rak B-02-A',
      'cover_color': Colors.amberAccent,
      'has_barcode': false,
    },
    {
      'id': 'BK-8803',
      'title': 'Ensiklopedi Sains Anak Interaktif',
      'isbn': '978-602-44-0112-9',
      'author': 'Prof. Ahmad Dahlan',
      'publisher': 'Pustaka Cendekia',
      'category': 'Sains & Anak',
      'stock': 320,
      'safety_threshold': 15,
      'location': 'Rak C-01-C',
      'cover_color': Colors.purpleAccent,
      'has_barcode': true,
    },
    {
      'id': 'BK-8804',
      'title': 'Manajemen Usaha Penerbitan Buku',
      'isbn': '978-602-12-8890-4',
      'author': 'Budi Santoso, M.T.',
      'publisher': 'Erlangga Utama',
      'category': 'Bisnis & Manajemen',
      'stock': 92,
      'safety_threshold': 20,
      'location': 'Rak D-05-D',
      'cover_color': Colors.greenAccent,
      'has_barcode': true,
    },
  ];

  final List<String> _categories = [
    'Semua Kategori',
    'Penerbitan & Edukasi',
    'Sastra & Seni',
    'Sains & Anak',
    'Bisnis & Manajemen',
  ];

  List<Map<String, dynamic>> get _filteredCatalog {
    return _dummyCatalog.where((book) {
      final matchesQuery = book['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['isbn'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['author'].toString().toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'Semua Kategori' || book['category'] == _selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();
  }

  // Dialog Konfirmasi Hapus Produk/Buku
  void _showDeleteBookConfirmDialog(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
              SizedBox(width: 10),
              Text('Hapus Buku?', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apakah Anda yakin ingin menghapus buku berikut dari katalog gudang?',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['title'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text('Kode: ${book['isbn']} | Stok: ${book['stock']} ex', style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Ya, Hapus Buku', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                final deletedTitle = book['title'];
                setState(() {
                  _dummyCatalog.removeWhere((item) => item['id'] == book['id']);
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content: Text('Buku "$deletedTitle" berhasil dihapus dari katalog!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog Khusus Edit Lokasi Rak
  void _showEditRackLocationDialog(Map<String, dynamic> book) {
    final locationCtrl = TextEditingController(text: book['location']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.place_outlined, color: Colors.amberAccent),
              SizedBox(width: 10),
              Text('Edit Lokasi Rak Buku', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul Buku: ${book['title']}', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text('Lokasi Rak Saat Ini: ${book['location']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 14),

              TextField(
                controller: locationCtrl,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'Lokasi Rak / Zona / Lemari Baru',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.place, color: Colors.amberAccent),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.save),
              label: const Text('Simpan Lokasi Rak', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                final newLocation = locationCtrl.text.trim();
                if (newLocation.isEmpty) return;

                setState(() {
                  book['location'] = newLocation;
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.amber.shade900,
                    content: Text('Lokasi rak "${book['title']}" diperbarui menjadi $newLocation!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog Kelola & Ubah Stok / Transaksi
  void _showUpdateStockDialog(Map<String, dynamic> book) {
    final qtyCtrl = TextEditingController(text: '1');
    final noteCtrl = TextEditingController();
    String mutationType = 'OUTBOUND'; // OUTBOUND (Terjual), INBOUND (Cetak Baru)

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E2E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: const [
                  Icon(Icons.edit_note, color: Colors.cyanAccent),
                  SizedBox(width: 10),
                  Text('Kelola Stok Buku', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Buku
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book['title'], style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Kode: ${book['isbn']} | Lokasi: ${book['location']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text('Stok Saat Ini: ${book['stock']} exemplar', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('Pilih Jenis Aksi:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),

                    // Segment: Terjual (-) / Cetak (+)
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Terjual (-)'),
                            selected: mutationType == 'OUTBOUND',
                            selectedColor: Colors.redAccent,
                            backgroundColor: Colors.black26,
                            labelStyle: TextStyle(
                              color: mutationType == 'OUTBOUND' ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            onSelected: (selected) {
                              if (selected) setDialogState(() => mutationType = 'OUTBOUND');
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Cetak / Tambah (+)'),
                            selected: mutationType == 'INBOUND',
                            selectedColor: Colors.greenAccent,
                            backgroundColor: Colors.black26,
                            labelStyle: TextStyle(
                              color: mutationType == 'INBOUND' ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            onSelected: (selected) {
                              if (selected) setDialogState(() => mutationType = 'INBOUND');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: mutationType == 'OUTBOUND' ? 'Jumlah Terjual (Exemplar)' : 'Jumlah Tambahan (Exemplar)',
                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        prefixIcon: Icon(
                          mutationType == 'OUTBOUND' ? Icons.remove_circle_outline : Icons.add_circle_outline,
                          color: mutationType == 'OUTBOUND' ? Colors.redAccent : Colors.greenAccent,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Catatan Opsional
                    TextField(
                      controller: noteCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Catatan / Keterangan (Opsional)',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
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
                    backgroundColor: mutationType == 'OUTBOUND' ? Colors.redAccent : Colors.greenAccent,
                    foregroundColor: mutationType == 'OUTBOUND' ? Colors.white : Colors.black,
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    final amount = int.tryParse(qtyCtrl.text.trim()) ?? 0;
                    if (amount <= 0) return;

                    final currentStock = book['stock'] as int;
                    int newStock = currentStock;

                    if (mutationType == 'OUTBOUND') {
                      if (amount > currentStock) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Jumlah penjualan melebihi stok yang ada!')),
                        );
                        return;
                      }
                      newStock = currentStock - amount;
                    } else if (mutationType == 'INBOUND') {
                      newStock = currentStock + amount;
                    }

                    setState(() {
                      book['stock'] = newStock;
                    });

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: mutationType == 'OUTBOUND' ? Colors.red.shade900 : Colors.green.shade900,
                        content: Text(
                          mutationType == 'OUTBOUND'
                              ? 'Terjual $amount ex! Stok "${book['title']}" menjadi $newStock ex.'
                              : 'Berhasil ditambah $amount ex! Stok "${book['title']}" menjadi $newStock ex.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddBookDialog() {
    final titleCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final authorCtrl = TextEditingController();
    final locationCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.add_box_outlined, color: Colors.cyanAccent),
              SizedBox(width: 10),
              Text(
                'Tambah Buku Baru',
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
                  'Ambil foto sampul/tumpukan buku. Pengisian judul dan detail lainnya bersifat opsional.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),

                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto buku berhasil diambil!')),
                    );
                  },
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.4)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, color: Colors.cyanAccent, size: 28),
                        SizedBox(height: 4),
                        Text('Ambil Foto Buku (Opsional)', style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Judul Buku (Opsional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Exemplar / Stok (Opsional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: authorCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nama Penulis / Penerbit (Opsional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: locationCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Lokasi Rak / Lemari (Opsional)',
                    labelStyle: TextStyle(color: Colors.grey),
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
              label: const Text('Simpan ke Katalog', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                final newTitle = titleCtrl.text.trim().isNotEmpty ? titleCtrl.text.trim() : 'Buku Baru (Tanpa Judul)';
                final newQty = int.tryParse(qtyCtrl.text.trim()) ?? 1;

                setState(() {
                  _dummyCatalog.insert(0, {
                    'id': 'BK-${DateTime.now().millisecondsSinceEpoch}',
                    'title': newTitle,
                    'isbn': 'TANPA-BARCODE-${_dummyCatalog.length + 1}',
                    'author': authorCtrl.text.trim().isNotEmpty ? authorCtrl.text.trim() : 'Penerbit Aksara',
                    'publisher': 'Penerbit Aksara',
                    'category': 'Penerbitan & Edukasi',
                    'stock': newQty,
                    'safety_threshold': 5,
                    'location': locationCtrl.text.trim().isNotEmpty ? locationCtrl.text.trim() : 'Rak Utama',
                    'cover_color': Colors.tealAccent,
                    'has_barcode': false,
                  });
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green.shade800,
                    content: Text('Buku "$newTitle" ($newQty exemplar) berhasil ditambahkan!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog & Stok Buku Penerbit'),
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.cyanAccent, size: 28),
            tooltip: 'Tambah Buku Baru',
            onPressed: _showAddBookDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Pencarian
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E2E),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari Judul Buku, ISBN, atau Penulis...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Chip Kategori
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: Colors.cyanAccent,
                        backgroundColor: Colors.black.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCategory = category);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Daftar Katalog Buku
          Expanded(
            child: _filteredCatalog.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Buku tidak ditemukan di katalog', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCatalog.length,
                    itemBuilder: (context, index) {
                      final book = _filteredCatalog[index];
                      final isLowStock = book['stock'] <= book['safety_threshold'];
                      final hasBarcode = book['has_barcode'] as bool? ?? true;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        color: const Color(0xFF1E1E2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isLowStock ? Colors.redAccent.withOpacity(0.6) : Colors.white12,
                            width: isLowStock ? 1.5 : 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: (book['cover_color'] as Color).withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: book['cover_color'] as Color),
                                    ),
                                    child: Icon(
                                      hasBarcode ? Icons.book : Icons.photo_camera_back,
                                      color: book['cover_color'] as Color,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                book['title'],
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (!hasBarcode)
                                              Container(
                                                margin: const EdgeInsets.only(left: 6),
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: const Text('Foto', style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Penulis: ${book['author']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        Text(
                                          hasBarcode ? 'ISBN: ${book['isbn']}' : 'Kode Internal: ${book['isbn']}',
                                          style: TextStyle(
                                            color: hasBarcode ? Colors.cyanAccent : Colors.orangeAccent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Tap langsung pada Tag Lokasi Rak (dengan Icon Pensil Edit Rak)
                                            InkWell(
                                              onTap: () => _showEditRackLocationDialog(book),
                                              borderRadius: BorderRadius.circular(6),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.place_outlined, size: 15, color: Colors.amberAccent),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      book['location'],
                                                      style: const TextStyle(
                                                        color: Colors.amberAccent,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        decoration: TextDecoration.underline,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(Icons.edit_location_alt_outlined, size: 14, color: Colors.amberAccent),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: isLowStock ? Colors.redAccent.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                'Stok: ${book['stock']} ex',
                                                style: TextStyle(
                                                  color: isLowStock ? Colors.redAccent : Colors.greenAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white12, height: 20),

                              // Baris Aksi yang Ditukar: Hapus Produk di Kiri & Kelola Stok di Kanan
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Tombol Hapus Produk (Tong Sampah Red) - Sekarang di KIRI
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    tooltip: 'Hapus Buku Ini',
                                    onPressed: () => _showDeleteBookConfirmDialog(book),
                                  ),

                                  // Tombol Kelola Stok - Sekarang di KANAN
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2A2A3D),
                                      foregroundColor: Colors.cyanAccent,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(color: Colors.cyanAccent, width: 1.2),
                                      ),
                                    ),
                                    icon: const Icon(Icons.edit_note, size: 18),
                                    label: const Text('Kelola Stok', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    onPressed: () => _showUpdateStockDialog(book),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
