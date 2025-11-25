import 'package:lost_and_found/app/data/models/category_model.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';

class Report {
  final int id;
  final String itemName;
  final String description;
  final String location;
  final DateTime date;
  final String? imageUrl; // Dibuat nullable, karena mungkin tidak ada gambar
  final String reportType; // 'hilang' atau 'ditemukan'
  final String status; // 'open', 'claimed', 'closed'
  final int userId; // ID pengguna yang memposting

  // --- Relasi Model ---
  final User? user; // Data lengkap user yang posting
  final Category? category; // Data lengkap kategori

  Report({
    required this.id,
    required this.itemName,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl,
    required this.reportType,
    required this.status,
    required this.userId,
    this.user,
    this.category,
  });

  // --- PENERJEMAH JSON (PENTING) ---
  // Ini menerjemahkan JSON dari API (Laravel) ke objek Report
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      // Pastikan key di sini (spt. 'item_name') SAMA PERSIS
      // dengan key di respon JSON API Anda
      id: json['id'] as int,
      itemName: json['item_name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['report_date'] as String), // Sesuaikan key
      imageUrl: json['image_url'] as String?, // Sesuaikan key
      reportType: json['report_type'] as String,
      status: json['status'] as String,
      userId: json['user_id'] as int,

      // Mengambil data relasi jika ada
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  // --- Helper untuk mengubah List JSON menjadi List<Report> ---
  static List<Report> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Report.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
