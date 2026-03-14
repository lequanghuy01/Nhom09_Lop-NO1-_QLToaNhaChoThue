import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'contract_list_screen.dart'; // <--- IMPORT MÀN HÌNH QUẢN LÝ HỢP ĐỒNG VÀO ĐÂY
import 'apartment_screen.dart'; // Import màn hình Căn hộ
import 'resident_screen.dart'; // Import màn hình Cư dân
import 'utility_record_screen.dart'; // Import màn hình Ghi điện nước
/*import 'create_invoice_screen.dart'; // Import màn hình Tạo hóa đơn*/
import 'invoice_list_screen.dart';
import 'fee_management_screen.dart'; // Import màn hình Quản lý thu phí
import 'send_notification_screen.dart'; //Trỏ tới form gửi thông báo
import 'maintenance_screen.dart'; // Import màn hình Bảo trì
import 'building_info_screen.dart'; // Import Thông tin tòa nhà
import 'price_service_screen.dart'; // Import màn hình Giá Dịch vụ (View)
import 'report_statistic_screen.dart'; // import màn hình báo cáo thống kê

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- THANH TÌM KIẾM ---
            TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm tính năng...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor:
                    AppColors.inputBackground,
                contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- NHÓM: CHO THUÊ ---
            _buildSectionTitle('CHO THUÊ'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons
                        .description_outlined,
                    title: 'Quản lý hợp đồng',
                    iconColor:
                        AppColors.primaryBlue,
                    onTap: () {
                      // LỆNH CHUYỂN TRANG NẰM Ở ĐÂY NÈ SẾP!
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ContractListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons
                        .meeting_room_outlined,
                    title: 'Quản lý thuê phòng',
                    iconColor:
                        AppColors.primaryBlue,
                    onTap: () {
                      // Trỏ về màn hình Căn hộ
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ApartmentScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title:
                        'Quản lý thông tin khách thuê',
                    iconColor:
                        AppColors.primaryBlue,
                    onTap: () {
                      // Trỏ về màn hình Cư dân
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ResidentScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- NHÓM: TÀI CHÍNH ---
            _buildSectionTitle('TÀI CHÍNH'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.bolt,
                    title: 'Ghi chỉ số Điện/Nước',
                    iconColor:
                        AppColors.successGreen,
                    onTap: () {
                      // Chuyển sang màn hình Ghi Điện Nước
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const UtilityRecordScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons
                        .receipt_long_outlined,
                    title: 'Hóa đơn',
                    iconColor:
                        AppColors.successGreen,
                    onTap: () {
                      // Chuyển sang màn hình Quản lý Danh sách Hóa đơn
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InvoiceListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons
                        .account_balance_wallet_outlined,
                    title: 'Quản lý thu phí',
                    iconColor:
                        AppColors.successGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FeeManagementScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- NHÓM: VẬN HÀNH ---
            _buildSectionTitle('VẬN HÀNH'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.campaign_outlined,
                    title:
                        'Gửi thông báo & tin tức',
                    iconColor:
                        AppColors.warningOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SendNotificationScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.build_outlined,
                    title: 'Tạo yêu cầu sửa chữa',
                    iconColor:
                        AppColors.warningOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MaintenanceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- NHÓM: HỆ THỐNG & TIỆN ÍCH ---
            _buildSectionTitle(
              'HỆ THỐNG & TIỆN ÍCH',
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.business,
                    title: 'Thông tin tòa nhà',
                    iconColor: Colors.pinkAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BuildingInfoScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title:
                        'Thiết lập giá & dịch vụ',
                    iconColor: Colors.pinkAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PriceServiceScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons
                        .directions_car_outlined,
                    title:
                        'Đăng ký & Tra cứu phương tiện',
                    iconColor: Colors.pinkAccent,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- NHÓM: QUẢN TRỊ & DỮ LIỆU ---
            _buildSectionTitle(
              'QUẢN TRỊ & DỮ LIỆU',
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  /*_buildMenuItem(
                    icon: Icons
                        .admin_panel_settings_outlined,
                    title:
                        'Phân quyền người dùng',
                    iconColor:
                        AppColors.textSecondary,
                    onTap: () {},
                  ),*/
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.bar_chart,
                    title: 'Báo cáo & Thống kê',
                    iconColor:
                        AppColors.textSecondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ReportStatisticScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- CÁC HÀM VẼ GIAO DIỆN PHỤ ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        left: 4,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 60,
      ), // Lùi vạch kẻ vào một chút cho đẹp
      child: Divider(
        color: AppColors.borderColor,
        height: 1,
      ),
    );
  }
}
