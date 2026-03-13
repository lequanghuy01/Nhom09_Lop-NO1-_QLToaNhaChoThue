import 'dart:io';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'edit_building_info_screen.dart';

class BuildingInfoScreen extends StatefulWidget {
  const BuildingInfoScreen({Key? key})
    : super(key: key);

  @override
  State<BuildingInfoScreen> createState() =>
      _BuildingInfoScreenState();
}

class _BuildingInfoScreenState
    extends State<BuildingInfoScreen> {
  final SetupData appData = SetupData();

  @override
  Widget build(BuildContext context) {
    int totalFloors = appData.floors.length;
    int totalRooms = appData.totalRooms;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // --- HEADER: ẢNH BÌA & APP BAR ---
          SliverAppBar(
            backgroundColor: AppColors.background,
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () =>
                  Navigator.pop(context),
            ),
            // Trả lại title cho AppBar như thiết kế gốc
            title: const Text(
              'Thông tin tòa nhà',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () async {
                  bool?
                  isUpdated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const EditBuildingInfoScreen(),
                    ),
                  );
                  if (isUpdated == true) {
                    setState(() {});
                  }
                },
                child: const Text(
                  'Chỉnh sửa',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background:
                  appData.buildingCoverImgPath !=
                      null
                  ? Image.file(
                      File(
                        appData
                            .buildingCoverImgPath!,
                      ),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.blueGrey,
                      child: const Icon(
                        Icons.business,
                        size: 60,
                        color: Colors.white24,
                      ),
                    ),
            ),
          ),

          // --- PHẦN NỘI DUNG CHÍNH ---
          SliverToBoxAdapter(
            child: Padding(
              // Bỏ Transform.translate, dùng Padding chuẩn để tách bạch 2 khối
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // --- 1. KHỐI THÔNG TIN TÒA NHÀ CƠ BẢN ---
                  Container(
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .cardBackground,
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          appData.buildingName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Icon(
                              Icons
                                  .location_on_outlined,
                              color: AppColors
                                  .primaryBlue,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                appData.address,
                                style: const TextStyle(
                                  color: AppColors
                                      .textSecondary,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        // ĐÃ XÓA MỤC CƯ DÂN - CHIA ĐỀU KHÔNG GIAN CHO 2 CỘT
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                          decoration: BoxDecoration(
                            color: AppColors
                                .inputBackground,
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceEvenly,
                            children: [
                              _buildStatColumn(
                                totalRooms
                                    .toString(),
                                'PHÒNG',
                              ),
                              _buildStatDivider(),
                              _buildStatColumn(
                                totalFloors
                                    .toString(),
                                'TẦNG',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 2. THÔNG TIN VẬN HÀNH ---
                  const Text(
                    'THÔNG TIN VẬN HÀNH',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .cardBackground,
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Ngày khánh thành',
                          appData
                              .inaugurationDate,
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
                        _buildInfoRow(
                          'Tổng diện tích',
                          appData.totalArea,
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
                        _buildInfoRow(
                          'Loại hình',
                          appData.buildingType,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 3. TIỆN ÍCH CHUNG ---
                  const Text(
                    'TIỆN ÍCH CHUNG',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .cardBackground,
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: appData
                          .buildingAmenities
                          .map(
                            (
                              amenity,
                            ) => _buildAmenityChip(
                              amenity['name'],
                              amenity['icon'],
                              Color(
                                amenity['color'],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 4. LIÊN HỆ BAN QUẢN LÝ ---
                  const Text(
                    'LIÊN HỆ BAN QUẢN LÝ',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .cardBackground,
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(
                                    10,
                                  ),
                              decoration: BoxDecoration(
                                color: AppColors
                                    .primaryBlue
                                    .withOpacity(
                                      0.15,
                                    ),
                                shape: BoxShape
                                    .circle,
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: AppColors
                                    .primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  'Số Hotline (SĐT TK)',
                                  style: TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  appData.hotline,
                                  style: const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(
                                    10,
                                  ),
                              decoration: BoxDecoration(
                                color: AppColors
                                    .primaryBlue
                                    .withOpacity(
                                      0.15,
                                    ),
                                shape: BoxShape
                                    .circle,
                              ),
                              child: const Icon(
                                Icons
                                    .email_outlined,
                                color: AppColors
                                    .primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  'Email hỗ trợ (Email TK)',
                                  style: TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  appData
                                      .supportEmail,
                                  style: const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 5. MÔ TẢ ---
                  const Text(
                    'MÔ TẢ',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .cardBackground,
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                    child: Text(
                      appData.buildingDescription,
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Khối vẽ cột số liệu
  Widget _buildStatColumn(
    String value,
    String label,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: AppColors.borderColor,
    );
  }

  // Dòng thông tin Vận hành
  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Chip Tiện ích
  Widget _buildAmenityChip(
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
