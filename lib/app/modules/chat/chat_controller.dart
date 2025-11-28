import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_and_found/app/data/models/claim_model.dart';
import 'package:lost_and_found/app/data/models/message_model.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';

class ChatController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final messageC = TextEditingController();
  final scrollC = ScrollController();
  final GetStorage box = GetStorage();

  late Claim claim;
  var messages = <Message>[].obs;
  var isLoading = true.obs;
  var myUserId = 0;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    // 1. Ambil Data Claim dari halaman sebelumnya
    if (Get.arguments is Claim) {
      claim = Get.arguments;
    } else {
      Get.back();
      Get.snackbar("Error", "Data chat tidak ditemukan");
    }

    // 2. Ambil ID Saya (untuk membedakan chat kanan/kiri)
    final userJson = box.read('user');
    if (userJson != null) {
      myUserId = User.fromJson(userJson).id;
    }

    fetchMessages();

    // 3. Auto Refresh Chat setiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => fetchMessages());
  }

  @override
  void onClose() {
    _timer?.cancel(); // Matikan timer saat keluar agar tidak error
    messageC.dispose();
    scrollC.dispose();
    super.onClose();
  }

  void fetchMessages() async {
    var newMessages = await apiProvider.getMessages(claim.id);

    // Update UI hanya jika jumlah pesan bertambah (ada pesan baru)
    if (newMessages.length != messages.length) {
      messages.assignAll(newMessages);
      isLoading(false);
      scrollToBottom();
    } else {
      isLoading(false);
    }
  }

  void scrollToBottom() {
    if (scrollC.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollC.animateTo(
          scrollC.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void sendMessage() async {
    if (messageC.text.trim().isEmpty) return;

    String content = messageC.text;
    messageC.clear(); // Bersihkan input text field

    bool success = await apiProvider.sendMessage(claim.id, content);
    if (success) {
      fetchMessages(); // Refresh chat langsung
    } else {
      Get.snackbar(
        "Gagal",
        "Pesan tidak terkirim",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
