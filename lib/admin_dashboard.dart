import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'shared_screens.dart';
import 'settings_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const LoansScreen(isAdmin: true),
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
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Loans'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedFilter = 'Menunggu';

  @override
  Widget build(BuildContext context) {
    List<LoanData> filteredLoans = dummyLoans.where((l) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Menunggu') return l.status == 'Menunggu';
      if (_selectedFilter == 'Aktif') return l.status == 'Aktif';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: Row(children: [Container(width: 30, height: 30, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white), child: const Icon(Icons.account_balance, color: primaryGreen, size: 18)), const SizedBox(width: 12), const Text("SmartBorrow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Halo, Admin Jurusan!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
            const Text("Kelola peminjaman inventaris jurusan hari ini.", style: TextStyle(fontSize: 13, color: Colors.grey)), const SizedBox(height: 20),
            
            _buildSummaryCard("PEMINJAMAN AKTIF", "24", Icons.outbox, Colors.orange.shade100, Colors.orange), const SizedBox(height: 12),
            _buildSummaryCard("MENUNGGU PERSETUJUAN", "7", Icons.pending_actions, Colors.red.shade100, Colors.red), const SizedBox(height: 12),
            _buildSummaryCard("TERLAMBAT", "2", Icons.warning_amber, Colors.grey.shade300, Colors.black54), const SizedBox(height: 24),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Menunggu (7)', 'Aktif (24)', 'Semua'].map((category) {
                  String filterVal = category.split(' ')[0];
                  bool isSelected = _selectedFilter == filterVal || (_selectedFilter == 'Semua' && category == 'Semua');
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category), selected: isSelected, onSelected: (selected) => setState(() => _selectedFilter = category == 'Semua' ? 'Semua' : filterVal),
                      selectedColor: primaryGreen, backgroundColor: Colors.white, labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? primaryGreen : Colors.grey.shade300)), showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            
            ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: filteredLoans.length, itemBuilder: (context, index) => _buildAdminLoanCard(filteredLoans[index])),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), child: Icon(icon, color: iconColor)), const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary))]))
        ],
      ),
    );
  }

  Widget _buildAdminLoanCard(LoanData loan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(loan.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover)),
              Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: loan.status == 'Menunggu' ? Colors.red.shade700 : primaryGreen, borderRadius: BorderRadius.circular(20)), child: Text(loan.status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Expanded(child: Text(loan.itemName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(8)), child: Text(loan.id, style: const TextStyle(fontSize: 12, color: Colors.grey)))]),
                const SizedBox(height: 12), Row(children: [const Icon(Icons.person_outline, size: 16, color: Colors.grey), const SizedBox(width: 8), Text("${loan.userName} (${loan.nim})", style: const TextStyle(fontSize: 13, color: Colors.black87))]),
                const SizedBox(height: 8), Row(children: [const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey), const SizedBox(width: 8), Text("${loan.date}, ${loan.time}", style: const TextStyle(fontSize: 13, color: Colors.black87))]),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    if (loan.status == 'Menunggu') ...[
                      Expanded(child: ElevatedButton.icon(onPressed: () { setState(() => loan.status = 'Aktif'); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pinjaman disetujui"))); }, icon: const Icon(Icons.check_circle_outline, size: 16), label: const Text("Setujui"), style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                      const SizedBox(width: 8),
                    ],
                    Expanded(child: OutlinedButton.icon(onPressed: () { showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => LoanDetailSheet(loan: loan, isAdmin: true)); }, icon: const Icon(Icons.info_outline, size: 16), label: const Text("Info"), style: OutlinedButton.styleFrom(foregroundColor: Colors.grey.shade700, padding: const EdgeInsets.symmetric(vertical: 12), side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                    if (loan.status == 'Menunggu') ...[
                      const SizedBox(width: 8),
                      Expanded(child: OutlinedButton.icon(onPressed: () { setState(() => dummyLoans.remove(loan)); }, icon: const Icon(Icons.cancel_outlined, size: 16), label: const Text("Tolak"), style: OutlinedButton.styleFrom(foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 12), side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                    ]
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