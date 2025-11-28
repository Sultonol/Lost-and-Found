import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/data/models/claim_model.dart';
import 'package:lost_and_found/app/modules/notifications/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller
    Get.put(NotificationsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Permintaan Klaim"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.incomingClaims.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  "Belum ada permintaan klaim.",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.incomingClaims.length,
          itemBuilder: (context, index) {
            final claim = controller.incomingClaims[index];
            return _buildClaimCard(context, claim);
          },
        );
      }),
    );
  }

  Widget _buildClaimCard(BuildContext context, Claim claim) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // --- HEADER: INFO CLAIMER (Orang yg minta) ---
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue[100],
              backgroundImage: claim.claimer?.avatarUrl != null
                  ? NetworkImage(claim.claimer!.avatarUrl!)
                  : null,
              child: claim.claimer?.avatarUrl == null
                  ? const Icon(Icons.person, color: Colors.blue)
                  : null,
            ),
            title: Text(
              claim.claimer?.name ?? "Pengguna",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              "Ingin mengklaim barang temuan Anda",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),

          const Divider(height: 1),

          // --- BODY: INFO BARANG ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Barang
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: (claim.item?.imageUrl != null)
                        ? CachedNetworkImage(
                            imageUrl: claim.item!.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                // Teks Detail Barang
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        claim.item?.itemName ?? "Barang Tidak Dikenal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              claim.item?.location ?? "-",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Tombol Lihat Detail Barang (Kecil)
                      InkWell(
                        onTap: () => controller.viewItemDetail(claim),
                        child: const Text(
                          "Lihat Detail Barang >",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- FOOTER: TOMBOL AKSI ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Tombol TOLAK
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.processClaim(claim.id, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Tolak"),
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol TERIMA
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.processClaim(claim.id, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text("Terima"),
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
