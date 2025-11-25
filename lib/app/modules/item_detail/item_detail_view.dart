import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found/app/modules/item_detail/item_detail_controller.dart';
import 'package:lost_and_found/app/theme/app_theme.dart';

class ItemDetailView extends GetView<ItemDetailController> {
  const ItemDetailView({super.key});

  // 1. Tambahkan widget helper ini (sama seperti di Card)
  Widget _buildImagePlaceholder() {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(
        Icons.broken_image_rounded,
        color: Colors.grey[400],
        size: 80,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obx diperlukan di sini agar Obx di bottomNavigationBar
    // bisa mendeteksi controller dengan benar
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text(controller.report.value.itemName)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. PERBAIKI BLOK GAMBAR INI
              (controller.report.value.imageUrl != null &&
                      controller.report.value.imageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: controller.report.value.imageUrl!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(), // Tampilkan jika null
              // Detail
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.report.value.itemName,
                      style: Get.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    // 3. PERBAIKI PANGGILAN KATEGORI INI
                    _buildDetailRow(
                      Icons.category_outlined,
                      "Kategori",
                      // Ubah dari .category menjadi .category?.name
                      controller.report.value.category?.name ??
                          "Tidak Ada Kategori",
                    ),
                    _buildDetailRow(
                      Icons.location_on_outlined,
                      controller.report.value.reportType == 'hilang'
                          ? "Lokasi Terakhir"
                          : "Lokasi Ditemukan",
                      controller.report.value.location,
                    ),
                    _buildDetailRow(
                      Icons.calendar_today_outlined,
                      controller.report.value.reportType == 'hilang'
                          ? "Tanggal Hilang"
                          : "Tanggal Ditemukan",
                      // Format tanggal sudah benar (menghasilkan String)
                      DateFormat(
                        'd MMMM yyyy, HH:mm',
                      ).format(controller.report.value.date),
                    ),
                    const Divider(height: 32),
                    Text("Deskripsi", style: Get.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      controller.report.value.description,
                      style: Get.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tombol Aksi mengambang di bawah
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(20),
        //   // Obx untuk menampilkan tombol berdasarkan kondisi
        //   child: Obx(() => controller.buildActionButton()),
        // ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            // 4. Tambahkan Expanded agar teks tidak overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Get.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
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
