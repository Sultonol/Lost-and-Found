import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found/app/data/api_constants.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';

class ReportItemCard extends StatelessWidget {
  final Report report;
  const ReportItemCard({super.key, required this.report});

  // --- LOGIKA WARNA (REVISI AESTHETIC) ---
  Color _getStatusColor(String status) {
    if (status == 'closed') {
      return Colors.red[800]!; // Merah Bata (Closed)
    } else if (status == 'claimed') {
      // GANTI JADI TEAL (Hijau Kebiruan)
      // Ini lebih "masuk" dengan tema biru daripada oranye/kuning
      return Colors.teal[700]!;
    } else if (status == 'resolved') {
      return Colors.grey[700]!;
    }
    return Colors.blue[700]!; // Biru (Tersedia)
  }

  // --- LOGIKA TEKS ---
  String _getStatusText(String status) {
    if (status == 'closed') {
      return "Closed";
    } else if (status == 'claimed') {
      return "Claimed";
    } else if (status == 'resolved') {
      return "Resolved";
    }
    return "Tersedia";
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(
        Icons.broken_image_rounded,
        color: Colors.grey[400],
        size: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // --- LOGIKA KLIK & NOTIFIKASI ---
        onTap: () {
          if (report.status == 'closed') {
            Get.snackbar(
              "Laporan Ditutup",
              "Barang ini sudah selesai dan tidak tersedia lagi.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: _getStatusColor('closed'),
              colorText: Colors.white,
              margin: const EdgeInsets.all(15),
              borderRadius: 10,
              icon: const Icon(Icons.lock_outline, color: Colors.white),
              duration: const Duration(seconds: 2),
            );
          } else if (report.status == 'claimed') {
            Get.snackbar(
              "Proses Klaim",
              "Barang ini sedang dalam proses pengambilan/verifikasi.",
              snackPosition: SnackPosition.TOP,
              // Gunakan warna statusnya (Teal) agar konsisten
              backgroundColor: _getStatusColor('claimed'),
              colorText: Colors.white,
              margin: const EdgeInsets.all(15),
              borderRadius: 10,
              icon: const Icon(Icons.history_edu, color: Colors.white),
              duration: const Duration(seconds: 2),
            );
          } else {
            Get.toNamed(Routes.ITEM_DETAIL, arguments: report);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN GAMBAR & STATUS ---
            Stack(
              children: [
                (report.imageUrl != null && report.imageUrl!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: ApiConstants.fixImageUrl(report.imageUrl),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),

                // --- BADGE STATUS ---
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      // Opacity 0.95 agar sedikit transparan tapi teks tetap jelas
                      color: _getStatusColor(report.status).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _getStatusText(report.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- BAGIAN INFO ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.itemName,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          report.category?.name ?? report.location,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('d MMM yyyy').format(report.date),
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
