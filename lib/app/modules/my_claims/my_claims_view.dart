import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/data/models/claim_model.dart';
import 'package:lost_and_found/app/modules/chat/chat_view.dart';
import 'package:lost_and_found/app/modules/my_claims/my_claims_controller.dart';

class MyClaimsView extends StatelessWidget {
  const MyClaimsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyClaimsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Status Klaim Saya")),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());

        if (controller.myClaims.isEmpty) {
          return const Center(child: Text("Belum ada klaim yang diajukan"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.myClaims.length,
          itemBuilder: (context, index) {
            final claim = controller.myClaims[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    title: Text(claim.item?.itemName ?? "Barang"),
                    subtitle: Text(
                      "Penemu: ${claim.finder?.name ?? 'Seseorang'}",
                    ),
                    trailing: _buildStatusBadge(claim.status),
                  ),

                  // TOMBOL CHAT HANYA MUNCUL JIKA APPROVED
                  if (claim.status == 'approved')
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              Get.to(() => const ChatView(), arguments: claim),
                          icon: const Icon(Icons.chat_bubble),
                          label: const Text("Chat Penemu"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  if (claim.status == 'rejected')
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Klaim ditolak oleh penemu.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'approved':
        color = Colors.green;
        text = "DITERIMA";
        break;
      case 'rejected':
        color = Colors.red;
        text = "DITOLAK";
        break;
      default:
        color = Colors.orange;
        text = "MENUNGGU";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
