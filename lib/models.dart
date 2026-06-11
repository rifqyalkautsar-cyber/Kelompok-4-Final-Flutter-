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

List<EquipmentItem> dummyItems = [
  EquipmentItem(id: '1', name: 'Proyektor Epson EB-X51', category: 'Proyektor', location: 'Fakultas Sains dan Teknologi', imageUrl: 'https://images.unsplash.com/photo-1579361730419-7b3b4bf6db4d?q=80&w=300&auto=format&fit=crop'),
  EquipmentItem(id: '2', name: 'Kamera Canon EOS 90D', category: 'Alat Lab', location: 'Humas Rektorat', imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=300&auto=format&fit=crop', isBorrowed: true),
  EquipmentItem(id: '3', name: 'Kursi Rapat', category: 'Umum', location: 'Gedung Rektorat Lt. 2', imageUrl: 'https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?q=80&w=300&auto=format&fit=crop'),
  EquipmentItem(id: '4', name: 'Spidol & Penghapus', category: 'Alat Tulis', location: 'Fakultas Sains dan Teknologi', imageUrl: 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?q=80&w=300&auto=format&fit=crop'),
];

List<LoanData> dummyLoans = [
  LoanData(
    id: 'INV-092', itemName: 'Proyektor Epson EB-X51', userName: 'Ahmad Rizal', nim: '60200119032',
    matkul: 'Pemrograman Web', dosen: 'Dr. Syamsuddin, M.T.',
    imageUrl: 'https://images.unsplash.com/photo-1579361730419-7b3b4bf6db4d?q=80&w=300&auto=format&fit=crop',
    date: '24 Okt 2023', time: '08:00 - 12:00 WITA', status: 'Menunggu',
  ),
  LoanData(
    id: 'INV-114', itemName: 'Kamera Canon EOS 90D', userName: 'Siti Aminah', nim: '60200120045',
    matkul: 'Fotografi Jurnalistik', dosen: 'M. Hasrul H, S.Kom, M.Kom',
    imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=300&auto=format&fit=crop',
    date: '25 Okt 2023', time: '10:00 - 14:00 WITA', status: 'Menunggu',
  ),
  LoanData(
    id: 'INV-045', itemName: 'MacBook Air M1', userName: 'Siti Nurhaliza', nim: '60200120045',
    matkul: 'Desain Grafis', dosen: 'Ahmad Anshari, M.Kom',
    imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=300&auto=format&fit=crop',
    date: '26 Okt 2023', time: '13:00 - 15:00 WITA', status: 'Terlambat',
  ),
  LoanData(
    id: 'INV-012', itemName: 'Kamera Sony A7III', userName: 'Budi Santoso', nim: '60200118012',
    matkul: 'Multimedia', dosen: 'Nur Aeni, S.Si., M.Pd.',
    imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=300&auto=format&fit=crop',
    date: '27 Okt 2023', time: '10:00 - 16:00 WITA', status: 'Aktif',
  ),
];