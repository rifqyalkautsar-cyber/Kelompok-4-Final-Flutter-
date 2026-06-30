import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'loans_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'borrow_form.dart';
import 'detail_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardScreen(onNavigateToLoans: () => _changeTab(1)),
      const LoansScreen(isAdmin: false),
      ProfileScreen(isAdmin: false, onNavigateToLoans: () => _changeTab(1)),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _changeTab(index),
          selectedItemColor: primaryGreen,
          unselectedItemColor: Colors.grey,
          backgroundColor: getCardColor(context),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'My Loans',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToLoans;

  const DashboardScreen({super.key, required this.onNavigateToLoans});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'Semua';
  String _searchQuery = ''; // <-- Tambahan state untuk menyimpan teks pencarian
  bool _isSearching =
      false; // <-- Tambahan state untuk toggle tampilan search bar

  final List<EquipmentItem> _items = [
    EquipmentItem(
      id: '1',
      name: 'Proyektor Epson',
      category: 'Proyektor',
      location: 'Fakultas Sains dan Teknologi',
      imageUrl: 'assets/Funnycat.jpg',
    ),
    EquipmentItem(
      id: '2',
      name: 'Kamera Sony A7',
      category: 'Alat Lab',
      location: 'Humas Rektorat',
      imageUrl: 'assets/Funnycat.jpg',
      isBorrowed: true,
    ),
    EquipmentItem(
      id: '3',
      name: 'Kursi Rapat',
      category: 'Umum',
      location: 'Gedung Rektorat Lt. 2',
      imageUrl: 'assets/Funnycat.jpg',
    ),
    EquipmentItem(
      id: '4',
      name: 'Spidol & Penghapus',
      category: 'Alat Tulis',
      location: 'Fakultas Sains dan Teknologi',
      imageUrl: 'assets/Funnycat.jpg',
    ),
  ];

  void _showBorrowSheet(EquipmentItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BorrowForm(
        itemName: item.name,
        onConfirm: () {
          Navigator.pop(context);
          _showSuccessScreen(item.name);
        },
      ),
    );
  }

  void _showSuccessScreen(String itemName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: getCardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              "Berhasil!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Pinjaman sudah diajukan. Harap kembalikan sesuai tepat waktu.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              "Anda dapat memantau status peminjaman di menu My Loans Atau Riwayat Peminjaman.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Kembali ke Beranda"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                widget.onNavigateToLoans(); // BERPINDAH KE TAB MY LOANS
              },
              child: const Text(
                "Lihat Detail Peminjaman",
                style: TextStyle(color: primaryGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Logika filter digabung (Kategori + Teks Pencarian)
    List<EquipmentItem> filteredItems = _items.where((e) {
      bool matchesCategory =
          _selectedFilter == 'Semua' || e.category == _selectedFilter;
      bool matchesSearch = e.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: "Cari alat (ex: Proyektor)...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: primaryGreen,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "SmartBorrow",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = ''; // Reset pencarian jika dibatalkan/ditutup
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBorrowSheet(
            EquipmentItem(
              id: '0',
              name: 'Alat Tambahan Manual',
              category: 'Umum',
              location: '',
              imageUrl: '',
            ),
          );
        },
        backgroundColor: primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, Muhammad Rifqy!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: getTextColor(context),
              ),
            ),
            const Text(
              "Sistem Peminjaman Inventaris UIN Alauddin",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                _buildStatCard(
                  context,
                  "TERSEDIA",
                  "${_items.where((e) => !e.isBorrowed).length}",
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  context,
                  "DIPINJAM",
                  "${_items.where((e) => e.isBorrowed).length}",
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    [
                      'Semua',
                      'Proyektor',
                      'Alat Tulis',
                      'Alat Lab',
                      'Umum',
                    ].map((category) {
                      bool isSelected = _selectedFilter == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) =>
                              setState(() => _selectedFilter = category),
                          selectedColor: primaryGreen,
                          backgroundColor: getCardColor(context),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? primaryGreen
                                  : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade300),
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return _buildEquipmentCard(context, filteredItems[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String count,
    Color dotColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentCard(BuildContext context, EquipmentItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  item.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.isBorrowed
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.isBorrowed ? "Dipinjam" : "Tersedia: 1",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: item.isBorrowed
                          ? Colors.red.shade800
                          : Colors.green.shade800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: getTextColor(context),
                        ),
                      ),
                    ),
                    const Icon(Icons.devices, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: item.isBorrowed
                            ? null
                            : () => _showBorrowSheet(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item.isBorrowed
                              ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade300)
                              : primaryGreen,
                          foregroundColor: item.isBorrowed
                              ? Colors.grey
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(
                          item.isBorrowed ? "Tidak Tersedia" : "Pinjam",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    if (item.isBorrowed) ...[
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            LoanData activeLoan;
                            try {
                              activeLoan = dummyLoans.firstWhere(
                                (l) =>
                                    (l.itemName.contains(item.name) ||
                                        item.name.contains(l.itemName)) &&
                                    (l.status == 'Aktif' ||
                                        l.status == 'Terlambat'),
                              );
                            } catch (e) {
                              activeLoan = dummyLoans.firstWhere(
                                (l) =>
                                    l.status == 'Aktif' ||
                                    l.status == 'Terlambat',
                                orElse: () => dummyLoans.first,
                              );
                            }

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => LoanDetailSheet(
                                loan: activeLoan,
                                isAdmin: false,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}