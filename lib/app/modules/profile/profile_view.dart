import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/modules/profile/profile_controller.dart';
import 'package:lost_and_found/app/modules/my_claims/my_claims_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profil Saya"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        final user = controller.currentUser.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // --- 1. FOTO PROFIL & NAMA ---
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue[100],
                      // Jika ada avatarUrl tampilkan gambar, jika tidak tampilkan inisial
                      backgroundImage:
                          (user?.avatarUrl != null &&
                              user!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(user!.avatarUrl!)
                          : null,
                      child:
                          (user?.avatarUrl == null || user!.avatarUrl!.isEmpty)
                          ? Text(
                              (user?.name ?? "U")[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? "Pengguna",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? "-",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 1),

              // --- 2. MENU OPTIONS ---

              // Opsi A: Edit Profil (Hanya placeholder visual)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: const Text("Edit Profil"),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  Get.snackbar("Info", "Fitur Edit Profil akan segera hadir");
                },
              ),

              // Opsi B: STATUS KLAIM SAYA (INI JAWABAN PERTANYAANMU)
              // Di sini tempat Claimer mengecek status dan chat Finder
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.history_edu, color: Colors.orange),
                ),
                title: const Text("Status Klaim Saya"),
                subtitle: const Text("Cek klaim yang Anda ajukan"),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  // Navigasi ke halaman MyClaimsView
                  Get.to(() => const MyClaimsView());
                },
              ),

              // Opsi C: Laporan Saya (Barang yang saya posting) - Opsional
              // Jika kamu punya fitur "MyReports", bisa ditaruh sini juga.
              const Divider(),

              // Opsi D: LOGOUT
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => controller.logout(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
