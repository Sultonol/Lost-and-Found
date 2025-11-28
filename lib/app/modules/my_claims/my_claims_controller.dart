// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lost_and_found/app/data/models/claim_model.dart';

// class MyClaimsController extends GetxController {
//   final RxList<Claim> claims = <Claim>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMyClaims();
//   }

//   void fetchMyClaims() {
//     // TODO: Ganti dengan API call

//     // Data dummy
//     var dummyClaims = [
//       Claim(
//         id: 'claim-1',
//         reportId: '3',
//         reportOwnerId: 'user-xyz',
//         claimerId: 'user-abc', // Ini adalah "saya"
//         status: 'pending',
//         reportItemName: 'Dompet Coklat',
//         reportItemImage: 'https://placehold.co/400x400/png?text=Dompet',
//       ),
//       Claim(
//         id: 'claim-2',
//         reportId: '4',
//         reportOwnerId: 'user-abc', // Ini adalah "saya"
//         claimerId: 'user-jkl',
//         status: 'approved',
//         reportItemName: 'Charger Laptop',
//         reportItemImage: 'https://placehold.co/400x400/png?text=Charger',
//       ),
//     ];

//     claims.assignAll(dummyClaims);
//   }

//   Color getStatusColor(String status) {
//     switch (status) {
//       case 'pending':
//         return Colors.orange.shade700;
//       case 'approved':
//         return Colors.green.shade700;
//       case 'rejected':
//         return Colors.red.shade700;
//       default:
//         return Colors.grey;
//     }
//   }
// }
