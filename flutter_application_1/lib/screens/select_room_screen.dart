import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart'; // Nối với Kho Dữ Liệu

class SelectRoomScreen extends StatefulWidget {
  const SelectRoomScreen({Key? key})
    : super(key: key);

  @override
  State<SelectRoomScreen> createState() =>
      _SelectRoomScreenState();
}

class _SelectRoomScreenState
    extends State<SelectRoomScreen> {
  final SetupData appData = SetupData();
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  // --- HÀM KIỂM TRA PHÒNG ĐÃ CÓ NGƯỜI Ở CHƯA ---
  bool _isRoomOccupied(String roomName) {
    try {
      String normalizedOriginalRoom = roomName
          .replaceAll(' ', '')
          .toLowerCase();

      // Tìm xem có cư dân nào đang khớp với phòng này không
      appData.residents.firstWhere((res) {
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

      // Nếu không bị lỗi (tức là tìm thấy người) -> Trả về true (Đã có người ở)
      return true;
    } catch (e) {
      // Nếu lỗi (không tìm thấy ai) -> Trả về false (Phòng trống)
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. TẠO BỘ LỌC TẦNG
    List<String> filterOptions = ['Tất cả'];
    filterOptions.addAll(
      appData.floors.map((f) => f.name),
    );

    // 2. TRẢI PHẲNG & LOẠI BỎ PHÒNG ĐÃ CÓ NGƯỜI Ở
    List<Map<String, dynamic>> availableRooms =
        [];
    for (var floor in appData.floors) {
      for (var room in floor.rooms) {
        // LOGIC MỚI: Chỉ thêm vào danh sách CHỌN PHÒNG nếu phòng đó KHÔNG CÓ NGƯỜI Ở
        if (!_isRoomOccupied(room.name)) {
          availableRooms.add({
            'room': room,
            'floorName': floor.name,
          });
        }
      }
    }

    // 3. LỌC THEO TÌM KIẾM VÀ TẦNG ĐANG CHỌN
    List<Map<String, dynamic>> filteredRooms =
        availableRooms.where((data) {
          RoomModel room = data['room'];
          String floorName = data['floorName'];

          bool matchesSearch = room.name
              .toLowerCase()
              .contains(
                _searchQuery.toLowerCase(),
              );
          bool matchesFilter =
              _selectedFilter == 'Tất cả' ||
              _selectedFilter == floorName;

          return matchesSearch && matchesFilter;
        }).toList();

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
          'Chọn phòng trống',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- THANH TÌM KIẾM ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                setState(
                  () => _searchQuery = value,
                );
              },
              decoration: InputDecoration(
                hintText: 'Tìm số phòng...',
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
          ),

          // --- BỘ LỌC TẦNG ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: filterOptions.map((
                filter,
              ) {
                bool isSelected =
                    _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(
                      () => _selectedFilter =
                          filter,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 12,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.background,
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
                      filter,
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

          // --- DANH SÁCH PHÒNG ---
          Expanded(
            child: filteredRooms.isEmpty
                ? const Center(
                    child: Text(
                      'Không còn phòng trống phù hợp',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                    itemCount:
                        filteredRooms.length,
                    itemBuilder: (context, index) {
                      RoomModel room =
                          filteredRooms[index]['room'];
                      String floorName =
                          filteredRooms[index]['floorName'];

                      return _buildRoomCard(
                        room,
                        floorName,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- UI THẺ PHÒNG ---
  Widget _buildRoomCard(
    RoomModel room,
    String floorName,
  ) {
    String roomNumber = room.name.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    if (roomNumber.isEmpty) roomNumber = 'P';

    String displayPrice =
        room.customPrice.isNotEmpty
        ? room.customPrice
        : appData.defaultPrice;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context, room.name);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors
                            .inputBackground,
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        roomNumber,
                        style: const TextStyle(
                          color: AppColors
                              .primaryBlue,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          room.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$floorName • ${room.area.isNotEmpty ? room.area : '--'}m²',
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
                    color: AppColors.primaryBlue
                        .withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'TRỐNG',
                    style: TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Divider(
                color: AppColors.borderColor,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nội thất',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.note.isNotEmpty
                            ? room.note
                            : 'Cơ bản',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Giá thuê',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '$displayPriceđ',
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),
                          const TextSpan(
                            text: '/th',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
