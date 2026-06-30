import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model Data untuk Predictive Text Mata Kuliah
class CourseData {
  final String name;
  final String lecturer;
  final String schedule;

  CourseData(this.name, this.lecturer, this.schedule);
}

class BorrowForm extends StatefulWidget {
  final String itemName;
  final VoidCallback onConfirm;

  const BorrowForm({
    super.key,
    required this.itemName,
    required this.onConfirm,
  });

  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  TextEditingController? _matkulController; // Diambil dari Autocomplete
  final _dosenController = TextEditingController();
  final _waktuController = TextEditingController();
  final _namaAlatManualController = TextEditingController();

  String? _errorMessage; // <-- Tambahan State untuk Notifikasi Dalam Form

  bool get _isManualAdd => widget.itemName == 'Alat Tambahan Manual';

  // Dataset Mata Kuliah sesuai instruksi
  final List<CourseData> _courseList = [
    CourseData(
      "Interaksi Manusia dan Komputer (A)",
      "Dr. FAISAL, S.T., M.T",
      "08:00-09:40",
    ),
    CourseData(
      "Interaksi Manusia dan Komputer (B)",
      "Dr. FAISAL, S.T., M.T",
      "10:00-11:40",
    ),
    CourseData(
      "Interaksi Manusia dan Komputer (C)",
      "Ahmad Anshari, M.Kom",
      "13:00-14:40",
    ),
    CourseData(
      "Interaksi Manusia dan Komputer (D)",
      "Ahmad Anshari, M.Kom",
      "15:00-16:40",
    ),
    CourseData(
      "Interaksi Manusia dan Komputer (E)",
      "Dr. FAISAL, S.T., M.T",
      "08:00-09:40",
    ),
    CourseData(
      "Jaringan Komputer (A)*",
      "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T",
      "10:00-12:30",
    ),
    CourseData(
      "Jaringan Komputer (B)*",
      "MUNIARDI, S.Kom., M.Kom",
      "13:00-15:30",
    ),
    CourseData(
      "Jaringan Komputer (C)*",
      "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T",
      "08:00-10:30",
    ),
    CourseData(
      "Jaringan Komputer (D)*",
      "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T",
      "10:40-13:10",
    ),
    CourseData(
      "Jaringan Komputer (E)*",
      "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T",
      "13:30-16:00",
    ),
    CourseData(
      "Metodologi Penelitian Sains & Teknologi (A)",
      "FAISAL, S.Kom., M.Kom",
      "08:00-09:40",
    ),
    CourseData(
      "Metodologi Penelitian Sains & Teknologi (B)",
      "M. Hasrul H, S.Kom, M.Kom",
      "10:00-11:40",
    ),
    CourseData(
      "Metodologi Penelitian Sains & Teknologi (C)",
      "Ahmad Anshari, M.Kom",
      "13:00-14:40",
    ),
    CourseData(
      "Metodologi Penelitian Sains & Teknologi (D)",
      "FAISAL, S.Kom., M.Kom",
      "15:00-16:40",
    ),
    CourseData(
      "Metodologi Penelitian Sains & Teknologi (E)",
      "FAISAL, S.Kom., M.Kom",
      "08:00-09:40",
    ),
    CourseData(
      "Pemrograman Perangkat Bergerak (A)*",
      "Ahmad Muyassar Ibrahim, S.Kom., M.Cs",
      "10:00-12:30",
    ),
    CourseData(
      "Pemrograman Perangkat Bergerak (B)*",
      "Ahmad Muyassar Ibrahim, S.Kom., M.Cs",
      "13:00-15:30",
    ),
    CourseData(
      "Pemrograman Perangkat Bergerak (C)*",
      "Ahmad Muyassar Ibrahim, S.Kom., M.Cs",
      "08:00-10:30",
    ),
    CourseData(
      "Pemrograman Perangkat Bergerak (D)*",
      "ASEP INDRA SYAHYADI, S. Kom., M.Kom",
      "10:40-13:10",
    ),
    CourseData(
      "Pemrograman Perangkat Bergerak (E)*",
      "Ahmad Muyassar Ibrahim, S.Kom., M.Cs",
      "13:30-16:00",
    ),
    CourseData(
      "Pemrograman WEB 2 (A)*",
      "NUR SALMAN, S.Kom., M.T.",
      "08:00-10:30",
    ),
    CourseData(
      "Pemrograman WEB 2 (B)*",
      "Ahmad Muyassar Ibrahim, S.Kom., M.Cs",
      "10:40-13:10",
    ),
    CourseData("Pemrograman WEB 2 (C)*", "NUR AFIF, S.T., M.T", "13:30-16:00"),
    CourseData(
      "Pemrograman WEB 2 (D)*",
      "NUR SALMAN, S.Kom., M.T.",
      "08:00-10:30",
    ),
    CourseData("Pemrograman WEB 2 (E)*", "NUR AFIF, S.T., M.T", "10:40-13:10"),
    CourseData(
      "Rekayasa Perangkat Lunak (A)",
      "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.",
      "08:00-10:30",
    ),
    CourseData(
      "Rekayasa Perangkat Lunak (B)",
      "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.",
      "10:40-13:10",
    ),
    CourseData(
      "Rekayasa Perangkat Lunak (C)",
      "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.",
      "13:30-16:00",
    ),
    CourseData(
      "Rekayasa Perangkat Lunak (D)",
      "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.",
      "08:00-10:30",
    ),
    CourseData(
      "Rekayasa Perangkat Lunak (E)",
      "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.",
      "10:40-13:10",
    ),
    CourseData(
      "Statistika dan Probabilitas (A)*",
      "Muhammad Ridwan, S.Si., M.Si.",
      "08:00-10:30",
    ),
    CourseData(
      "Statistika dan Probabilitas (B)*",
      "Sri Dewi Anugrawati, S.Pd., M.Sc",
      "10:40-13:10",
    ),
    CourseData(
      "Statistika dan Probabilitas (C)*",
      "Sri Dewi Anugrawati, S.Pd., M.Sc",
      "13:30-16:00",
    ),
    CourseData(
      "Statistika dan Probabilitas (D)*",
      "Antamil, S.T., M.T.",
      "08:00-10:30",
    ),
    CourseData(
      "Statistika dan Probabilitas (E)*",
      "Muhammad Ridwan, S.Si., M.Si.",
      "10:40-13:10",
    ),
    CourseData(
      "Statistika dan Probabilitas (F)*",
      "Sri Dewi Anugrawati, S.Pd., M.Sc",
      "13:30-16:00",
    ),
    CourseData(
      "Teori Bahasa dan Automata (A)",
      "Dr. Ir. A. Muhammad Syafar, S.T., M.T",
      "08:00-10:30",
    ),
    CourseData(
      "Teori Bahasa dan Automata (B)",
      "MUSTIKASARI, S.Kom., M.Kom",
      "10:40-13:10",
    ),
    CourseData(
      "Teori Bahasa dan Automata (C)",
      "MUSTIKASARI, S.Kom., M.Kom",
      "13:30-16:00",
    ),
    CourseData(
      "Teori Bahasa dan Automata (D)",
      "Dr. Ir. A. Muhammad Syafar, S.T., M.T",
      "08:00-10:30",
    ),
    CourseData(
      "Teori Bahasa dan Automata (E)",
      "Dr. Ir. A. Muhammad Syafar, S.T., M.T",
      "10:40-13:10",
    ),
    // Dummy Sistem Informasi jika mencari kata "Sistem"
    CourseData("Sistem Informasi (A)", "Dosen Sistem Informasi", "08:00-10:30"),
  ];

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  void _validateAndSubmit() async {
    String nama = _namaController.text.trim();
    String nim = _nimController.text.trim();
    String matkul = _matkulController?.text.trim() ?? '';
    String dosen = _dosenController.text.trim();
    String waktu = _waktuController.text.trim();
    String alatManual = _namaAlatManualController.text.trim();

    // 1. Lengkapi semua data (Peringatan Merah)
    if (nama.isEmpty ||
        nim.isEmpty ||
        matkul.isEmpty ||
        dosen.isEmpty ||
        waktu.isEmpty ||
        (_isManualAdd && alatManual.isEmpty)) {
      _showError("Lengkapi data peminjaman anda!!!");
      return;
    }

    // 2. Validasi NIM (11 angka dan Maksimal 60200124165)
    if (nim.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(nim)) {
      _showError("NIM anda tidak tercantum oleh jurusan");
      return;
    }
    BigInt? nimValue = BigInt.tryParse(nim);
    BigInt maxNim = BigInt.parse("60200124165");
    if (nimValue == null || nimValue > maxNim) {
      _showError("NIM anda tidak tercantum oleh jurusan");
      return;
    }

    // 3. Validasi Waktu (Hanya Boleh Angka & Karakter Pemisah seperti : atau -)
    if (!RegExp(r'^[0-9:\-\s]+$').hasMatch(waktu)) {
      _showError("Jadwal/Waktu tidak boleh berisi huruf!");
      return;
    }

    // --- MENGIRIM DATA KE LARAVEL ---
    try {
      // PENTING:
      // 10.0.2.2 adalah IP untuk mengakses localhost Laravel dari Emulator Android.
      // Jika Anda memakai HP Fisik untuk testing, ubah ke IP WiFi Laptop/PC Anda (contoh: 192.168.1.15)
      final url = Uri.parse('http://10.0.2.2/api/loans'); 

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_mahasiswa': nama,
          'nim': nim,
          'mata_kuliah': matkul,
          'dosen': dosen,
          'nama_barang': _isManualAdd ? alatManual : widget.itemName, 
          // LOGIKA STATUS: Jika input manual maka 'Menunggu', jika barang biasa langsung 'Aktif'
          'status': _isManualAdd ? 'Menunggu' : 'Aktif',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Jika sukses tersimpan di MySQL, tampilkan dialog berhasil
        widget.onConfirm(); 
      } else {
        _showError("Gagal menyimpan data ke database server.");
      }
    } catch (e) {
      _showError("Gagal terhubung ke server backend: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isManualAdd
                            ? "Pinjam Alat Lainnya"
                            : "Formulir Peminjaman",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: getTextColor(context),
                        ),
                      ),
                      Text(
                        "Harap lengkapi data berikut.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- Menampilkan Pesan Error di Dalam Formulir ---
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (_isManualAdd) ...[
              _buildInputLabel(context, "Nama Alat"),
              _buildTextField(
                context,
                _namaAlatManualController,
                "Masukkan nama alat",
                Icons.build_outlined,
              ),
              const SizedBox(height: 16),
            ],

            _buildInputLabel(context, "Nama Lengkap"),
            _buildTextField(
              context,
              _namaController,
              "Masukkan nama lengkap",
              Icons.person_outline,
            ),
            const SizedBox(height: 16),

            _buildInputLabel(context, "NIM"),
            _buildTextField(
              context,
              _nimController,
              "Masukkan Nomor Induk Mahasiswa",
              Icons.badge_outlined,
              isNumeric: true,
            ),
            const SizedBox(height: 16),

            _buildInputLabel(context, "Mata Kuliah/Praktikum"),
            _buildCourseAutocomplete(context),
            const SizedBox(height: 16),

            _buildInputLabel(context, "Nama Dosen/Asisten Dosen"),
            _buildTextField(
              context,
              _dosenController,
              "Otomatis terisi dari mata kuliah",
              Icons.school_outlined,
            ),
            const SizedBox(height: 16),

            _buildInputLabel(context, "Waktu/Jadwal"),
            _buildTextField(
              context,
              _waktuController,
              "Otomatis terisi (ex: 08:00-09:40)",
              Icons.schedule,
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: Colors.orange, width: 4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Perhatian Limit Waktu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Batas waktu peminjaman alat untuk sesi ini adalah 35 menit. Keterlambatan akan dicatat dalam sistem.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Konfirmasi Pinjaman",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: getTextColor(context),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumeric = false,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: getTextColor(context)),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        filled: true,
        fillColor: getCardColor(context),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
      ),
    );
  }

  // Fungsi Autocomplete/Predictive Text
  Widget _buildCourseAutocomplete(BuildContext context) {
    return Autocomplete<CourseData>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<CourseData>.empty();
        }
        return _courseList.where((CourseData option) {
          return option.name.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      displayStringForOption: (CourseData option) => option.name,
      onSelected: (CourseData selection) {
        _dosenController.text = selection.lecturer;
        _waktuController.text = selection.schedule;
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            _matkulController = textEditingController;
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              style: TextStyle(color: getTextColor(context)),
              decoration: InputDecoration(
                hintText: "Cari mata kuliah (ex: sistem atau jaringan)",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.book_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                filled: true,
                fillColor: getCardColor(context),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
              ),
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            color: getCardColor(context),
            child: SizedBox(
              height: 250.0,
              width: MediaQuery.of(context).size.width - 48,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final CourseData option = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      option.name,
                      style: TextStyle(
                        color: getTextColor(context),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${option.lecturer} | ${option.schedule}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}