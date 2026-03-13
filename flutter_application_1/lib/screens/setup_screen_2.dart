import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'setup_screen_3.dart'; // Sẽ mở lại ở đợt sau

class SetupScreen2 extends StatefulWidget {
  final SetupData setupData; // Nhận Balo từ Màn 1
  const SetupScreen2({
    Key? key,
    required this.setupData,
  }) : super(key: key);

  @override
  State<SetupScreen2> createState() =>
      _SetupScreen2State();
}

class _SetupScreen2State
    extends State<SetupScreen2> {
  final List<String> roomTypes = [
    'Căn hộ 1 PN',
    'Căn hộ 2 PN',
    'Studio',
    'Phòng trọ',
  ];

  @override
  void initState() {
    super.initState();
    // LOGIC TỰ SINH TẦNG: Nếu balo chưa có tầng nào, tự đẻ ra theo Số tầng nổi Màn 1
    if (widget.setupData.floors.isEmpty) {
      for (
        int i = 0;
        i < widget.setupData.aboveFloors;
        i++
      ) {
        widget.setupData.floors.add(
          FloorModel(
            name: 'Tầng ${i + 1}',
            rooms: [],
          ),
        );
      }
    }
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
          'Cấu trúc tòa nhà',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Lưu nháp',
              style: TextStyle(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                    side: const BorderSide(
                      color:
                          AppColors.borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                  ),
                  child: const Text(
                    'Quay lại',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    // (Sẽ gắn chuyển sang Màn 3 ở đợt code sau)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SetupScreen3(
                              setupData: widget
                                  .setupData,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryBlue,
                    padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                  ),
                  child: const Text(
                    'Tiếp tục',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
              'Chi tiết Căn hộ & Nội thất',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cập nhật diện tích và danh sách tài sản bàn giao cho từng phòng để quản lý chính xác hơn.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // RENDER DANH SÁCH TẦNG TỪ BALO
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount:
                  widget.setupData.floors.length,
              itemBuilder: (context, index) {
                return _buildDynamicFloor(
                  widget.setupData.floors[index],
                  index,
                );
              },
            ),
            const SizedBox(height: 16),

            // NÚT THÊM TẦNG MỚI
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    int newFloorNum =
                        widget
                            .setupData
                            .floors
                            .length +
                        1;
                    widget.setupData.floors.add(
                      FloorModel(
                        name: 'Tầng $newFloorNum',
                        rooms: [],
                        isExpanded: true,
                      ),
                    );
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                label: const Text(
                  'Thêm tầng mới',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                  backgroundColor:
                      AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI THẺ TẦNG ---
  Widget _buildDynamicFloor(
    FloorModel floor,
    int floorIndex,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(
              () => floor.isExpanded =
                  !floor.isExpanded,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue
                    .withOpacity(0.15),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.business,
                color: AppColors.primaryBlue,
              ),
            ),
            title: Text(
              floor.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${floor.rooms.length} phòng đã tạo',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              floor.isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
          ),
          if (floor.isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child: Column(
                children: [
                  ...floor.rooms
                      .map(
                        (room) =>
                            _buildDynamicRoom(
                              room,
                              floor,
                            ),
                      )
                      .toList(),
                  const SizedBox(height: 8),
                  // NÚT THÊM PHÒNG (Viền nét mảnh mờ)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          floor.rooms.add(
                            RoomModel(
                              name:
                                  'P. ${floorIndex + 1}0${floor.rooms.length + 1}',
                              isEditing: true,
                            ),
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        color:
                            AppColors.primaryBlue,
                        size: 18,
                      ),
                      label: const Text(
                        'Thêm phòng',
                        style: TextStyle(
                          color: AppColors
                              .primaryBlue,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors
                              .primaryBlue
                              .withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- UI THẺ PHÒNG ---
  Widget _buildDynamicRoom(
    RoomModel room,
    FloorModel floor,
  ) {
    if (room.isEditing) {
      // 1. TRẠNG THÁI MỞ RỘNG (Đang sửa)
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.door_front_door,
                      color:
                          AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      room.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_up,
                    color:
                        AppColors.textSecondary,
                  ),
                  onPressed: () => setState(
                    () => room.isEditing = false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diện tích (m²)',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 48,
                        child: TextFormField(
                          initialValue: room.area,
                          keyboardType:
                              TextInputType
                                  .number,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (val) =>
                              room.area = val,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors
                                .cardBackground,
                            contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    8,
                                  ),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Loại phòng',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                        decoration: BoxDecoration(
                          color: AppColors
                              .cardBackground,
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: room.type,
                            isExpanded: true,
                            dropdownColor: AppColors
                                .cardBackground,
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 14,
                                ),
                            icon: const Icon(
                              Icons
                                  .keyboard_arrow_down,
                              color: AppColors
                                  .textSecondary,
                              size: 16,
                            ),
                            onChanged: (val) =>
                                setState(
                                  () =>
                                      room.type =
                                          val!,
                                ),
                            items: roomTypes
                                .map(
                                  (val) =>
                                      DropdownMenuItem(
                                        value:
                                            val,
                                        child:
                                            Text(
                                              val,
                                            ),
                                      ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Ghi chú tài sản & Nội thất',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: room.note,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              onChanged: (val) => room.note = val,
              decoration: InputDecoration(
                hintText:
                    'Ví dụ: Tủ lạnh, Điều hòa 2 chiều...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor:
                    AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => setState(
                  () => room.isEditing = false,
                ),
                child: const Text(
                  'Lưu thay đổi',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // 2. TRẠNG THÁI THU GỌN (Chỉ xem)
      return GestureDetector(
        onTap: () =>
            setState(() => room.isEditing = true),
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 12,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(
              12,
            ),
            border: Border.all(
              color: AppColors.borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons
                        .door_front_door_outlined,
                    color:
                        AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    room.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    room.area.isNotEmpty
                        ? '${room.area} m²'
                        : 'Chưa cập nhật',
                    style: const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.edit,
                    color:
                        AppColors.textSecondary,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
