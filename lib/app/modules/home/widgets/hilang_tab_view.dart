import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/modules/home/home_controller.dart';
import 'package:lost_and_found/app/modules/home/widgets/report_item_card.dart';

class HilangTabView extends GetView<HomeController> {
  const HilangTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchReports(),
        child: controller.lostItems.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    alignment: Alignment.center,
                    child: const Text("Belum ada laporan barang hilang."),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.lostItems.length,
                itemBuilder: (context, index) {
                  final report = controller.lostItems[index];
                  return ReportItemCard(report: report);
                },
              ),
      );
    });
  }
}
