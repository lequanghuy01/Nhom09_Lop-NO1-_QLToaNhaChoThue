import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class TenantDashboardScreen
    extends StatelessWidget {
  const TenantDashboardScreen({Key? key})
    : super(key: key);

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
              // --- 1. HEADER (LỜI CHÀO & AVATAR) ---
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Row(
                    children: [
                      // Avatar ảo
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors
                                .primaryBlue,
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/150?img=11',
                            ),
                            fit: BoxFit.cover,
                          ),
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
                              fontSize: 13,
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
                  // Nút chuông thông báo có chấm đỏ
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons
                              .notifications_none,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 10,
                          height: 10,
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
                ],
              ),
              const SizedBox(height: 24),

              // --- 2. THÔNG TIN PHÒNG ĐANG THUÊ ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
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
                                horizontal: 10,
                                vertical: 4,
                              ),
                          decoration: BoxDecoration(
                            color: AppColors
                                .successGreen
                                .withOpacity(
                                  0.15,
                                ),
                            borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                          ),
                          child: const Text(
                            'Đang thuê',
                            style: TextStyle(
                              color: AppColors
                                  .successGreen,
                              fontSize: 11,
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
                                  12,
                                ),
                          ),
                          child: const Icon(
                            Icons.meeting_room,
                            color: AppColors
                                .primaryBlue,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Phòng P.101',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons
                              .location_on_outlined,
                          color: AppColors
                              .textSecondary,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Tòa nhà Phenikaa',
                          style: TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors
                                  .inputBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Xem chi tiết hợp đồng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- 3. KHỐI HÓA ĐƠN CHỜ THANH TOÁN (MÀU XANH NỔI BẬT) ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400,
                      AppColors.primaryBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue
                          .withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: const [
                        Text(
                          'Tổng hóa đơn chờ thanh toán',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        Icon(
                          Icons
                              .account_balance_wallet_outlined,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: const [
                        Text(
                          '2.540.000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        Padding(
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
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(
                              8,
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
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                          elevation: 0,
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
                ),
              ),
              const SizedBox(height: 32),

              // --- 4. CHỈ SỐ THÁNG NÀY (ĐIỆN & NƯỚC) ---
              Row(
                children: const [
                  Icon(
                    Icons.insert_chart_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
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
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'ĐIỆN',
                      '1,245',
                      'kWh',
                      Icons.bolt,
                      Colors.orangeAccent,
                      '+12% so với tháng trước',
                      AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      'NƯỚC',
                      '48',
                      'm³',
                      Icons.water_drop_outlined,
                      Colors.lightBlueAccent,
                      '— Không đổi',
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- 5. DỊCH VỤ & TIỆN ÍCH ---
              Row(
                children: const [
                  Icon(
                    Icons.grid_view_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
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
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildServiceButton(
                    'Yêu cầu sửa chữa',
                    Icons.build_circle_outlined,
                    Colors.redAccent,
                  ),
                  // Chỗ này tôi đổi "Xem hợp đồng" thành "Lịch sử nộp tiền" cho đỡ lặp với nút ở trên
                  _buildServiceButton(
                    'Lịch sử nộp tiền',
                    Icons.receipt_long_outlined,
                    Colors.blueAccent,
                  ),
                  _buildServiceButton(
                    'Ban quản lý',
                    Icons.support_agent,
                    Colors.indigoAccent,
                    subText: '0912.345.678',
                  ),
                  _buildServiceButton(
                    'Đăng ký gửi xe',
                    Icons
                        .directions_car_filled_outlined,
                    AppColors.successGreen,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Khối vẽ Chỉ số Điện/Nước
  Widget _buildMetricCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color iconColor,
    String trend,
    Color trendColor,
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
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
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
            trend,
            style: TextStyle(
              color: trendColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Khối vẽ Nút Dịch vụ Tiện ích
  Widget _buildServiceButton(
    String title,
    IconData icon,
    Color color, {
    String? subText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(
                      0.15,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subText != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                          top: 4,
                        ),
                    child: Text(
                      subText,
                      style: const TextStyle(
                        color:
                            AppColors.primaryBlue,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
