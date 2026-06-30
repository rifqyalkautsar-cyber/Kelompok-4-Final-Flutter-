import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'settings_screen.dart';
import 'detail_sheet.dart';

class LoansScreen extends StatefulWidget {
  final bool isAdmin;
  const LoansScreen({super.key, required this.isAdmin});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  String _selectedFilter = 'Semua Riwayat';
  String _searchQuery =
      ''; // <-- 1. Tambahan state untuk menyimpan teks pencarian

  @override
  Widget build(BuildContext context) {
    List<LoanData> displayLoans = widget.isAdmin
        ? dummyLoans
        : dummyLoans.where((l) => l.nim == '60200119032').toList();

    // 2. Logika filter diperbarui untuk mencocokkan pencarian barang
    List<LoanData> filteredLoans = displayLoans.where((l) {
      // Filter berdasarkan kategori Chip
      bool matchesCategory = true;
      if (_selectedFilter == 'Semua Riwayat')
        matchesCategory = true;
      else if (_selectedFilter == 'Sedang Dipinjam')
        matchesCategory = l.status == 'Aktif' || l.status == 'Menunggu';
      else if (_selectedFilter == 'Terlambat')
        matchesCategory = l.status == 'Terlambat';
      else if (_selectedFilter == 'Selesai')
        matchesCategory = l.status == 'Selesai';

      // Filter berdasarkan teks pencarian
      bool matchesSearch = l.itemName.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: primaryGreen,
        elevation: 0,
        title: const Text(
          "Riwayat Peminjaman",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              // 3. Menambahkan fungsi onChanged untuk menangkap ketikan keyboard
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(color: getTextColor(context)),
              decoration: InputDecoration(
                hintText: "Cari barang...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: getCardColor(context),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children:
                  [
                    'Semua Riwayat',
                    'Sedang Dipinjam',
                    'Terlambat',
                    'Selesai',
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
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredLoans.length,
              itemBuilder: (context, index) {
                return _buildHistoryCard(context, filteredLoans[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, LoanData loan) {
    Color statusColor;
    Color statusBg;
    if (loan.status == 'Selesai') {
      statusColor = Colors.green;
      statusBg = Colors.green.shade50;
    } else if (loan.status == 'Terlambat') {
      statusColor = Colors.red;
      statusBg = Colors.red.shade50;
    } else if (loan.status == 'Aktif') {
      statusColor = Colors.orange;
      statusBg = Colors.orange.shade50;
    } else {
      statusColor = primaryGreen;
      statusBg = primaryGreen.withValues(alpha: 0.1);
    }

    if (Theme.of(context).brightness == Brightness.dark) {
      statusBg = statusColor.withValues(alpha: 0.2);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: loan.status == 'Terlambat'
              ? Colors.red.shade300
              : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200),
        ),
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
                  child: Image.asset(
                    loan.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              loan.status == 'Aktif'
                                  ? 'Sedang Dipinjam'
                                  : loan.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                loan.date.substring(0, 6),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loan.itemName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: getTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${loan.userName} (${loan.nim})",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: getSurfaceColor(context),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      loan.status == 'Terlambat'
                          ? Icons.warning_amber
                          : Icons.access_time,
                      size: 16,
                      color: loan.status == 'Terlambat'
                          ? Colors.red
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loan.time,
                      style: TextStyle(
                        fontSize: 13,
                        color: loan.status == 'Terlambat'
                            ? Colors.red
                            : (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black87),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => LoanDetailSheet(
                        loan: loan,
                        isAdmin: widget.isAdmin,
                        onAction: (action) {
                          if (action == 'Setujui') {
                            setState(() => loan.status = 'Aktif');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Pinjaman disetujui"),
                              ),
                            );
                          } else if (action == 'Tolak') {
                            setState(() => dummyLoans.remove(loan));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Pinjaman ditolak")),
                            );
                          }
                        },
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Info",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: primaryGreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}