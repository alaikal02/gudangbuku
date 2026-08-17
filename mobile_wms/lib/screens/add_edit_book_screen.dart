import 'package:flutter/material.dart';
import '../models/book.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? bookToEdit;

  const AddEditBookScreen({Key? key, this.bookToEdit}) : super(key: key);

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _safetyThresholdController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _customCoverController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _category = 'Fiqih & Syariah';
  String _zone = 'Zona A';
  String _rack = 'Rak 01';
  String _bin = 'Bin A';
  String _coverType = 'Softcover';

  final List<String> _categories = [
    'Fiqih & Syariah',
    'Nahwu, Sharaf & Alat',
    'Akhlak & Tasawuf',
    'Aqidah & Tauhid',
    'Sastra & Balaghoh',
    'Umum',
  ];

  final List<String> _zones = ['Zona A', 'Zona B', 'Zona C', 'Zona D', 'Zona E'];
  final List<String> _racks = ['Rak 01', 'Rak 02', 'Rak 03', 'Rak 04', 'Rak 05'];
  final List<String> _bins = ['Bin A', 'Bin B', 'Bin C', 'Bin D'];

  final List<String> _coverTypes = [
    'Softcover',
    'Hardcover',
    'Hardcover Lux',
    'Jilid Saku (Pocket)',
    'E-Book (Digital)',
    'Lainnya (Ketik Manual)',
  ];

  @override
  void initState() {
    super.initState();
    final b = widget.bookToEdit;
    _titleController.text = b?.title ?? '';
    _isbnController.text = b?.isbn ?? '';
    _stockController.text = b != null ? b.stock.toString() : '50';
    _safetyThresholdController.text = b != null ? b.safetyThreshold.toString() : '15';
    _authorController.text = b?.author ?? '';
    _publisherController.text = b?.publisher ?? 'Darussholah';
    _priceController.text = b?.price != null ? b!.price!.toStringAsFixed(0) : '60000';
    _costPriceController.text = b?.costPrice != null ? b!.costPrice!.toStringAsFixed(0) : '25000';
    _weightController.text = b?.weightGram != null ? b!.weightGram.toString() : '200';
    _pagesController.text = b?.pages != null ? b!.pages.toString() : '150';
    _sizeController.text = b?.size ?? '14 x 21 cm (A5)';
    _customCoverController.text = b?.coverType ?? '';
    _notesController.text = b?.notes ?? '';

    if (b != null) {
      if (_categories.contains(b.category)) _category = b.category;
      if (_zones.contains(b.locationZone)) _zone = b.locationZone;
      if (_racks.contains(b.locationRack)) _rack = b.locationRack;
      if (_bins.contains(b.locationBin)) _bin = b.locationBin;

      // Match Cover Type
      if (_coverTypes.contains(b.coverType)) {
        _coverType = b.coverType;
      } else {
        _coverType = 'Lainnya (Ketik Manual)';
        _customCoverController.text = b.coverType;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _isbnController.dispose();
    _stockController.dispose();
    _safetyThresholdController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _weightController.dispose();
    _pagesController.dispose();
    _sizeController.dispose();
    _customCoverController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final isbn = _isbnController.text.trim();
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final safetyThreshold = int.tryParse(_safetyThresholdController.text.trim()) ?? 10;
    final author = _authorController.text.trim().isEmpty ? null : _authorController.text.trim();
    final publisher = _publisherController.text.trim().isEmpty ? 'Darussholah' : _publisherController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final costPrice = double.tryParse(_costPriceController.text.trim());
    final weight = int.tryParse(_weightController.text.trim());
    final pages = int.tryParse(_pagesController.text.trim());
    final size = _sizeController.text.trim().isEmpty ? null : _sizeController.text.trim();

    // Determine Cover value
    final finalCover = _coverType == 'Lainnya (Ketik Manual)'
        ? (_customCoverController.text.trim().isNotEmpty ? _customCoverController.text.trim() : 'Softcover')
        : _coverType;

    final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

    if (widget.bookToEdit != null) {
      final updated = widget.bookToEdit!.copyWith(
        title: title,
        isbn: isbn,
        category: _category,
        stock: stock,
        safetyThreshold: safetyThreshold,
        author: author,
        publisher: publisher,
        locationZone: _zone,
        locationRack: _rack,
        locationBin: _bin,
        price: price,
        costPrice: costPrice,
        weightGram: weight,
        pages: pages,
        size: size,
        coverType: finalCover,
        notes: notes,
      );
      Navigator.pop(context, updated);
    } else {
      final newBook = Book(
        title: title,
        isbn: isbn,
        category: _category,
        stock: stock,
        safetyThreshold: safetyThreshold,
        author: author,
        publisher: publisher,
        locationZone: _zone,
        locationRack: _rack,
        locationBin: _bin,
        price: price,
        costPrice: costPrice,
        weightGram: weight,
        pages: pages,
        size: size,
        coverType: finalCover,
        notes: notes,
      );
      Navigator.pop(context, newBook);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.bookToEdit != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF13131F) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        elevation: 1,
        title: Text(
          isEdit ? 'Edit Buku Inventaris' : 'Tambah Judul Buku Baru',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: Colors.cyanAccent),
            tooltip: 'Simpan',
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('1. Identitas & Metadata Buku'),
              _buildTextField(
                controller: _titleController,
                label: 'Judul Lengkap Buku *',
                hint: 'Contoh: Nadham Qaidah Sharfiyyah (Saku)',
                icon: Icons.menu_book,
                isDark: isDark,
                validator: (val) => val == null || val.trim().isEmpty ? 'Judul buku wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _isbnController,
                label: 'Nomor ISBN / Barcode',
                hint: 'Contoh: 978-602-0853-20-4',
                icon: Icons.qr_code_2,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _authorController,
                      label: 'Penulis / Penyusun',
                      hint: 'Nama Penulis',
                      icon: Icons.person_outline,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _publisherController,
                      label: 'Penerbit Utama',
                      hint: 'Darussholah',
                      icon: Icons.domain,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Kategori / Genre Kitab',
                value: _category,
                items: _categories,
                icon: Icons.category_outlined,
                isDark: isDark,
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('2. Inventaris Stok & Denah Rak Fisik'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _stockController,
                      label: 'Stok Fisik Saat Ini (eks) *',
                      hint: '0',
                      icon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Stok wajib diisi';
                        if (int.tryParse(val.trim()) == null) return 'Harus angka valid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _safetyThresholdController,
                      label: 'Batas Minimum Alert (eks) *',
                      hint: '10',
                      icon: Icons.warning_amber_rounded,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Zona Gudang',
                value: _zone,
                items: _zones,
                icon: Icons.grid_view,
                isDark: isDark,
                onChanged: (val) => setState(() => _zone = val!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Nomor Rak',
                      value: _rack,
                      items: _racks,
                      icon: Icons.table_rows_outlined,
                      isDark: isDark,
                      onChanged: (val) => setState(() => _rack = val!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Bin / Kotak',
                      value: _bin,
                      items: _bins,
                      icon: Icons.inbox_outlined,
                      isDark: isDark,
                      onChanged: (val) => setState(() => _bin = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('3. Harga, Spesifikasi Fisik & Logistik'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Harga Jual (HET)',
                      hint: '60000',
                      icon: Icons.monetization_on_outlined,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _costPriceController,
                      label: 'Harga Pokok Cetak (HPP)',
                      hint: '25000',
                      icon: Icons.price_change_outlined,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _weightController,
                      label: 'Berat Buku (Gram)',
                      hint: '180',
                      icon: Icons.scale_outlined,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _pagesController,
                      label: 'Jumlah Halaman (Hlm)',
                      hint: '180',
                      icon: Icons.auto_stories_outlined,
                      keyboardType: TextInputType.number,
                      suffixText: 'Hlm',
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Dropdown Jenis Cover
              _buildDropdown(
                label: 'Jenis Cover / Finishing',
                value: _coverType,
                items: _coverTypes,
                icon: Icons.style_outlined,
                isDark: isDark,
                onChanged: (val) => setState(() => _coverType = val!),
              ),
              if (_coverType == 'Lainnya (Ketik Manual)') ...[
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _customCoverController,
                  label: 'Ketik Jenis Cover Kustom',
                  hint: 'Contoh: Hardcover Kulit Sintetis / Velvet',
                  icon: Icons.edit_note_outlined,
                  isDark: isDark,
                ),
              ],
              const SizedBox(height: 12),
              _buildTextField(
                controller: _sizeController,
                label: 'Dimensi / Ukuran Buku',
                hint: 'Contoh: 14 x 21 cm (A5) atau 10 x 14 cm',
                icon: Icons.aspect_ratio_outlined,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _notesController,
                label: 'Catatan Khusus Gudang',
                hint: 'Keterangan edisi jilid, status stok, atau pesan khusus',
                icon: Icons.note_alt_outlined,
                maxLines: 2,
                isDark: isDark,
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  isEdit ? 'Simpan Perubahan Buku' : 'Daftarkan Buku ke Gudang',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: _saveForm,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    String? suffixText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey[600] : Colors.grey[400]),
        prefixIcon: Icon(icon, size: 18, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        suffixText: suffixText,
        suffixStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.cyanAccent : Colors.teal[800],
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? Colors.transparent : Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? Colors.transparent : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required bool isDark,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      isDense: true,
      items: items.map((it) {
        return DropdownMenuItem<String>(
          value: it,
          child: Text(
            it,
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        prefixIcon: Icon(icon, size: 18, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? Colors.transparent : Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? Colors.transparent : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}
