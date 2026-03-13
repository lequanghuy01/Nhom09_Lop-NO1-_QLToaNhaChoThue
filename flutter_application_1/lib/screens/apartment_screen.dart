import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'room_detail_screen.dart'; // Import màn hình chi tiết phòng

class ApartmentScreen extends StatefulWidget {
  const ApartmentScreen({Key? key})
    : super(key: key);

  @override
  State<ApartmentScreen> createState() =>
      _ApartmentScreenState();
}

class _ApartmentScreenState
    extends State<ApartmentScreen> {
  final SetupData appData = SetupData();

  String _searchQuery = '';
  String _selectedStatus = 'Tất cả';

  final List<String> _statusFilters = [
    'Tất cả',
    'Phòng trống',
    'Đang ở',
    'Bảo trì',
    'Sắp hết hạn',
  ];

  // --- THUẬT TOÁN ĐỊNH DANH TRẠNG THÁI PHÒNG (VIP) ---
  Map<String, dynamic> _getRoomInfo(
    RoomModel room,
  ) {
    // 1. Ưu tiên cao nhất: Kiểm tra nút gạt Bảo trì
    if (room.isUnderMaintenance) {
      return {
        'status': 'Bảo trì',
        'subtitle': 'Đang sửa chữa',
        'color': AppColors.warningOrange,
      };
    }

    try {
      String normalizedOriginalRoom = room.name
          .replaceAll(' ', '')
          .toLowerCase();
      var resident = appData.residents.firstWhere(
        (res) {
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
        },
      );

      // 2. Kiểm tra "Sắp hết hạn": Nếu cư dân có badge cảnh báo (Tạm mô phỏng logic hợp đồng)
      if (resident['badge'] == 'SẮP HẾT HẠN') {
        return {
          'status': 'Sắp hết hạn',
          'subtitle': resident['name'],
          'color': Colors.orange,
        };
      }

      // 3. Bình thường: Đang ở
      return {
        'status': 'Đang ở',
        'subtitle': resident['name'],
        'color': AppColors.successGreen,
      };
    } catch (e) {
      // 4. Không có ai ở: Trống
      return {
        'status': 'Phòng trống',
        'subtitle': 'Sẵn sàng',
        'color': AppColors.primaryBlue,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) =>
                          setState(
                            () => _searchQuery =
                                value,
                          ),
                      decoration: InputDecoration(
                        hintText:
                            'Tìm số phòng...',
                        hintStyle:
                            const TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 14,
                            ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors
                              .textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors
                            .inputBackground,
                        contentPadding:
                            const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                          borderSide:
                              const BorderSide(
                                color: AppColors
                                    .borderColor,
                              ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                          borderSide:
                              const BorderSide(
                                color: AppColors
                                    .primaryBlue,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .inputBackground,
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                      border: Border.all(
                        color:
                            AppColors.borderColor,
                      ),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: _statusFilters.map((
                  status,
                ) {
                  bool isSelected =
                      _selectedStatus == status;
                  return GestureDetector(
                    onTap: () => setState(
                      () => _selectedStatus =
                          status,
                    ),
                    child: Container(
                      margin:
                          const EdgeInsets.only(
                            right: 12,
                          ),
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors
                                  .primaryBlue
                            : AppColors
                                  .background,
                        border: Border.all(
                          color: isSelected
                              ? AppColors
                                    .primaryBlue
                              : AppColors
                                    .borderColor,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors
                                    .textSecondary,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                itemCount: appData.floors.length,
                itemBuilder: (context, index) {
                  FloorModel floor =
                      appData.floors[index];
                  List<RoomModel> filteredRooms =
                      floor.rooms.where((room) {
                        bool matchesSearch = room
                            .name
                            .toLowerCase()
                            .contains(
                              _searchQuery
                                  .toLowerCase(),
                            );
                        var roomInfo =
                            _getRoomInfo(room);
                        bool matchesStatus =
                            _selectedStatus ==
                                'Tất cả' ||
                            roomInfo['status'] ==
                                _selectedStatus;
                        return matchesSearch &&
                            matchesStatus;
                      }).toList();

                  if (filteredRooms.isEmpty)
                    return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors
                                  .primaryBlue,
                              borderRadius:
                                  BorderRadius.circular(
                                    2,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            floor.name
                                .toUpperCase(),
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  letterSpacing:
                                      1.0,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing:
                                  12,
                              mainAxisSpacing: 12,
                              childAspectRatio:
                                  1.5,
                            ),
                        itemCount:
                            filteredRooms.length,
                        itemBuilder: (context, roomIndex) {
                          RoomModel room =
                              filteredRooms[roomIndex];
                          var info = _getRoomInfo(
                            room,
                          );

                          // TRUYỀN DỮ LIỆU SANG MÀN CHI TIẾT
                          return GestureDetector(
                            onTap: () async {
                              // Đợi màn hình Chi tiết đóng lại, sau đó tải lại giao diện để cập nhật màu sắc
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RoomDetailScreen(
                                        room:
                                            room,
                                        floorName:
                                            floor
                                                .name,
                                      ),
                                ),
                              );
                              setState(
                                () {},
                              ); // Refresh màn hình Căn hộ
                            },
                            child: _buildRoomCard(
                              room.name,
                              info['status'],
                              info['subtitle'],
                              info['color'],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(
    String roomName,
    String statusText,
    String subtitle,
    Color statusColor,
  ) {
    String displayStatus =
        statusText == 'Phòng trống'
        ? 'Trống'
        : statusText;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Text(
            displayStatus,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            roomName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
