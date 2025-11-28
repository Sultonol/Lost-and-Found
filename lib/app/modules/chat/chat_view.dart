// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lost_and_found/app/modules/chat/chat_controller.dart';
// import 'package:lost_and_found/app/theme/app_theme.dart';

// class ChatView extends GetView<ChatController> {
//   const ChatView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat Klaim: ${controller.claim.value.reportItemName}"),
//       ),
//       body: Column(
//         children: [
//           // Daftar Pesan
//           Expanded(
//             child: Obx(
//               () => ListView.builder(
//                 reverse: true, // Pesan baru di bawah
//                 padding: const EdgeInsets.all(16),
//                 itemCount: controller.messages.length,
//                 itemBuilder: (context, index) {
//                   final message = controller.messages[index];
//                   final isMyMessage =
//                       message['senderId'] == controller.myUserId;

//                   return Align(
//                     alignment: isMyMessage
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 16,
//                       ),
//                       margin: const EdgeInsets.only(bottom: 8),
//                       decoration: BoxDecoration(
//                         color: isMyMessage
//                             ? AppTheme.primaryColor
//                             : Colors.white,
//                         borderRadius: BorderRadius.circular(16).copyWith(
//                           bottomRight: isMyMessage
//                               ? const Radius.circular(4)
//                               : const Radius.circular(16),
//                           bottomLeft: isMyMessage
//                               ? const Radius.circular(16)
//                               : const Radius.circular(4),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 5,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         message['text'],
//                         style: TextStyle(
//                           color: isMyMessage ? Colors.white : Colors.black87,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           // Input Pesan
//           _buildMessageInput(),
//         ],
//       ),
//       // Tombol Aksi untuk Penemu
//       bottomNavigationBar: Obx(() => controller.buildActionButtons()),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: controller.messageC,
//                 decoration: InputDecoration(
//                   hintText: "Ketik pesan verifikasi...",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: const BorderSide(color: AppTheme.primaryColor),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             CircleAvatar(
//               radius: 24,
//               backgroundColor: AppTheme.primaryColor,
//               child: IconButton(
//                 icon: const Icon(Icons.send_rounded, color: Colors.white),
//                 onPressed: () => controller.sendMessage(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
