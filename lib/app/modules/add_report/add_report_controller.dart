import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found/app/data/models/category_model.dart';
import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/providers/api_provider.dart';
import 'package:lost_and_found/app/modules/home/home_controller.dart';
import 'package:lost_and_found/app/routes/app_pages.dart';

class AddReportController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ApiProvider apiProvider = Get.find<ApiProvider>();
  // Gunakan try-catch saat mencari HomeController untuk mencegah crash jika testing terisolasi
  HomeController? get homeController {
    try {
      return Get.find<HomeController>();
    } catch (_) {
      return null;
    }
  }

  late TextEditingController itemNameC, locationC, descriptionC, dateC;

  var isLoading = false.obs;
  final RxString reportType = 'hilang'.obs;
  final Rxn<int> selectedCategoryId = Rxn<int>();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<File> imageFile = Rxn<File>();
  final RxList<Category> categories = <Category>[].obs;

  final ImagePicker _picker = ImagePicker();

  var isEditMode = false.obs;
  final Rxn<Report> existingReport = Rxn<Report>();

  @override
  void onInit() {
    super.onInit();
    itemNameC = TextEditingController();
    locationC = TextEditingController();
    descriptionC = TextEditingController();
    dateC = TextEditingController();

    if (Get.arguments != null && Get.arguments is Report) {
      isEditMode.value = true;
      existingReport.value = Get.arguments as Report;
      _prefillForm(existingReport.value!);
    }

    fetchCategories();
  }

  void _prefillForm(Report report) {
    itemNameC.text = report.itemName;
    locationC.text = report.location;
    descriptionC.text = report.description;
    dateC.text = DateFormat('d MMMM yyyy, HH:mm').format(report.date);
    selectedDate.value = report.date;
    reportType.value = report.reportType;
    selectedCategoryId.value = report.category?.id;
  }

  @override
  void onClose() {
    itemNameC.dispose();
    locationC.dispose();
    descriptionC.dispose();
    dateC.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    if (!isEditMode.value) isLoading(true);
    var result = await apiProvider.getCategories();
    categories.assignAll(result);
    isLoading(false);
  }

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          selectedDate.value ?? DateTime.now(),
        ),
      );

      if (time != null) {
        selectedDate.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        dateC.text = DateFormat(
          'd MMMM yyyy, HH:mm',
        ).format(selectedDate.value!);
      }
    }
  }

  Future<void> pickImage() async {
    Get.defaultDialog(
      title: "Pilih Sumber Gambar",
      content: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text("Galeri"),
            onTap: () {
              _getImage(ImageSource.gallery);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text("Kamera"),
            onTap: () {
              _getImage(ImageSource.camera);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1080,
    );
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  void submitReport() async {
    // 1. Validasi Input
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        "Peringatan",
        "Mohon lengkapi data formulir",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedCategoryId.value == null) {
      Get.snackbar(
        "Peringatan",
        "Kategori harus dipilih",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (imageFile.value == null && !isEditMode.value) {
      Get.snackbar(
        "Peringatan",
        "Foto barang wajib diisi",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading(true);

    try {
      final formData = FormData({
        'item_name': itemNameC.text,
        'description': descriptionC.text,
        'location': locationC.text,
        'report_type': reportType.value,
        'category_id': selectedCategoryId.value.toString(),
        'report_date': selectedDate.value!.toIso8601String(),
      });

      if (imageFile.value != null) {
        formData.files.add(
          MapEntry(
            'image',
            MultipartFile(
              imageFile.value!,
              filename: imageFile.value!.path.split('/').last,
            ),
          ),
        );
      }

      bool success;
      if (isEditMode.value) {
        success = await apiProvider.updateReport(
          existingReport.value!.id,
          formData,
        );
      } else {
        success = await apiProvider.createReport(formData);
      }

      isLoading(false);

      if (success) {
        Get.snackbar(
          "Sukses",
          "${isEditMode.value ? 'Laporan diperbarui' : 'Laporan berhasil dibuat'}!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (homeController != null) {
          // Refresh data terlebih dahulu
          await homeController!.refreshAndSetTab(reportType.value);
          // Tutup halaman add report dan kembali ke Home
          Get.offNamed(Routes.HOME);
        } else {
          Get.back();
        }
      }
      // Jika gagal, user tetap di halaman ini untuk memperbaiki data
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteReport() async {
    Get.defaultDialog(
      title: "Hapus Laporan",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      middleText:
          "Apakah Anda yakin ingin menghapus laporan ini? Tindakan ini tidak dapat dibatalkan.",
      onConfirm: () async {
        Get.back(); // Tutup dialog

        isLoading(true);
        try {
          bool success = await apiProvider.deleteReport(
            existingReport.value!.id,
          );

          isLoading(false);

          if (success) {
            // Refresh data dan navigate ke home dengan tab yang sesuai
            if (homeController != null) {
              await homeController!.refreshAndSetTab(reportType.value);
              Get.offNamed(Routes.HOME);
            } else {
              Get.back();
            }
          }
        } catch (e) {
          isLoading(false);
          Get.snackbar(
            "Error",
            "Terjadi kesalahan: ${e.toString()}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onCancel: () {
        Get.back(); // Tutup dialog tanpa hapus
      },
      confirmTextColor: Colors.white,
      textCancel: "Tidak",
      textConfirm: "Ya",
      buttonColor: Colors.red,
      cancelTextColor: Colors.black,
    );
  }
}
