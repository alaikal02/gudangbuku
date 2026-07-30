# language: id
Fitur: Skenario Uji Kritis Sistem WMS Gudang Buku Skala Besar

  Skenario: Sinkronisasi data opname otomatis saat perangkat Android kembali terhubung Wi-Fi
    Given Perangkat Android petugas berada di area blank spot tanpa koneksi internet
    And Petugas telah mencatat 25 transaksi opname fisik yang tersimpan di SQLite lokal dengan status "PENDING_SYNC"
    When Perangkat Android berpindah lokasi dan mendapatkan sinyal Wi-Fi gudang "WMS-WIFI-ZONE-A"
    Then Mobile Sync Engine secara otomatis mendeteksi perubahan status jaringan menjadi ONLINE
    And Background service mengirimkan batch 25 transaksi opname ke endpoint POST "/api/v1/sync/opname"
    And Server Backend merespons HTTP 200 OK dengan daftar UUID transaksi yang sukses
    And Status 25 data transaksi di database lokal HP berubah dari "PENDING_SYNC" menjadi "SYNCED"

  Skenario: Penolakan transaksi (Distributed Lock Redlock) saat pengambilan barang bersamaan pada stok terakhir
    Given Buku dengan ISBN "9786020324121" di Rak "A-01-B" hanya tersisa 1 exemplar di database
    When Petugas A memindai barcode untuk pengambilan 1 exemplar pada pukul 10:00:00.100
    And Petugas B memindai barcode untuk pengambilan 1 exemplar pada pukul 10:00:00.102
    Then Sistem Backend mengunci resource kunci "lock:inventory:BK-8801" menggunakan Redis Redlock untuk Petugas A
    And Permintaan Petugas A berhasil memperbarui stok menjadi 0 exemplar dan menghasilkan pesanan "PICK-001"
    And Permintaan Petugas B ditolak oleh Redis Lock dengan respons HTTP 409 Conflict "Stok telah dialokasikan oleh transaksi lain"
    And Sisa stok di database tidak boleh bernilai negatif (-1)

  Skenario: Pengiriman notifikasi alert merah ke Web Admin Dashboard saat stok menyentuh Safety Threshold
    Given Buku "Clean Code" memiliki stok awal 11 exemplar dengan Safety Threshold dikonfigurasi 10 exemplar
    And Web Admin Dashboard terhubung ke WebSocket Notifikasi Gudang
    When Terjadi mutasi pengeluaran barang sebanyak 2 exemplar untuk pengiriman toko cabang
    Then Sisa stok fisik buku berkurang secara transaksional menjadi 9 exemplar
    And Domain Event "INVENTORY_SAFETY_THRESHOLD_REACHED" dipublikasikan ke Kafka Topic "wms-inventory-events"
    And WebSocket Consumer meneruskan pesan ke Web Admin Dashboard
    And Dashboard Web Admin menampilkan popup alert merah "PERINGATAN STOK CRITICAL: Clean Code (Sisa 9)" dalam waktu kurang dari 500 milidetik
