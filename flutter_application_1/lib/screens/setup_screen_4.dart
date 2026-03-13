import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'main_screen.dart';

class SetupScreen4 extends StatelessWidget {
  final SetupData setupData;
  const SetupScreen4({
    Key? key,
    required this.setupData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đếm tổng số phòng thực tế bạn đã tạo ở Màn 2
    int totalRooms = setupData.floors.fold(
      0,
      (sum, floor) => sum + floor.rooms.length,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kiểm tra & Hoàn tất',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // HOÀN TẤT VÀ ĐẨY VÀO DASHBOARD
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MainScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons
                            .check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Hoàn tất thiết lập',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        AppColors.inputBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                  ),
                  child: const Text(
                    'Quay lại chỉnh sửa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Xác nhận thông tin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionCard(
              title: 'THÔNG TIN CHUNG',
              icon: Icons.business,
              children: [
                _buildInfoRow(
                  'Tên tòa nhà',
                  setupData.buildingName,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  'Địa chỉ',
                  setupData.address,
                ),
              ],
            ),

            _buildSectionCard(
              title: 'CẤU TRÚC',
              icon: Icons.layers,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSquareStat(
                        'Tổng số tầng',
                        setupData.aboveFloors
                            .toString(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSquareStat(
                        'Tổng số phòng',
                        totalRooms.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            _buildSectionCard(
              title: 'DỊCH VỤ ĐỊNH KỲ',
              icon: Icons.receipt_long,
              children: setupData.services
                  .map(
                    (s) => _buildServiceRow(
                      s.icon,
                      s.name,
                      '${s.price} ${s.unit}',
                    ),
                  )
                  .toList(),
            ),

            _buildSectionCard(
              title: 'TỔNG HỢP GIÁ PHÒNG',
              icon: Icons.meeting_room,
              children: [
                // Quét dữ liệu phòng để vẽ
                for (var floor
                    in setupData.floors)
                  for (var room in floor.rooms)
                    Column(
                      children: [
                        _buildRoomSample(
                          room.name,
                          '${room.area.isNotEmpty ? room.area : '--'}m² • ${room.type}',
                          // Logic kiểm tra giá riêng hay giá mặc định
                          room
                                  .customPrice
                                  .isNotEmpty
                              ? '${room.customPrice}đ'
                              : '${setupData.defaultPrice}đ (Mặc định)',
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                          child: Divider(
                            color: AppColors
                                .borderColor,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                if (totalRooms == 0)
                  const Text(
                    'Chưa tạo phòng nào.',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                color: AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildSquareStat(
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(
    IconData icon,
    String name,
    String price,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomSample(
    String name,
    String desc,
    String price,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        Text(
          price,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
