import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'add_resident_screen.dart';
import 'notification_list_screen.dart'; // Màn hình Trung tâm thông báo
import 'utility_record_screen.dart'; // Màn hình Ghi điện nước
import 'create_invoice_screen.dart'; // Màn hình Tạo hóa đơn
import 'send_notification_screen.dart'; // Màn hình Gửi thông báo

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key})
    : super(key: key);

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  final SetupData appData = SetupData();

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Chào buổi sáng!';
    if (hour < 18) return 'Chào buổi chiều!';
    return 'Chào buổi tối!';
  }

  // Hàm xử lý khi bấm Thêm Cư Dân
  Future<void> _navigateToAddResident() async {
    final newResident = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddResidentScreen(),
      ),
    );

    if (newResident != null) {
      setState(() {
        appData.residents.insert(0, newResident);
        if (appData.totalRooms >
            appData.occupiedRooms) {
          appData.occupiedRooms++;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thêm cư dân thành công!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String emptyPercent = '0%';
    if (appData.totalRooms > 0) {
      emptyPercent =
          '${((appData.availableRooms / appData.totalRooms) * 100).toInt()}%';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // --- HEADER TÙY CHỈNH ---
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            appData.buildingName,
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),
                          const Icon(
                            Icons
                                .keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ĐÂY CHÍNH LÀ CÁI CHUÔNG THÔNG BÁO CỦA BẠN
                  GestureDetector(
                    onTap: () {
                      // Đã sửa đường dẫn trỏ về màn NotificationListScreen mới tạo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificationListScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        const Icon(
                          Icons
                              .notifications_none,
                          color: Colors.white,
                          size: 28,
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration:
                                const BoxDecoration(
                                  color: Colors
                                      .redAccent,
                                  shape: BoxShape
                                      .circle,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- THỐNG KÊ ---
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                children: [
                  _buildStatCard(
                    icon: Icons
                        .door_front_door_outlined,
                    iconColor:
                        AppColors.primaryBlue,
                    title: 'Phòng trống',
                    value:
                        '${appData.availableRooms}/${appData.totalRooms}',
                    topRightWidget: Text(
                      emptyPercent,
                      style: const TextStyle(
                        color: AppColors
                            .successGreen,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _buildStatCard(
                    icon: Icons.people_outline,
                    iconColor:
                        Colors.purpleAccent,
                    title: 'Cư dân',
                    value:
                        '${appData.residentCount}',
                  ),
                  _buildStatCard(
                    icon: Icons.payments_outlined,
                    iconColor:
                        AppColors.successGreen,
                    title: 'Doanh thu dự kiến',
                    value: '0đ',
                  ),
                  _buildStatCard(
                    icon: Icons.build_outlined,
                    iconColor:
                        AppColors.warningOrange,
                    title: 'Yêu cầu bảo trì',
                    value: 'Tất cả ổn',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- LỐI TẮT NHANH ---
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'Lối tắt nhanh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Tùy chỉnh',
                      style: TextStyle(
                        color:
                            AppColors.primaryBlue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  _buildQuickAction(
                    Icons.person_add_alt_1,
                    'Thêm\ncư dân',
                    AppColors.primaryBlue,
                    _navigateToAddResident,
                  ),
                  _buildQuickAction(
                    Icons.bolt,
                    'Ghi điện\nnước',
                    AppColors.textSecondary,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const UtilityRecordScreen(),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    Icons.receipt_long,
                    'Tạo\nhóa đơn',
                    AppColors.successGreen,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CreateInvoiceScreen(),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    Icons.campaign,
                    'Gửi\nthông báo',
                    Colors.purpleAccent,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SendNotificationScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- HOẠT ĐỘNG GẦN ĐÂY ---
              const Text(
                'Hoạt động gần đây',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 20,
                    ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                            16,
                          ),
                      decoration:
                          const BoxDecoration(
                            color: AppColors
                                .inputBackground,
                            shape:
                                BoxShape.circle,
                          ),
                      child: const Icon(
                        Icons.handshake_outlined,
                        color: AppColors
                            .textSecondary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chào mừng bạn!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Mọi thứ đã sẵn sàng. Hãy bắt đầu thêm cư dân đầu tiên vào tòa nhà của bạn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed:
                          _navigateToAddResident,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Thêm cư dân ngay',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    Widget? topRightWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              if (topRightWidget != null)
                topRightWidget,
            ],
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
