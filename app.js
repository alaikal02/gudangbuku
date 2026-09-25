/*
========================================================================
   DARUSSHOLAH - INTERACTIVE APPLICATION ENGINE
   State Management, SPA Routing, Catalog Engine, Cart, Modals & Forms
========================================================================
*/

// --- BOOK DATABASE (Synced with API / books.json) ---
let BOOKS = [
  {
    id: "nadham-qaidah-sharfiyyah",
    title: "Nadham Qaidah sharfiyyah (saku)",
    author: "K.H. M. Anwar",
    genre: "tatabahasa",
    format: "print",
    status: "bestseller",
    isbn: "978-602-0853-20-4",
    price: 55000,
    originalPrice: 55000,
    discount: 0,
    synopsis: "Buku saku praktis yang memuat bait-bait Nadham Qaidah Sharfiyyah untuk memudahkan para santri menghafal dan memahami perubahan kata (tashrif) dalam tata bahasa Arab. Sangat cocok bagi santri tingkat dasar (Ibtidaiyah) untuk hafalan harian.",
    coverClass: "bg-gradient-to-br from-indigo-950 via-slate-900 to-indigo-900",
    coverImg: "",
    specs: {
      language: "Arab & Indonesia",
      pages: "96 Halaman",
      size: "10 x 14 cm (Saku)",
      weight: "120 gram",
      releaseDate: "Mei 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>بَابُ التَّصْرِيْفِ</h2><p>تَصْرِيْفُ الأسْمَاءِ وَالأفْعَالِ هُوَ تَحْوِيْلُ الأصْلِ الْوَاحِدِ اِلىٰ أمْثِلَةٍ مُخْتَلِفَةٍ لِمَعَانٍ مَقْصُوْدَةٍ لاَ تَحْصُلُ اِلاَّ بِهَا.</p><p>Tashrif secara bahasa berarti perubahan. Secara istilah, tashrif adalah merubah bentuk kalimat asal (masdar/fi'il) ke bentuk-bentuk lain untuk menghasilkan makna yang dikehendaki.</p>",
        right: "<h2>KAIDAH PERUBAHAN</h2><p>1. Fi'il Tsulatsi Mujarrad memiliki 6 bab tasrif: fa'ala-yaf'ulu, fa'ala-yaf'ili, fa'ala-yaf'alu, fa'ila-yaf'alu, fa'ula-yaf'ulu, fa'ila-yaf'ilu.</p><p>Santri diwajibkan menghafal wazan dan mauzun beserta contoh penerapannya dalam Al-Qur'an.</p>"
      }
    ]
  },
  {
    id: "trjmh-f-qorib-zaman-now",
    altId: "trjmh-fqorib-zaman-now-saku",
    title: "Trjmh F.Qorib Zaman Now (saku)",
    author: "Tim Redaksi Darussholah",
    genre: "fiqih",
    format: "print",
    status: "new",
    isbn: "978-602-0853-21-1",
    price: 60000,
    originalPrice: 75000,
    discount: 20,
    synopsis: "Terjemah Kitab Fathul Qorib Al-Mujib yang disajikan secara kekinian dengan bahasa yang mudah dicerna oleh generasi millenial dan santri era digital, tanpa mengurangi orisinalitas hukum fikih fiqih Syafi'iyah.",
    warranty: "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.",
    marketplace_links: {
      tokopedia: "https://tokopedia.com",
      shopee: "https://shopee.co.id",
      whatsapp_sales: "https://wa.me"
    },
    dimensions: {
      length_cm: 14,
      width_cm: 10,
      type: "Saku"
    },
    weight_gram: 180,
    pages: 180,
    pricing: {
      original_price: 75000,
      discount_percentage: 20,
      selling_price: 60000,
      currency: "IDR"
    },
    coverClass: "bg-gradient-to-br from-emerald-900 via-green-900 to-stone-900",
    coverImg: "",
    specs: {
      language: "Indonesia & Arab",
      pages: "180 Halaman",
      size: "10 x 14 cm (Saku)",
      weight: "180 gram",
      releaseDate: "Maret 2026",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>بَابُ الطَّهَارَةِ</h2><p>الْمِيَاهُ الَّتِي يَجُوزُ التَّطْهِيرُ بِهَا سَبْعُ مِيَاهٍ: مَاءُ السَّمَاءِ، وَمَاءُ الْبَحْرِ، وَمَاءُ النَّهْرِ، وَمَاءُ الْبِئْرِ، وَمَاءُ الْعَيْنِ، وَمَاءُ الثَّلْجِ، وَمَاءُ الْبَرَدِ.</p><p>Air yang boleh digunakan bersuci ada 7 macam: air hujan, air laut, air sungai, air sumur, air mata air, air salju, dan air es/embun.</p>",
        right: "<h2>SYARAT WUDHU</h2><p>Fardhu wudhu ada 6 perkara: 1. Niat saat membasuh wajah, 2. Membasuh wajah, 3. Membasuh kedua tangan sampai siku, 4. Mengusap sebagian kepala, 5. Membasuh kedua kaki sampai mata kaki, 6. Tertib.</p>"
      }
    ]
  },
  {
    id: "fiqih-populer-saku-muin",
    title: "Fiqih populer saku (trjmh f.mu'in)",
    author: "K.H. Hamim Djazuli",
    genre: "fiqih",
    format: "print",
    status: "bestseller",
    isbn: "978-602-0853-22-8",
    price: 120000,
    originalPrice: 120000,
    discount: 0,
    synopsis: "Buku saku ringkas terjemah Fathul Mu'in. Membahas hukum fikih tingkat menengah madzhab Syafi'i secara lugas dan ringkas, sangat membantu santri senior (Aliyah/Mualimin) merujuk hukum ibadah praktis.",
    coverClass: "bg-gradient-to-br from-emerald-950 via-green-950 to-emerald-900",
    coverImg: "",
    specs: {
      language: "Indonesia",
      pages: "310 Halaman",
      size: "11 x 15 cm",
      weight: "250 gram",
      releaseDate: "Januari 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>KAPASITAS SHALAT BERJAMA'AH</h2><p>Shalat berjama'ah hukumnya fardhu kifayah bagi laki-laki mukim untuk shalat lima waktu yang bukan shalat Jum'at. Bagi shalat Jum'at hukumnya fardhu 'ain.</p><p>Keutamaan jama'ah melebihi shalat sendirian sebanyak 27 derajat.</p>",
        right: "<h2>SYARAT IMAM & MAKMUM</h2><p>Di antara syarat sah berjama'ah: Makmum tidak boleh mengetahui batalnya shalat imam, kedudukan makmum tidak boleh lebih maju daripada imam, dan makmum harus mengikuti gerakan imam.</p>"
      }
    ]
  },
  {
    id: "fiqih-populer-fathul-muin-lengkap",
    title: "Fiqih Populer: Terjemah Fathul Mu'in 1,2,3",
    author: "Lembaga Kajian Fikih Darussholah",
    genre: "fiqih",
    format: "print",
    status: "bestseller",
    isbn: "978-602-0853-23-5",
    price: 200000,
    originalPrice: 200000,
    discount: 0,
    synopsis: "Edisi lengkap 3 Jilid terjemah Fathul Mu'in. Membedah tuntas bab ibadah, muamalah ekonomi Islam, pernikahan (munakahat), waris, hingga hukum pidana Islam secara komprehensif dengan rujukan kitab kuning mu'tabarah.",
    coverClass: "bg-gradient-to-br from-emerald-950 via-teal-950 to-stone-900",
    coverImg: "",
    specs: {
      language: "Indonesia (3 Jilid)",
      pages: "750 Halaman (Total)",
      size: "15 x 23 cm",
      weight: "1200 gram",
      releaseDate: "Agustus 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>JILID I: TRANSAKSI JUAL BELI</h2><p>Rukun jual beli (bai') ada tiga: 1. Aqid (orang yang bertransaksi), 2. Ma'qud 'alaih (barang dan uang), 3. Shighat (ijab dan qabul).</p><p>Syarat barang harus suci, bermanfaat, milik penuh, dan dapat diserahterimakan.</p>",
        right: "<h2>JILID II: PERNIKAHAN</h2><p>Syarat nikah sah: Adanya calon pengantin laki-laki, calon pengantin perempuan, wali nasab/hakim, dua saksi laki-laki yang adil, serta shighat aqad nikah.</p><p>Wanita yang haram dinikahi (mahram) terbagi atas sebab nasab, sepersusuan, dan perkawinan.</p>"
      }
    ]
  },
  {
    id: "terjemah-bidayatul-hidayah",
    title: "Terjemah Bidayatul Hidayah",
    author: "Imam Al-Ghazali (Terjemah)",
    genre: "akhlak",
    format: "print",
    status: "bestseller",
    isbn: "978-602-0853-24-2",
    price: 200000,
    originalPrice: 200000,
    discount: 0,
    synopsis: "Kajian Akhlak Paling Lengkap berdasarkan kitab Bidayatul Hidayah karya Hujjatul Islam Imam Al-Ghazali. Pemandu harian santri dalam menata adab bangun tidur, shalat, bergaul dengan sesama makhluk, dan menjauhi maksiat batin.",
    coverClass: "bg-gradient-to-br from-amber-950 via-red-955 to-stone-950",
    coverImg: "",
    specs: {
      language: "Indonesia",
      pages: "290 Halaman",
      size: "14 x 21 cm",
      weight: "350 gram",
      releaseDate: "Desember 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>ADAB BANGUN TIDUR</h2><p>Saat matamu terbuka dari tidur, berusahalah agar yang pertama kali terbersit di hatimu adalah mengingat Allah. Ucapkanlah syukur: Segala puji bagi Allah yang menghidupkan kami setelah mematikan kami.</p>",
        right: "<h2>MENGHINDARI PENYAKIT HATI</h2><p>Ketahuilah bahwa penyakit hati seperti hasad (dengki), riya' (pamer), dan ujub (bangga diri) adalah perusak amal ibadah layaknya api memakan kayu kering yang rapuh.</p>"
      }
    ]
  },
  {
    id: "asmaul-husna",
    title: "Asma'ul husna",
    author: "K.H. Mustofa Bisri",
    genre: "aqidah",
    format: "print",
    status: "new",
    isbn: "978-602-0853-25-9",
    price: 150000,
    originalPrice: 150000,
    discount: 0,
    synopsis: "Buku inspiratif yang mengisahkan cerita indah di balik makna 99 Nama Allah (Asma'ul Husna), memudahkan santri membumikan tauhid dan akhlak ilahiyah dalam kehidupan sehari-hari.",
    coverClass: "bg-gradient-to-br from-teal-950 via-emerald-950 to-slate-950",
    coverImg: "",
    specs: {
      language: "Indonesia",
      pages: "240 Halaman",
      size: "14 x 20 cm",
      weight: "290 gram",
      releaseDate: "Oktober 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>الرَّحْمٰنُ : MAHA PENGASIH</h2><p>Ar-Rahman berarti Allah melimpahkan kasih sayang-Nya kepada semua makhluk di dunia tanpa pandang bulu, baik mukmin maupun kafir. Ini adalah pengajaran agar kita saling berkasih sayang.</p>",
        right: "<h2>الْكَرِيْمُ : MAHA DERMAWAN</h2><p>Al-Karim mengajarkan kita untuk menjadi pribadi yang berjiwa mulia, suka memberi maaf sebelum diminta, dan berinfak dengan kelapangan dada meniru akhlak mulia para nabi.</p>"
      }
    ]
  },
  {
    id: "terjemah-kaidah-fiqih",
    title: "Terjemah Kaidah fiqih",
    author: "K.H. A. Yasin Asymuni",
    genre: "fiqih",
    format: "print",
    status: "new",
    isbn: "978-602-0853-26-6",
    price: 45000,
    originalPrice: 50000,
    discount: 10,
    synopsis: "Penjelasan nadhom Al-faro'id Al-bahiyyah yang menguraikan kaidah-kaidah fikih penting (Qawa'id Fiqhiyyah) madzhab Syafi'i untuk melatih santri berijtihad dalam masalah-masalah kontemporer.",
    coverClass: "bg-gradient-to-br from-emerald-900 via-teal-900 to-emerald-950",
    coverImg: "",
    specs: {
      language: "Indonesia & Arab",
      pages: "120 Halaman",
      size: "14 x 21 cm",
      weight: "150 gram",
      releaseDate: "November 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>الأمُوْرُ بِمَقَاصِدِهَا</h2><p>Kaidah Pertama: Segala urusan dinilai berdasarkan niat atau tujuannya. Niat membedakan antara ibadah murni dan kebiasaan adat sehari-hari.</p>",
        right: "<h2>اليَقِيْنُ لاَ يُزَالُ بِالشَّكِّ</h2><p>Kaidah Kedua: Keyakinan tidak bisa dihilangkan oleh keraguan. Jika seseorang yakin telah suci lalu ragu apakah batal, ia dinilai masih suci.</p>"
      }
    ]
  },
  {
    id: "terjemah-tijan-darori",
    title: "Terjemah Tijan ad-Darori",
    author: "Syaikh Ibrahim al-Bajuri",
    genre: "aqidah",
    format: "print",
    status: "normal",
    isbn: "978-602-0853-27-3",
    price: 50000,
    originalPrice: 50000,
    discount: 0,
    synopsis: "Kajian dasar ilmu tauhid yang menerjemahkan kitab Tijan ad-Darori, membahas sifat wajib, mustahil, dan jaiz bagi Allah dan rasul-Nya dengan argumen rasional (aqli) dan tekstual (naqli).",
    coverClass: "bg-gradient-to-br from-teal-950 via-stone-900 to-slate-950",
    coverImg: "",
    specs: {
      language: "Indonesia",
      pages: "80 Halaman",
      size: "14 x 20 cm",
      weight: "110 gram",
      releaseDate: "September 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>SIFAT WUJUD Allah</h2><p>Sifat pertama Allah adalah Wujud (Ada). Dalil adanya Allah adalah ciptaan alam semesta ini. Tidak mungkin sebuah lukisan ada tanpa pelukisnya.</p>",
        right: "<h2>SIFAT MUKHALAFATU LIL HAWADITSI</h2><p>Allah berbeda dengan makhluk ciptaan-Nya. Allah tidak membutuhkan ruang, arah, waktu, dan tidak tersusun dari partikel-partikel fisik.</p>"
      }
    ]
  },
  {
    id: "as-sanusi",
    title: "As-sanusi.",
    author: "Imam As-Sanusi",
    genre: "aqidah",
    format: "print",
    status: "normal",
    isbn: "978-602-0853-28-0",
    price: 50000,
    originalPrice: 50000,
    discount: 0,
    synopsis: "Terjemah Syarah umm Al-barahin. Kitab dasar akidah Ahlussunnah wal Jama'ah Asy'ariyah yang membedah konsep ketauhidan dan argumen sifat 20 bagi Allah secara logis.",
    coverClass: "bg-gradient-to-br from-teal-900 via-emerald-950 to-stone-950",
    coverImg: "",
    specs: {
      language: "Indonesia",
      pages: "110 Halaman",
      size: "14 x 21 cm",
      weight: "140 gram",
      releaseDate: "Juni 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>MAKNA KALIMAT LA ILAHA ILLALLAH</h2><p>Kalimat tauhid mengandung makna Isyghna' (Maha Kaya/Allah tidak membutuhkan selain-Nya) dan Iftiqaar (Makhluk membutuhkan Allah).</p>",
        right: "<h2>AQIDAH SEKET (AQIDAH 50)</h2><p>Terdiri dari 20 sifat wajib Allah, 20 sifat mustahil Allah, 1 sifat jaiz Allah, 4 sifat wajib Rasul, 4 sifat mustahil Rasul, dan 1 sifat jaiz Rasul.</p>"
      }
    ]
  },
  {
    id: "terjemah-jauharul-maknun",
    title: "Terjemah Jauharul Maknun",
    author: "Syaikh Abdurrahman al-Akhdari",
    genre: "sastra",
    format: "print",
    status: "bestseller",
    isbn: "978-602-0853-29-7",
    price: 100000,
    originalPrice: 100000,
    discount: 0,
    synopsis: "Mutiara balaghoh Jauharul Maknun, dalam ilmu Ma'ani, Bayan, dan Badi'. Kitab sastra Arab tingkat tinggi untuk menyingkap rahasia keindahan balaghah Al-Qur'an dan hadits.",
    coverClass: "bg-gradient-to-br from-amber-900 via-amber-950 to-yellow-950",
    coverImg: "",
    specs: {
      language: "Indonesia & Arab",
      pages: "220 Halaman",
      size: "15 x 23 cm",
      weight: "320 gram",
      releaseDate: "Juli 2025",
      publisher: "Darussholah"
    },
    samplePages: [
      {
        left: "<h2>بَابُ الْبَيَانِ : ILMU BAYAN</h2><p>Ilmu Bayan adalah ilmu untuk mengetahui cara mendatangkan satu makna dengan berbagai ungkapan yang berbeda tingkat kejelasannya (Tasybih, Majaz, Kinayah).</p>",
        right: "<h2>ILMU BADI' (KEINDAHAN BAHASA)</h2><p>Ilmu Badi' mengupas keindahan lafadz (Muhassinat Lafdziyah) dan keindahan makna (Muhassinat Ma'nawiyah) seperti Jinas, Saja', dan Thibaq.</p>"
      }
    ]
  }
];;

// --- BLOG DATABASE ---
const BLOGS = [
  {
    id: 1,
    title: "Tips Menulis Novel Bestseller untuk Penulis Pemula",
    excerpt: "Bagaimana cara menyusun kerangka cerita yang menarik pembaca sejak halaman pertama? Simak panduan dari editor senior kami.",
    author: "Redaksi Prime",
    date: "18 Juli 2026",
    readTime: "5 Menit Baca",
    category: "tips",
    content: "<p>Menulis novel bestseller bukanlah hal yang kebetulan. Ini adalah hasil perpaduan antara kreativitas murni dan pemahaman mendalam tentang struktur naratif. Editor kami menyarankan untuk memulai dengan <b>logline</b> atau premis satu kalimat yang kuat.</p><p>Selanjutnya, susun struktur tiga babak klasik (Three-Act Structure): Pengenalan (Set-up), Konflik Utama (Confrontation), dan Resolusi (Resolution). Hal terpenting adalah menciptakan karakter protagonis yang memiliki kelemahan nyata (flawed character) agar pembaca dapat bersimpati dan terhubung secara emosional dengan perjalanannya.</p>"
  },
  {
    id: 2,
    title: "Pentingnya Menjaga Keaslian Buku di Era Digital",
    excerpt: "Buku bajakan merugikan penulis lokal dan merusak ekosistem penerbitan. Kenapa membeli buku berlisensi dari penerbit tangan pertama sangat krusial?",
    author: "Humas Prime",
    date: "15 Juli 2026",
    readTime: "7 Menit Baca",
    category: "berita",
    content: "<p>Buku bajakan masih menjadi momok menakutkan bagi dunia literasi Indonesia. Dengan membeli buku bajakan, Anda secara tidak langsung menghentikan kreativitas penulis kesayangan Anda untuk menelurkan karya-karya hebat berikutnya.</p><p>Membeli langsung dari penerbit tangan pertama memberikan jaminan kualitas cetakan terbaik (kertas bookpaper premium, tinta tajam tidak buram), serta bonus merchandise eksklusif dan jaminan keaslian isi. Mari dukung industri kreatif nasional dengan menolak keras segala bentuk pembajakan buku!</p>"
  },
  {
    id: 3,
    title: "Mengenal Model Penerbitan Mayor vs Hybrid",
    excerpt: "Bingung memilih model penerbitan untuk naskah perdana Anda? Pelajari perbedaan, kelebihan, dan kekurangannya di sini.",
    author: "Tim Layanan Penulis",
    date: "10 Juni 2026",
    readTime: "6 Menit Baca",
    category: "tips",
    content: "<p>Bagi penulis pemula, memilih jalur penerbitan bisa sangat membingungkan. Penerbitan Mayor (Traditional Publishing) menawarkan pembiayaan 100% dari penerbit, mulai dari editing, cetak, hingga distribusi nasional, dan penulis menerima royalti berkala. Namun, seleksinya sangat ketat.</p><p>Sebaliknya, Penerbitan Hybrid membagi biaya produksi dengan penulis. Ini adalah solusi cepat bagi mereka yang ingin memegang kendali penuh atas hak cipta dan desain buku, dengan jaminan proses cetak profesional dari tim ahli kami serta akses distribusi toko online maupun offline.</p>"
  }
];

// --- APP STATE ---
let CART = [];
let ACTIVE_BOOK = null;
let ACTIVE_PDF_BOOK = null;
let CURRENT_PDF_PAGE = 0; // index of spread

// ============================================================================
// UNIVERSAL CUSTOM DROPDOWN ENGINE (Enterprise UI)
// ============================================================================
function initCustomDropdown(selectEl) {
  if (!selectEl || selectEl.dataset.customDropdownInit === "true") return;
  selectEl.dataset.customDropdownInit = "true";

  // Hide the native select accessibly
  selectEl.classList.add("custom-select-native-hidden");

  // Create custom dropdown wrapper
  const wrap = document.createElement("div");
  wrap.className = "custom-select-wrap";
  if (selectEl.classList.contains("filter-select")) wrap.classList.add("wrap-filter-select");
  if (selectEl.classList.contains("admin-select")) wrap.classList.add("wrap-admin-select");
  if (selectEl.classList.contains("form-control")) wrap.classList.add("wrap-form-control");
  if (selectEl.id) wrap.id = `wrap-${selectEl.id}`;

  // Trigger button
  const trigger = document.createElement("button");
  trigger.type = "button";
  trigger.className = "custom-select-trigger";
  if (selectEl.classList.contains("form-control")) trigger.classList.add("trigger-form-control");
  if (selectEl.classList.contains("filter-select")) trigger.classList.add("trigger-filter-select");
  if (selectEl.classList.contains("admin-select")) trigger.classList.add("trigger-admin-select");

  const triggerText = document.createElement("span");
  triggerText.className = "custom-select-label";

  const triggerArrow = document.createElement("i");
  triggerArrow.className = "fas fa-chevron-down custom-select-arrow";

  trigger.appendChild(triggerText);
  trigger.appendChild(triggerArrow);

  // Options container
  const optionsList = document.createElement("div");
  optionsList.className = "custom-select-options";

  // Build items from <option> tags
  function renderOptions() {
    optionsList.innerHTML = "";
    const options = Array.from(selectEl.options);
    const selectedOpt = selectEl.options[selectEl.selectedIndex] || options[0];
    triggerText.textContent = selectedOpt ? selectedOpt.text : "Pilih opsi...";

    options.forEach((opt) => {
      const item = document.createElement("div");
      item.className = "custom-select-item";
      if (opt.value === selectEl.value) {
        item.classList.add("is-selected");
      }
      if (opt.disabled) {
        item.classList.add("is-disabled");
      }

      item.innerHTML = `
        <span class="option-text">${opt.text}</span>
        ${opt.value === selectEl.value ? '<i class="fas fa-check option-check-icon"></i>' : ''}
      `;

      item.addEventListener("click", (e) => {
        e.stopPropagation();
        if (opt.disabled) return;
        selectEl.value = opt.value;
        selectEl.dispatchEvent(new Event("change", { bubbles: true }));
        selectEl.dispatchEvent(new Event("input", { bubbles: true }));
        closeAllCustomDropdowns();
      });

      optionsList.appendChild(item);
    });
  }

  renderOptions();

  // Toggle open
  trigger.addEventListener("click", (e) => {
    e.stopPropagation();
    if (selectEl.disabled) return;
    const isOpen = wrap.classList.contains("is-open");
    closeAllCustomDropdowns();
    if (!isOpen) {
      wrap.classList.add("is-open");
      renderOptions();
    }
  });

  // Insert wrapper into DOM
  selectEl.parentNode.insertBefore(wrap, selectEl);
  wrap.appendChild(selectEl);
  wrap.appendChild(trigger);
  wrap.appendChild(optionsList);

  // Listen for native select change to re-render custom trigger
  selectEl.addEventListener("change", () => {
    renderOptions();
    if (selectEl.classList.contains("input-error")) {
      trigger.classList.add("input-error");
    } else {
      trigger.classList.remove("input-error");
    }
  });

  // Sync error and disabled states
  const observer = new MutationObserver(() => {
    if (selectEl.classList.contains("input-error")) {
      trigger.classList.add("input-error");
    } else {
      trigger.classList.remove("input-error");
    }
    if (selectEl.disabled) {
      wrap.classList.add("is-disabled");
    } else {
      wrap.classList.remove("is-disabled");
    }
  });
  observer.observe(selectEl, { attributes: true, attributeFilter: ["class", "disabled"] });

  wrap._renderOptions = renderOptions;
}

function initAllCustomDropdowns(root = document) {
  root.querySelectorAll("select").forEach(select => {
    initCustomDropdown(select);
  });
}

function syncCustomDropdowns(root = document) {
  root.querySelectorAll(".custom-select-wrap").forEach(wrap => {
    if (typeof wrap._renderOptions === "function") {
      wrap._renderOptions();
    }
  });
}

function closeAllCustomDropdowns() {
  document.querySelectorAll(".custom-select-wrap.is-open").forEach(w => {
    w.classList.remove("is-open");
  });
}

// Global click & escape to close dropdowns
document.addEventListener("click", closeAllCustomDropdowns);
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") closeAllCustomDropdowns();
});

// --- INITIALIZATION ---
document.addEventListener("DOMContentLoaded", () => {
  initRouting();
  initSearch();
  initCatalogFilters();
  initCart();
  initModals();
  initForms();
  initAdmin();
  initAllCustomDropdowns();
  renderHomeFeatured();
  renderBlogList();

  // Load from API in background and re-render with fresh data
  loadBooksFromAPI().then(() => {
    renderHomeFeatured();
    renderCatalog();
    renderAdminDashboard();
    syncCustomDropdowns();
  });
});

// --- ROUTING (SPA NAVIGATION) ---
function initRouting() {
  const navLinks = document.querySelectorAll(".nav-link, .spa-route");
  
  navLinks.forEach(link => {
    link.addEventListener("click", (e) => {
      e.preventDefault();
      const targetPageId = link.getAttribute("href").substring(1);
      navigateTo(targetPageId);
    });
  });

  // Handle browser back/forward buttons
  window.addEventListener("popstate", () => {
    const hash = window.location.hash.substring(1) || "home";
    showPage(hash);
  });

  // Initial load
  const initialHash = window.location.hash.substring(1) || "home";
  navigateTo(initialHash);
}

function navigateTo(pageId) {
  window.location.hash = pageId;
  showPage(pageId);
}

function showPage(pageId) {
  // Normalize page IDs
  let targetId = pageId;
  if (pageId === "blog" || pageId === "berita") targetId = "blog-page";
  
  const sections = document.querySelectorAll(".page-section");
  let found = false;

  sections.forEach(sec => {
    if (sec.id === targetId) {
      sec.classList.add("active-page");
      found = true;
    } else {
      sec.classList.remove("active-page");
    }
  });

  // Fallback to home if page doesn't exist
  if (!found) {
    document.getElementById("home").classList.add("active-page");
    targetId = "home";
  }

  // Toggle Dedicated Backoffice Mode
  if (targetId === "admin") {
    document.body.classList.add("in-admin-mode");
    renderAdminView();
  } else {
    document.body.classList.remove("in-admin-mode");
    if (targetId === "katalog") {
      renderCatalog();
    } else if (targetId === "home") {
      renderHomeFeatured();
    }
  }

  // Update Active Nav Link
  const navLinks = document.querySelectorAll(".nav-menu .nav-link");
  navLinks.forEach(link => {
    const href = link.getAttribute("href").substring(1);
    if (href === pageId || (pageId === "blog-page" && href === "blog") || (pageId === "berita" && href === "blog")) {
      link.classList.add("active");
    } else {
      link.classList.remove("active");
    }
  });

  // Close mobile sub-nav if open
  const subNav = document.getElementById("nav-sub-bar");
  if (subNav) subNav.classList.remove("open");

  // Scroll to top
  window.scrollTo({ top: 0, behavior: "smooth" });
}

// --- SEARCH ENGINE ---
function initSearch() {
  const searchInput = document.getElementById("header-search");
  const searchResults = document.getElementById("search-results-dropdown");

  // Create search results box if it doesn't exist in HTML
  if (!searchResults) return;

  searchInput.addEventListener("input", (e) => {
    const query = e.target.value.toLowerCase().trim();
    
    if (query.length < 2) {
      searchResults.style.display = "none";
      return;
    }

    const filtered = BOOKS.filter(book => 
      book.title.toLowerCase().includes(query) || 
      book.author.toLowerCase().includes(query) || 
      book.isbn.includes(query)
    );

    renderSearchResults(filtered);
  });

  // Hide dropdown on clicking outside
  document.addEventListener("click", (e) => {
    if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
      searchResults.style.display = "none";
    }
  });

  searchInput.addEventListener("focus", () => {
    if (searchInput.value.trim().length >= 2) {
      searchResults.style.display = "block";
    }
  });
}

function renderSearchResults(results) {
  const dropdown = document.getElementById("search-results-dropdown");
  dropdown.innerHTML = "";

  if (results.length === 0) {
    dropdown.innerHTML = `<div class="search-no-result" style="padding: 12px 16px; font-size: 0.85rem; color: var(--text-muted);">Buku tidak ditemukan.</div>`;
    dropdown.style.display = "block";
    return;
  }

  results.forEach(book => {
    const item = document.createElement("div");
    item.className = "search-result-item";
    item.style.display = "flex";
    item.style.alignItems = "center";
    item.style.gap = "10px";
    item.style.padding = "10px 16px";
    item.style.borderBottom = "1px solid var(--border-color)";
    item.style.cursor = "pointer";
    item.style.transition = "var(--transition)";

    // Hover effect styles via JS for safety
    item.addEventListener("mouseenter", () => item.style.backgroundColor = "var(--bg-cream-dark)");
    item.addEventListener("mouseleave", () => item.style.backgroundColor = "transparent");

    const coverHtml = book.coverImg 
      ? `<img src="${book.coverImg}" style="width: 30px; height: 42px; object-fit: cover; border-radius: 2px;">`
      : `<div class="${book.coverClass}" style="width: 30px; height: 42px; border-radius: 2px; font-size: 0.4rem; color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; text-align: center; padding: 2px;">${book.author}</div>`;

    item.innerHTML = `
      ${coverHtml}
      <div style="flex-grow: 1; min-width: 0;">
        <div style="font-size: 0.85rem; font-weight: 600; color: var(--primary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${book.title}</div>
        <div style="font-size: 0.72rem; color: var(--text-muted);">${book.author} | ISBN: ${book.isbn}</div>
      </div>
    `;

    item.addEventListener("click", () => {
      openBookDetailModal(book.id);
      dropdown.style.display = "none";
      document.getElementById("header-search").value = "";
    });

    dropdown.appendChild(item);
  });

  dropdown.style.display = "block";
}

// --- CATALOG ENGINE (FILTERS & RENDERING) ---
function initCatalogFilters() {
  const genreFilter = document.getElementById("filter-genre");
  const formatFilter = document.getElementById("filter-format");
  const statusFilter = document.getElementById("filter-status");
  const inlineSearch = document.getElementById("filter-search-inline");

  if (!genreFilter) return; // Not on the catalog page

  const handleFilterChange = () => {
    renderCatalog();
  };

  genreFilter.addEventListener("change", handleFilterChange);
  formatFilter.addEventListener("change", handleFilterChange);
  statusFilter.addEventListener("change", handleFilterChange);
  inlineSearch.addEventListener("input", handleFilterChange);

  // Initial render on load
  renderCatalog();
}

function renderCatalog() {
  const genreVal = document.getElementById("filter-genre").value;
  const formatVal = document.getElementById("filter-format").value;
  const statusVal = document.getElementById("filter-status").value;
  const query = document.getElementById("filter-search-inline").value.toLowerCase().trim();

  const filtered = BOOKS.filter(book => {
    const matchesGenre = genreVal === "all" || book.genre === genreVal;
    const matchesFormat = formatVal === "all" || book.format === formatVal;
    const matchesStatus = statusVal === "all" || book.status === statusVal;
    const matchesQuery = query === "" || 
                         book.title.toLowerCase().includes(query) || 
                         book.author.toLowerCase().includes(query) || 
                         book.isbn.includes(query);

    return matchesGenre && matchesFormat && matchesStatus && matchesQuery;
  });

  const catalogGrid = document.getElementById("catalog-books-grid");
  const resultsCount = document.getElementById("results-count");
  
  if (!catalogGrid) return;

  resultsCount.textContent = `Menampilkan ${filtered.length} dari ${BOOKS.length} Buku`;
  catalogGrid.innerHTML = "";

  if (filtered.length === 0) {
    catalogGrid.innerHTML = `
      <div class="no-results">
        <i class="fas fa-book-open"></i>
        <h3>Buku tidak ditemukan</h3>
        <p>Silakan coba atur ulang filter pencarian Anda.</p>
      </div>
    `;
    return;
  }

  filtered.forEach(book => {
    catalogGrid.appendChild(createBookCard(book));
  });
}

function createBookCard(book) {
  const col = document.createElement("div");
  col.className = "book-card-item"; // Grid wrapper
  
  const discountHtml = book.discount > 0 
    ? `<span class="book-card-discount">-${book.discount}%</span>` 
    : '';

  const originalPriceHtml = book.discount > 0 
    ? `<span class="book-card-price-original">Rp ${book.originalPrice.toLocaleString('id-ID')}</span>` 
    : '';

  const badgeClass = book.status === 'bestseller' ? 'bestseller' : 'new';
  const badgeLabel = book.status === 'bestseller' ? 'Bestseller' : 'Baru';
  const badgeHtml = book.status !== 'normal' 
    ? `<div class="book-badge ${badgeClass}">${badgeLabel}</div>` 
    : '';

  // Cover image with fallback to styled CSS cover
  let coverHtml = "";
  if (book.coverImg) {
    coverHtml = `<img src="${book.coverImg}" alt="${book.title}" class="book-cover" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">`;
  }
  
  const fallbackCoverHtml = `
    <div class="book-cover-css ${book.coverClass}" style="${book.coverImg ? 'display:none;' : 'display:flex;'}">
      <span class="book-cover-css-badge">${book.genre}</span>
      <h3 class="book-cover-css-title">${book.title.split(':')[0]}</h3>
      <span class="book-cover-css-author">${book.author}</span>
    </div>
  `;

  col.innerHTML = `
    <div class="book-card">
      <div class="book-card-image-wrap">
        ${badgeHtml}
        <div class="book-3d">
          <div class="book-3d-spine"></div>
          ${coverHtml}
          ${fallbackCoverHtml}
        </div>
      </div>
      <div class="book-card-info">
        <span class="book-card-genre">${book.genre.replace('-', ' ')}</span>
        <h3 class="book-card-title">${book.title}</h3>
        <p class="book-card-author">Karya ${book.author}</p>
        <div class="book-card-price-row">
          <span class="book-card-price-current">Rp ${book.price.toLocaleString('id-ID')}</span>
          ${originalPriceHtml}
          ${discountHtml}
        </div>
        ${book.marketplace_links && book.marketplace_links.shopee ? `
        <div style="margin: 6px 0 10px 0; display: inline-flex; align-items: center; gap: 5px; font-size: 0.72rem; color: #ee4d2d; font-weight: 600; background: rgba(238, 77, 45, 0.08); padding: 3px 8px; border-radius: 4px; border: 1px solid rgba(238, 77, 45, 0.2);">
          <i class="fas fa-shopping-basket"></i> Di Shopee Resmi
        </div>` : ''}
        <div class="book-card-actions">
          <button class="btn btn-primary btn-sm btn-detail" data-id="${book.id}">Detail & Beli</button>
          <button class="btn btn-sample btn-sm btn-sneak-peek" data-id="${book.id}">Intip Isi (PDF)</button>
        </div>
      </div>
    </div>
  `;

  // Attach interactive events
  col.querySelector(".btn-detail").addEventListener("click", () => openBookDetailModal(book.id));
  col.querySelector(".btn-sneak-peek").addEventListener("click", () => openPdfViewerModal(book.id));

  return col;
}

// --- HOME PAGE FEATURED SHOWCASE ---
function renderHomeFeatured() {
  const homeGrid = document.getElementById("home-featured-grid");
  if (!homeGrid) return;

  // Take the first 4 bestseller or new books to display on Home
  const featured = BOOKS.slice(0, 4);
  homeGrid.innerHTML = "";
  
  featured.forEach(book => {
    homeGrid.appendChild(createBookCard(book));
  });
}

// --- CART drawer & logic ---
function initCart() {
  const cartBtn = document.getElementById("header-cart-btn");
  const cartOverlay = document.getElementById("cart-overlay");
  const cartClose = document.getElementById("cart-close-btn");
  const checkoutBtn = document.getElementById("cart-checkout-btn");

  if (!cartBtn) return;

  // Drawer Toggles
  cartBtn.addEventListener("click", () => cartOverlay.classList.add("active"));
  cartClose.addEventListener("click", () => cartOverlay.classList.remove("active"));
  cartOverlay.addEventListener("click", (e) => {
    if (e.target === cartOverlay) cartOverlay.classList.remove("active");
  });

  checkoutBtn.addEventListener("click", () => {
    handleCartCheckout();
  });

  updateCartUI();
}

function addToCart(bookId, format = "print") {
  const book = BOOKS.find(b => b.id === bookId);
  if (!book) return;

  const existing = CART.find(item => item.id === bookId && item.format === format);

  if (existing) {
    existing.quantity += 1;
  } else {
    CART.push({
      id: book.id,
      title: book.title,
      author: book.author,
      price: book.price,
      coverImg: book.coverImg,
      coverClass: book.coverClass,
      format: format,
      quantity: 1
    });
  }

  updateCartUI();
  
  // Slide open the cart automatically for feedback
  document.getElementById("cart-overlay").classList.add("active");
}

function removeFromCart(bookId, format) {
  CART = CART.filter(item => !(item.id === bookId && item.format === format));
  updateCartUI();
}

function changeQuantity(bookId, format, delta) {
  const item = CART.find(item => item.id === bookId && item.format === format);
  if (!item) return;

  item.quantity += delta;
  if (item.quantity <= 0) {
    removeFromCart(bookId, format);
  } else {
    updateCartUI();
  }
}

function updateCartUI() {
  const cartList = document.getElementById("cart-items-container");
  const badge = document.getElementById("cart-count-badge");
  const subtotalLabel = document.getElementById("cart-subtotal");
  const totalLabel = document.getElementById("cart-total");

  if (!cartList) return;

  cartList.innerHTML = "";
  
  let totalCount = 0;
  let subtotalPrice = 0;

  if (CART.length === 0) {
    cartList.innerHTML = `
      <div class="cart-empty">
        <i class="fas fa-shopping-basket"></i>
        <p>Keranjang Anda masih kosong.</p>
      </div>
    `;
    document.getElementById("cart-checkout-btn").disabled = true;
  } else {
    document.getElementById("cart-checkout-btn").disabled = false;
    
    CART.forEach(item => {
      totalCount += item.quantity;
      subtotalPrice += item.price * item.quantity;

      const itemDiv = document.createElement("div");
      itemDiv.className = "cart-item";

      const coverHtml = item.coverImg 
        ? `<img src="${item.coverImg}" class="cart-item-img" alt="${item.title}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">`
        : '';
      
      const fallbackCoverHtml = `
        <div class="cart-item-img ${item.coverClass} flex-center" style="color: white; font-size: 0.35rem; text-align: center; padding: 2px; font-weight: bold; ${item.coverImg ? 'display:none;' : 'display:flex;'}">
          ${item.author}
        </div>
      `;

      itemDiv.innerHTML = `
        ${coverHtml}
        ${fallbackCoverHtml}
        <div class="cart-item-details">
          <h4 class="cart-item-title">${item.title}</h4>
          <div class="cart-item-meta">${item.format} | Karya ${item.author}</div>
          <div class="cart-item-price">Rp ${item.price.toLocaleString('id-ID')}</div>
          <div class="cart-item-controls">
            <div class="quantity-picker">
              <button class="btn-qty-minus"><i class="fas fa-minus"></i></button>
              <span>${item.quantity}</span>
              <button class="btn-qty-plus"><i class="fas fa-plus"></i></button>
            </div>
            <button class="cart-item-remove btn-remove"><i class="fas fa-trash-alt"></i> Hapus</button>
          </div>
        </div>
      `;

      // Event Listeners
      itemDiv.querySelector(".btn-qty-minus").addEventListener("click", () => changeQuantity(item.id, item.format, -1));
      itemDiv.querySelector(".btn-qty-plus").addEventListener("click", () => changeQuantity(item.id, item.format, 1));
      itemDiv.querySelector(".btn-remove").addEventListener("click", () => removeFromCart(item.id, item.format));

      cartList.appendChild(itemDiv);
    });
  }

  // Update totals
  badge.textContent = totalCount;
  badge.style.display = totalCount > 0 ? "flex" : "none";
  subtotalLabel.textContent = `Rp ${subtotalPrice.toLocaleString('id-ID')}`;
  totalLabel.textContent = `Rp ${subtotalPrice.toLocaleString('id-ID')}`;
}

function handleCartCheckout() {
  if (CART.length === 0) return;

  let message = "Halo Sales Darussholah,\nSaya ingin memesan buku-buku berikut langsung dari penerbit:\n\n";
  
  CART.forEach((item, index) => {
    message += `${index + 1}. *${item.title}* (${item.format.toUpperCase()})\n`;
    message += `   Jumlah: ${item.quantity} eks\n`;
    message += `   Harga: Rp ${(item.price * item.quantity).toLocaleString('id-ID')}\n\n`;
  });

  const total = CART.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  message += `*Total Pembelian:* Rp ${total.toLocaleString('id-ID')}\n`;
  message += `Mohon info rincian ongkos kirim dan metode pembayaran. Terima kasih!`;

  const waUrl = `https://wa.me/628123456789?text=${encodeURIComponent(message)}`;
  window.open(waUrl, "_blank");

  // Empty cart and close drawer
  CART = [];
  updateCartUI();
  document.getElementById("cart-overlay").classList.remove("active");
}

// --- MODALS DIALOGS MANAGER ---
function initModals() {
  const detailModal = document.getElementById("book-detail-modal");
  const pdfModal = document.getElementById("pdf-viewer-modal");
  const adminModal = document.getElementById("admin-book-modal");

  const closeBtns = document.querySelectorAll(".modal-close, .modal-close-trigger");

  closeBtns.forEach(btn => {
    btn.addEventListener("click", () => {
      if (detailModal) detailModal.classList.remove("active");
      if (pdfModal) pdfModal.classList.remove("active");
      if (adminModal) adminModal.classList.remove("active");
      document.body.style.overflow = ""; // restore scrolling
    });
  });

  // Handle outside clicks to close
  window.addEventListener("click", (e) => {
    if (e.target === detailModal) {
      detailModal.classList.remove("active");
      document.body.style.overflow = "";
    }
    if (e.target === pdfModal) {
      pdfModal.classList.remove("active");
      document.body.style.overflow = "";
    }
    if (e.target === adminModal) {
      adminModal.classList.remove("active");
      document.body.style.overflow = "";
    }
  });

  // Init Modal inner tab clicks
  const detailTabs = document.querySelectorAll(".detail-tab");
  detailTabs.forEach(tab => {
    tab.addEventListener("click", () => {
      detailTabs.forEach(t => t.classList.remove("active"));
      tab.classList.add("active");

      const tabTarget = tab.getAttribute("data-tab");
      const synopsisContent = document.getElementById("detail-tab-synopsis");
      const specsContent = document.getElementById("detail-tab-specs");

      if (tabTarget === "synopsis") {
        synopsisContent.classList.remove("hidden");
        specsContent.classList.add("hidden");
      } else {
        synopsisContent.classList.add("hidden");
        specsContent.classList.remove("hidden");
      }
    });
  });

  // PDF controls
  document.getElementById("pdf-prev-btn").addEventListener("click", () => navigatePdfPage(-1));
  document.getElementById("pdf-next-btn").addEventListener("click", () => navigatePdfPage(1));
}

function openBookDetailModal(bookId) {
  const book = BOOKS.find(b => b.id === bookId || b.altId === bookId);
  if (!book) return;

  ACTIVE_BOOK = book;

  const modal = document.getElementById("book-detail-modal");
  
  // Populate details
  document.getElementById("detail-title").textContent = book.title;
  document.getElementById("detail-author").textContent = `Karya ${book.author} | Genre: ${book.genre.replace('-', ' ').toUpperCase()}`;
  document.getElementById("detail-synopsis-text").textContent = book.synopsis;
  document.getElementById("detail-isbn").textContent = book.isbn;
  document.getElementById("detail-pages").textContent = book.specs.pages;
  document.getElementById("detail-size").textContent = book.specs.size;
  document.getElementById("detail-weight").textContent = book.specs.weight;
  document.getElementById("detail-date").textContent = book.specs.releaseDate;
  document.getElementById("detail-publisher").textContent = book.specs.publisher;

  // Warranty text
  const warrantyEl = document.getElementById("detail-warranty-text");
  if (warrantyEl) {
    warrantyEl.textContent = book.warranty || "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.";
  }

  // Prices
  const originalWrap = document.getElementById("detail-original-price");
  const discountWrap = document.getElementById("detail-discount-badge");
  
  document.getElementById("detail-current-price").textContent = `Rp ${book.price.toLocaleString('id-ID')}`;
  
  if (book.discount > 0) {
    originalWrap.textContent = `Rp ${book.originalPrice.toLocaleString('id-ID')}`;
    originalWrap.style.display = "inline";
    discountWrap.textContent = `-${book.discount}%`;
    discountWrap.style.display = "inline";
  } else {
    originalWrap.style.display = "none";
    discountWrap.style.display = "none";
  }

  // Cover image load/fallback
  const imgWrap = document.getElementById("detail-img-container");
  imgWrap.innerHTML = "";
  
  const img3d = document.createElement("div");
  img3d.className = "detail-book-3d";
  
  const spine = document.createElement("div");
  spine.className = "detail-book-spine";
  
  let coverHtml = "";
  if (book.coverImg) {
    coverHtml = `<img src="${book.coverImg}" alt="${book.title}" class="detail-book-cover" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">`;
  }

  const fallbackCoverHtml = `
    <div class="book-cover-css ${book.coverClass}" style="width:100%; height:100%; display:${book.coverImg ? 'none' : 'flex'}; border-radius:2px; padding:20px 15px; color:white; flex-direction:column; justify-content:space-between;">
      <span class="book-cover-css-badge">${book.genre}</span>
      <h3 class="book-cover-css-title" style="font-size:1.2rem;">${book.title.split(':')[0]}</h3>
      <span class="book-cover-css-author">${book.author}</span>
    </div>
  `;

  img3d.appendChild(spine);
  img3d.innerHTML += coverHtml + fallbackCoverHtml;
  imgWrap.appendChild(img3d);

  // Set default active tab (synopsis)
  const tabs = document.querySelectorAll(".detail-tab");
  tabs.forEach(t => t.classList.remove("active"));
  tabs[0].classList.add("active");
  document.getElementById("detail-tab-synopsis").classList.remove("hidden");
  document.getElementById("detail-tab-specs").classList.add("hidden");

  // Re-bind click CTAs
  const buyWaBtn = document.getElementById("detail-buy-wa-btn");
  const addToCartBtn = document.getElementById("detail-add-cart-btn");
  const peekBtn = document.getElementById("detail-sneak-peek-btn");
  const tokopediaBtn = document.getElementById("detail-tokopedia-btn");
  const shopeeBtn = document.getElementById("detail-shopee-btn");

  // Format link buttons / Event handlers
  buyWaBtn.onclick = () => {
    if (book.marketplace_links && book.marketplace_links.whatsapp_sales && book.marketplace_links.whatsapp_sales !== "https://wa.me") {
      window.open(book.marketplace_links.whatsapp_sales, "_blank");
      return;
    }
    const text = `Halo Sales Darussholah,\nSaya ingin membeli buku *${book.title}* via WhatsApp. Mohon diinfokan langkah selanjutnya. Terima kasih!`;
    window.open(`https://wa.me/628123456789?text=${encodeURIComponent(text)}`, "_blank");
  };

  // Direct Marketplace links
  if (book.marketplace_links && book.marketplace_links.tokopedia) {
    tokopediaBtn.href = book.marketplace_links.tokopedia;
    tokopediaBtn.title = "Buka produk di Tokopedia";
  } else {
    tokopediaBtn.href = `https://www.tokopedia.com/search?q=Darussholah%20${encodeURIComponent(book.title)}`;
  }

  if (book.marketplace_links && book.marketplace_links.shopee) {
    shopeeBtn.href = book.marketplace_links.shopee;
    shopeeBtn.innerHTML = `<i class="fas fa-shopping-basket"></i> Beli di Shopee`;
    shopeeBtn.title = "Buka produk di Shopee";
  } else {
    shopeeBtn.href = `https://shopee.co.id/search?keyword=Darussholah%20${encodeURIComponent(book.title)}`;
    shopeeBtn.innerHTML = `<i class="fas fa-shopping-basket"></i> Shopee`;
  }

  addToCartBtn.onclick = () => {
    addToCart(book.id, "print");
    modal.classList.remove("active");
    document.body.style.overflow = "";
  };

  peekBtn.onclick = () => {
    modal.classList.remove("active");
    openPdfViewerModal(book.id);
  };

  modal.classList.add("active");
  document.body.style.overflow = "hidden"; // lock background scroll
}

// --- PDF SAMPLE VIEWER ENGINE ---
function openPdfViewerModal(bookId) {
  const book = BOOKS.find(b => b.id === bookId);
  if (!book) return;

  ACTIVE_PDF_BOOK = book;
  CURRENT_PDF_PAGE = 0;

  const modal = document.getElementById("pdf-viewer-modal");
  document.getElementById("pdf-book-title").textContent = `Sneak Peek: ${book.title}`;

  renderPdfPages();
  modal.classList.add("active");
  document.body.style.overflow = "hidden";
}

function renderPdfPages() {
  const leftPageSheet = document.getElementById("pdf-left-page");
  const rightPageSheet = document.getElementById("pdf-right-page");
  const prevBtn = document.getElementById("pdf-prev-btn");
  const nextBtn = document.getElementById("pdf-next-btn");
  const pageIndicator = document.getElementById("pdf-page-num");

  const spreads = ACTIVE_PDF_BOOK.samplePages;
  const currentSpread = spreads[CURRENT_PDF_PAGE];

  // Populate HTML structure inside mock sheets
  leftPageSheet.innerHTML = `
    <div class="pdf-sheet-header">
      <span>Darussholah</span>
      <span>Sample Preview Only</span>
    </div>
    <div class="pdf-sheet-body">
      ${currentSpread.left}
    </div>
    <div class="pdf-watermark">PREVIEW ONLY</div>
    <div class="pdf-sheet-footer">
      Halaman ${CURRENT_PDF_PAGE * 2 + 1}
    </div>
  `;

  rightPageSheet.innerHTML = `
    <div class="pdf-sheet-header">
      <span>Sample Preview Only</span>
      <span>${ACTIVE_PDF_BOOK.author}</span>
    </div>
    <div class="pdf-sheet-body">
      ${currentSpread.right}
    </div>
    <div class="pdf-watermark">PREVIEW ONLY</div>
    <div class="pdf-sheet-footer">
      Halaman ${CURRENT_PDF_PAGE * 2 + 2}
    </div>
  `;

  // Controls status
  prevBtn.disabled = CURRENT_PDF_PAGE === 0;
  nextBtn.disabled = CURRENT_PDF_PAGE === spreads.length - 1;
  pageIndicator.textContent = `Halaman ${CURRENT_PDF_PAGE * 2 + 1}-${CURRENT_PDF_PAGE * 2 + 2} dari ${spreads.length * 2}`;
}

function navigatePdfPage(direction) {
  const spreads = ACTIVE_PDF_BOOK.samplePages;
  const targetSpread = CURRENT_PDF_PAGE + direction;

  if (targetSpread >= 0 && targetSpread < spreads.length) {
    CURRENT_PDF_PAGE = targetSpread;
    renderPdfPages();
  }
}

// --- FORMS HANDLERS & SUCCESS STATES ---
function initForms() {
  const partnerForm = document.getElementById("b2b-partner-form");
  const manuscriptForm = document.getElementById("manuscript-submission-form");
  const contactForm = document.getElementById("general-contact-form");

  if (partnerForm) {
    partnerForm.addEventListener("submit", (e) => {
      e.preventDefault();
      
      // Simple validation check
      const inputs = partnerForm.querySelectorAll(".form-control");
      let valid = true;
      inputs.forEach(input => {
        if (input.required && !input.value.trim()) valid = false;
      });

      if (valid) {
        // Dynamic switch to Success State
        const formBox = partnerForm.parentElement;
        const orgTitle = formBox.querySelector("h2");
        const orgSubtitle = formBox.querySelector(".form-box-subtitle");

        orgTitle.style.display = "none";
        orgSubtitle.style.display = "none";
        partnerForm.style.display = "none";

        const successHtml = `
          <div class="form-success-card">
            <div class="success-icon-wrap"><i class="fas fa-check"></i></div>
            <h3>Pendaftaran Dikirim!</h3>
            <p>Terima kasih atas ketertarikan Anda. Tim B2B kami akan memproses data kemitraan Anda dan mengirimkan katalog daftar harga grosir eksklusif dalam 1x24 jam kerja melalui email / WhatsApp Anda.</p>
            <button class="btn btn-outline-dark btn-sm btn-back-form">Kembali ke Form</button>
          </div>
        `;
        
        const successDiv = document.createElement("div");
        successDiv.innerHTML = successHtml;
        formBox.appendChild(successDiv);

        successDiv.querySelector(".btn-back-form").addEventListener("click", () => {
          successDiv.remove();
          orgTitle.style.display = "block";
          orgSubtitle.style.display = "block";
          partnerForm.style.display = "block";
          partnerForm.reset();
        });
      }
    });
  }

  if (manuscriptForm) {
    const fileInput = document.getElementById("manuscript-file");
    const fileLabel = document.getElementById("file-upload-label");

    if (fileInput) {
      fileInput.addEventListener("change", (e) => {
        if (e.target.files.length > 0) {
          const fileName = e.target.files[0].name;
          const fileSize = (e.target.files[0].size / 1024 / 1024).toFixed(2);
          fileLabel.innerHTML = `<i class="fas fa-file-pdf" style="color:red; font-size:1.8rem; margin-bottom:8px;"></i><br><strong>${fileName}</strong> (${fileSize} MB)`;
        } else {
          fileLabel.innerHTML = `<i class="fas fa-cloud-upload-alt file-upload-icon"></i><div class="file-upload-text">Tarik & lepas file di sini, atau <span>Pilih File</span></div>`;
        }
      });
    }

    manuscriptForm.addEventListener("submit", (e) => {
      e.preventDefault();
      
      const inputs = manuscriptForm.querySelectorAll(".form-control");
      let valid = true;
      inputs.forEach(input => {
        if (input.required && !input.value.trim()) valid = false;
      });

      if (valid) {
        const formBox = manuscriptForm.parentElement;
        const orgTitle = formBox.querySelector("h2");
        const orgSubtitle = formBox.querySelector(".form-box-subtitle");

        orgTitle.style.display = "none";
        orgSubtitle.style.display = "none";
        manuscriptForm.style.display = "none";

        const successHtml = `
          <div class="form-success-card">
            <div class="success-icon-wrap"><i class="fas fa-feather-alt"></i></div>
            <h3>Naskah Diterima!</h3>
            <p>Naskah dan sinopsis Anda telah terunggah ke sistem kami. Tim Redaksi Darussholah akan melakukan evaluasi kelayakan terbit naskah Anda. Proses seleksi memakan waktu maksimal 14 hari kerja. Hasil seleksi akan dikirimkan langsung ke email Anda.</p>
            <button class="btn btn-outline-dark btn-sm btn-back-form">Kirim Naskah Baru</button>
          </div>
        `;
        
        const successDiv = document.createElement("div");
        successDiv.innerHTML = successHtml;
        formBox.appendChild(successDiv);

        successDiv.querySelector(".btn-back-form").addEventListener("click", () => {
          successDiv.remove();
          orgTitle.style.display = "block";
          orgSubtitle.style.display = "block";
          manuscriptForm.style.display = "block";
          manuscriptForm.reset();
          fileLabel.innerHTML = `<i class="fas fa-cloud-upload-alt file-upload-icon"></i><div class="file-upload-text">Tarik & lepas file di sini, atau <span>Pilih File</span></div>`;
        });
      }
    });
  }

  if (contactForm) {
    contactForm.addEventListener("submit", (e) => {
      e.preventDefault();
      
      const inputs = contactForm.querySelectorAll(".form-control");
      let valid = true;
      inputs.forEach(input => {
        if (input.required && !input.value.trim()) valid = false;
      });

      if (valid) {
        const formParent = contactForm.parentElement;
        contactForm.style.display = "none";

        const successDiv = document.createElement("div");
        successDiv.className = "form-success-card";
        successDiv.innerHTML = `
          <div class="success-icon-wrap"><i class="fas fa-paper-plane"></i></div>
          <h3>Pesan Terkirim!</h3>
          <p>Terima kasih telah menghubungi kami. Customer support kami akan membalas pesan Anda dalam 24 jam ke depan.</p>
          <button class="btn btn-outline-dark btn-sm btn-back-form">Kirim Pesan Lain</button>
        `;

        formParent.appendChild(successDiv);

        successDiv.querySelector(".btn-back-form").addEventListener("click", () => {
          successDiv.remove();
          contactForm.style.display = "block";
          contactForm.reset();
        });
      }
    });
  }
}

// --- BLOG LIST & VIEWER RENDERER ---
function renderBlogList() {
  const blogListGrid = document.getElementById("blog-list-grid");
  const homeBlogGrid = document.getElementById("home-blog-grid");

  // 1. Home Previews (First 3 posts)
  if (homeBlogGrid) {
    homeBlogGrid.innerHTML = "";
    BLOGS.slice(0, 3).forEach(post => {
      const card = createBlogCardElement(post);
      homeBlogGrid.appendChild(card);
    });
  }

  // 2. Full Blog Page
  if (blogListGrid) {
    renderBlogPage(BLOGS);
    initBlogCategories();
  }
}

function renderBlogPage(posts) {
  const grid = document.getElementById("blog-list-grid");
  grid.innerHTML = "";
  
  if (posts.length === 0) {
    grid.innerHTML = `<div style="grid-column:1/-1; text-align:center; padding:40px; color:var(--text-muted);">Tidak ada artikel yang cocok.</div>`;
    return;
  }

  posts.forEach(post => {
    grid.appendChild(createBlogCardElement(post));
  });
}

function createBlogCardElement(post) {
  const col = document.createElement("div");
  col.className = "blog-card-item";

  // Category-specific color theme for blog cover placeholder
  let catBg = "from-slate-700 to-slate-900";
  if (post.category === "tips") catBg = "from-blue-900 to-indigo-950";
  if (post.category === "berita") catBg = "from-amber-900 to-stone-900";

  col.innerHTML = `
    <div class="blog-card">
      <div class="blog-img-wrap flex-center bg-gradient-to-br ${catBg}">
        <div style="text-align:center; color:white; padding:30px;">
          <i class="${post.category === 'tips' ? 'fas fa-lightbulb' : 'fas fa-newspaper'}" style="font-size:2.5rem; margin-bottom:12px; opacity:0.8;"></i>
          <div style="font-size:0.75rem; text-transform:uppercase; letter-spacing:1px; font-weight:bold; color:var(--accent);">${post.category}</div>
        </div>
      </div>
      <div class="blog-info">
        <div class="blog-meta">
          <span><i class="far fa-calendar"></i> ${post.date}</span>
          <span><i class="far fa-clock"></i> ${post.readTime}</span>
        </div>
        <h3 class="blog-title">${post.title}</h3>
        <p class="blog-excerpt">${post.excerpt}</p>
        <button class="blog-link btn-read-article" data-id="${post.id}" style="background:none; border:none; cursor:pointer; padding:0; text-align:left; font-family:inherit;">
          Baca Selengkapnya <i class="fas fa-arrow-right"></i>
        </button>
      </div>
    </div>
  `;

  col.querySelector(".btn-read-article").addEventListener("click", () => {
    openArticleDetail(post.id);
  });

  return col;
}

function initBlogCategories() {
  const tabs = document.querySelectorAll(".category-tab");
  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      tabs.forEach(t => t.classList.remove("active"));
      tab.classList.add("active");

      const cat = tab.getAttribute("data-category");
      if (cat === "all") {
        renderBlogPage(BLOGS);
      } else {
        const filtered = BLOGS.filter(post => post.category === cat);
        renderBlogPage(filtered);
      }
    });
  });
}

function openArticleDetail(postId) {
  const post = BLOGS.find(p => p.id === postId);
  if (!post) return;

  // Let's reuse the book detail modal structure, or show a simple overlay for reading
  // Create dynamic overlay modal for reading articles
  const articleModal = document.createElement("div");
  articleModal.className = "modal-overlay active";
  articleModal.id = "article-read-modal";
  articleModal.style.zIndex = "4000";

  let catBg = "from-slate-700 to-slate-900";
  if (post.category === "tips") catBg = "from-blue-900 to-indigo-950";
  if (post.category === "berita") catBg = "from-amber-900 to-stone-900";

  articleModal.innerHTML = `
    <div class="modal-content" style="max-width:700px;">
      <button class="modal-close" id="article-close-btn"><i class="fas fa-times"></i></button>
      <div class="bg-gradient-to-br ${catBg}" style="padding:50px 30px; text-align:center; color:white; border-top-left-radius:12px; border-top-right-radius:12px;">
        <span style="font-size:0.75rem; text-transform:uppercase; letter-spacing:2px; font-weight:bold; color:var(--accent); display:block; margin-bottom:10px;">Kategori: ${post.category}</span>
        <h2 style="color:white; font-size:1.8rem; line-height:1.3; font-family:var(--font-base);">${post.title}</h2>
        <div style="display:flex; justify-content:center; gap:20px; font-size:0.8rem; margin-top:20px; opacity:0.8;">
          <span>By: ${post.author}</span>
          <span>|</span>
          <span>${post.date}</span>
          <span>|</span>
          <span>${post.readTime}</span>
        </div>
      </div>
      <div style="padding:40px; font-size:1rem; line-height:1.8; color:var(--text-main); text-align:justify;">
        ${post.content}
      </div>
      <div style="padding:20px 40px; background-color:var(--bg-cream-dark); border-bottom-left-radius:12px; border-bottom-right-radius:12px; display:flex; justify-content:space-between; align-items:center;">
        <span style="font-size:0.8rem; color:var(--text-muted);">Darussholah &copy; 2026</span>
        <button class="btn btn-outline-dark btn-sm" id="article-close-footer">Tutup</button>
      </div>
    </div>
  `;

  document.body.appendChild(articleModal);
  document.body.style.overflow = "hidden";

  const closeFn = () => {
    articleModal.remove();
    document.body.style.overflow = "";
  };

  document.getElementById("article-close-btn").addEventListener("click", closeFn);
  document.getElementById("article-close-footer").addEventListener("click", closeFn);
  articleModal.addEventListener("click", (e) => {
    if (e.target === articleModal) closeFn();
  });
}

/*
========================================================================
   ADMIN PORTAL CMS & REST API CLIENT
   CRUD, Real-time sync, Cover Uploads, and Stats Engine
========================================================================
*/

async function loadBooksFromAPI() {
  try {
    const res = await fetch("/api/books");
    if (res.ok) {
      const data = await res.json();
      if (Array.isArray(data) && data.length > 0) {
        BOOKS = data;
        console.log("Katalog buku berhasil disinkronkan dari Backend API:", BOOKS.length, "buku.");
        const statusEl = document.getElementById("stat-server-status");
        if (statusEl) statusEl.innerHTML = '<i class="fas fa-check-circle"></i> Terhubung (API)';
        return;
      }
    }
  } catch (err) {
    console.warn("Backend API tidak merespons, menggunakan fallback data lokal:", err);
    const statusEl = document.getElementById("stat-server-status");
    if (statusEl) statusEl.innerHTML = '<i class="fas fa-database"></i> Mode Offline';
  }
}

// --- Admin Modal Tab Switcher, Currency & Validation Engine (Shared Global Scope) ---
const ADMIN_TABS = [
  { id: "basic", label: "Langkah 1 dari 3: Info & Sinopsis" },
  { id: "pricing", label: "Langkah 2 dari 3: Harga & Marketplace" },
  { id: "specs", label: "Langkah 3 dari 3: Spesifikasi & Cover" }
];
let currentAdminTabIndex = 0;

const REQUIRED_ADMIN_FIELDS = [
  { id: "form-book-title", name: "Judul Lengkap Buku", tab: "basic", tabIndex: 0, tabLabel: "1. Info & Sinopsis" },
  { id: "form-book-author", name: "Penulis / Penyusun", tab: "basic", tabIndex: 0, tabLabel: "1. Info & Sinopsis" },
  { id: "form-book-genre", name: "Kategori / Genre Kitab", tab: "basic", tabIndex: 0, tabLabel: "1. Info & Sinopsis" },
  { id: "form-book-original-price", name: "Harga Normal / HET", tab: "pricing", tabIndex: 1, tabLabel: "2. Harga & Marketplace" },
  { id: "form-book-price", name: "Harga Jual Akhir", tab: "pricing", tabIndex: 1, tabLabel: "2. Harga & Marketplace" }
];

function formatRupiahInput(inputEl) {
  if (!inputEl) return 0;
  const rawVal = inputEl.value;
  const cursorStart = inputEl.selectionStart || 0;
  const digitsBeforeCursor = (rawVal.slice(0, cursorStart).match(/\d/g) || []).length;
  
  const cleanDigits = rawVal.replace(/\D/g, "");
  if (!cleanDigits) {
    inputEl.value = "";
    return 0;
  }
  
  const num = parseInt(cleanDigits, 10);
  const formatted = num.toLocaleString("id-ID");
  inputEl.value = formatted;
  
  // Reposition cursor smoothly
  let newCursorPos = 0;
  let seenDigits = 0;
  for (let i = 0; i < formatted.length; i++) {
    if (/\d/.test(formatted[i])) {
      seenDigits++;
    }
    if (seenDigits === digitsBeforeCursor) {
      newCursorPos = i + 1;
      break;
    }
  }
  if (digitsBeforeCursor === 0) newCursorPos = 0;
  if (seenDigits < digitsBeforeCursor) newCursorPos = formatted.length;
  
  try {
    inputEl.setSelectionRange(newCursorPos, newCursorPos);
  } catch (e) {}
  
  return num;
}

function parseRupiah(val) {
  if (typeof val === "number") return val;
  if (!val) return 0;
  const clean = String(val).replace(/\D/g, "");
  return clean ? parseInt(clean, 10) : 0;
}

function formatRupiahDisplay(num) {
  if (num === null || num === undefined || isNaN(num) || num === "") return "";
  const parsed = parseInt(String(num).replace(/\D/g, ""), 10);
  if (isNaN(parsed)) return "";
  return parsed.toLocaleString("id-ID");
}

function switchAdminTab(index) {
  currentAdminTabIndex = Math.max(0, Math.min(index, ADMIN_TABS.length - 1));
  const activeTab = ADMIN_TABS[currentAdminTabIndex];

  document.querySelectorAll(".admin-tab-btn").forEach(btn => {
    btn.classList.toggle("active", btn.dataset.tab === activeTab.id);
  });

  document.querySelectorAll(".admin-tab-pane").forEach(pane => {
    pane.classList.toggle("active", pane.id === `pane-${activeTab.id}`);
  });

  const prevBtn = document.getElementById("admin-tab-prev-btn");
  const nextBtn = document.getElementById("admin-tab-next-btn");
  const stepIndicator = document.getElementById("admin-step-indicator");

  if (prevBtn) prevBtn.style.display = currentAdminTabIndex > 0 ? "inline-flex" : "none";
  if (nextBtn) nextBtn.style.display = currentAdminTabIndex < ADMIN_TABS.length - 1 ? "inline-flex" : "none";
  if (stepIndicator) stepIndicator.textContent = activeTab.label;
}

function validateAdminForm(showAlert = true) {
  const errors = [];
  const tabErrorCounts = { basic: 0, pricing: 0, specs: 0 };

  REQUIRED_ADMIN_FIELDS.forEach(field => {
    const el = document.getElementById(field.id);
    const errEl = document.getElementById(`err-${field.id}`);
    const wrapEl = document.getElementById(`wrap-${field.id}`);
    if (!el) return;

    const val = (el.value || "").trim();
    let isInvalid = !val;
    if (el.type === "number" && !isInvalid) {
      const numVal = parseFloat(val);
      if (isNaN(numVal) || numVal <= 0) {
        isInvalid = true;
      }
    }
    if ((field.id === "form-book-original-price" || field.id === "form-book-price") && !isInvalid) {
      const numVal = parseRupiah(val);
      if (numVal <= 0) {
        isInvalid = true;
      }
    }

    if (isInvalid) {
      errors.push(field);
      tabErrorCounts[field.tab]++;
      el.classList.add("input-error");
      if (wrapEl) wrapEl.classList.add("has-error");
      if (errEl) errEl.style.display = "inline-flex";
    } else {
      el.classList.remove("input-error");
      if (wrapEl) wrapEl.classList.remove("has-error");
      if (errEl) errEl.style.display = "none";
    }
  });

  // Update Tab Error Badges on sub-navigation buttons
  Object.keys(tabErrorCounts).forEach(tabKey => {
    const badge = document.getElementById(`badge-tab-${tabKey}`);
    const tabBtn = document.getElementById(`tab-btn-${tabKey}`);
    const count = tabErrorCounts[tabKey];
    if (badge && tabBtn) {
      if (count > 0) {
        badge.style.display = "inline-flex";
        badge.textContent = count;
        tabBtn.classList.add("tab-has-error");
      } else {
        badge.style.display = "none";
        tabBtn.classList.remove("tab-has-error");
      }
    }
  });

  // Update Top Alert Notification Banner (Sleek 1-line bar)
  const alertBanner = document.getElementById("admin-validation-alert");
  const alertText = document.getElementById("val-alert-text");
  if (alertBanner) {
    if (showAlert && errors.length > 0) {
      if (alertText) {
        alertText.innerHTML = `Mohon lengkapi <strong>${errors.length} kolom wajib</strong> yang ditandai merah pada tab di atas.`;
      }
      alertBanner.style.display = "flex";
    } else {
      alertBanner.style.display = "none";
    }
  }

  return errors;
}

function clearAdminFormValidation() {
  REQUIRED_ADMIN_FIELDS.forEach(field => {
    const el = document.getElementById(field.id);
    const errEl = document.getElementById(`err-${field.id}`);
    const wrapEl = document.getElementById(`wrap-${field.id}`);
    if (el) el.classList.remove("input-error");
    if (wrapEl) wrapEl.classList.remove("has-error");
    if (errEl) errEl.style.display = "none";
  });

  ["basic", "pricing", "specs"].forEach(tabKey => {
    const badge = document.getElementById(`badge-tab-${tabKey}`);
    const tabBtn = document.getElementById(`tab-btn-${tabKey}`);
    if (badge) badge.style.display = "none";
    if (tabBtn) tabBtn.classList.remove("tab-has-error");
  });

  const alertBanner = document.getElementById("admin-validation-alert");
  if (alertBanner) alertBanner.style.display = "none";
}

function jumpToAdminFormField(tabIndex, fieldId) {
  switchAdminTab(parseInt(tabIndex));
  setTimeout(() => {
    const el = document.getElementById(fieldId);
    if (el) {
      const customTrigger = el.parentElement?.querySelector(".custom-select-trigger");
      const target = customTrigger || el;
      target.focus();
      target.scrollIntoView({ behavior: "smooth", block: "center" });
      target.classList.remove("input-error");
      void target.offsetWidth; // retrigger css animation
      target.classList.add("input-error");
    }
  }, 60);
}

// Global window attachments
window.switchAdminTab = switchAdminTab;
window.formatRupiahInput = formatRupiahInput;
window.parseRupiah = parseRupiah;
window.formatRupiahDisplay = formatRupiahDisplay;
window.validateAdminForm = validateAdminForm;
window.clearAdminFormValidation = clearAdminFormValidation;
window.jumpToAdminFormField = jumpToAdminFormField;

function initAdmin() {
  const openAddBtn = document.getElementById("admin-btn-open-add");
  const modalCloseBtn = document.getElementById("admin-modal-close-btn");
  const cancelBtn = document.getElementById("admin-btn-cancel");
  const refreshBtn = document.getElementById("admin-refresh-btn");
  const searchInput = document.getElementById("admin-search-input");
  const genreFilter = document.getElementById("admin-filter-genre");
  const form = document.getElementById("admin-book-form");
  const modal = document.getElementById("admin-book-modal");

  // Dropzone elements
  const dropzone = document.getElementById("admin-cover-dropzone");
  const fileInput = document.getElementById("form-book-cover-file");
  const previewBox = document.getElementById("admin-cover-preview-box");
  const previewImg = document.getElementById("admin-cover-preview-img");
  const removeCoverBtn = document.getElementById("admin-btn-remove-cover");
  const coverUrlInput = document.getElementById("form-book-cover-url");

  // Price auto calculation
  const origPriceInput = document.getElementById("form-book-original-price");
  const discountInput = document.getElementById("form-book-discount");
  const priceInput = document.getElementById("form-book-price");

  if (!modal) return;

  const updatePriceCalculation = () => {
    const orig = parseRupiah(origPriceInput?.value || 0);
    const disc = parseFloat(discountInput?.value || 0) || 0;
    if (orig > 0) {
      const calculated = Math.round(orig * (1 - disc / 100));
      if (priceInput) priceInput.value = formatRupiahDisplay(calculated);
    }
  };

  origPriceInput?.addEventListener("input", () => {
    formatRupiahInput(origPriceInput);
    updatePriceCalculation();
    if (parseRupiah(origPriceInput.value) > 0) {
      origPriceInput.classList.remove("input-error");
      const errEl = document.getElementById("err-form-book-original-price");
      if (errEl) errEl.style.display = "none";
      const wrap = document.getElementById("wrap-form-book-original-price");
      if (wrap) wrap.classList.remove("has-error");
    }
  });

  priceInput?.addEventListener("input", () => {
    formatRupiahInput(priceInput);
    if (parseRupiah(priceInput.value) > 0) {
      priceInput.classList.remove("input-error");
      const errEl = document.getElementById("err-form-book-price");
      if (errEl) errEl.style.display = "none";
      const wrap = document.getElementById("wrap-form-book-price");
      if (wrap) wrap.classList.remove("has-error");
    }
  });

  discountInput?.addEventListener("input", updatePriceCalculation);

  // Real-time input listeners to update tab badges dynamically as user types
  REQUIRED_ADMIN_FIELDS.forEach(field => {
    const el = document.getElementById(field.id);
    if (!el) return;
    const checkFieldOnInput = () => {
      const val = (el.value || "").trim();
      let isValid = !!val;
      if (el.type === "number" && isValid) {
        isValid = parseFloat(val) > 0;
      }
      if ((field.id === "form-book-original-price" || field.id === "form-book-price") && isValid) {
        isValid = parseRupiah(val) > 0;
      }

      const wrapEl = document.getElementById(`wrap-${field.id}`);

      if (isValid) {
        el.classList.remove("input-error");
        if (wrapEl) wrapEl.classList.remove("has-error");
        const errEl = document.getElementById(`err-${field.id}`);
        if (errEl) errEl.style.display = "none";

        // Recheck tab error counts
        const tabFields = REQUIRED_ADMIN_FIELDS.filter(f => f.tab === field.tab);
        const remainingTabErrors = tabFields.filter(f => {
          const fEl = document.getElementById(f.id);
          const fVal = (fEl?.value || "").trim();
          if (!fVal) return true;
          if (fEl?.type === "number" && parseFloat(fVal) <= 0) return true;
          if ((f.id === "form-book-original-price" || f.id === "form-book-price") && parseRupiah(fVal) <= 0) return true;
          return false;
        });

        const badge = document.getElementById(`badge-tab-${field.tab}`);
        const tabBtn = document.getElementById(`tab-btn-${field.tab}`);
        if (badge && tabBtn) {
          if (remainingTabErrors.length > 0) {
            badge.style.display = "inline-flex";
            badge.textContent = remainingTabErrors.length;
            tabBtn.classList.add("tab-has-error");
          } else {
            badge.style.display = "none";
            tabBtn.classList.remove("tab-has-error");
          }
        }

        // Check if any error left globally
        const anyGlobalErrors = REQUIRED_ADMIN_FIELDS.some(f => {
          const fEl = document.getElementById(f.id);
          const fVal = (fEl?.value || "").trim();
          if (!fVal) return true;
          if (fEl?.type === "number" && parseFloat(fVal) <= 0) return true;
          if ((f.id === "form-book-original-price" || f.id === "form-book-price") && parseRupiah(fVal) <= 0) return true;
          return false;
        });
        const alertBanner = document.getElementById("admin-validation-alert");
        if (alertBanner && !anyGlobalErrors) {
          alertBanner.style.display = "none";
        }
      }
    };

    el.addEventListener("input", checkFieldOnInput);
    el.addEventListener("change", checkFieldOnInput);
  });

  // Close button on validation alert banner
  document.getElementById("admin-val-alert-close")?.addEventListener("click", () => {
    const alertBanner = document.getElementById("admin-validation-alert");
    if (alertBanner) alertBanner.style.display = "none";
  });

  window.switchAdminTab = function(index) {
    currentAdminTabIndex = Math.max(0, Math.min(index, ADMIN_TABS.length - 1));
    const activeTab = ADMIN_TABS[currentAdminTabIndex];

    document.querySelectorAll(".admin-tab-btn").forEach(btn => {
      btn.classList.toggle("active", btn.dataset.tab === activeTab.id);
    });

    document.querySelectorAll(".admin-tab-pane").forEach(pane => {
      pane.classList.toggle("active", pane.id === `pane-${activeTab.id}`);
    });

    const prevBtn = document.getElementById("admin-tab-prev-btn");
    const nextBtn = document.getElementById("admin-tab-next-btn");
    const stepIndicator = document.getElementById("admin-step-indicator");

    if (prevBtn) prevBtn.style.display = currentAdminTabIndex > 0 ? "inline-flex" : "none";
    if (nextBtn) nextBtn.style.display = currentAdminTabIndex < ADMIN_TABS.length - 1 ? "inline-flex" : "none";
    if (stepIndicator) stepIndicator.textContent = activeTab.label;
  };

  // Bind Tab Click Buttons
  document.querySelectorAll(".admin-tab-btn").forEach((btn, idx) => {
    btn.addEventListener("click", () => window.switchAdminTab(idx));
  });

  // Next & Prev Buttons in Footer
  document.getElementById("admin-tab-next-btn")?.addEventListener("click", () => {
    validateAdminForm(false); // quietly update error badges on tabs
    window.switchAdminTab(currentAdminTabIndex + 1);
  });
  document.getElementById("admin-tab-prev-btn")?.addEventListener("click", () => {
    window.switchAdminTab(currentAdminTabIndex - 1);
  });

  // Global Modal open function for Add Book
  window.openAddBookModal = function() {
    const modalEl = document.getElementById("admin-book-modal");
    const formEl = document.getElementById("admin-book-form");
    const dropzoneEl = document.getElementById("admin-cover-dropzone");
    const previewBoxEl = document.getElementById("admin-cover-preview-box");
    const coverUrlEl = document.getElementById("form-book-cover-url");

    if (formEl) formEl.reset();
    clearAdminFormValidation();
    syncCustomDropdowns(formEl);

    const idEl = document.getElementById("form-book-id");
    if (idEl) idEl.value = "";
    if (coverUrlEl) coverUrlEl.value = "";
    if (previewBoxEl) previewBoxEl.style.display = "none";
    if (dropzoneEl) dropzoneEl.style.display = "block";
    const titleEl = document.getElementById("admin-modal-title");
    if (titleEl) titleEl.textContent = "Tambah Koleksi Buku Baru";
    const submitBtn = document.getElementById("admin-btn-submit");
    if (submitBtn) {
      submitBtn.innerHTML = '<i class="fas fa-save"></i> Simpan Buku';
      submitBtn.disabled = false;
    }
    const warrantyEl = document.getElementById("form-book-warranty");
    if (warrantyEl) warrantyEl.value = "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.";
    if (document.getElementById("form-book-width")) document.getElementById("form-book-width").value = "";
    if (document.getElementById("form-book-height")) document.getElementById("form-book-height").value = "";
    if (document.getElementById("form-book-length")) document.getElementById("form-book-length").value = "";
    if (document.getElementById("form-book-thickness")) document.getElementById("form-book-thickness").value = "";
    if (document.getElementById("form-book-size")) document.getElementById("form-book-size").value = "";
    if (origPriceInput) origPriceInput.value = "";
    if (discountInput) discountInput.value = "0";
    if (priceInput) priceInput.value = "";
    
    switchAdminTab(0);

    if (modalEl) {
      modalEl.classList.add("active");
      document.body.style.overflow = "hidden";
    }
  };

  // Modal open/close
  openAddBtn?.addEventListener("click", () => {
    window.openAddBookModal();
  });

  const closeModal = () => {
    modal.classList.remove("active");
    document.body.style.overflow = "";
  };

  modalCloseBtn?.addEventListener("click", closeModal);
  cancelBtn?.addEventListener("click", closeModal);
  modal.addEventListener("click", (e) => {
    if (e.target === modal) closeModal();
  });

  // Refresh data button
  refreshBtn?.addEventListener("click", async () => {
    refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Memuat...';
    await loadBooksFromAPI();
    renderAdminDashboard();
    renderCatalog();
    renderHomeFeatured();
    refreshBtn.innerHTML = '<i class="fas fa-sync-alt"></i> Data Tersinkron!';
    setTimeout(() => {
      refreshBtn.innerHTML = '<i class="fas fa-sync-alt"></i> Muat Ulang Data';
    }, 2000);
  });

  // Search & Filter
  searchInput?.addEventListener("input", () => renderAdminDashboard());
  genreFilter?.addEventListener("change", () => renderAdminDashboard());

  // Table row action delegation (Robust fallback for all dynamic rows)
  const tbodyEl = document.getElementById("admin-books-tbody");
  tbodyEl?.addEventListener("click", (e) => {
    const editBtn = e.target.closest(".btn-admin-edit");
    if (editBtn && editBtn.dataset.id) {
      e.preventDefault();
      editBookInAdmin(editBtn.dataset.id);
      return;
    }
    const viewBtn = e.target.closest(".btn-admin-view");
    if (viewBtn && viewBtn.dataset.id) {
      e.preventDefault();
      openBookDetailModal(viewBtn.dataset.id);
      return;
    }
    const delBtn = e.target.closest(".btn-admin-del");
    if (delBtn && delBtn.dataset.id) {
      e.preventDefault();
      deleteBookFromAdmin(delBtn.dataset.id);
      return;
    }
  });

  // Upload file handling
  dropzone?.addEventListener("click", () => fileInput.click());
  
  dropzone?.addEventListener("dragover", (e) => {
    e.preventDefault();
    dropzone.classList.add("dragover");
  });

  dropzone?.addEventListener("dragleave", () => {
    dropzone.classList.remove("dragover");
  });

  dropzone?.addEventListener("drop", (e) => {
    e.preventDefault();
    dropzone.classList.remove("dragover");
    if (e.dataTransfer.files.length > 0) {
      handleFileSelected(e.dataTransfer.files[0]);
    }
  });

  fileInput?.addEventListener("change", (e) => {
    if (e.target.files.length > 0) {
      handleFileSelected(e.target.files[0]);
    }
  });

  removeCoverBtn?.addEventListener("click", () => {
    fileInput.value = "";
    coverUrlInput.value = "";
    previewBox.style.display = "none";
    dropzone.style.display = "block";
  });

  async function handleFileSelected(file) {
    if (!file.type.startsWith("image/")) {
      alert("Silakan pilih file gambar (JPG, PNG, atau WebP).");
      return;
    }

    // Local preview immediately
    const reader = new FileReader();
    reader.onload = async (e) => {
      const base64Data = e.target.result;
      previewImg.src = base64Data;
      previewBox.style.display = "flex";
      dropzone.style.display = "none";

      // Upload to backend API
      try {
        const uploadRes = await fetch("/api/upload", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: jsonSafeStringify({
            filename: file.name,
            data: base64Data
          })
        });

        if (uploadRes.ok) {
          const uploadData = await uploadRes.json();
          if (uploadData.url) {
            coverUrlInput.value = uploadData.url;
            console.log("Cover berhasil diunggah ke backend:", uploadData.url);
          }
        } else {
          // Fallback: use data uri locally
          coverUrlInput.value = base64Data;
        }
      } catch (err) {
        console.warn("Upload ke server gagal, menggunakan data lokal:", err);
        coverUrlInput.value = base64Data;
      }
    };
    reader.readAsDataURL(file);
  }

  // Form Submit with Cross-Tab Validation
  form?.addEventListener("submit", async (e) => {
    e.preventDefault();

    // Check all required fields across all tabs
    const errors = validateAdminForm(true);
    if (errors.length > 0) {
      const firstError = errors[0];
      // Automatically navigate to the tab with missing field & focus it
      window.jumpToAdminFormField(firstError.tabIndex, firstError.id);
      showAdminToast(`Ada ${errors.length} kolom wajib yang belum terisi. Beralih ke tab '${firstError.tabLabel}'...`, "warning");
      return;
    }

    const submitBtn = document.getElementById("admin-btn-submit");
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Menyimpan...';
    submitBtn.disabled = true;

    const bookId = document.getElementById("form-book-id").value;
    const title = document.getElementById("form-book-title").value.trim();
    const author = document.getElementById("form-book-author").value.trim();
    const genre = document.getElementById("form-book-genre").value;
    const format = document.getElementById("form-book-format").value;
    const status = document.getElementById("form-book-status").value;
    const isbn = document.getElementById("form-book-isbn").value.trim() || "Belum Terdaftar";
    const widthVal = document.getElementById("form-book-width") ? document.getElementById("form-book-width").value.trim() : "";
    const heightVal = (document.getElementById("form-book-height") || document.getElementById("form-book-length")) ? (document.getElementById("form-book-height") || document.getElementById("form-book-length")).value.trim() : "";
    const thicknessVal = document.getElementById("form-book-thickness") ? document.getElementById("form-book-thickness").value.trim() : "";

    const cleanW = widthVal.replace(/cm/gi, "").trim();
    const cleanH = heightVal.replace(/cm/gi, "").trim();
    const cleanT = thicknessVal.replace(/cm/gi, "").trim();

    let size = "";
    if (cleanW || cleanH) {
      const parts = [];
      if (cleanW) parts.push(cleanW);
      if (cleanH) parts.push(cleanH);
      if (cleanT) parts.push(cleanT);
      size = parts.join(" × ") + " cm";
    } else {
      size = (document.getElementById("form-book-size")?.value || "").trim() || "10 × 14 × 1.5 cm";
    }

    const rawWeight = document.getElementById("form-book-weight").value.trim().replace(/gram/gi, "").trim();
    const weight = rawWeight ? `${rawWeight} gram` : "200 gram";
    const rawPages = document.getElementById("form-book-pages").value.trim().replace(/halaman|hlm/gi, "").trim();
    const pages = rawPages ? `${rawPages} Halaman` : "100 Halaman";
    const language = document.getElementById("form-book-language").value.trim() || "Indonesia";
    const releaseDate = document.getElementById("form-book-release").value.trim() || "2026";
    const originalPrice = parseRupiah(document.getElementById("form-book-original-price").value) || 0;
    const discount = parseFloat(document.getElementById("form-book-discount").value) || 0;
    const price = parseRupiah(document.getElementById("form-book-price").value) || originalPrice;
    const shopeeLink = document.getElementById("form-book-shopee").value.trim();
    const tokopediaLink = document.getElementById("form-book-tokopedia").value.trim();
    const waLink = document.getElementById("form-book-wa").value.trim();
    const synopsis = document.getElementById("form-book-synopsis").value.trim() || "Buku berkualitas terbitan resmi Darussholah.";
    const warranty = document.getElementById("form-book-warranty").value.trim();
    const coverImg = coverUrlInput.value || "";

    // Parse dimensions for numeric format compatibility
    const numWidth = parseFloat(cleanW.replace(',', '.')) || 10;
    const numHeight = parseFloat(cleanH.replace(',', '.')) || (size.match(/(\d+)\s*[xX×]\s*(\d+)/) ? parseInt(size.match(/(\d+)\s*[xX×]\s*(\d+)/)[2]) : 14);
    const numThickness = parseFloat(cleanT.replace(',', '.')) || 1.5;
    const weightGram = parseInt(weight.replace(/\D/g, "")) || 180;
    const pagesNum = parseInt(pages.replace(/\D/g, "")) || 180;

    const bookPayload = {
      id: bookId || undefined,
      title: title,
      author: author,
      genre: genre,
      format: format,
      status: status,
      isbn: isbn,
      price: price,
      originalPrice: originalPrice,
      discount: discount,
      synopsis: synopsis,
      warranty: warranty,
      coverImg: coverImg,
      coverClass: coverImg ? "" : "bg-gradient-to-br from-indigo-950 via-slate-900 to-indigo-900",
      dimensions: {
        width_cm: numWidth,
        height_cm: numHeight,
        length_cm: numHeight,
        thickness_cm: numThickness,
        type: (numHeight <= 15 && numWidth <= 11) ? "Saku" : "Standar"
      },
      weight_gram: weightGram,
      pages: pagesNum,
      pricing: {
        original_price: originalPrice,
        discount_percentage: discount,
        selling_price: price,
        currency: "IDR"
      },
      marketplace_links: {
        shopee: shopeeLink || undefined,
        tokopedia: tokopediaLink || undefined,
        whatsapp_sales: waLink || undefined
      },
      specs: {
        language: language,
        pages: pages,
        width: widthVal || `${numWidth} cm`,
        height: heightVal || `${numHeight} cm`,
        length: heightVal || `${numHeight} cm`,
        thickness: thicknessVal || `${numThickness} cm`,
        size: size,
        weight: weight,
        releaseDate: releaseDate,
        publisher: "Darussholah"
      },
      samplePages: [
        {
          left: `<h2>${title}</h2><p>Buku ini diterbitkan secara resmi oleh Darussholah Publisher & Direct Retailer.</p><p>${synopsis}</p>`,
          right: `<h2>DAFTAR ISI & SPESIFIKASI</h2><p>Kategori: ${genre.toUpperCase()}<br>ISBN: ${isbn}<br>Tebal: ${pages}<br>Dimensi: ${size}</p><p>Dapatkan buku asli hanya melalui website resmi atau akun Shopee Darussholah.</p>`
        }
      ]
    };

    try {
      const saveRes = await fetch("/api/books", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: jsonSafeStringify(bookPayload)
      });

      if (saveRes.ok) {
        const savedData = await saveRes.json();
        const savedBook = savedData.book;
        
        // Update local BOOKS array
        const existingIdx = BOOKS.findIndex(b => b.id === savedBook.id || (savedBook.altId && b.id === savedBook.altId));
        if (existingIdx >= 0) {
          BOOKS[existingIdx] = savedBook;
        } else {
          BOOKS.unshift(savedBook);
        }
      } else {
        // Fallback local update
        fallbackSaveLocal(bookPayload);
      }
    } catch (err) {
      console.warn("Gagal menyimpan via API, fallback ke penyimpanan memori lokal:", err);
      fallbackSaveLocal(bookPayload);
    }

    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
    closeModal();

    // Re-render components
    renderAdminDashboard();
    renderCatalog();
    renderHomeFeatured();

    // Toast feedback
    showAdminToast("Buku berhasil disimpan ke katalog!", "success");
  });
}

function fallbackSaveLocal(bookPayload) {
  if (!bookPayload.id) {
    bookPayload.id = "buku-" + Date.now();
  }
  const idx = BOOKS.findIndex(b => b.id === bookPayload.id);
  if (idx >= 0) {
    BOOKS[idx] = { ...BOOKS[idx], ...bookPayload };
  } else {
    BOOKS.unshift(bookPayload);
  }
}

function renderAdminDashboard() {
  const tbody = document.getElementById("admin-books-tbody");
  const statTotal = document.getElementById("stat-total-books");
  const statGenres = document.getElementById("stat-total-genres");
  const statShopee = document.getElementById("stat-shopee-books");
  const countBadge = document.getElementById("admin-count-badge");
  const searchInput = document.getElementById("admin-search-input");
  const genreFilter = document.getElementById("admin-filter-genre");

  if (!tbody) return;

  // Stats calculation
  const totalCount = BOOKS.length;
  const uniqueGenres = new Set(BOOKS.map(b => b.genre)).size;
  const shopeeCount = BOOKS.filter(b => b.marketplace_links && b.marketplace_links.shopee).length;

  if (statTotal) statTotal.textContent = totalCount;
  if (statGenres) statGenres.textContent = uniqueGenres;
  if (statShopee) statShopee.textContent = shopeeCount;

  // Filter & Search
  const query = (searchInput?.value || "").toLowerCase().trim();
  const genreVal = genreFilter?.value || "all";

  const filtered = BOOKS.filter(b => {
    const matchesGenre = genreVal === "all" || b.genre === genreVal;
    const matchesQuery = query === "" || 
                         b.title.toLowerCase().includes(query) || 
                         b.author.toLowerCase().includes(query) || 
                         (b.isbn && b.isbn.includes(query));
    return matchesGenre && matchesQuery;
  });

  if (countBadge) {
    countBadge.textContent = `Menampilkan ${filtered.length} dari ${totalCount} Buku`;
  }

  tbody.innerHTML = "";

  if (filtered.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="7" style="text-align:center; padding: 40px; color: var(--text-muted);">
          <i class="fas fa-inbox" style="font-size: 2rem; margin-bottom: 8px; display:block; opacity:0.5;"></i>
          Tidak ada buku yang sesuai dengan pencarian.
        </td>
      </tr>
    `;
    return;
  }

  filtered.forEach(book => {
    const tr = document.createElement("tr");

    const coverHtml = book.coverImg 
      ? `<img src="${book.coverImg}" class="admin-thumb" alt="${book.title}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">`
      : '';
    const fallbackCover = `
      <div class="admin-thumb ${book.coverClass || 'bg-gradient-to-br from-indigo-950 to-slate-900'}" style="color:white; font-size:0.65rem; font-weight:bold; text-align:center; padding:4px; ${book.coverImg ? 'display:none;' : 'display:flex;'}">
        ${book.genre.substring(0, 3).toUpperCase()}
      </div>
    `;

    const discountHtml = book.discount > 0 
      ? `<span style="text-decoration:line-through; color:var(--text-muted); font-size:0.75rem; margin-left:4px;">Rp ${book.originalPrice?.toLocaleString('id-ID')}</span> <span class="admin-pill" style="background:#fee2e2; color:#dc2626; padding:1px 5px; font-size:0.68rem;">-${book.discount}%</span>` 
      : '';

    const shopeeStatus = (book.marketplace_links && book.marketplace_links.shopee) 
      ? `<a href="${book.marketplace_links.shopee}" target="_blank" class="admin-pill admin-pill-shopee" title="Buka produk Shopee"><i class="fas fa-shopping-basket"></i> Shopee Aktif</a>`
      : `<span style="font-size:0.75rem; color:var(--text-muted);">-</span>`;

    tr.innerHTML = `
      <td>
        <div style="position:relative;">
          ${coverHtml}
          ${fallbackCover}
        </div>
      </td>
      <td>
        <span class="admin-book-title-cell">${book.title}</span>
        <span class="admin-book-author-cell">Oleh: ${book.author} | ISBN: ${book.isbn || '-'}</span>
      </td>
      <td>
        <span class="admin-pill admin-pill-genre">${book.genre.toUpperCase()}</span>
        <div style="font-size:0.75rem; color:var(--text-muted); margin-top:2px;">Format: ${book.format === 'ebook' ? 'Digital' : 'Cetak'}</div>
      </td>
      <td>
        <strong style="color:var(--primary); font-size:0.92rem;">Rp ${book.price.toLocaleString('id-ID')}</strong>
        <div>${discountHtml}</div>
      </td>
      <td>
        <div style="font-size:0.8rem; color:var(--text-main);">${book.specs?.size || '-'}</div>
        <div style="font-size:0.72rem; color:var(--text-muted);">${book.specs?.weight || '-'} | ${book.specs?.pages || '-'}</div>
      </td>
      <td>
        ${shopeeStatus}
      </td>
      <td>
        <div class="admin-action-group">
          <button type="button" class="btn-admin-act btn-admin-view" title="Lihat di Modal Pengunjung" data-id="${book.id}">
            <i class="fas fa-eye" style="pointer-events: none;"></i>
          </button>
          <button type="button" class="btn-admin-act btn-admin-edit" title="Edit Data Buku" data-id="${book.id}">
            <i class="fas fa-edit" style="pointer-events: none;"></i>
          </button>
          <button type="button" class="btn-admin-act btn-admin-del" title="Hapus Buku" data-id="${book.id}">
            <i class="fas fa-trash-alt" style="pointer-events: none;"></i>
          </button>
        </div>
      </td>
    `;

    // Bind row actions
    tr.querySelector(".btn-admin-view")?.addEventListener("click", (e) => {
      e.stopPropagation();
      openBookDetailModal(book.id);
    });
    tr.querySelector(".btn-admin-edit")?.addEventListener("click", (e) => {
      e.stopPropagation();
      editBookInAdmin(book.id);
    });
    tr.querySelector(".btn-admin-del")?.addEventListener("click", (e) => {
      e.stopPropagation();
      deleteBookFromAdmin(book.id);
    });

    tbody.appendChild(tr);
  });
}

function editBookInAdmin(bookId) {
  const book = BOOKS.find(b => b.id === bookId || (b.altId && b.altId === bookId));
  if (!book) return;

  clearAdminFormValidation();

  const modal = document.getElementById("admin-book-modal");
  const previewBox = document.getElementById("admin-cover-preview-box");
  const previewImg = document.getElementById("admin-cover-preview-img");
  const dropzone = document.getElementById("admin-cover-dropzone");
  const coverUrlInput = document.getElementById("form-book-cover-url");

  // Tab 1: Info Dasar & Identitas
  if (document.getElementById("form-book-id")) document.getElementById("form-book-id").value = book.id;
  if (document.getElementById("form-book-title")) document.getElementById("form-book-title").value = book.title || "";
  if (document.getElementById("form-book-author")) document.getElementById("form-book-author").value = book.author || "";
  if (document.getElementById("form-book-genre")) document.getElementById("form-book-genre").value = book.genre || "umum";
  if (document.getElementById("form-book-format")) document.getElementById("form-book-format").value = book.format || "print";
  if (document.getElementById("form-book-status")) document.getElementById("form-book-status").value = book.status || "normal";
  if (document.getElementById("form-book-isbn")) document.getElementById("form-book-isbn").value = book.isbn || "";
  if (document.getElementById("form-book-synopsis")) document.getElementById("form-book-synopsis").value = book.synopsis || "";

  // Tab 2: Harga & Penjualan
  const origPrice = book.originalPrice || book.pricing?.original_price || book.price || book.pricing?.selling_price || 0;
  const discVal = (book.discount !== undefined && book.discount !== null) ? book.discount : (book.pricing?.discount_percentage || 0);
  const sellPrice = book.price || book.pricing?.selling_price || origPrice;

  if (document.getElementById("form-book-original-price")) {
    document.getElementById("form-book-original-price").value = formatRupiahDisplay(origPrice);
  }
  if (document.getElementById("form-book-discount")) {
    document.getElementById("form-book-discount").value = discVal;
  }
  if (document.getElementById("form-book-price")) {
    document.getElementById("form-book-price").value = formatRupiahDisplay(sellPrice);
  }

  if (document.getElementById("form-book-shopee")) {
    document.getElementById("form-book-shopee").value = book.marketplace_links?.shopee || "";
  }
  if (document.getElementById("form-book-tokopedia")) {
    document.getElementById("form-book-tokopedia").value = book.marketplace_links?.tokopedia || "";
  }
  if (document.getElementById("form-book-wa")) {
    document.getElementById("form-book-wa").value = book.marketplace_links?.whatsapp_sales || "";
  }
  if (document.getElementById("form-book-warranty")) {
    document.getElementById("form-book-warranty").value = book.warranty || "Setiap pembelian di situs resmi ini mendapatkan garansi penukaran buku baru jika terdapat kerusakan cetak atau halaman yang terbalik.";
  }

  // Tab 3: Spesifikasi Fisik & Cover
  let bookWidth = "";
  let bookHeight = "";
  let bookThickness = "";

  if (book.specs?.width) bookWidth = book.specs.width;
  if (book.specs?.height) bookHeight = book.specs.height;
  if (book.specs?.length && !bookHeight) bookHeight = book.specs.length;
  if (book.specs?.thickness) bookThickness = book.specs.thickness;

  if (!bookWidth && book.dimensions?.width_cm) {
    bookWidth = `${book.dimensions.width_cm} cm`;
  }
  if (!bookHeight && book.dimensions?.height_cm) {
    bookHeight = `${book.dimensions.height_cm} cm`;
  }
  if (!bookHeight && book.dimensions?.length_cm) {
    bookHeight = `${book.dimensions.length_cm} cm`;
  }
  if (!bookThickness && book.dimensions?.thickness_cm) {
    bookThickness = `${book.dimensions.thickness_cm} cm`;
  }

  // Fallback parsing from specs.size if available (e.g. "10 x 14 cm (Saku)" or "10 x 14 x 1.5 cm")
  if (!bookWidth && !bookHeight && book.specs?.size) {
    const rawSize = book.specs.size.replace(/\(.*?\)/g, '');
    const parts = rawSize.match(/(\d+(?:[.,]\d+)?)/g);
    if (parts && parts.length >= 2) {
      const p1 = parseFloat(parts[0].replace(',', '.'));
      const p2 = parseFloat(parts[1].replace(',', '.'));
      if (p1 > p2) {
        bookHeight = `${parts[0]} cm`;
        bookWidth = `${parts[1]} cm`;
      } else {
        bookWidth = `${parts[0]} cm`;
        bookHeight = `${parts[1]} cm`;
      }
      if (parts[2]) {
        bookThickness = `${parts[2]} cm`;
      }
    }
  }

  if (document.getElementById("form-book-width")) document.getElementById("form-book-width").value = bookWidth.replace(/cm/gi, "").trim();
  if (document.getElementById("form-book-height")) document.getElementById("form-book-height").value = bookHeight.replace(/cm/gi, "").trim();
  if (document.getElementById("form-book-length")) document.getElementById("form-book-length").value = bookHeight.replace(/cm/gi, "").trim();
  if (document.getElementById("form-book-thickness")) document.getElementById("form-book-thickness").value = bookThickness.replace(/cm/gi, "").trim();
  if (document.getElementById("form-book-size")) document.getElementById("form-book-size").value = book.specs?.size || "";

  const bookWeight = book.specs?.weight || (book.weight_gram ? `${book.weight_gram} gram` : "");
  const bookPages = book.specs?.pages || (book.pages ? `${book.pages} Halaman` : "");

  if (document.getElementById("form-book-weight")) {
    document.getElementById("form-book-weight").value = bookWeight.replace(/gram/gi, "").trim();
  }
  if (document.getElementById("form-book-pages")) {
    document.getElementById("form-book-pages").value = bookPages.replace(/halaman|hlm/gi, "").trim();
  }
  if (document.getElementById("form-book-language")) {
    document.getElementById("form-book-language").value = book.specs?.language || "Indonesia & Arab";
  }

  const rawRelease = book.specs?.releaseDate || book.specs?.year || book.published_date || "";
  const yearMatch = String(rawRelease).match(/\b(19\d\d|20\d\d)\b/);
  if (document.getElementById("form-book-release")) {
    document.getElementById("form-book-release").value = yearMatch ? yearMatch[0] : rawRelease;
  }

  // Cover image preview / dropzone
  if (book.coverImg) {
    if (coverUrlInput) coverUrlInput.value = book.coverImg;
    if (previewImg) previewImg.src = book.coverImg;
    if (previewBox) previewBox.style.display = "flex";
    if (dropzone) dropzone.style.display = "none";
  } else {
    if (coverUrlInput) coverUrlInput.value = "";
    if (previewBox) previewBox.style.display = "none";
    if (dropzone) dropzone.style.display = "block";
  }

  // Set modal header & action button text
  const modalTitle = document.getElementById("admin-modal-title");
  if (modalTitle) modalTitle.textContent = `Edit Buku: ${book.title}`;

  const submitBtn = document.getElementById("admin-btn-submit");
  if (submitBtn) {
    submitBtn.innerHTML = '<i class="fas fa-save"></i> Perbarui Buku';
    submitBtn.disabled = false;
  }

  // Synchronize custom dropdown UI and switch to first tab
  syncCustomDropdowns(document.getElementById("admin-book-form"));
  switchAdminTab(0);

  if (modal) {
    modal.classList.add("active");
    document.body.style.overflow = "hidden";
  }
}

// Global exports for accessibility and programmatic calls
window.editBookInAdmin = editBookInAdmin;
window.openEditBookModal = editBookInAdmin;

async function deleteBookFromAdmin(bookId) {
  const book = BOOKS.find(b => b.id === bookId || (b.altId && b.altId === bookId));
  if (!book) return;

  if (!confirm(`Apakah Anda yakin ingin menghapus buku "${book.title}" dari katalog?`)) {
    return;
  }

  try {
    const res = await fetch(`/api/books/${book.id}`, { method: "DELETE" });
    if (!res.ok) {
      console.warn("Delete API returned non-OK status, deleting locally.");
    }
  } catch (err) {
    console.warn("Delete via API gagal, menghapus dari state memori:", err);
  }

  // Remove locally
  BOOKS = BOOKS.filter(b => b.id !== bookId && b.altId !== bookId);
  renderAdminDashboard();
  renderCatalog();
  renderHomeFeatured();

  showAdminToast(`Buku "${book.title}" berhasil dihapus.`, "info");
}

function showAdminToast(message, type = "success") {
  const toast = document.createElement("div");
  toast.style.position = "fixed";
  toast.style.bottom = "24px";
  toast.style.right = "24px";

  let bg = "#1e293b";
  let icon = "fa-info-circle";
  if (type === "success") {
    bg = "#0f766e";
    icon = "fa-check-circle";
  } else if (type === "warning") {
    bg = "#c2410c";
    icon = "fa-exclamation-triangle";
  } else if (type === "error") {
    bg = "#b91c1c";
    icon = "fa-times-circle";
  }

  toast.style.backgroundColor = bg;
  toast.style.color = "#ffffff";
  toast.style.padding = "14px 24px";
  toast.style.borderRadius = "10px";
  toast.style.boxShadow = "0 12px 28px -5px rgba(0,0,0,0.35)";
  toast.style.zIndex = "99999";
  toast.style.fontSize = "0.92rem";
  toast.style.fontWeight = "600";
  toast.style.display = "flex";
  toast.style.alignItems = "center";
  toast.style.gap = "12px";
  toast.style.transition = "all 0.3s ease";
  toast.innerHTML = `<i class="fas ${icon}"></i> <span>${message}</span>`;

  document.body.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = "0";
    toast.style.transform = "translateY(10px)";
    setTimeout(() => toast.remove(), 300);
  }, 4000);
}

function jsonSafeStringify(obj) {
  return JSON.stringify(obj);
}

function toggleMobileNav() {
  const subNav = document.getElementById("nav-sub-bar");
  if (subNav) {
    subNav.classList.toggle("open");
  }
}
window.toggleMobileNav = toggleMobileNav;

// ========================================================================
// ADMIN AUTHENTICATION GATE & SECURITY LOGIC
// ========================================================================
const ADMIN_MASTER_PASSWORD = "darussholah2026";
const ADMIN_SESSION_KEY = "darussholah_admin_session";

function isAdminAuthenticated() {
  return sessionStorage.getItem(ADMIN_SESSION_KEY) === "true";
}

function renderAdminView() {
  const loginView = document.getElementById("admin-login-view");
  const dashView = document.getElementById("admin-dashboard-view");
  
  if (isAdminAuthenticated()) {
    if (loginView) loginView.style.display = "none";
    if (dashView) dashView.style.display = "block";
    renderAdminDashboard();
  } else {
    if (dashView) dashView.style.display = "none";
    if (loginView) {
      loginView.style.display = "flex";
      const pwdInput = document.getElementById("admin-password-input");
      const errBox = document.getElementById("admin-login-error");
      if (pwdInput) pwdInput.value = "";
      if (errBox) errBox.style.display = "none";
      setTimeout(() => pwdInput?.focus(), 150);
    }
  }
}

function handleAdminLogin(e) {
  if (e) e.preventDefault();
  const pwdInput = document.getElementById("admin-password-input");
  const errBox = document.getElementById("admin-login-error");
  const card = document.querySelector(".admin-login-card");
  const entered = pwdInput?.value.trim();

  // Validate master password (or simple admin fallback)
  if (entered === ADMIN_MASTER_PASSWORD || entered === "admin") {
    sessionStorage.setItem(ADMIN_SESSION_KEY, "true");
    if (errBox) errBox.style.display = "none";
    showAdminToast("Berhasil masuk. Selamat datang di Portal Admin Darussholah!", "success");
    renderAdminView();
  } else {
    if (errBox) {
      errBox.style.display = "flex";
    }
    if (card) {
      card.classList.remove("shake-animation");
      void card.offsetWidth; // Force CSS reflow to re-trigger animation
      card.classList.add("shake-animation");
    }
    if (pwdInput) {
      pwdInput.value = "";
      pwdInput.focus();
    }
  }
}

function handleAdminLogout() {
  sessionStorage.removeItem(ADMIN_SESSION_KEY);
  showAdminToast("Sesi administrator telah ditutup. Akses terkunci.", "info");
  renderAdminView();
}

function toggleAdminPasswordVisibility() {
  const pwdInput = document.getElementById("admin-password-input");
  const eyeIcon = document.getElementById("admin-pwd-eye");
  if (!pwdInput || !eyeIcon) return;
  
  if (pwdInput.type === "password") {
    pwdInput.type = "text";
    eyeIcon.classList.remove("fa-eye");
    eyeIcon.classList.add("fa-eye-slash");
  } else {
    pwdInput.type = "password";
    eyeIcon.classList.remove("fa-eye-slash");
    eyeIcon.classList.add("fa-eye");
  }
}

// Global Secret Shortcut for Staff: Ctrl + Shift + A
window.addEventListener("keydown", (e) => {
  if (e.ctrlKey && e.shiftKey && (e.key === "A" || e.key === "a")) {
    e.preventDefault();
    navigateTo("admin");
  }
});

// Export functions to global scope
window.handleAdminLogin = handleAdminLogin;
window.handleAdminLogout = handleAdminLogout;
window.toggleAdminPasswordVisibility = toggleAdminPasswordVisibility;
window.renderAdminView = renderAdminView;
window.isAdminAuthenticated = isAdminAuthenticated;


