import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'tenant_dashboard_screen.dart';
import 'tenant_invoice_screen.dart';
import 'tenant_request_screen.dart';
import 'tenant_profile_screen.dart';

class TenantMainScreen extends StatefulWidget {
  const TenantMainScreen({Key? key})
    : super(key: key);

  @override
  State<TenantMainScreen> createState() =>
      _TenantMainScreenState();
}

class _TenantMainScreenState
    extends State<TenantMainScreen> {
  int _selectedIndex = 0;

  // Tạm thời để các Text rỗng, bước sau mình sẽ nhét Dashboard Cư Dân vào đây
  final List<Widget> _screens = [
    const TenantDashboardScreen(), // << ĐÃ THAY MÀN HÌNH DASHBOARD VÀO ĐÂY
    /*const Center(
      child: Text(
        'Dashboard Cư dân (Đang xây dựng)',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    ),*/
    const TenantInvoiceScreen(), // << ĐÃ THAY TAB HÓA ĐƠN VÀO ĐÂY
    /*const Center(
      child: Text(
        'Hóa đơn Cư dân',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    ),*/
    const TenantRequestScreen(), // << ĐÃ THAY TAB YÊU CẦU VÀO ĐÂY
    /*const Center(
      child: Text(
        'Yêu cầu Sửa chữa',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    ),*/
    const TenantProfileScreen(), // << ĐÃ THAY TAB CÁ NHÂN VÀO ĐÂY
    /*const Center(
      child: Text(
        'Tài khoản Cư dân',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    ),*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.cardBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor:
            AppColors.textSecondary,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt_long_outlined,
            ),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Hóa đơn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Yêu cầu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cá Nhân',
          ),
        ],
      ),
    );
  }
}
