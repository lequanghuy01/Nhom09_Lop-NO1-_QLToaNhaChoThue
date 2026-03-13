import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class FeeManagementScreen extends StatefulWidget {
  const FeeManagementScreen({Key? key})
    : super(key: key);

  @override
  State<FeeManagementScreen> createState() =>
      _FeeManagementScreenState();
}

class _FeeManagementScreenState
    extends State<FeeManagementScreen> {
  final SetupData appData = SetupData();
  final formatterFull = NumberFormat(
    '#,###',
    'vi_VN',
  );

  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  // Hàm định dạng số tiền rút gọn (VD: 124.500.000 -> 124.500k)
  String _formatCompact(int amount) {
    if (amount == 0) return '0k';
    return '${formatterFull.format(amount / 1000)}k';
  }

  @override
  Widget build(BuildContext context) {
    // --- THUẬT TOÁN TÍNH TOÁN REAL-TIME CHO DASHBOARD ---
    int totalExpected = 0;
    int totalCollected = 0;

    for (var inv in appData.invoices) {
      int amount = inv['totalAmount'] ?? 0;
      totalExpected += amount;
      if (inv['status'] == 'Đã thanh toán') {
        totalCollected += amount;
      }
    }

    double progressPercent = totalExpected > 0
        ? (totalCollected / totalExpected)
        : 0.0;
    int percentDisplay = (progressPercent * 100)
        .toInt();

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
          'Quản lý thu phí',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // --- THANH TÌM KIẾM ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) => setState(
                () => _searchQuery = val,
              ),
              decoration: InputDecoration(
                hintText:
                    'Tìm phòng hoặc tên khách...',
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

          // --- DASHBOARD THỐNG KÊ (Real-time) ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Khối TỔNG CẦN THU
                Expanded(
                  child: Container(
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
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          'TỔNG CẦN THU',
                          style: TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatCompact(
                            totalExpected,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .calendar_today,
                              color: AppColors
                                  .textSecondary,
                              size: 12,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Tháng ${DateFormat('MM/yyyy').format(DateTime.now())}',
                              style: const TextStyle(
                                color: AppColors
                                    .textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Khối ĐÃ THU
                Expanded(
                  child: Container(
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
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              'ĐÃ THU',
                              style: TextStyle(
                                color: AppColors
                                    .textSecondary,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            // Vòng tròn Progress
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: Stack(
                                alignment:
                                    Alignment
                                        .center,
                                children: [
                                  CircularProgressIndicator(
                                    value:
                                        progressPercent,
                                    backgroundColor:
                                        AppColors
                                            .inputBackground,
                                    valueColor:
                                        const AlwaysStoppedAnimation<
                                          Color
                                        >(
                                          AppColors
                                              .successGreen,
                                        ),
                                    strokeWidth:
                                        3,
                                  ),
                                  Text(
                                    '$percentDisplay%',
                                    style: const TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize: 9,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatCompact(
                            totalCollected,
                          ),
                          style: const TextStyle(
                            color: AppColors
                                .successGreen,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(
                              Icons.trending_up,
                              color: AppColors
                                  .successGreen,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '+12% so với tháng trước',
                              style: TextStyle(
                                color: AppColors
                                    .successGreen,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- BỘ LỌC TABS ---
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Row(
              children:
                  [
                    'Tất cả',
                    'Chưa thanh toán',
                    'Đã thanh toán',
                  ].map((filter) {
                    bool isSelected =
                        _selectedFilter == filter;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(
                          () => _selectedFilter =
                              filter,
                        ),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors
                                      .inputBackground
                                : Colors
                                      .transparent,
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                          ),
                          alignment:
                              Alignment.center,
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors
                                        .primaryBlue
                                  : AppColors
                                        .textSecondary,
                              fontSize: 12,
                              fontWeight:
                                  isSelected
                                  ? FontWeight
                                        .bold
                                  : FontWeight
                                        .normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // --- DANH SÁCH HÓA ĐƠN ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'DANH SÁCH HÓA ĐƠN',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildInvoiceList()),
        ],
      ),
    );
  }

  Widget _buildInvoiceList() {
    List<Map<String, dynamic>> filteredList =
        appData.invoices.where((inv) {
          bool matchFilter =
              _selectedFilter == 'Tất cả' ||
              inv['status'] == _selectedFilter;
          bool matchSearch =
              (inv['room'] ?? '')
                  .toLowerCase()
                  .contains(
                    _searchQuery.toLowerCase(),
                  ) ||
              (inv['residentName'] ?? '')
                  .toLowerCase()
                  .contains(
                    _searchQuery.toLowerCase(),
                  );
          return matchFilter && matchSearch;
        }).toList();

    if (filteredList.isEmpty)
      return const Center(
        child: Text(
          'Không có dữ liệu thu phí',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var inv = filteredList[index];
        bool isUnpaid =
            inv['status'] == 'Chưa thanh toán';

        return Container(
          margin: const EdgeInsets.only(
            bottom: 16,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors
                              .primaryBlue
                              .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                        alignment:
                            Alignment.center,
                        child: Text(
                          inv['room']?.replaceAll(
                                'P.',
                                '',
                              ) ??
                              '',
                          style: const TextStyle(
                            color: AppColors
                                .primaryBlue,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            inv['residentName'] ??
                                'Khách thuê',
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
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Hóa đơn: ${inv['dueDate']}',
                            style: const TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
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
                      color: isUnpaid
                          ? Colors.transparent
                          : AppColors.successGreen
                                .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(
                            4,
                          ),
                      border: Border.all(
                        color: isUnpaid
                            ? Colors.redAccent
                                  .withOpacity(
                                    0.5,
                                  )
                            : AppColors
                                  .successGreen,
                      ),
                    ),
                    child: Text(
                      isUnpaid
                          ? 'CHƯA THU'
                          : 'ĐÃ THU',
                      style: TextStyle(
                        color: isUnpaid
                            ? Colors.redAccent
                            : AppColors
                                  .successGreen,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SỐ TIỀN',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatterFull.format(inv['totalAmount'] ?? 0)}đ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (isUnpaid)
                    // NÚT ĐÒI NỢ ĂN TIỀN LÀ ĐÂY!
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          inv['status'] =
                              'Đã thanh toán'; // Chuyển trạng thái hóa đơn -> Tiền tự động nhảy lên Dashboard
                        });
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đã thu tiền phòng ${inv['room']} thành công!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                      ),
                      child: const Text(
                        'Xác nhận đã đóng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        right: 8.0,
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
