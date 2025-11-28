// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lost_and_found/app/modules/my_claims/my_claims_controller.dart';
// import 'package:lost_and_found/app/routes/app_pages.dart';

// class MyClaimsView extends GetView<MyClaimsController> {
//   const MyClaimsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Proses Klaim Saya')),
//       body: Obx(() {
//         if (controller.claims.isEmpty) {
//           return const Center(child: Text("Anda belum memiliki proses klaim."));
//         }
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.claims.length,
//           itemBuilder: (context, index) {
//             final claim = controller.claims[index];
//             return Card(
//               margin: const EdgeInsets.only(bottom: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: ListTile(
//                 onTap: () => Get.toNamed(Routes.CHAT, arguments: claim),
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: CachedNetworkImage(
//                     imageUrl: claim.reportItemImage,
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 title: Text(
//                   claim.reportItemName,
//                   style: Get.textTheme.titleMedium,
//                 ),
//                 subtitle: Text(
//                   "Status: ${claim.status.capitalizeFirst}",
//                   style: TextStyle(
//                     color: controller.getStatusColor(claim.status),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 trailing: const Icon(Icons.chevron_right_rounded),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
