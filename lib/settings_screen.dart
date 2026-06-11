import 'package:flutter/material.dart';
import 'constants.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(title: const Text("Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: primaryGreen, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("TAMPILAN", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)), const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(backgroundColor: backgroundLight, child: const Icon(Icons.dark_mode_outlined, color: primaryGreen)),
                title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w600)), subtitle: const Text("Gunakan tema gelap", style: TextStyle(fontSize: 12, color: Colors.grey)),
                trailing: Switch(value: isDarkMode, activeColor: primaryGreen, onChanged: (val) => setState(() => isDarkMode = val)),
              ),
            ),
            const SizedBox(height: 32),
            const Text("INFORMASI & BANTUAN", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)), const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  _buildSettingsMenuItem(Icons.info_outline, "Tentang Kami", null, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen()))), const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildSettingsMenuItem(Icons.menu_book_outlined, "Panduan Penggunaan", null, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserGuideScreen()))), const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildSettingsMenuItem(Icons.support_agent_outlined, "Hubungi Teknisi", "Bantuan teknis aplikasi", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactTechScreen()))),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false),
                icon: const Icon(Icons.logout, color: Colors.red), label: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem(IconData icon, String title, String? subtitle, VoidCallback onTap) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), leading: CircleAvatar(backgroundColor: backgroundLight, child: Icon(icon, color: primaryGreen)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null, trailing: const Icon(Icons.chevron_right, color: Colors.grey), onTap: onTap);
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(title: const Text("Tentang Kami", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, foregroundColor: primaryGreen, elevation: 0),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Tentang SmartBorrow", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)), const SizedBox(height: 12),
              Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)), child: const Text("SmartBorrow Jurusan v1.0", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54))), const SizedBox(height: 32),
              const Text("Aplikasi ini dikembangkan untuk mempermudah mahasiswa dalam meminjam alat inventaris jurusan secara digital, mengurangi penggunaan kertas, serta meminimalisir keterlambatan pengembalian menggunakan WhatsApp Bot.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5)),
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
      backgroundColor: backgroundLight,
      appBar: AppBar(title: const Text("SmartBorrow", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: backgroundLight, foregroundColor: primaryGreen, elevation: 0, centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: const Text("Pusat Bantuan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryGreen))), const SizedBox(height: 16),
            const Text("Panduan Penggunaan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)), const SizedBox(height: 16),
            const Text("Ikuti langkah-langkah di bawah ini untuk meminjam alat inventaris dengan mudah dan cepat melalui sistem akademik kami.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)), const SizedBox(height: 32),
            _buildTimelineItem(Icons.search, "1. Cari Alat", "Cari alat yang Anda butuhkan di menu Inventory."),
            _buildTimelineItem(Icons.edit_document, "2. Isi Formulir", "Klik tombol pinjam dan lengkapi data peminjaman Anda."),
            _buildTimelineItem(Icons.pending_actions, "3. Tunggu Persetujuan", "Admin akan memverifikasi pengajuan Anda dalam waktu singkat."),
            _buildTimelineItem(Icons.pan_tool_alt, "4. Ambil & Gunakan", "Ambil alat di teknisi setelah mendapat persetujuan."),
            _buildTimelineItem(Icons.history_toggle_off, "5. Kembalikan Tepat Waktu", "Pastikan mengembalikan alat sesuai jadwal untuk menghindari denda administratif.", isLast: true),
          ],
        ),
      ),
    );
  }
  Widget _buildTimelineItem(IconData icon, String title, String desc, {bool isLast = false}) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Column(children: [Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryGreen, width: 2), color: Colors.white), child: Icon(icon, color: primaryGreen, size: 20)), if (!isLast) Container(width: 2, height: 80, color: primaryGreen)]), const SizedBox(width: 16), Expanded(child: Container(margin: const EdgeInsets.only(bottom: 24), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 8), Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black54))]))),]);
}

class ContactTechScreen extends StatelessWidget {
  const ContactTechScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(title: const Text("Layanan Teknis", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: backgroundLight, foregroundColor: primaryGreen, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Butuh bantuan dengan aplikasi? Hubungi tim teknis kami melalui saluran di bawah ini. Kami siap membantu Anda.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5)), const SizedBox(height: 32),
            Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)), child: Column(children: [CircleAvatar(radius: 30, backgroundColor: backgroundLight, child: const Icon(Icons.chat_bubble_outline, color: primaryGreen, size: 28)), const SizedBox(height: 16), const Text("Hubungi via WhatsApp", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text("Dapatkan respon cepat untuk kendala teknis.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)), const SizedBox(height: 24), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Mulai Chat", style: TextStyle(fontWeight: FontWeight.bold))))])),
          ],
        ),
      ),
    );
  }
}