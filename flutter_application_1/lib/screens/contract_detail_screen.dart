import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'contract_pdf_screen.dart'; // Import màn hình xem PDF ở bước 2

class ContractDetailScreen
    extends StatefulWidget {
  final Map<String, dynamic> contractData;

  const ContractDetailScreen({
    Key? key,
    required this.contractData,
  }) : super(key: key);

  @override
  State<ContractDetailScreen> createState() =>
      _ContractDetailScreenState();
}

class _ContractDetailScreenState
    extends State<ContractDetailScreen> {
  final SetupData appData = SetupData();

  // Hàm tính toán số ngày và phần trăm tiến độ hợp đồng
  Map<String, dynamic> _calculateProgress() {
    try {
      // Ép kiểu chuỗi dd/MM/yyyy thành DateTime
      List<String> startParts =
          (widget.contractData['startDate'] ?? '')
              .split('/');
      List<String> endParts =
          (widget.contractData['endDate'] ?? '')
              .split('/');

      if (startParts.length == 3 &&
          endParts.length == 3) {
        DateTime start = DateTime(
          int.parse(startParts[2]),
          int.parse(startParts[1]),
          int.parse(startParts[0]),
        );
        DateTime end = DateTime(
          int.parse(endParts[2]),
          int.parse(endParts[1]),
          int.parse(endParts[0]),
        );
        DateTime now = DateTime.now();

        int totalDays = end
            .difference(start)
            .inDays;
        int remainingDays = end
            .difference(now)
            .inDays;

        if (remainingDays < 0) remainingDays = 0;

        double progress = 0.0;
        if (totalDays > 0) {
          progress =
              (totalDays - remainingDays) /
              totalDays;
        }
        if (progress > 1.0) progress = 1.0;
        if (progress < 0.0) progress = 0.0;

        return {
          'remaining': remainingDays,
          'progress': progress,
          'isExpired': remainingDays == 0,
        };
      }
    } catch (e) {
      // Lỗi parse ngày thì trả về mặc định
    }
    return {
      'remaining': 0,
      'progress': 0.0,
      'isExpired': false,
    };
  }

  // Hàm xử lý Thanh lý Hợp đồng
  void _terminateContract() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              AppColors.cardBackground,
          title: const Text(
            'Thanh lý hợp đồng',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Hợp đồng này sẽ được chuyển sang trạng thái "Đã thanh lý" và phòng sẽ được trả lại trạng thái Trống. Bạn có chắc chắn?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                // Cập nhật trạng thái
                widget.contractData['status'] =
                    'Đã thanh lý';
                widget.contractData['badge'] =
                    'ĐÃ KẾT THÚC';
                widget.contractData['badgeColor'] =
                    AppColors.textSecondary;

                // Trả phòng trống
                if (appData.occupiedRooms > 0) {
                  appData.occupiedRooms--;
                }

                Navigator.pop(
                  context,
                ); // Đóng Dialog
                Navigator.pop(
                  context,
                  true,
                ); // Đóng màn Chi tiết, gửi tín hiệu true để danh sách refresh
              },
              child: const Text(
                'Xác nhận thanh lý',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressData = _calculateProgress();
    bool isTerminated =
        widget.contractData['status'] ==
        'Đã thanh lý';

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
          'Chi tiết Hợp đồng',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primaryBlue,
            ),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: isTerminated
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Chức năng Gia hạn đang phát triển',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors
                                  .primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                          ),
                        ),
                        child: const Text(
                          'Gia hạn hợp đồng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed:
                            _terminateContract,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color:
                                Colors.redAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                          ),
                        ),
                        child: const Text(
                          'Thanh lý hợp đồng',
                          style: TextStyle(
                            color:
                                Colors.redAccent,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
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
          children: [
            // --- HEADER: Thông tin khách thuê ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors
                              .primaryBlue
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors
                              .primaryBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              widget.contractData['name'] ??
                                  'Khách thuê',
                              style:
                                  const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Khách thuê ${widget.contractData['room']}',
                              style: const TextStyle(
                                color: AppColors
                                    .textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                        decoration: BoxDecoration(
                          color:
                              (widget.contractData['badgeColor']
                                      as Color)
                                  .withOpacity(
                                    0.15,
                                  ),
                          borderRadius:
                              BorderRadius.circular(
                                6,
                              ),
                        ),
                        child: Text(
                          widget.contractData['badge'] ??
                              '',
                          style: TextStyle(
                            color: widget
                                .contractData['badgeColor'],
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.phone_outlined,
                            color: AppColors
                                .primaryBlue,
                            size: 16,
                          ),
                          label: const Text(
                            'Gọi',
                            style: TextStyle(
                              color: AppColors
                                  .primaryBlue,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors
                                    .primaryBlue
                                    .withOpacity(
                                      0.1,
                                    ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    8,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons
                                .chat_bubble_outline,
                            color: AppColors
                                .primaryBlue,
                            size: 16,
                          ),
                          label: const Text(
                            'Nhắn tin',
                            style: TextStyle(
                              color: AppColors
                                  .primaryBlue,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors
                                    .primaryBlue
                                    .withOpacity(
                                      0.1,
                                    ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    8,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- THỜI HẠN HỢP ĐỒNG ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      const Text(
                        'THỜI HẠN HỢP ĐỒNG',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        progressData['isExpired']
                            ? 'Đã hết hạn'
                            : 'Còn ${progressData['remaining']} ngày',
                        style: TextStyle(
                          color:
                              progressData['remaining'] <=
                                  30
                              ? Colors.orange
                              : AppColors
                                    .successGreen,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors
                            .textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.contractData['startDate']} - ${widget.contractData['endDate']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Thanh Progress Bar
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value:
                          progressData['progress'],
                      minHeight: 6,
                      backgroundColor: AppColors
                          .inputBackground,
                      valueColor:
                          AlwaysStoppedAnimation<
                            Color
                          >(
                            progressData['remaining'] <=
                                    30
                                ? Colors.orange
                                : AppColors
                                      .primaryBlue,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- CHI TIẾT TÀI CHÍNH ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHI TIẾT TÀI CHÍNH',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFinanceRow(
                    Icons.payments_outlined,
                    'Giá thuê',
                    '${widget.contractData['rentPrice']}đ/tháng',
                    AppColors.primaryBlue,
                    null,
                  ),
                  const SizedBox(height: 16),
                  _buildFinanceRow(
                    Icons
                        .account_balance_wallet_outlined,
                    'Tiền đặt cọc',
                    '${widget.contractData['deposit']}đ',
                    Colors.white,
                    'ĐÃ NỘP',
                  ),
                  const SizedBox(height: 16),
                  _buildFinanceRow(
                    Icons
                        .event_available_outlined,
                    'Ngày thanh toán',
                    'Ngày 05 hàng tháng',
                    Colors.white,
                    null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- DỊCH VỤ ĐĂNG KÝ ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DỊCH VỤ ĐĂNG KÝ',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Load danh sách dịch vụ từ Kho tổng (Mô phỏng)
                  ...appData.services
                      .map(
                        (service) => Padding(
                          padding:
                              const EdgeInsets.only(
                                bottom: 12,
                              ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    service.icon,
                                    color: AppColors
                                        .warningOrange,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    service.name,
                                    style: const TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                          14,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${service.price}đ/${service.unit}',
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
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- TÀI LIỆU ĐÍNH KÈM (PDF) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TÀI LIỆU ĐÍNH KÈM',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .picture_as_pdf,
                              color: Colors
                                  .redAccent,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              'Hợp đồng điện tử (PDF)',
                              style: TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons
                                .remove_red_eye_outlined,
                            color: AppColors
                                .textSecondary,
                          ),
                          onPressed: () {
                            // Chuyển sang màn hình xem PDF
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ContractPdfScreen(
                                      contractData:
                                          widget
                                              .contractData,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceRow(
    IconData icon,
    String label,
    String value,
    Color valueColor,
    String? subBadge,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subBadge != null) ...[
              const SizedBox(height: 2),
              Text(
                subBadge,
                style: const TextStyle(
                  color: AppColors.successGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
