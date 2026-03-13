import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class EditRoomPriceScreen extends StatefulWidget {
  const EditRoomPriceScreen({Key? key})
    : super(key: key);

  @override
  State<EditRoomPriceScreen> createState() =>
      _EditRoomPriceScreenState();
}

class _EditRoomPriceScreenState
    extends State<EditRoomPriceScreen> {
  final SetupData appData = SetupData();
  final Map<String, TextEditingController>
  _roomControllers = {};

  @override
  void initState() {
    super.initState();
    // Khởi tạo các ô nhập cho từng phòng
    for (var floor in appData.floors) {
      for (var room in floor.rooms) {
        _roomControllers[room.name] =
            TextEditingController(
              text: room.customPrice,
            );
      }
    }
  }

  void _saveAllAndFinish() {
    // Lưu lại giá trị mới vào Kho dữ liệu
    for (var floor in appData.floors) {
      for (var room in floor.rooms) {
        room.customPrice =
            _roomControllers[room.name]?.text
                .trim() ??
            '';
      }
    }

    // Bắn thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã cập nhật Bảng giá thành công!',
        ),
      ),
    );

    // Đóng 2 màn hình (Edit Phòng + Edit Dịch vụ) để về lại màn hình View
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
          'Thiết lập',
          style: TextStyle(
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
            const Text(
              'Tùy chỉnh Giá theo Phòng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nhập giá riêng cho từng phòng nếu khác giá mặc định.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Lặp qua từng Tầng
            ...appData.floors.map((floor) {
              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.layers,
                        color:
                            AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        floor.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Lặp qua từng Phòng trong Tầng
                  ...floor.rooms.map((room) {
                    return Container(
                      margin:
                          const EdgeInsets.only(
                            bottom: 12,
                          ),
                      padding:
                          const EdgeInsets.all(
                            12,
                          ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .cardBackground,
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  room.name,
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
                                  height: 4,
                                ),
                                Text(
                                  room
                                          .area
                                          .isEmpty
                                      ? 'Trống'
                                      : room.area,
                                  style: const TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextField(
                              controller:
                                  _roomControllers[room
                                      .name],
                              keyboardType:
                                  TextInputType
                                      .number,
                              style:
                                  const TextStyle(
                                    color: Colors
                                        .white,
                                  ),
                              textAlign:
                                  TextAlign.right,
                              decoration: InputDecoration(
                                hintText:
                                    'Mặc định',
                                hintStyle: const TextStyle(
                                  color: AppColors
                                      .textSecondary,
                                ),
                                filled: true,
                                fillColor: AppColors
                                    .inputBackground,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        8,
                                      ),
                                  borderSide:
                                      BorderSide
                                          .none,
                                ),
                                suffixText: 'đ',
                                suffixStyle:
                                    const TextStyle(
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                      horizontal:
                                          16,
                                      vertical:
                                          12,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _saveAllAndFinish,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
          ),
          child: const Text(
            'Lưu thay đổi ✓',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
