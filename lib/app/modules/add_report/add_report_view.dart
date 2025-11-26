import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/app/modules/add_report/add_report_controller.dart';

class AddReportView extends GetView<AddReportController> {
  const AddReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Tipe Laporan
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.reportType.value,
                  decoration: const InputDecoration(
                    labelText: 'Tipe Laporan',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'hilang',
                      child: Text("Saya Kehilangan Barang"),
                    ),
                    DropdownMenuItem(
                      value: 'ditemukan',
                      child: Text("Saya Menemukan Barang"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.reportType.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 2. Nama Barang
              TextFormField(
                controller: controller.itemNameC,
                decoration: const InputDecoration(
                  hintText: "Nama Barang",
                  labelText: "Nama Barang",
                  prefixIcon: Icon(Icons.label_important_outline),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama barang tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // 3. Kategori (DINAMIS DARI API)
              Obx(() {
                if (controller.categories.isEmpty &&
                    controller.isLoading.value) {
                  return const Center(child: Text("Mengambil kategori..."));
                }
                return DropdownButtonFormField<int>(
                  value: controller.selectedCategoryId.value,
                  hint: const Text("Pilih Kategori"),
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.bookmark_border_rounded),
                  ),
                  items: controller.categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedCategoryId.value = value;
                  },
                  validator: (value) =>
                      value == null ? "Kategori harus dipilih" : null,
                );
              }),
              const SizedBox(height: 16),

              // 4. Lokasi
              TextFormField(
                controller: controller.locationC,
                decoration: const InputDecoration(
                  hintText: "Lokasi Terakhir / Ditemukan",
                  labelText: "Lokasi",
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Lokasi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // 5. Tanggal & Waktu
              TextFormField(
                controller: controller.dateC,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: "Tanggal & Waktu",
                  labelText: "Tanggal & Waktu",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                onTap: () => controller.selectDateTime(context),
                validator: (value) =>
                    value!.isEmpty ? "Tanggal tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // 6. Deskripsi
              TextFormField(
                controller: controller.descriptionC,
                decoration: const InputDecoration(
                  hintText: "Deskripsi (Ciri-ciri, dll)",
                  labelText: "Deskripsi",
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 24),

              // 7. Upload Foto
              Text("Upload Foto", style: Get.textTheme.titleMedium),
              const SizedBox(height: 8),
              Obx(
                () => AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!),
                      image: controller.imageFile.value != null
                          ? DecorationImage(
                              image: FileImage(controller.imageFile.value!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: InkWell(
                      onTap: () => controller.pickImage(),
                      child: controller.imageFile.value == null
                          ? const Center(
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey,
                                size: 50,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 8. Tombol Submit (Dengan Loading)
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null // Nonaktifkan tombol saat loading
                      : () => controller.submitReport(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Submit Laporan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
