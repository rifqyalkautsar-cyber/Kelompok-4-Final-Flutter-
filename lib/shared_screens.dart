import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

// --- PROFILE SCREEN ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text("Profil", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, foregroundColor: primaryGreen, elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
              child: Column(
                children: [
                  const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop')),
                  const SizedBox(height: 16),
                  const Text("Muhammad Rifqy\nAlkautsar Samudra", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
                  const SizedBox(height: 4),
                  const Text("60200124135", style: TextStyle(fontSize: 14, color: primaryGreen, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.school, size: 16, color: Colors.grey), SizedBox(width: 8), Text("FAKULTAS SAINS DAN TEKNOLOGI", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600))]),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border(top: BorderSide(color: Colors.orange.shade300, width: 4))),
              child: const Row(children: [Icon(Icons.library_books, color: primaryGreen), SizedBox(width: 12), Text("Total Pinjam", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)), Spacer(), Text("12", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimary))]),
            ),
            const SizedBox(height: 24),
            _buildProfileMenu(Icons.person_outline, "Edit Foto Profil", () {}),
            _buildProfileMenu(Icons.history, "Riwayat Peminjaman", () {}),
            _buildProfileMenu(Icons.settings_outlined, "Pengaturan", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()))),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false),
                icon: const Icon(Icons.logout, color: Colors.red), label: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: ListTile(leading: Icon(icon, color: primaryGreen), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), trailing: const Icon(Icons.chevron_right, color: Colors.grey), onTap: onTap),
    );
  }
}

// --- LOANS HISTORY SCREEN ---
class LoansScreen extends StatefulWidget {
  final bool isAdmin;
  const LoansScreen({super.key, required this.isAdmin});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  String _selectedFilter = 'Semua Riwayat';

  @override
  Widget build(BuildContext context) {
    List<LoanData> displayLoans = widget.isAdmin ? dummyLoans : dummyLoans.where((l) => l.nim == '60200119032').toList();
    List<LoanData> filteredLoans = displayLoans.where((l) {
      if (_selectedFilter == 'Semua Riwayat') return true;
      if (_selectedFilter == 'Sedang Dipinjam') return l.status == 'Aktif' || l.status == 'Menunggu';
      if (_selectedFilter == 'Terlambat') return l.status == 'Terlambat';
      if (_selectedFilter == 'Selesai') return l.status == 'Selesai';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: backgroundLight, foregroundColor: primaryGreen, elevation: 0,
        title: const Text("Riwayat Peminjaman", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari barang...", prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Semua Riwayat', 'Sedang Dipinjam', 'Terlambat', 'Selesai'].map((category) {
                bool isSelected = _selectedFilter == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category), selected: isSelected, onSelected: (selected) => setState(() => _selectedFilter = category),
                    selectedColor: primaryGreen, backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? primaryGreen : Colors.grey.shade300)),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredLoans.length,
              itemBuilder: (context, index) => _buildHistoryCard(filteredLoans[index]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHistoryCard(LoanData loan) {
    Color statusColor; Color statusBg;
    if (loan.status == 'Selesai') { statusColor = Colors.green; statusBg = Colors.green.shade50; }
    else if (loan.status == 'Terlambat') { statusColor = Colors.red; statusBg = Colors.red.shade50; }
    else if (loan.status == 'Aktif') { statusColor = Colors.orange; statusBg = Colors.orange.shade50; }
    else { statusColor = primaryGreen; statusBg = primaryGreen.withValues(alpha: 0.1); }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: loan.status == 'Terlambat' ? Colors.red.shade300 : Colors.grey.shade200)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(loan.imageUrl, width: 80, height: 80, fit: BoxFit.cover)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)), child: Text(loan.status == 'Aktif' ? 'Sedang Dipinjam' : loan.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor))),
                          Row(children: [const Icon(Icons.calendar_today, size: 12, color: Colors.grey), const SizedBox(width: 4), Text(loan.date.substring(0, 6), style: const TextStyle(fontSize: 12, color: Colors.grey))])
                        ],
                      ),
                      const SizedBox(height: 8), Text(loan.itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4), Text("${loan.userName} (${loan.nim})", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: backgroundLight, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Icon(loan.status == 'Terlambat' ? Icons.warning_amber : Icons.access_time, size: 16, color: loan.status == 'Terlambat' ? Colors.red : Colors.black87), const SizedBox(width: 8), Text(loan.time, style: TextStyle(fontSize: 13, color: loan.status == 'Terlambat' ? Colors.red : Colors.black87))]),
                InkWell(
                  onTap: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => LoanDetailSheet(loan: loan, isAdmin: widget.isAdmin)),
                  child: const Row(children: [Text("Info", style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen)), Icon(Icons.arrow_forward, size: 16, color: primaryGreen)]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- LOAN DETAIL BOTTOM SHEET ---
class LoanDetailSheet extends StatelessWidget {
  final LoanData loan;
  final bool isAdmin;
  const LoanDetailSheet({super.key, required this.loan, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 24, left: 24, right: 24, top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Detail Peminjaman", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)), IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context), style: IconButton.styleFrom(backgroundColor: Colors.grey.shade200))]),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.devices, color: primaryGreen)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Nama Barang", style: TextStyle(fontSize: 12, color: Colors.grey)), Text(loan.itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]))]),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle(Icons.person_outline, "INFORMASI PEMINJAM"),
            _buildDetailRow("Nama", loan.userName, "NIM", loan.nim), const SizedBox(height: 16),
            
            _buildSectionTitle(Icons.menu_book_outlined, "INFORMASI AKADEMIK"),
            _buildDetailSingleRow("Mata Kuliah", loan.matkul), _buildDetailSingleRow("Dosen Pengampu", loan.dosen), const SizedBox(height: 16),
            
            _buildSectionTitle(Icons.calendar_today_outlined, "JADWAL & WAKTU"),
            Container(
              padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryGreen.withValues(alpha: 0.2))),
              child: Row(children: [const Icon(Icons.access_time, color: primaryGreen), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(loan.date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(loan.time, style: const TextStyle(fontSize: 12, color: Colors.black87))])]),
            ),
            
            if (isAdmin && loan.status == 'Menunggu') ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(foregroundColor: Colors.brown.shade700, padding: const EdgeInsets.symmetric(vertical: 16), side: BorderSide(color: Colors.brown.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Tolak", style: TextStyle(fontWeight: FontWeight.bold)))),
                  const SizedBox(width: 16),
                  Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Setujui", style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Row(children: [Icon(icon, size: 16, color: primaryGreen), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen, letterSpacing: 1.1))]));
  Widget _buildDetailRow(String label1, String val1, String label2, String val2) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label1, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(val1, style: const TextStyle(fontWeight: FontWeight.w500))])), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label2, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(val2, style: const TextStyle(fontWeight: FontWeight.w500))]))]));
  Widget _buildDetailSingleRow(String label, String val) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(val, style: const TextStyle(fontWeight: FontWeight.w500))]));
}