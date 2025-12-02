import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/modules/home/home_controller.dart';
import 'package:lost_and_found/app/modules/home/widgets/hilang_tab_view.dart';
import 'package:lost_and_found/app/modules/home/widgets/ditemukan_tab_view.dart';
import 'package:lost_and_found/app/modules/notifications/notifications_view.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isLoading.value && controller.tabController == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Lost & Found'),
          actions: [
            // --- 1. KEY NOTIFIKASI DIPASANG DI SINI ---
            Stack(
              key: controller.notifKey, // <--- Key Notifikasi
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Get.to(() => const NotificationsView());
                  },
                ),
                if (controller.notificationCount.value > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${controller.notificationCount.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),

            // --- 2. ICON PROFILE ---
            IconButton(
              icon: const Icon(Icons.person_outline_rounded),
              onPressed: () => Get.toNamed(Routes.PROFILE),
            ),
          ],
          bottom: controller.tabController != null
              ? TabBar(
                  // --- 3. KEY TAB BAR DIPASANG DI SINI ---
                  key: controller.tabKey, // <--- Key Tab Bar
                  controller: controller.tabController,
                  tabs: const [
                    Tab(text: 'Barang Hilang'),
                    Tab(text: 'Barang Ditemukan'),
                  ],
                )
              : null,
        ),
        body: controller.tabController != null
            ? TabBarView(
                controller: controller.tabController,
                children: const [HilangTabView(), DitemukanTabView()],
              )
            : const Center(child: CircularProgressIndicator()),

        floatingActionButton: FloatingActionButton(
          // --- 4. KEY FAB DIPASANG DI SINI ---
          key: controller.fabKey, // <--- Key Tombol Tambah
          onPressed: () => Get.toNamed(Routes.ADD_REPORT),
          child: const Icon(Icons.add_rounded),
        ),
      );
    });
  }
}
