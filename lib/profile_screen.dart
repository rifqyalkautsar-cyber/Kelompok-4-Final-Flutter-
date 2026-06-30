import 'package:flutter/material.dart';
import 'constants.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isAdmin;
  final VoidCallback onNavigateToLoans;

  const ProfileScreen({
    super.key,
    required this.isAdmin,
    required this.onNavigateToLoans,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/Funnycat.jpg',
                    ), //foto profil
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isAdmin
                        ? "Admin Jurusan"
                        : "Muhammad Rifqy\nAlkautsar Samudra",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAdmin ? "Staf Administrasi" : "60200124135",
                    style: const TextStyle(
                      fontSize: 14,
                      color: primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: getSurfaceColor(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.school, size: 16, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "FAKULTAS SAINS DAN TEKNOLOGI",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  top: BorderSide(color: Colors.orange.shade300, width: 4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.library_books, color: primaryGreen),
                  const SizedBox(width: 12),
                  const Text(
                    "Total Pinjam",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isAdmin ? "26" : "12",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildProfileMenu(
              context,
              Icons.person_outline,
              "Edit Foto Profil",
              () {},
            ),

            // TOMBOL RIWAYAT PEMINJAMAN - MEMINDAHKAN KE TAB MY LOANS
            _buildProfileMenu(context, Icons.history, "Riwayat Peminjaman", () {
              onNavigateToLoans();
            }),

            _buildProfileMenu(
              context,
              Icons.settings_outlined,
              "Pengaturan",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                ),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Keluar",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: primaryGreen),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: getTextColor(context),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}