import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'add_resident_screen.dart';
import 'tenant_detail_screen.dart';

class ResidentScreen extends StatefulWidget {
  const ResidentScreen({Key? key})
    : super(key: key);

  @override
  State<ResidentScreen> createState() =>
      _ResidentScreenState();
}

class _ResidentScreenState
    extends State<ResidentScreen> {
  final SetupData appData = SetupData();

  String _selectedBuilding = 'Tất cả tòa nhà';
  String _selectedFloor = 'Tất cả tầng';

  @override
  void initState() {
    super.initState();
    if (appData.buildingName.isNotEmpty) {
      _selectedBuilding = appData.buildingName;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> floorOptions = ['Tất cả tầng'];
    floorOptions.addAll(
      appData.floors.map((f) => f.name),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Danh sách Cư dân',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Tên, SĐT, CCCD hoặc số phòng...',
                  hintStyle: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color:
                        AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor:
                      AppColors.inputBackground,
                  contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                  enabledBorder:
                      OutlineInputBorder(
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
                  focusedBorder:
                      OutlineInputBorder(
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
              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterIcon(),
                    const SizedBox(width: 12),
                    _buildFilterPill(
                      'Đang ở',
                      isSelected: true,
                    ),
                    const SizedBox(width: 12),
                    _buildFilterPill('Nợ phí'),
                    const SizedBox(width: 12),
                    _buildFilterPill(
                      'Sắp hết hạn',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.background,
                        border: Border.all(
                          color: AppColors
                              .borderColor,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                              8,
                            ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value:
                              _selectedBuilding,
                          isExpanded: true,
                          dropdownColor: AppColors
                              .cardBackground,
                          icon: const Icon(
                            Icons
                                .keyboard_arrow_down,
                            color: AppColors
                                .textSecondary,
                            size: 16,
                          ),
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 13,
                          ),
                          onChanged: (val) =>
                              setState(
                                () =>
                                    _selectedBuilding =
                                        val!,
                              ),
                          items: [_selectedBuilding]
                              .map(
                                (String value) =>
                                    DropdownMenuItem<
                                      String
                                    >(
                                      value:
                                          value,
                                      child: Text(
                                        value,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                      ),
                                    ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.background,
                        border: Border.all(
                          color: AppColors
                              .borderColor,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                              8,
                            ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFloor,
                          isExpanded: true,
                          dropdownColor: AppColors
                              .cardBackground,
                          icon: const Icon(
                            Icons
                                .keyboard_arrow_down,
                            color: AppColors
                                .textSecondary,
                            size: 16,
                          ),
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 13,
                          ),
                          onChanged: (val) =>
                              setState(
                                () =>
                                    _selectedFloor =
                                        val!,
                              ),
                          items: floorOptions
                              .map(
                                (String value) =>
                                    DropdownMenuItem<
                                      String
                                    >(
                                      value:
                                          value,
                                      child: Text(
                                        value,
                                      ),
                                    ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'KẾT QUẢ (${appData.residents.length} CƯ DÂN)',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // --- KIỂM TRA: NẾU TRỐNG THÌ HIỆN GIAO DIỆN TRỐNG, CÓ NGƯỜI THÌ HIỆN DANH SÁCH ---
              Expanded(
                child: appData.residents.isEmpty
                    ? _buildEmptyState() // Giao diện khi chưa có ai
                    : ListView.builder(
                        itemCount: appData
                            .residents
                            .length,
                        itemBuilder: (context, index) {
                          final res = appData
                              .residents[index];
                          return _buildResidentCard(
                            res,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newResident =
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AddResidentScreen(),
                ),
              );
          if (newResident != null) {
            setState(() {
              appData.residents.insert(
                0,
                newResident,
              );
              if (appData.totalRooms >
                  appData.occupiedRooms)
                appData.occupiedRooms++;
            });
          }
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // --- GIAO DIỆN KHI CHƯA CÓ CƯ DÂN NÀO ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.textSecondary
                .withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa có cư dân nào',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bấm vào nút + góc dưới để thêm mới',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 40,
          ), // Đẩy lên một chút cho cân đối
        ],
      ),
    );
  }

  // --- CÁC HÀM VẼ GIAO DIỆN PHỤ ---
  Widget _buildFilterIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.tune,
        color: AppColors.textSecondary,
        size: 16,
      ),
    );
  }

  Widget _buildFilterPill(
    String text, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryBlue.withOpacity(
                0.15,
              )
            : AppColors.background,
        border: Border.all(
          color: isSelected
              ? AppColors.primaryBlue
              : AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? AppColors.primaryBlue
              : AppColors.textSecondary,
          fontSize: 13,
          fontWeight: isSelected
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildResidentCard(
    Map<String, dynamic> resident,
  ) {
    List<String> nameParts =
        (resident['name'] ?? 'NA').split(' ');
    String initials = '';
    if (nameParts.isNotEmpty)
      initials += nameParts[0][0];
    if (nameParts.length > 1)
      initials += nameParts.last[0];
    initials = initials.toUpperCase();

    return GestureDetector(
      onTap: () async {
        final isDeleted = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TenantDetailScreen(
                  residentData: resident,
                ),
          ),
        );

        // Nếu màn hình Chi tiết báo về là đã xóa (isDeleted == true)
        // Thì gọi setState để load lại giao diện ngay lập tức
        if (isDeleted == true) {
          setState(() {});
        }
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TenantDetailScreen(
                  residentData: resident,
                ),
          ),
        );*/
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue
                        .withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        resident['name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.apartment,
                            color: AppColors
                                .textSecondary,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${resident['room']} • ${appData.buildingName}',
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
                ),
                if (resident['badge'] != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color:
                            resident['badgeColor'] ??
                            AppColors.primaryBlue,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                            4,
                          ),
                    ),
                    child: Text(
                      resident['badge'],
                      style: TextStyle(
                        color:
                            resident['badgeColor'] ??
                            AppColors.primaryBlue,
                        fontSize: 9,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: Divider(
                color: AppColors.borderColor,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      color:
                          AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      resident['phone'] ?? '',
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Chi tiết >',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
