import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  // 2. UBAH MENJADI ASYNC
  // 3. TAMBAHKAN DUA BARIS INI UNTUK INISIALISASI
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Lost & Found Kampus",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Jika Anda ingin mendukung mode gelap
      // themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL, // Rute awal (kita akan atur ke splash)
      getPages: AppPages.routes, // Daftar semua halaman
    );
  }
}
