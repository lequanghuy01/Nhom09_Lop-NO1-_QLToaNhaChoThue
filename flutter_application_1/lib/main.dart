import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import màn hình đăng nhập

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Tòa Nhà',
      debugShowCheckedModeBanner:
          false, // Ẩn dải ruy-băng "DEBUG" ở góc phải màn hình
      theme: ThemeData(
        // Cấu hình theme cơ bản, màu sắc chi tiết chúng ta đã dùng AppColors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      // Đặt LoginScreen làm màn hình đầu tiên xuất hiện khi mở app
      home: const LoginScreen(),
    );
  }
}
