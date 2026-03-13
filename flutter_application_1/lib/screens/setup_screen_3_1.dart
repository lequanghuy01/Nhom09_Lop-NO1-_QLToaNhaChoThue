import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart'; // Import Balo

class SetupScreen31 extends StatefulWidget {
  final SetupData setupData;
  const SetupScreen31({
    Key? key,
    required this.setupData,
  }) : super(key: key);

  @override
  State<SetupScreen31> createState() =>
      _SetupScreen31State();
}

class _SetupScreen31State
    extends State<SetupScreen31> {
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
          'Tùy chỉnh giá',
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
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Đã lưu giá tùy chỉnh thành công!',
                    ),
                  ),
                );
                Navigator.pop(
                  context,
                ); // Dữ liệu đã lưu thẳng vào reference của balo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lưu thay đổi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
              'Tùy chỉnh Giá theo Phòng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nhập giá riêng cho từng phòng nếu khác giá mặc định. Để trống nếu dùng giá mặc định.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Lặp qua các tầng và phòng trong Balo để render
            ...widget.setupData.floors
                .map(
                  (floor) =>
                      _buildDynamicFloorSection(
                        floor,
                      ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFloorSection(
    FloorModel floor,
  ) {
    // Nếu tầng không có phòng nào thì ẩn đi cho gọn
    if (floor.rooms.isEmpty)
      return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24.0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.layers,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                floor.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...floor.rooms
              .map(
                (room) =>
                    _buildDynamicRoomPriceRow(
                      room,
                    ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDynamicRoomPriceRow(
    RoomModel room,
  ) {
    // Tạo 1 controller tạm để quản lý UI ô nhập liệu
    TextEditingController priceCtrl =
        TextEditingController(
          text: room.customPrice,
        );
    priceCtrl.addListener(
      () => room.customPrice = priceCtrl.text,
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                  decoration: BoxDecoration(
                    color:
                        AppColors.inputBackground,
                    borderRadius:
                        BorderRadius.circular(4),
                  ),
                  child: Text(
                    room.area.isNotEmpty
                        ? '${room.area}m²'
                        : '--',
                    style: const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: priceCtrl,
                    keyboardType:
                        TextInputType.number,
                    style: TextStyle(
                      color:
                          room
                              .customPrice
                              .isNotEmpty
                          ? Colors.white
                          : AppColors
                                .textSecondary,
                      fontWeight:
                          room
                              .customPrice
                              .isNotEmpty
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onChanged: (val) => setState(
                      () {},
                    ), // Refresh để đổi màu chữ và dòng text
                    decoration: InputDecoration(
                      hintText: 'Giá mặc định',
                      hintStyle: const TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                      suffixText: 'đ',
                      suffixStyle:
                          const TextStyle(
                            color: AppColors
                                .textSecondary,
                          ),
                      filled: true,
                      fillColor: AppColors
                          .inputBackground,
                      contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                      enabledBorder:
                          OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                            borderSide:
                                const BorderSide(
                                  color: AppColors
                                      .borderColor,
                                ),
                          ),
                      focusedBorder:
                          OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  8,
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
                if (room.customPrice.isEmpty) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Sử dụng giá mặc định',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
