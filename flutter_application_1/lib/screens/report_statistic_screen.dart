import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class ReportStatisticScreen
    extends StatefulWidget {
  const ReportStatisticScreen({Key? key})
    : super(key: key);

  @override
  State<ReportStatisticScreen> createState() =>
      _ReportStatisticScreenState();
}

class _ReportStatisticScreenState
    extends State<ReportStatisticScreen> {
  final SetupData appData = SetupData();

  int selectedMonth = 10;
  int selectedYear = 2023;

  @override
  Widget build(BuildContext context) {
    // --- BỘ LỌC DATA (Đọc từ dạng Map) ---
    var currentMonthInvoices = appData.invoices
        .where(
          (inv) =>
              inv['month'] == selectedMonth &&
              inv['year'] == selectedYear,
        )
        .toList();

    // Tính toán
    double totalCollected = currentMonthInvoices
        .where(
          (inv) =>
              inv['status'] == 'Đã thanh toán' ||
              inv['status'] == 'PAID',
        )
        .fold(
          0,
          (sum, inv) =>
              sum +
              (inv['totalAmount'] as num)
                  .toDouble(),
        );
    double totalDebt = currentMonthInvoices
        .where(
          (inv) =>
              inv['status'] ==
                  'Chưa thanh toán' ||
              inv['status'] == 'UNPAID',
        )
        .fold(
          0,
          (sum, inv) =>
              sum +
              (inv['totalAmount'] as num)
                  .toDouble(),
        );
    double totalExpected =
        totalCollected + totalDebt;

    double elecCost = currentMonthInvoices.fold(
      0,
      (sum, inv) =>
          sum +
          ((inv['electricityCost'] ?? 0) as num)
              .toDouble(),
    );
    double waterCost = currentMonthInvoices.fold(
      0,
      (sum, inv) =>
          sum +
          ((inv['waterCost'] ?? 0) as num)
              .toDouble(),
    );
    double otherCost = currentMonthInvoices.fold(
      0,
      (sum, inv) =>
          sum +
          ((inv['otherCost'] ?? 0) as num)
              .toDouble(),
    );

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
          'Báo cáo & Thống kê',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 16,
              top: 10,
              bottom: 10,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(
                8,
              ),
              border: Border.all(
                color: AppColors.borderColor,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Tháng $selectedMonth, $selectedYear',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_month,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- KHỐI 1: DOANH THU ---
            Container(
              padding: const EdgeInsets.all(20),
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
                        'Tổng doanh thu',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                        decoration: BoxDecoration(
                          color: AppColors
                              .primaryBlue
                              .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(
                                4,
                              ),
                        ),
                        child: const Text(
                          'DỰ KIẾN',
                          style: TextStyle(
                            color: AppColors
                                .primaryBlue,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(
                          totalExpected,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 6,
                          left: 4,
                        ),
                        child: Text(
                          'đ',
                          style: TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'ĐÃ THU TIỀN',
                              style: TextStyle(
                                color: AppColors
                                    .textSecondary,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Text(
                                  _formatCurrency(
                                    totalCollected,
                                  ),
                                  style: TextStyle(
                                    color: Colors
                                        .greenAccent
                                        .shade400,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                Text(
                                  ' đ',
                                  style: TextStyle(
                                    color: Colors
                                        .greenAccent
                                        .shade400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'CÒN NỢ',
                              style: TextStyle(
                                color: AppColors
                                    .textSecondary,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Text(
                                  _formatCurrency(
                                    totalDebt,
                                  ),
                                  style: TextStyle(
                                    color: Colors
                                        .redAccent
                                        .shade400,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                Text(
                                  ' đ',
                                  style: TextStyle(
                                    color: Colors
                                        .redAccent
                                        .shade400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- KHỐI 2: BIỂU ĐỒ 6 THÁNG ---
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DOANH THU 6 THÁNG',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const Text(
                  'Tăng 12% vs Q2',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment
                      .spaceAround,
                  maxY: 500,
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    // VÁ LỖI THƯ VIỆN Ở ĐÂY: Dùng Padding thay cho SideTitleWidget bị lỗi phiên bản
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const titles = [
                            'T5',
                            'T6',
                            'T7',
                            'T8',
                            'T9',
                            'T10',
                          ];
                          return Padding(
                            padding:
                                const EdgeInsets.only(
                                  top: 8.0,
                                ),
                            child: Text(
                              titles[value
                                  .toInt()],
                              style: const TextStyle(
                                color: AppColors
                                    .textSecondary,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    _buildBarData(0, 280),
                    _buildBarData(1, 310),
                    _buildBarData(2, 350),
                    _buildBarData(3, 395),
                    _buildBarData(4, 420),
                    _buildBarData(
                      5,
                      totalExpected / 1000000,
                    ), // Lấy từ Data
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- KHỐI 3: CHI PHÍ ---
            Container(
              padding: const EdgeInsets.all(20),
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
                    'CHI PHÍ DỊCH VỤ',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildServiceRow(
                    'Điện',
                    Colors.amber,
                    elecCost,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceRow(
                    'Nước',
                    Colors.blueAccent,
                    waterCost,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceRow(
                    'Khác',
                    Colors.purpleAccent,
                    otherCost,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              const SnackBar(
                content: Text(
                  'Đang tạo báo cáo Excel...',
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.download,
            color: Colors.white,
            size: 20,
          ),
          label: const Text(
            'Xuất báo cáo (Excel/PDF)',
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
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- HÀM HỖ TRỢ ---
  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i > 0) {
        result = '.$result';
        count = 0;
      }
    }
    return result;
  }

  String _formatShortCurrency(double amount) {
    return '${(amount / 1000000).toStringAsFixed(1)}M';
  }

  BarChartGroupData _buildBarData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primaryBlue
              .withOpacity(0.8),
          width: 16,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData:
              BackgroundBarChartRodData(
                show: true,
                toY: 500,
                color: AppColors.inputBackground,
              ),
        ),
      ],
    );
  }

  Widget _buildServiceRow(
    String name,
    Color color,
    double amount,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(
          _formatShortCurrency(amount),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
