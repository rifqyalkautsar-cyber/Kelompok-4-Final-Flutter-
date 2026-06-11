import 'package:flutter/material.dart';

// ============================================================================
// 📂 FILE: constants.dart
// ============================================================================

// --- STATE GLOBAL UNTUK DARK MODE ---
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// --- TEMA APLIKASI ---
const Color primaryGreen = Color(0xFF045415); // Warna Hijau Gelap UIN
const Color backgroundLight = Color(0xFFF3F7F3); // Warna latar terang (krem kehijauan)
const Color textPrimary = Color(0xFF1E1E1E);

// --- HELPER WARNA UNTUK DARK MODE ---
Color getCardColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white;
Color getTextColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? Colors.white : textPrimary;
Color getSurfaceColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2C) : backgroundLight;


// ============================================================================
// 📂 FILE: main.dart
// ============================================================================
void main() {
  runApp(const SmartBorrowApp());
}

class SmartBorrowApp extends StatelessWidget {
  const SmartBorrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'SmartBorrow UIN',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: primaryGreen,
            scaffoldBackgroundColor: backgroundLight,
            fontFamily: 'Poppins', 
            appBarTheme: const AppBarTheme(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              centerTitle: false,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: primaryGreen,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              centerTitle: false,
            ),
          ),
          home: const LoginScreen(),
        );
      }
    );
  }
}

// ============================================================================
// 📂 FILE: models.dart
// ============================================================================

class EquipmentItem {
  final String id;
  final String name;
  final String category;
  final String location;
  final String imageUrl;
  bool isBorrowed;
  bool isPending;

  EquipmentItem({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.imageUrl,
    this.isBorrowed = false,
    this.isPending = false,
  });
}

class LoanData {
  final String id;
  final String itemName;
  final String userName;
  final String nim;
  final String matkul;
  final String dosen;
  final String imageUrl;
  final String date;
  final String time;
  String status; // 'Menunggu', 'Aktif', 'Terlambat', 'Selesai'

  LoanData({
    required this.id,
    required this.itemName,
    required this.userName,
    required this.nim,
    required this.matkul,
    required this.dosen,
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.status,
  });
}

List<LoanData> dummyLoans = [
  LoanData(
    id: 'INV-092', itemName: 'Proyektor Epson EB-X51', userName: 'Ahmad Rizal', nim: '60200119032',
    matkul: 'Pemrograman Web', dosen: 'Dr. Syamsuddin, M.T.',
    imageUrl: ('assets/Funnycat.jpg'),
    date: '24 Okt 2023', time: '08:00 - 12:00 WITA', status: 'Menunggu',
  ),
  LoanData(
    id: 'INV-114', itemName: 'Kamera Canon EOS 90D', userName: 'Siti Aminah', nim: '60200120045',
    matkul: 'Fotografi Jurnalistik', dosen: 'M. Hasrul H, S.Kom, M.Kom',
    imageUrl: ('assets/Funnycat.jpg'),
    date: '25 Okt 2023', time: '10:00 - 14:00 WITA', status: 'Menunggu',
  ),
  LoanData(
    id: 'INV-045', itemName: 'MacBook Air M1', userName: 'Siti Nurhaliza', nim: '60200120045',
    matkul: 'Desain Grafis', dosen: 'Ahmad Anshari, M.Kom',
    imageUrl: ('assets/Funnycat.jpg'),
    date: '26 Okt 2023', time: '13:00 - 15:00 WITA', status: 'Terlambat',
  ),
  LoanData(
    id: 'INV-012', itemName: 'Kamera Sony A7III', userName: 'Budi Santoso', nim: '60200118012',
    matkul: 'Multimedia', dosen: 'Nur Aeni, S.Si., M.Pd.',
    imageUrl: ('assets/Funnycat.jpg'),
    date: '27 Okt 2023', time: '10:00 - 16:00 WITA', status: 'Aktif',
  ),
];


// ============================================================================
// 📂 FILE: login_screen.dart
// ============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void _handleLogin() {
    String username = _usernameController.text;
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan NIM atau Username", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (username.toLowerCase() == 'admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminMainScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                  ],
                  // Menghapus const dari DecorationImage agar kompatibel dengan semua versi
                  image: const DecorationImage(
                    image: AssetImage('assets/profilUIN.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "SmartBorrow",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGreen),
              ),
              const SizedBox(height: 8),
              const Text(
                "Silakan masuk dengan NIM atau akun\nAdmin",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              _buildInputLabel(context, "Username / NIM"),
              TextField(
                controller: _usernameController,
                decoration: _buildInputDecoration(context, "Masukkan NIM atau username", Icons.person_outline),
                style: TextStyle(color: getTextColor(context)),
              ),
              const SizedBox(height: 20),
              
              _buildInputLabel(context, "Password"),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                style: TextStyle(color: getTextColor(context)),
                decoration: _buildInputDecoration(context, "Masukkan password", Icons.lock_outline).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: getTextColor(context))),
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: getCardColor(context),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
    );
  }
}

// ============================================================================
// 📂 FILE: user_dashboard.dart
// ============================================================================
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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _changeTab(index),
          selectedItemColor: primaryGreen,
          unselectedItemColor: Colors.grey,
          backgroundColor: getCardColor(context),
          type: BottomNavigationBarType.fixed,
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
  final VoidCallback onNavigateToLoans;
  
  const DashboardScreen({super.key, required this.onNavigateToLoans});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'Semua';
  
final List<EquipmentItem> _items = [
    EquipmentItem(id: '1', name: 'Proyektor Epson', category: 'Proyektor', location: 'Fakultas Sains dan Teknologi', imageUrl: 'assets/Funnycat.jpg'), // <-- Sudah diganti
    EquipmentItem(id: '2', name: 'Kamera Sony A7', category: 'Alat Lab', location: 'Humas Rektorat', imageUrl: 'assets/Funnycat.jpg', isBorrowed: true), // <-- Sudah diganti
    EquipmentItem(id: '3', name: 'Kursi Rapat', category: 'Umum', location: 'Gedung Rektorat Lt. 2', imageUrl: 'assets/Funnycat.jpg'), // <-- Sudah diganti
    EquipmentItem(id: '4', name: 'Spidol & Penghapus', category: 'Alat Tulis', location: 'Fakultas Sains dan Teknologi', imageUrl: 'assets/Funnycat.jpg'), // <-- Sudah diganti
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
              decoration: const BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text("Berhasil!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Kembali ke Beranda"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                widget.onNavigateToLoans(); // BERPINDAH KE TAB MY LOANS
              },
              child: const Text("Lihat Detail Peminjaman", style: TextStyle(color: primaryGreen)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<EquipmentItem> filteredItems = _selectedFilter == 'Semua' 
        ? _items 
        : _items.where((e) => e.category == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: const Icon(Icons.account_balance, color: primaryGreen, size: 18),
            ),
            const SizedBox(width: 12),
            const Text("SmartBorrow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.settings), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBorrowSheet(EquipmentItem(id: '0', name: 'Alat Tambahan Manual', category: 'Umum', location: '', imageUrl: ''));
        },
        backgroundColor: primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo, Muhammad Rifqy!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: getTextColor(context))),
            const Text("Sistem Peminjaman Inventaris UIN Alauddin", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 24),
            
            Row(
              children: [
                _buildStatCard(context, "TERSEDIA", "${_items.where((e) => !e.isBorrowed).length}", Colors.green),
                const SizedBox(width: 16),
                _buildStatCard(context, "DIPINJAM", "${_items.where((e) => e.isBorrowed).length}", Colors.red),
              ],
            ),
            const SizedBox(height: 24),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Semua', 'Proyektor', 'Alat Tulis', 'Alat Lab', 'Umum'].map((category) {
                  bool isSelected = _selectedFilter == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) => setState(() => _selectedFilter = category),
                      selectedColor: primaryGreen,
                      backgroundColor: getCardColor(context),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? primaryGreen : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300)),
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

  Widget _buildStatCard(BuildContext context, String title, String count, Color dotColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen)),
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
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(item.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: item.isBorrowed ? Colors.red.shade100 : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.isBorrowed ? "Dipinjam" : "Tersedia: 1", 
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold,
                      color: item.isBorrowed ? Colors.red.shade800 : Colors.green.shade800,
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
                    Expanded(child: Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: getTextColor(context)))),
                    const Icon(Icons.devices, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: item.isBorrowed ? null : () => _showBorrowSheet(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item.isBorrowed ? (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300) : primaryGreen,
                          foregroundColor: item.isBorrowed ? Colors.grey : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(item.isBorrowed ? "Tidak Tersedia" : "Pinjam", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
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

// ============================================================================
// --- 4. PROFILE SCREEN USER & ADMIN ---
// ============================================================================
class ProfileScreen extends StatelessWidget {
  final bool isAdmin;
  final VoidCallback onNavigateToLoans;

  const ProfileScreen({super.key, required this.isAdmin, required this.onNavigateToLoans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Profil", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        foregroundColor: primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    // Menghapus const dari NetworkImage
                    backgroundImage: AssetImage('assets/Funnycat.jpg'), //foto profil
                  ),
                  const SizedBox(height: 16),
                  Text(isAdmin ? "Admin Jurusan" : "Muhammad Rifqy\nAlkautsar Samudra", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: getTextColor(context))),
                  const SizedBox(height: 4),
                  Text(isAdmin ? "Staf Administrasi" : "60200124135", style: const TextStyle(fontSize: 14, color: primaryGreen, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: getSurfaceColor(context), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school, size: 16, color: Colors.grey),
                        SizedBox(width: 8),
                        Text("FAKULTAS SAINS DAN TEKNOLOGI", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius: BorderRadius.circular(16),
                border: Border(top: BorderSide(color: Colors.orange.shade300, width: 4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.library_books, color: primaryGreen),
                  const SizedBox(width: 12),
                  const Text("Total Pinjam", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(isAdmin ? "26" : "12", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: getTextColor(context))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildProfileMenu(context, Icons.person_outline, "Edit Foto Profil", () {}),
            
            // TOMBOL RIWAYAT PEMINJAMAN - MEMINDAHKAN KE TAB MY LOANS
            _buildProfileMenu(context, Icons.history, "Riwayat Peminjaman", () {
              onNavigateToLoans();
            }),
            
            _buildProfileMenu(context, Icons.settings_outlined, "Pengaturan", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            }),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: primaryGreen),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: getTextColor(context))),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

// ============================================================================
// --- 5. FORM PEMINJAMAN (BOTTOM SHEET) ---
// ============================================================================

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

  const BorrowForm({super.key, required this.itemName, required this.onConfirm});

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
    CourseData("Interaksi Manusia dan Komputer (A)", "Dr. FAISAL, S.T., M.T", "08:00-09:40"),
    CourseData("Interaksi Manusia dan Komputer (B)", "Dr. FAISAL, S.T., M.T", "10:00-11:40"),
    CourseData("Interaksi Manusia dan Komputer (C)", "Ahmad Anshari, M.Kom", "13:00-14:40"),
    CourseData("Interaksi Manusia dan Komputer (D)", "Ahmad Anshari, M.Kom", "15:00-16:40"),
    CourseData("Interaksi Manusia dan Komputer (E)", "Dr. FAISAL, S.T., M.T", "08:00-09:40"),
    CourseData("Jaringan Komputer (A)*", "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T", "10:00-12:30"),
    CourseData("Jaringan Komputer (B)*", "MUNIARDI, S.Kom., M.Kom", "13:00-15:30"),
    CourseData("Jaringan Komputer (C)*", "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T", "08:00-10:30"),
    CourseData("Jaringan Komputer (D)*", "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T", "10:40-13:10"),
    CourseData("Jaringan Komputer (E)*", "ANDI MUHAMMAD NUR HIDAYAT, S.Kom., M.T", "13:30-16:00"),
    CourseData("Metodologi Penelitian Sains & Teknologi (A)", "FAISAL, S.Kom., M.Kom", "08:00-09:40"),
    CourseData("Metodologi Penelitian Sains & Teknologi (B)", "M. Hasrul H, S.Kom, M.Kom", "10:00-11:40"),
    CourseData("Metodologi Penelitian Sains & Teknologi (C)", "Ahmad Anshari, M.Kom", "13:00-14:40"),
    CourseData("Metodologi Penelitian Sains & Teknologi (D)", "FAISAL, S.Kom., M.Kom", "15:00-16:40"),
    CourseData("Metodologi Penelitian Sains & Teknologi (E)", "FAISAL, S.Kom., M.Kom", "08:00-09:40"),
    CourseData("Pemrograman Perangkat Bergerak (A)*", "Ahmad Muyassar Ibrahim, S.Kom., M.Cs", "10:00-12:30"),
    CourseData("Pemrograman Perangkat Bergerak (B)*", "Ahmad Muyassar Ibrahim, S.Kom., M.Cs", "13:00-15:30"),
    CourseData("Pemrograman Perangkat Bergerak (C)*", "Ahmad Muyassar Ibrahim, S.Kom., M.Cs", "08:00-10:30"),
    CourseData("Pemrograman Perangkat Bergerak (D)*", "ASEP INDRA SYAHYADI, S. Kom., M.Kom", "10:40-13:10"),
    CourseData("Pemrograman Perangkat Bergerak (E)*", "Ahmad Muyassar Ibrahim, S.Kom., M.Cs", "13:30-16:00"),
    CourseData("Pemrograman WEB 2 (A)*", "NUR SALMAN, S.Kom., M.T.", "08:00-10:30"),
    CourseData("Pemrograman WEB 2 (B)*", "Ahmad Muyassar Ibrahim, S.Kom., M.Cs", "10:40-13:10"),
    CourseData("Pemrograman WEB 2 (C)*", "NUR AFIF, S.T., M.T", "13:30-16:00"),
    CourseData("Pemrograman WEB 2 (D)*", "NUR SALMAN, S.Kom., M.T.", "08:00-10:30"),
    CourseData("Pemrograman WEB 2 (E)*", "NUR AFIF, S.T., M.T", "10:40-13:10"),
    CourseData("Rekayasa Perangkat Lunak (A)", "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.", "08:00-10:30"),
    CourseData("Rekayasa Perangkat Lunak (B)", "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.", "10:40-13:10"),
    CourseData("Rekayasa Perangkat Lunak (C)", "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.", "13:30-16:00"),
    CourseData("Rekayasa Perangkat Lunak (D)", "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.", "08:00-10:30"),
    CourseData("Rekayasa Perangkat Lunak (E)", "Dr. RIDWAN ANDI KAMBAU, S.T., M.Kom.", "10:40-13:10"),
    CourseData("Statistika dan Probabilitas (A)*", "Muhammad Ridwan, S.Si., M.Si.", "08:00-10:30"),
    CourseData("Statistika dan Probabilitas (B)*", "Sri Dewi Anugrawati, S.Pd., M.Sc", "10:40-13:10"),
    CourseData("Statistika dan Probabilitas (C)*", "Sri Dewi Anugrawati, S.Pd., M.Sc", "13:30-16:00"),
    CourseData("Statistika dan Probabilitas (D)*", "Antamil, S.T., M.T.", "08:00-10:30"),
    CourseData("Statistika dan Probabilitas (E)*", "Muhammad Ridwan, S.Si., M.Si.", "10:40-13:10"),
    CourseData("Statistika dan Probabilitas (F)*", "Sri Dewi Anugrawati, S.Pd., M.Sc", "13:30-16:00"),
    CourseData("Teori Bahasa dan Automata (A)", "Dr. Ir. A. Muhammad Syafar, S.T., M.T", "08:00-10:30"),
    CourseData("Teori Bahasa dan Automata (B)", "MUSTIKASARI, S.Kom., M.Kom", "10:40-13:10"),
    CourseData("Teori Bahasa dan Automata (C)", "MUSTIKASARI, S.Kom., M.Kom", "13:30-16:00"),
    CourseData("Teori Bahasa dan Automata (D)", "Dr. Ir. A. Muhammad Syafar, S.T., M.T", "08:00-10:30"),
    CourseData("Teori Bahasa dan Automata (E)", "Dr. Ir. A. Muhammad Syafar, S.T., M.T", "10:40-13:10"),
    // Dummy Sistem Informasi jika mencari kata "Sistem"
    CourseData("Sistem Informasi (A)", "Dosen Sistem Informasi", "08:00-10:30"),
  ];

  void _showError(String message) {
    // Mengubah notifikasi agar muncul DI DALAM form, bukan sebagai Snackbar di luar
    setState(() {
      _errorMessage = message;
    });
    
    // Hilangkan peringatan setelah 3 detik otomatis
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  void _validateAndSubmit() {
    String nama = _namaController.text.trim();
    String nim = _nimController.text.trim();
    String matkul = _matkulController?.text.trim() ?? '';
    String dosen = _dosenController.text.trim();
    String waktu = _waktuController.text.trim();
    String alatManual = _namaAlatManualController.text.trim();

    // 1. Lengkapi semua data (Peringatan Merah)
    if (nama.isEmpty || nim.isEmpty || matkul.isEmpty || dosen.isEmpty || waktu.isEmpty || (_isManualAdd && alatManual.isEmpty)) {
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

    // Lolos Validasi -> Tampilkan Dialog Berhasil
    widget.onConfirm();
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
        left: 24, right: 24, top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isManualAdd ? "Pinjam Alat Lainnya" : "Formulir Peminjaman",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: getTextColor(context)),
                      ),
                      Text("Harap lengkapi data berikut.", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
                )
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
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            if (_isManualAdd) ...[
              _buildInputLabel(context, "Nama Alat"),
              _buildTextField(context, _namaAlatManualController, "Masukkan nama alat", Icons.build_outlined),
              const SizedBox(height: 16),
            ],
            
            _buildInputLabel(context, "Nama Lengkap"),
            _buildTextField(context, _namaController, "Masukkan nama lengkap", Icons.person_outline),
            const SizedBox(height: 16),
            
            _buildInputLabel(context, "NIM"),
            _buildTextField(context, _nimController, "Masukkan Nomor Induk Mahasiswa", Icons.badge_outlined, isNumeric: true),
            const SizedBox(height: 16),
            
            _buildInputLabel(context, "Mata Kuliah/Praktikum"),
            _buildCourseAutocomplete(context),
            const SizedBox(height: 16),
            
            _buildInputLabel(context, "Nama Dosen/Asisten Dosen"),
            _buildTextField(context, _dosenController, "Otomatis terisi dari mata kuliah", Icons.school_outlined),
            const SizedBox(height: 16),
            
            _buildInputLabel(context, "Waktu/Jadwal"),
            _buildTextField(context, _waktuController, "Otomatis terisi (ex: 08:00-09:40)", Icons.schedule),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: const Border(left: BorderSide(color: Colors.orange, width: 4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Perhatian Limit Waktu", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                        SizedBox(height: 4),
                        Text("Batas waktu peminjaman alat untuk sesi ini adalah 35 menit. Keterlambatan akan dicatat dalam sistem.", style: TextStyle(fontSize: 12, color: Colors.black87)),
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
                onPressed: _validateAndSubmit, // Fungsi Validasi Dipanggil
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Konfirmasi Pinjaman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: getTextColor(context), fontSize: 13)),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, String hint, IconData icon, {bool isNumeric = false}) {
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
          borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300),
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
          return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (CourseData option) => option.name,
      onSelected: (CourseData selection) {
        // Otomatis Mengisi Dosen dan Waktu ketika Matkul Dipilih
        _dosenController.text = selection.lecturer;
        _waktuController.text = selection.schedule;
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        _matkulController = textEditingController; // Bind ke Controller utama
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          style: TextStyle(color: getTextColor(context)),
          decoration: InputDecoration(
            hintText: "Cari mata kuliah (ex: sistem atau jaringan)",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.book_outlined, color: Colors.grey, size: 20),
            filled: true,
            fillColor: getCardColor(context),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300),
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
              width: MediaQuery.of(context).size.width - 48, // Menyesuaikan lebar input
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final CourseData option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.name, style: TextStyle(color: getTextColor(context), fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text("${option.lecturer} | ${option.schedule}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
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

// ============================================================================
// --- 6. PENGATURAN & SUB-HALAMAN ---
// ============================================================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("TAMPILAN", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentMode, child) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: getSurfaceColor(context),
                      child: const Icon(Icons.dark_mode_outlined, color: primaryGreen),
                    ),
                    title: Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w600, color: getTextColor(context))),
                    subtitle: const Text("Gunakan tema gelap", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: Switch(
                      value: currentMode == ThemeMode.dark,
                      activeColor: primaryGreen,
                      onChanged: (val) {
                        // SET THEME GLOBALLY
                        themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: 32),
            
            const Text("INFORMASI & BANTUAN", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildSettingsMenuItem(context, Icons.info_outline, "Tentang Kami", null, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen()));
                  }),
                  Divider(height: 1, indent: 16, endIndent: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
                  _buildSettingsMenuItem(context, Icons.menu_book_outlined, "Panduan Penggunaan", null, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserGuideScreen()));
                  }),
                  Divider(height: 1, indent: 16, endIndent: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
                  _buildSettingsMenuItem(context, Icons.support_agent_outlined, "Hubungi Teknisi", "Bantuan teknis aplikasi", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactTechScreen()));
                  }),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            Center(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem(BuildContext context, IconData icon, String title, String? subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: getSurfaceColor(context),
        child: Icon(icon, color: primaryGreen),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: getTextColor(context))),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Tentang Kami", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        foregroundColor: primaryGreen,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: getCardColor(context),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Tentang SmartBorrow", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: getSurfaceColor(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300)
                ),
                child: const Text("SmartBorrow Jurusan v1.0", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
              ),
              const SizedBox(height: 32),
              Text(
                "Aplikasi ini dikembangkan untuk mempermudah mahasiswa dalam meminjam alat inventaris jurusan secara digital, mengurangi penggunaan kertas, serta meminimalisir keterlambatan pengembalian menggunakan WhatsApp Bot.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: getTextColor(context), height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("SmartBorrow", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Pusat Bantuan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryGreen)),
            ),
            const SizedBox(height: 16),
            Text("Panduan Penggunaan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: getTextColor(context))),
            const SizedBox(height: 16),
            const Text(
              "Ikuti langkah-langkah di bawah ini untuk meminjam alat inventaris dengan mudah dan cepat melalui sistem akademik kami.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            _buildTimelineItem(context, Icons.search, "1. Cari Alat", "Cari alat yang Anda butuhkan di menu Inventory. Anda dapat memfilter berdasarkan kategori atau ketersediaan."),
            _buildTimelineItem(context, Icons.edit_document, "2. Isi Formulir", "Klik tombol pinjam dan lengkapi data peminjaman Anda. Pastikan tujuan penggunaan dan durasi sesuai dengan kebutuhan praktikum atau kegiatan."),
            _buildTimelineItem(context, Icons.pending_actions, "3. Tunggu Persetujuan", "Admin akan memverifikasi pengajuan Anda dalam waktu singkat. Anda akan menerima notifikasi setelah disetujui."),
            _buildTimelineItem(context, Icons.pan_tool_alt, "4. Ambil & Gunakan", "Ambil alat di teknisi setelah mendapat persetujuan. Tunjukkan kode unik peminjaman Anda sebagai bukti."),
            _buildTimelineItem(context, Icons.history_toggle_off, "5. Kembalikan Tepat Waktu", "Pastikan mengembalikan alat sesuai jadwal untuk menghindari denda administratif dan menjaga kepercayaan fasilitas institusi.", isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, IconData icon, String title, String desc, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryGreen, width: 2),
                color: getCardColor(context),
              ),
              child: Icon(icon, color: primaryGreen, size: 20),
            ),
            if (!isLast)
              Container(width: 2, height: 80, color: primaryGreen),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: getCardColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: getTextColor(context))),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ContactTechScreen extends StatelessWidget {
  const ContactTechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Layanan Teknis", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: primaryGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Butuh bantuan dengan aplikasi? Hubungi tim teknis kami melalui saluran di bawah ini. Kami siap membantu Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: getSurfaceColor(context),
                    child: const Icon(Icons.chat_bubble_outline, color: primaryGreen, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text("Hubungi via WhatsApp", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: getTextColor(context))),
                  const SizedBox(height: 8),
                  const Text(
                    "Dapatkan respon cepat untuk kendala teknis atau pertanyaan seputar penggunaan aplikasi melalui layanan WhatsApp kami.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Mulai Chat", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: getSurfaceColor(context),
                    child: const Icon(Icons.email_outlined, color: primaryGreen, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text("Hubungi via Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: getTextColor(context))),
                  const SizedBox(height: 8),
                  const Text(
                    "Kirimkan detail kendala atau lampiran dokumen terkait permasalahan Anda ke alamat email resmi kami.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: getSurfaceColor(context),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: const Text(
                      "support@uin-alauddin.ac.id",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, color: primaryGreen),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryGreen),
                        foregroundColor: primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Kirim Email", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// --- 7. HALAMAN ADMIN & RIWAYAT PEMINJAMAN ---
// ============================================================================

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AdminDashboardScreen(onNavigateToLoans: () => _changeTab(1)),
      const LoansScreen(isAdmin: true),
      ProfileScreen(isAdmin: true, onNavigateToLoans: () => _changeTab(1)),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _changeTab(index),
          selectedItemColor: primaryGreen,
          unselectedItemColor: Colors.grey,
          backgroundColor: getCardColor(context),
          type: BottomNavigationBarType.fixed,
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
  final VoidCallback onNavigateToLoans;
  
  const AdminDashboardScreen({super.key, required this.onNavigateToLoans});

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: const Icon(Icons.account_balance, color: primaryGreen, size: 18),
            ),
            const SizedBox(width: 12),
            const Text("SmartBorrow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Halo, Admin Jurusan!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
            const Text("Kelola peminjaman inventaris jurusan hari ini.", style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),
            
            // Summary Cards
            _buildSummaryCard(context, "PEMINJAMAN AKTIF", "24", Icons.outbox, Colors.orange.shade100, Colors.orange),
            const SizedBox(height: 12),
            _buildSummaryCard(context, "MENUNGGU PERSETUJUAN", "7", Icons.pending_actions, Colors.red.shade100, Colors.red),
            const SizedBox(height: 12),
            _buildSummaryCard(context, "TERLAMBAT", "2", Icons.warning_amber, Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300, Colors.grey),
            const SizedBox(height: 24),
            
            // Chips Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Menunggu (7)', 'Aktif (24)', 'Semua'].map((category) {
                  String filterVal = category.split(' ')[0];
                  bool isSelected = _selectedFilter == filterVal || (_selectedFilter == 'Semua' && category == 'Semua');
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) => setState(() => _selectedFilter = category == 'Semua' ? 'Semua' : filterVal),
                      selectedColor: primaryGreen,
                      backgroundColor: getCardColor(context),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? primaryGreen : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300)),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            
            // Admin Loan Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredLoans.length,
              itemBuilder: (context, index) {
                return _buildAdminLoanCard(context, filteredLoans[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String count, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: getTextColor(context))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAdminLoanCard(BuildContext context, LoanData loan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(loan.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: loan.status == 'Menunggu' ? Colors.red.shade700 : primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    loan.status,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
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
                  children: [
                    Expanded(child: Text(loan.itemName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: getTextColor(context)))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: getSurfaceColor(context), borderRadius: BorderRadius.circular(8)),
                      child: const Text("INV-xxx", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("${loan.userName} (${loan.nim})", style: TextStyle(fontSize: 13, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("${loan.date}, ${loan.time}", style: TextStyle(fontSize: 13, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87)),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Setujui, Info, Tolak Buttons
                Row(
                  children: [
                    if (loan.status == 'Menunggu') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => loan.status = 'Aktif');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pinjaman disetujui")));
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text("Setujui"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showLoanDetail(context, loan, true),
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text("Info"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    if (loan.status == 'Menunggu') ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => dummyLoans.remove(loan));
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 16),
                          label: const Text("Tolak"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
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
  
  void _showLoanDetail(BuildContext context, LoanData loan, bool isAdmin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LoanDetailSheet(loan: loan, isAdmin: isAdmin),
    );
  }
}

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: primaryGreen,
        elevation: 0,
        title: const Text("Riwayat Peminjaman", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.settings), 
          onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: TextStyle(color: getTextColor(context)),
              decoration: InputDecoration(
                hintText: "Cari barang...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: getCardColor(context),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.transparent)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Semua Riwayat', 'Sedang Dipinjam', 'Terlambat', 'Selesai'].map((category) {
                bool isSelected = _selectedFilter == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _selectedFilter = category),
                    selectedColor: primaryGreen,
                    backgroundColor: getCardColor(context),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? primaryGreen : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300)),
                    ),
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
              itemBuilder: (context, index) {
                return _buildHistoryCard(context, filteredLoans[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, LoanData loan) {
    Color statusColor;
    Color statusBg;
    if (loan.status == 'Selesai') { statusColor = Colors.green; statusBg = Colors.green.shade50; }
    else if (loan.status == 'Terlambat') { statusColor = Colors.red; statusBg = Colors.red.shade50; }
    else if (loan.status == 'Aktif') { statusColor = Colors.orange; statusBg = Colors.orange.shade50; }
    else { statusColor = primaryGreen; statusBg = primaryGreen.withValues(alpha: 0.1); }

    if (Theme.of(context).brightness == Brightness.dark) {
      statusBg = statusColor.withValues(alpha: 0.2); 
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: loan.status == 'Terlambat' ? Colors.red.shade300 : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(loan.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                            child: Text(loan.status == 'Aktif' ? 'Sedang Dipinjam' : loan.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(loan.date.substring(0, 6), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(loan.itemName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: getTextColor(context))),
                      const SizedBox(height: 4),
                      Text("${loan.userName} (${loan.nim})", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: getSurfaceColor(context),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(loan.status == 'Terlambat' ? Icons.warning_amber : Icons.access_time, size: 16, color: loan.status == 'Terlambat' ? Colors.red : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87)),
                    const SizedBox(width: 8),
                    Text(loan.time, style: TextStyle(fontSize: 13, color: loan.status == 'Terlambat' ? Colors.red : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87))),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => LoanDetailSheet(loan: loan, isAdmin: widget.isAdmin),
                    );
                  },
                  child: const Row(
                    children: [
                      Text("Info", style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen)),
                      Icon(Icons.arrow_forward, size: 16, color: primaryGreen),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LoanDetailSheet extends StatelessWidget {
  final LoanData loan;
  final bool isAdmin;
  
  const LoanDetailSheet({super.key, required this.loan, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 24, left: 24, right: 24, top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Detail Peminjaman", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: getTextColor(context))),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
                )
              ],
            ),
            const SizedBox(height: 24),
            
            // Card Nama Barang
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: getCardColor(context), borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: getSurfaceColor(context), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.devices, color: primaryGreen),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nama Barang", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(loan.itemName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: getTextColor(context))),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle("INFORMASI PEMINJAM"),
            _buildDetailRow(context, "Nama", loan.userName, "NIM", loan.nim),
            
            const SizedBox(height: 16),
            _buildSectionTitle("INFORMASI AKADEMIK"),
            _buildDetailSingleRow(context, "Mata Kuliah", loan.matkul),
            _buildDetailSingleRow(context, "Dosen Pengampu", loan.dosen),
            
            const SizedBox(height: 16),
            _buildSectionTitle("JADWAL & WAKTU"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryGreen.withValues(alpha: 0.2))),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: primaryGreen),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loan.date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: getTextColor(context))),
                      Text(loan.time, style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87)),
                    ],
                  )
                ],
              ),
            ),
            
            if (isAdmin && loan.status == 'Menunggu') ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.brown.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.brown.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Tolak", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Setujui", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, size: 16, color: primaryGreen),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen, letterSpacing: 1.1)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label1, String val1, String label2, String val2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label1, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(val1, style: TextStyle(fontWeight: FontWeight.w500, color: getTextColor(context)))])),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label2, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(val2, style: TextStyle(fontWeight: FontWeight.w500, color: getTextColor(context)))])),
        ],
      ),
    );
  }

  Widget _buildDetailSingleRow(BuildContext context, String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(val, style: TextStyle(fontWeight: FontWeight.w500, color: getTextColor(context))),
        ],
      ),
    );
  }
}