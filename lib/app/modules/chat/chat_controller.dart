// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lost_and_found/app/data/models/claim_model.dart';
// import 'package:lost_and_found/app/theme/app_theme.dart';

// class ChatController extends GetxController {
//   final Rx<Claim> claim = (Get.arguments as Claim).obs;
//   late TextEditingController messageC;

//   // Mock ID pengguna
//   // TODO: Ganti dengan ID pengguna asli
//   // Kita buat skenario:
//   // myUserId = user-abc (Pengklaim)
//   // myUserId = user-xyz (Penemu)
//   final String myUserId = "user-abc";

//   // Data dummy pesan
//   final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[
//     {
//       'id': 'msg-2',
//       'text': 'Dompetnya warna apa ya? Dan isinya apa aja?',
//       'senderId': 'user-xyz', // Penemu
//     },
//     {
//       'id': 'msg-1',
//       'text': 'Halo, saya rasa itu dompet saya yang hilang.',
//       'senderId': 'user-abc', // Pengklaim
//     },
//   ].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     messageC = TextEditingController();
//   }

//   @override
//   void onClose() {
//     messageC.dispose();
//     super.onClose();
//   }

//   void sendMessage() {
//     if (messageC.text.trim().isEmpty) return;

//     // TODO: Kirim pesan ke API/Socket

//     // Tambahkan ke list (simulasi)
//     final newMessage = {
//       'id': 'msg-${messages.length + 1}',
//       'text': messageC.text.trim(),
//       'senderId': myUserId,
//     };

//     // Insert di awal list agar tampil di bawah
//     messages.insert(0, newMessage);

//     messageC.clear();
//   }

//   // Logika untuk menampilkan tombol Setuju/Tolak
//   Widget buildActionButtons() {
//     // Cek: Apakah SAYA adalah PENEMU barang?
//     bool isReportOwner = claim.value.reportOwnerId == myUserId;
//     // Cek: Apakah status klaim masih 'pending'?
//     bool isPending = claim.value.status == 'pending';

//     if (isReportOwner && isPending) {
//       return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () => rejectClaim(),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.red,
//                     side: const BorderSide(color: Colors.red),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: const Text("Tolak Klaim"),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () => approveClaim(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                   child: const Text("Setujui Pengembalian"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // Jika bukan penemu, atau status sudah tidak pending
//     return const SizedBox.shrink();
//   }

//   void approveClaim() {
//     // TODO: Panggil API
//     print("Menyetujui klaim...");
//     Get.snackbar(
//       "Berhasil",
//       "Klaim telah disetujui",
//       backgroundColor: Colors.green,
//     );

//     // Update status lokal
//     claim.update((val) {
//       // val.status = 'approved'; // Seharusnya dari API
//     });
//     // TODO: Refresh MyClaims list
//     // Get.find<MyClaimsController>().fetchMyClaims();
//   }

//   void rejectClaim() {
//     // TODO: Panggil API
//     print("Menolak klaim...");
//     Get.snackbar(
//       "Berhasil",
//       "Klaim telah ditolak",
//       backgroundColor: Colors.red,
//     );

//     // Update status lokal
//     claim.update((val) {
//       // val.status = 'rejected'; // Seharusnya dari API
//     });
//     // TODO: Refresh MyClaims list
//     // Get.find<MyClaimsController>().fetchMyClaims();
//   }
// }
