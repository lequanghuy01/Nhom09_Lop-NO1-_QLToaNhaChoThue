import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class UtilityRecordScreen extends StatefulWidget {
  const UtilityRecordScreen({Key? key})
    : super(key: key);

  @override
  State<UtilityRecordScreen> createState() =>
      _UtilityRecordScreenState();
}

class _UtilityRecordScreenState
    extends State<UtilityRecordScreen> {
  final SetupData appData = SetupData();
  String _searchQuery = '';
  String _selectedFilter =
      'Tất cả tầng'; // Các filter: Tất cả tầng, Chưa ghi, Đã ghi

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu điện nước mặc định cho các phòng nếu chưa có
    for (var floor in appData.floors) {
      for (var room in floor.rooms) {
        if (!appData.utilityData.containsKey(
          room.name,
        )) {
          // Khởi tạo số cũ giả lập là 100 để bạn test tính năng trừ số
          appData.utilityData[room.name] =
              UtilityRecord(
                oldElec: 100,
                oldWater: 50,
              );
        }
      }
    }
  }

  // Hàm Lưu tất cả
  void _saveAll() {
    setState(() {
      for (var record
          in appData.utilityData.values) {
        if (record.newElec > 0 ||
            record.newWater > 0) {
          record.isRecorded = true;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu tất cả chỉ số!'),
      ),
    );
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
          'Ghi chỉ số Điện/Nước',
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
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _saveAll,
            icon: const Icon(
              Icons.save_outlined,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Lưu tất cả chỉ số',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // --- THANH TÌM KIẾM ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) => setState(
                () => _searchQuery = val,
              ),
              decoration: InputDecoration(
                hintText:
                    'Tìm kiếm phòng (VD: P.101)',
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

          // --- BỘ LỌC ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children:
                  [
                    'Tất cả tầng',
                    'Chưa ghi',
                    'Đã ghi',
                  ].map((filter) {
                    bool isSelected =
                        _selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(
                        () => _selectedFilter =
                            filter,
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
                                    .inputBackground,
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
                                : FontWeight
                                      .normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // --- DANH SÁCH TẦNG VÀ PHÒNG ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              itemCount: appData.floors.length,
              itemBuilder: (context, index) {
                var floor = appData.floors[index];

                // Lọc phòng theo Tìm kiếm và Trạng thái
                var filteredRooms = floor.rooms
                    .where((r) {
                      bool matchSearch = r.name
                          .toLowerCase()
                          .contains(
                            _searchQuery
                                .toLowerCase(),
                          );
                      bool matchFilter = true;
                      bool isRec =
                          appData
                              .utilityData[r.name]
                              ?.isRecorded ??
                          false;
                      if (_selectedFilter ==
                          'Chưa ghi')
                        matchFilter = !isRec;
                      if (_selectedFilter ==
                          'Đã ghi')
                        matchFilter = isRec;
                      return matchSearch &&
                          matchFilter;
                    })
                    .toList();

                if (filteredRooms.isEmpty)
                  return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      floor.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...filteredRooms
                        .map(
                          (room) => UtilityCard(
                            roomName: room.name,
                            record:
                                appData
                                    .utilityData[room
                                    .name]!,
                            onSave: () => setState(
                              () {},
                            ), // Reload khi ấn lưu 1 phòng
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET THẺ GHI ĐIỆN NƯỚC (CÓ STATE RIÊNG ĐỂ TÍNH TOÁN REAL-TIME) ---
class UtilityCard extends StatefulWidget {
  final String roomName;
  final UtilityRecord record;
  final VoidCallback onSave;

  const UtilityCard({
    Key? key,
    required this.roomName,
    required this.record,
    required this.onSave,
  }) : super(key: key);

  @override
  State<UtilityCard> createState() =>
      _UtilityCardState();
}

class _UtilityCardState
    extends State<UtilityCard> {
  late TextEditingController _oldElecCtrl;
  late TextEditingController _newElecCtrl;
  late TextEditingController _oldWaterCtrl;
  late TextEditingController _newWaterCtrl;

  @override
  void initState() {
    super.initState();
    // Đổ dữ liệu từ Record vào Controller
    _oldElecCtrl = TextEditingController(
      text: widget.record.oldElec.toString(),
    );
    _newElecCtrl = TextEditingController(
      text: widget.record.newElec > 0
          ? widget.record.newElec.toString()
          : '',
    );
    _oldWaterCtrl = TextEditingController(
      text: widget.record.oldWater.toString(),
    );
    _newWaterCtrl = TextEditingController(
      text: widget.record.newWater > 0
          ? widget.record.newWater.toString()
          : '',
    );

    // Lắng nghe sự thay đổi khi gõ phím để tự động trừ ra lượng "Tiêu thụ"
    _newElecCtrl.addListener(_updateCalc);
    _oldElecCtrl.addListener(_updateCalc);
    _newWaterCtrl.addListener(_updateCalc);
    _oldWaterCtrl.addListener(_updateCalc);
  }

  void _updateCalc() {
    setState(() {
      widget.record.oldElec =
          int.tryParse(_oldElecCtrl.text) ?? 0;
      widget.record.newElec =
          int.tryParse(_newElecCtrl.text) ?? 0;
      widget.record.oldWater =
          int.tryParse(_oldWaterCtrl.text) ?? 0;
      widget.record.newWater =
          int.tryParse(_newWaterCtrl.text) ?? 0;
    });
  }

  @override
  void dispose() {
    _oldElecCtrl.dispose();
    _newElecCtrl.dispose();
    _oldWaterCtrl.dispose();
    _newWaterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NẾU ĐÃ GHI -> HIỂN THỊ GIAO DIỆN THU GỌN
    if (widget.record.isRecorded) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.roomName,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ĐIỆN: ${widget.record.consumedElec}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NƯỚC: ${widget.record.consumedWater}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
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
                        BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ĐÃ GHI',
                    style: TextStyle(
                      color:
                          AppColors.successGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color:
                        AppColors.textSecondary,
                  ),
                  onPressed: () {
                    // Mở lại để sửa
                    setState(
                      () =>
                          widget
                                  .record
                                  .isRecorded =
                              false,
                    );
                    widget.onSave();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    // NẾU CHƯA GHI -> HIỂN THỊ GIAO DIỆN MỞ RỘNG ĐỂ NHẬP
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.roomName,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
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
                  color: Colors.orange
                      .withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(4),
                ),
                child: const Text(
                  'CHƯA HOÀN TẤT',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Khối ĐIỆN
          Row(
            children: const [
              Icon(
                Icons.bolt,
                color: Colors.orange,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Chỉ số Điện',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInputCol(
                  'Số cũ',
                  _oldElecCtrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputCol(
                  'Số mới',
                  _newElecCtrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Tiêu thụ: ',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text:
                      '${widget.record.consumedElec} kWh',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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

          // Khối NƯỚC
          Row(
            children: const [
              Icon(
                Icons.water_drop_outlined,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Chỉ số Nước',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInputCol(
                  'Số cũ (m³)',
                  _oldWaterCtrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputCol(
                  'Số mới',
                  _newWaterCtrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Tiêu thụ: ',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text:
                      '${widget.record.consumedWater} m³',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () => widget.record.isRecorded =
                      true,
                );
                widget
                    .onSave(); // Báo cho danh sách load lại
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Lưu chỉ số ${widget.roomName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCol(
    String label,
    TextEditingController ctrl,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: ctrl,
                  keyboardType:
                      TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        AppColors.inputBackground,
                    contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            8,
                          ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderColor,
                ),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
