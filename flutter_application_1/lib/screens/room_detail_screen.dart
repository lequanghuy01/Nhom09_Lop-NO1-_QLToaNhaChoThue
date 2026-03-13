import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // <--- ĐÃ IMPORT THƯ VIỆN NÉT ĐỨT
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'tenant_detail_screen.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomModel room;
  final String floorName;

  const RoomDetailScreen({
    Key? key,
    required this.room,
    required this.floorName,
  }) : super(key: key);

  @override
  State<RoomDetailScreen> createState() =>
      _RoomDetailScreenState();
}

class _RoomDetailScreenState
    extends State<RoomDetailScreen> {
  final SetupData appData = SetupData();
  Map<String, dynamic>? currentResident;

  @override
  void initState() {
    super.initState();
    _checkResident();
  }

  void _checkResident() {
    try {
      String normalizedOriginalRoom = widget
          .room
          .name
          .replaceAll(' ', '')
          .toLowerCase();
      currentResident = appData.residents
          .firstWhere((res) {
            String resRoom = (res['room'] ?? '')
                .toString()
                .replaceAll(' ', '')
                .toLowerCase();
            return resRoom.contains(
                  normalizedOriginalRoom,
                ) ||
                normalizedOriginalRoom.contains(
                  resRoom,
                );
          });
    } catch (e) {
      currentResident = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayPrice =
        widget.room.customPrice.isNotEmpty
        ? widget.room.customPrice
        : appData.defaultPrice;

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
        title: Text(
          'Chi tiết ${widget.room.name}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- KHỐI TẢI ẢNH (ĐÃ DÙNG DOTTED BORDER) ---
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tính năng tải ảnh từ thư viện sẽ được phát triển sau.',
                    ),
                  ),
                );
              },
              child: DottedBorder(
                color: AppColors.borderColor
                    .withOpacity(
                      0.8,
                    ), // Màu viền nét đứt
                strokeWidth: 1.5, // Độ dày nét
                dashPattern: const [
                  8,
                  4,
                ], // Chiều dài nét đứt 8px, khoảng trống 4px
                borderType: BorderType.RRect,
                radius: const Radius.circular(
                  16,
                ), // Bo góc 16
                padding: EdgeInsets
                    .zero, // Bỏ padding thừa
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors
                        .cardBackground
                        .withOpacity(0.4),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons
                            .add_a_photo_outlined,
                        size: 40,
                        color: AppColors
                            .textSecondary
                            .withOpacity(0.7),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tải ảnh thực tế phòng lên',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary
                              .withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- KHỐI 1: TRẠNG THÁI & BẢO TRÌ ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(
                                  8,
                                ),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .warningOrange
                                  .withOpacity(
                                    0.15,
                                  ),
                              borderRadius:
                                  BorderRadius.circular(
                                    8,
                                  ),
                            ),
                            child: const Icon(
                              Icons
                                  .build_outlined,
                              color: AppColors
                                  .warningOrange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            'Đánh dấu Bảo trì',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: widget
                            .room
                            .isUnderMaintenance,
                        activeColor: AppColors
                            .warningOrange,
                        onChanged: (value) {
                          setState(() {
                            widget
                                    .room
                                    .isUnderMaintenance =
                                value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (widget
                      .room
                      .isUnderMaintenance) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Phòng đang ở trạng thái bảo trì. Thẻ phòng ngoài danh sách sẽ hiển thị màu cam.',
                      style: TextStyle(
                        color: AppColors
                            .warningOrange,
                        fontSize: 12,
                        fontStyle:
                            FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- KHỐI 2: THÔNG SỐ CĂN HỘ ---
            const Text(
              'THÔNG SỐ CĂN HỘ',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    'Tầng',
                    widget.floorName,
                  ),
                  const Divider(
                    color: AppColors.borderColor,
                    height: 24,
                  ),
                  _buildInfoRow(
                    'Loại phòng',
                    widget.room.type,
                  ),
                  const Divider(
                    color: AppColors.borderColor,
                    height: 24,
                  ),
                  _buildInfoRow(
                    'Diện tích',
                    '${widget.room.area.isNotEmpty ? widget.room.area : '--'} m²',
                  ),
                  const Divider(
                    color: AppColors.borderColor,
                    height: 24,
                  ),
                  _buildInfoRow(
                    'Nội thất',
                    widget.room.note.isNotEmpty
                        ? widget.room.note
                        : 'Cơ bản',
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
                      const Text(
                        'Giá thuê định mức',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$displayPrice đ/tháng',
                        style: const TextStyle(
                          color: AppColors
                              .primaryBlue,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- KHỐI 3: TRẠNG THÁI CƯ DÂN ---
            const Text(
              'TÌNH TRẠNG LƯU TRÚ',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            currentResident == null
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .inputBackground,
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                      border: Border.all(
                        color: AppColors
                            .primaryBlue
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons
                              .door_front_door_outlined,
                          color: AppColors
                              .primaryBlue,
                          size: 40,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Phòng đang trống',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sẵn sàng đón khách mới',
                          style: TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TenantDetailScreen(
                                residentData:
                                    currentResident!,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.all(
                            16,
                          ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .cardBackground,
                        borderRadius:
                            BorderRadius.circular(
                              16,
                            ),
                        border: Border.all(
                          color: AppColors
                              .successGreen
                              .withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(
                                  12,
                                ),
                            decoration:
                                BoxDecoration(
                                  color: AppColors
                                      .successGreen
                                      .withOpacity(
                                        0.15,
                                      ),
                                  shape: BoxShape
                                      .circle,
                                ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors
                                  .successGreen,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  'Đang cho thuê',
                                  style: TextStyle(
                                    color: AppColors
                                        .successGreen,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  currentResident!['name'],
                                  style: const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'SĐT: ${currentResident!['phone']}',
                                  style: const TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors
                                .textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
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
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
