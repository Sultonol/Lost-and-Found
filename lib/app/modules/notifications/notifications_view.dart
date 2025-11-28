import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/data/models/claim_model.dart';
import 'package:lost_and_found/app/modules/notifications/notifications_controller.dart';
// Import Chat View
import 'package:lost_and_found/app/modules/chat/chat_view.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
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
    final hasAvatar =
        claim.claimer?.avatarUrl != null &&
        claim.claimer!.avatarUrl!.isNotEmpty;

    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // HEADER: Info Claimer
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue[100],
              backgroundImage: hasAvatar
                  ? NetworkImage(claim.claimer!.avatarUrl!)
                  : null,
              child: !hasAvatar
                  ? Text(
                      (claim.claimer?.name ?? "U")[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )
                  : null,
            ),
            title: Text(
              claim.claimer?.name ?? "Pengguna",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              claim.status == 'approved'
                  ? "Klaim disetujui. Silakan chat."
                  : "Ingin mengklaim barang temuan Anda",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),

          const Divider(height: 1),

          // BODY: Info Barang
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child:
                        (claim.item?.imageUrl != null &&
                            claim.item!.imageUrl!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: claim.item!.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        claim.item?.itemName ?? "Barang",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        claim.item?.location ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FOOTER: Tombol Aksi
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            // JIKA STATUS APPROVED, TAMPILKAN TOMBOL CHAT
            child: claim.status == 'approved'
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Masuk ke Chat Room
                        Get.to(() => const ChatView(), arguments: claim);
                      },
                      icon: const Icon(Icons.chat_bubble_rounded),
                      label: const Text("DISKUSI PENGAMBILAN"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  )
                // JIKA STATUS PENDING, TAMPILKAN TERIMA/TOLAK
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              controller.processClaim(claim.id, false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text("Tolak"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.processClaim(claim.id, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
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
