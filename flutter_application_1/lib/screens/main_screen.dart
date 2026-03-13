import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'dashboard_screen.dart';
import 'apartment_screen.dart';
import 'account_screen.dart';
import 'resident_screen.dart';
import 'menu_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Danh sách các màn hình tương ứng với từng Tab
  final List<Widget> _screens = [
    const DashboardScreen(), // Index 0: Tab Tổng quan
    const ApartmentScreen(), // Index 1: Tab Căn hộ
    const ResidentScreen(),
    const AccountScreen(), // Index 3: Tab Tài khoản
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body:
          _screens[_currentIndex], // Hiển thị màn hình theo Tab được chọn
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor:
              AppColors.cardBackground,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor:
              AppColors.primaryBlue,
          unselectedItemColor:
              AppColors.textSecondary,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Tổng quan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Căn hộ',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people_alt_outlined,
              ),
              label: 'Cư dân',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Tài khoản',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets_outlined),
              label: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}
