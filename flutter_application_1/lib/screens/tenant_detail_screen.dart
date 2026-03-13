import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart'; // Nối với Kho Dữ Liệu

class TenantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> residentData;

  const TenantDetailScreen({
    Key? key,
    required this.residentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.pop(context),
          ),
          title: const Text(
            'Chi tiết khách thuê',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),

        // --- NÚT KẾT THÚC HỢP ĐỒNG Ở ĐÁY ---
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Hiển thị Popup xác nhận
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: AppColors
                            .cardBackground,
                        title: const Text(
                          'Xác nhận trả phòng',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Bạn có chắc chắn muốn kết thúc hợp đồng với ${residentData['name']} không? Mọi dữ liệu của khách thuê này sẽ bị xóa.',
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(
                                  context,
                                ), // Đóng popup
                            child: const Text(
                              'Hủy',
                              style: TextStyle(
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors
                                      .redAccent,
                            ),
                            onPressed: () {
                              // 1. Gọi Kho dữ liệu ra
                              final appData =
                                  SetupData();

                              // 2. Xóa cư dân này khỏi mảng
                              appData.residents
                                  .remove(
                                    residentData,
                                  );

                              // 3. Giảm số phòng đang thuê xuống 1 (để Phòng trống tăng lên)
                              if (appData
                                      .occupiedRooms >
                                  0) {
                                appData
                                    .occupiedRooms--;
                              }

                              // 4. Đóng Popup
                              Navigator.pop(
                                context,
                              );

                              // 5. Đóng màn hình Chi tiết và báo về cho màn Danh sách là "Đã xóa (true)"
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            child: const Text(
                              'Xác nhận xóa',
                              style: TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                  size: 20,
                ),
                label: const Text(
                  'Kết thúc hợp đồng / Trả phòng',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.redAccent,
                  ),
                  backgroundColor: Colors
                      .redAccent
                      .withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),

        body: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 2,
                ),
                color: AppColors.inputBackground,
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              residentData['name'] ??
                  'Chưa cập nhật',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen
                        .withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          AppColors.successGreen,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors
                            .successGreen,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        residentData['status'] ??
                            'Đang ở',
                        style: const TextStyle(
                          color: AppColors
                              .successGreen,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '- ${residentData['room'] ?? ''}',
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Gọi nhanh',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryBlue,
                        padding:
                            const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Nhắn tin',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors
                            .cardBackground,
                        padding:
                            const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const TabBar(
              indicatorColor:
                  AppColors.primaryBlue,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor:
                  AppColors.textSecondary,
              tabs: [
                Tab(text: 'Thông tin cá nhân'),
                Tab(text: 'Hợp đồng'),
                Tab(text: 'Phương tiện'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabThongTinCaNhan(),
                  _buildTabHopDong(),
                  /*_buildTabPhuongTien(),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: THÔNG TIN CÁ NHÂN ---
  Widget _buildTabThongTinCaNhan() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildInfoCard([
          _buildInfoRow(
            'Số CCCD',
            residentData['cccd'] ??
                'Chưa cập nhật',
          ),
          _buildInfoRow(
            'Số điện thoại',
            residentData['phone'] ?? 'Chưa có',
          ),
          _buildInfoRow(
            'Email',
            residentData['email'] ??
                'Chưa cập nhật',
            isLast: true,
          ),
        ]),
        const SizedBox(height: 16),
        _buildInfoCard([
          _buildInfoRow(
            'Ngày sinh',
            residentData['dob'] ??
                'Chưa cập nhật',
          ),
          _buildInfoRow(
            'Giới tính',
            residentData['gender'] ??
                'Chưa cập nhật',
          ),
          _buildInfoRow(
            'Quê quán',
            residentData['address'] ??
                'Chưa cập nhật',
            isLast: true,
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildCCCDPlaceholder(
                  'Mặt trước',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCCCDPlaceholder(
                  'Mặt sau',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCCCDPlaceholder(String label) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderColor,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // --- TAB 2: HỢP ĐỒNG ---
  Widget _buildTabHopDong() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: const [
            Icon(
              Icons.radio_button_checked,
              color: AppColors.primaryBlue,
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              'Hợp đồng hiện tại',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              16,
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
                  Text(
                    residentData['room'] ??
                        'Chưa gán phòng',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .successGreen
                          .withOpacity(0.1),
                      border: Border.all(
                        color: AppColors
                            .successGreen,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                            4,
                          ),
                    ),
                    child: const Text(
                      'ĐANG HIỆU LỰC',
                      style: TextStyle(
                        color: AppColors
                            .successGreen,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Thời hạn: 01/01/2024 - 01/01/2025',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const Divider(
                color: AppColors.borderColor,
                height: 24,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Giá thuê',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '5.000.000đ',
                        style: TextStyle(
                          color: AppColors
                              .primaryBlue,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tiền cọc',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '10.000.000đ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 3: PHƯƠNG TIỆN ---
  /*Widget _buildTabPhuongTien() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildVehicleCard(
          'Xe máy',
          'Thẻ xe: VX-99210',
          '59-X1 123.45',
          'Honda Vision',
          'Đen',
          'HOẠT ĐỘNG',
          AppColors.successGreen,
          Icons.motorcycle,
        ),
      ],
    );
  }

  Widget _buildVehicleCard(
    String type,
    String subType,
    String plate,
    String brand,
    String color,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color:
                          AppColors.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        subType,
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(
                    0.1,
                  ),
                  border: Border.all(
                    color: statusColor,
                  ),
                  borderRadius:
                      BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: AppColors.borderColor,
            height: 24,
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BIỂN SỐ',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THƯƠNG HIỆU',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }*/
}
