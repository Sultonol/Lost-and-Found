import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';

class ReportItemCard extends StatelessWidget {
  final Report report;
  const ReportItemCard({super.key, required this.report});

  // Helper untuk warna status
  Color _getStatusColor(String status) {
    if (status == 'claimed' || status == 'resolved') {
      return Colors.green;
    } else if (status == 'pending') {
      return Colors.orange;
    }
    return Colors.blue; // open
  }

  // Helper untuk teks status
  String _getStatusText(String status) {
    if (status == 'claimed' || status == 'resolved') {
      return "Sudah Diklaim";
    } else if (status == 'pending') {
      return "Menunggu Konfirmasi";
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
        onTap: () {
          Get.toNamed(Routes.ITEM_DETAIL, arguments: report);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN GAMBAR & STATUS ---
            Stack(
              children: [
                (report.imageUrl != null && report.imageUrl!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: report.imageUrl!,
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

                // --- BADGE STATUS (BARU) ---
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(report.status).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(report.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
                    style: Get.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          report.category?.name ?? report.location,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('d MMMM yyyy').format(report.date),
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
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
