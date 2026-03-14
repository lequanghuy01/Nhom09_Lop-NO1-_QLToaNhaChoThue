import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class TenantDashboardScreen
    extends StatefulWidget {
  const TenantDashboardScreen({Key? key})
    : super(key: key);

  @override
  State<TenantDashboardScreen> createState() =>
      _TenantDashboardScreenState();
}

class _TenantDashboardScreenState
    extends State<TenantDashboardScreen> {
  // --- BỘ CÔNG TẮC GIẢ LẬP DỮ LIỆU (MOCK STATE) ---
  // Giả lập: Đã gán phòng P.101, nhưng tháng này CHƯA có hóa đơn và CHƯA chốt điện nước
  bool isAssignedRoom = true;
  bool hasPendingInvoice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER CHÀO MỪNG ---
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors
                            .cardBackground,
                        child: Icon(
                          Icons.person,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: const [
                          Text(
                            'Xin chào,',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Nguyễn Văn An',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- 2. THÔNG TIN PHÒNG ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                          decoration: BoxDecoration(
                            color: isAssignedRoom
                                ? AppColors
                                      .successGreen
                                      .withOpacity(
                                        0.2,
                                      )
                                : Colors.orange
                                      .withOpacity(
                                        0.2,
                                      ),
                            borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                          ),
                          child: Text(
                            isAssignedRoom
                                ? 'Đang thuê'
                                : 'Chờ xếp phòng',
                            style: TextStyle(
                              color:
                                  isAssignedRoom
                                  ? AppColors
                                        .successGreen
                                  : Colors.orange,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.all(
                                8,
                              ),
                          decoration: BoxDecoration(
                            color: AppColors
                                .primaryBlue
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                          ),
                          child: const Icon(
                            Icons.door_front_door,
                            color: AppColors
                                .primaryBlue,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isAssignedRoom
                          ? 'Phòng P.101'
                          : 'Chưa có thông tin phòng',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          color: AppColors
                              .textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAssignedRoom
                              ? 'Tòa nhà Phenikaa'
                              : 'Vui lòng liên hệ Ban quản lý',
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (isAssignedRoom) ...[
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors
                                    .background,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                          ),
                          child: const Text(
                            'Xem chi tiết hợp đồng',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- 3. TỔNG HÓA ĐƠN CHỜ THANH TOÁN ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF0033CC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          'Tổng hóa đơn chờ thanh toán',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const Icon(
                          Icons
                              .account_balance_wallet_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          (isAssignedRoom &&
                                  hasPendingInvoice)
                              ? '2.540.000'
                              : '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(
                                bottom: 6,
                                left: 8,
                              ),
                          child: Text(
                            'VNĐ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (isAssignedRoom &&
                        hasPendingInvoice)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Hạn chót: 05/04/2026',
                              style: TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                        ),
                        child: const Text(
                          'Tháng này bạn không có nợ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    if (isAssignedRoom &&
                        hasPendingInvoice) ...[
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                          ),
                          child: const Text(
                            'Thanh toán ngay',
                            style: TextStyle(
                              color: AppColors
                                  .primaryBlue,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- 4. CHỈ SỐ THÁNG NÀY (Để giá trị 0 vì chưa chốt) ---
              Row(
                children: [
                  const Icon(
                    Icons.bar_chart,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Chỉ số tháng này',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: isAssignedRoom
                    ? 1.0
                    : 0.5,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        Icons.bolt,
                        Colors.orangeAccent,
                        'ĐIỆN',
                        '0',
                        'kWh',
                        'Chưa chốt số',
                        AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        Icons.water_drop_outlined,
                        Colors.lightBlueAccent,
                        'NƯỚC',
                        '0',
                        'm³',
                        'Chưa chốt số',
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- 5. DỊCH VỤ & TIỆN ÍCH (Đầy đủ 4 nút) ---
              Row(
                children: [
                  const Icon(
                    Icons.grid_view,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Dịch vụ & Tiện ích',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: isAssignedRoom
                    ? 1.0
                    : 0.5,
                child: IgnorePointer(
                  ignoring: !isAssignedRoom,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        1.0, // Chỉnh tỷ lệ khung hình một chút để nhét vừa chữ
                    children: [
                      _buildServiceCard(
                        Icons.build_circle,
                        Colors.redAccent,
                        'Yêu cầu sửa chữa',
                        onTap: () {},
                      ),
                      _buildServiceCard(
                        Icons.description,
                        Colors.blueAccent,
                        'Xem hợp đồng',
                        onTap: () {},
                      ),
                      _buildServiceCard(
                        Icons.support_agent,
                        const Color(0xFF3F51B5),
                        'Ban quản lý',
                        subTitle: '028.1234.567',
                        onTap: () {},
                      ),
                      _buildServiceCard(
                        Icons.directions_car,
                        Colors.teal,
                        'Đăng ký gửi xe',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    IconData icon,
    Color iconColor,
    String title,
    String value,
    String unit,
    String subText,
    Color subColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subText,
            style: TextStyle(
              color: subColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo thẻ Dịch vụ đã được nâng cấp để hỗ trợ thêm chữ nhỏ (subTitle)
  Widget _buildServiceCard(
    IconData icon,
    Color color,
    String title, {
    String? subTitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Nếu có truyền vào subTitle thì hiển thị, không thì thôi
            if (subTitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subTitle,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
