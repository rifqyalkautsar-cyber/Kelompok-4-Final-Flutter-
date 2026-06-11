import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'shared_screens.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const DashboardScreen(),
    const LoansScreen(isAdmin: false), 
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: primaryGreen, unselectedItemColor: Colors.grey, backgroundColor: Colors.white, type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Inventory'),
            BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'My Loans'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'Semua';

  void _showBorrowSheet(EquipmentItem item) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => BorrowForm(itemName: item.name, onConfirm: () { Navigator.pop(context); _showSuccessScreen(item.name); }));
  }

  void _showSuccessScreen(String itemName) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: primaryGreen, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 40)),
            const SizedBox(height: 24), const Text("Berhasil!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
            const SizedBox(height: 16), const Text("Pinjaman sudah diajukan. Harap kembalikan sesuai tepat waktu.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16), const Text("Anda dapat memantau status peminjaman di menu My Loans Atau Riwayat Peminjaman.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { Navigator.pop(context); setState(() {}); }, style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Kembali ke Beranda"))),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Lihat Detail Peminjaman", style: TextStyle(color: primaryGreen)))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<EquipmentItem> filteredItems = _selectedFilter == 'Semua' ? dummyItems : dummyItems.where((e) => e.category == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: Row(children: [Container(width: 30, height: 30, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white), child: const Icon(Icons.account_balance, color: primaryGreen, size: 18)), const SizedBox(width: 12), const Text("SmartBorrow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {}), IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())))],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showBorrowSheet(EquipmentItem(id: '0', name: 'Alat Tambahan Manual', category: 'Umum', location: '', imageUrl: '')), backgroundColor: primaryGreen, child: const Icon(Icons.add, color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Halo, Muhammad Rifqy!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)), const Text("Sistem Peminjaman Inventaris UIN Alauddin", style: TextStyle(fontSize: 12, color: Colors.grey)), const SizedBox(height: 24),
            Row(children: [_buildStatCard("TERSEDIA", "${dummyItems.where((e) => !e.isBorrowed).length}", Colors.green), const SizedBox(width: 16), _buildStatCard("DIPINJAM", "${dummyItems.where((e) => e.isBorrowed).length}", Colors.red)]), const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Semua', 'Proyektor', 'Alat Tulis', 'Alat Lab', 'Umum'].map((category) {
                  bool isSelected = _selectedFilter == category;
                  return Padding(padding: const EdgeInsets.only(right: 8.0), child: ChoiceChip(label: Text(category), selected: isSelected, onSelected: (selected) => setState(() => _selectedFilter = category), selectedColor: primaryGreen, backgroundColor: Colors.white, labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? primaryGreen : Colors.grey.shade300)), showCheckmark: false));
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: filteredItems.length, itemBuilder: (context, index) => _buildEquipmentCard(filteredItems[index])),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color dotColor) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))]), const SizedBox(height: 8), Text(count, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen))])));

  Widget _buildEquipmentCard(EquipmentItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(item.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover)),
              Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: item.isBorrowed ? Colors.red.shade100 : Colors.green.shade100, borderRadius: BorderRadius.circular(20)), child: Text(item.isBorrowed ? "Dipinjam" : "Tersedia: 1", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: item.isBorrowed ? Colors.red.shade800 : Colors.green.shade800)))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))), const Icon(Icons.devices, color: Colors.grey, size: 20)]),
                const SizedBox(height: 4), Text(item.location, style: const TextStyle(fontSize: 12, color: Colors.grey)), const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: item.isBorrowed ? null : () => _showBorrowSheet(item), style: ElevatedButton.styleFrom(backgroundColor: item.isBorrowed ? Colors.grey.shade300 : primaryGreen, foregroundColor: item.isBorrowed ? Colors.grey : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 12), elevation: 0), child: Text(item.isBorrowed ? "Tidak Tersedia" : "Pinjam", style: const TextStyle(fontWeight: FontWeight.bold)))),
                    const SizedBox(width: 8), Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: IconButton(icon: const Icon(Icons.info_outline, color: Colors.grey), onPressed: () {}))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BorrowForm extends StatefulWidget {
  final String itemName;
  final VoidCallback onConfirm;
  const BorrowForm({super.key, required this.itemName, required this.onConfirm});
  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _matkulController = TextEditingController();
  final _dosenController = TextEditingController();
  final _waktuController = TextEditingController();
  final _namaAlatManualController = TextEditingController(); 

  bool get _isManualAdd => widget.itemName == 'Alat Tambahan Manual';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24, left: 24, right: 24, top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_isManualAdd ? "Pinjam Alat Lainnya" : "Formulir Peminjaman", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)), Text("Harap lengkapi data berikut.", style: TextStyle(color: Colors.grey.shade600, fontSize: 14))])),
                IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context), style: IconButton.styleFrom(backgroundColor: Colors.grey.shade200))
              ],
            ),
            const SizedBox(height: 24),

            if (_isManualAdd) ...[ _buildInputLabel("Nama Alat"), _buildTextField(_namaAlatManualController, "Masukkan nama alat", Icons.build_outlined), const SizedBox(height: 16) ],
            _buildInputLabel("Nama Lengkap"), _buildTextField(_namaController, "Masukkan nama lengkap", Icons.person_outline), const SizedBox(height: 16),
            _buildInputLabel("NIM"), _buildTextField(_nimController, "Masukkan Nomor Induk Mahasiswa", Icons.badge_outlined), const SizedBox(height: 16),
            _buildInputLabel("Mata Kuliah/Praktikum"), _buildTextField(_matkulController, "Masukkan mata kuliah", Icons.book_outlined), const SizedBox(height: 16),
            _buildInputLabel("Nama Dosen/Asisten Dosen"), _buildTextField(_dosenController, "Masukkan nama dosen pengampu", Icons.school_outlined), const SizedBox(height: 16),
            _buildInputLabel("Waktu/Jadwal"), _buildTextField(_waktuController, "Contoh: 08:00 - 10:00", Icons.schedule), const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8), border: const Border(left: BorderSide(color: Colors.orange, width: 4))),
              child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Perhatian Limit Waktu", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)), SizedBox(height: 4), Text("Batas waktu peminjaman alat untuk sesi ini adalah 35 menit. Keterlambatan akan dicatat dalam sistem.", style: TextStyle(fontSize: 12, color: Colors.black87))]))]),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: () { if (_namaController.text.isNotEmpty && _nimController.text.isNotEmpty) { widget.onConfirm(); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi form terlebih dahulu!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red)); } },
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Konfirmasi Pinjaman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_forward)]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 6.0), child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: textPrimary, fontSize: 13)));
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) => TextField(controller: controller, decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey, fontSize: 14), prefixIcon: Icon(icon, color: Colors.grey, size: 20), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: primaryGreen, width: 2))));
}