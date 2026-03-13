import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'tenant_invoice_detail_screen.dart';

class TenantInvoiceScreen extends StatefulWidget {
  const TenantInvoiceScreen({Key? key})
    : super(key: key);

  @override
  State<TenantInvoiceScreen> createState() =>
      _TenantInvoiceScreenState();
}

class _TenantInvoiceScreenState
    extends State<TenantInvoiceScreen> {
  // --- MOCK DATA: Dữ liệu giả lập Hóa đơn của Khách thuê ---
  final List<Map<String, dynamic>> myInvoices = [
    {
      'id': 'INV-20231201',
      'month': '12/2023',
      'status': 'CHƯA THANH TOÁN',
      'isLate': true,
      'dueDate': '10/12/2023',
      'total': 3750000.0,
      'rent': 2500000.0,
      'elec': 875000.0,
      'water': 125000.0,
      'services': 250000.0,
      'elecOld': 12450,
      'elecNew': 12700,
      'waterOld': 450,
      'waterNew': 455,
    },
    {
      'id': 'INV-20231101',
      'month': '11/2023',
      'status': 'ĐÃ THANH TOÁN',
      'isLate': false,
      'dueDate': '10/11/2023',
      'paidDate': '05/11/2023',
      'total': 2500000.0,
      'rent': 2500000.0,
      'elec': 0.0,
      'water': 0.0,
      'services': 0.0,
      'elecOld': 12200,
      'elecNew': 12200,
      'waterOld': 445,
      'waterNew': 445,
    },
    {
      'id': 'INV-20231001',
      'month': '10/2023',
      'status': 'ĐÃ THANH TOÁN',
      'isLate': false,
      'dueDate': '10/10/2023',
      'paidDate': '04/10/2023',
      'total': 2500000.0,
      'rent': 2500000.0,
      'elec': 0.0,
      'water': 0.0,
      'services': 0.0,
      'elecOld': 12000,
      'elecNew': 12000,
      'waterOld': 440,
      'waterNew': 440,
    },
  ];

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
    return '$result đ';
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng nợ (Chỉ cộng những cái chưa thanh toán)
    double totalDebt = myInvoices
        .where(
          (inv) =>
              inv['status'] == 'CHƯA THANH TOÁN',
        )
        .fold(
          0,
          (sum, inv) => sum + inv['total'],
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Hóa đơn của tôi',
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
            // KHỐI TỔNG NỢ
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryBlue
                      .withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(
                              12,
                            ),
                        decoration: BoxDecoration(
                          color: AppColors
                              .primaryBlue
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .account_balance_wallet,
                          color: AppColors
                              .primaryBlue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'TỔNG NỢ HIỆN TẠI',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            _formatCurrency(
                              totalDebt,
                            ),
                            style: const TextStyle(
                              color: AppColors
                                  .primaryBlue,
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: const [
                      Text(
                        'Hạn thanh toán:',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '10/12/2023',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                      ),
                      child: const Text(
                        'Thanh toán ngay',
                        style: TextStyle(
                          color: Colors.white,
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
            const SizedBox(height: 32),

            const Text(
              'Lịch sử hóa đơn',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // DANH SÁCH HÓA ĐƠN
            ListView.separated(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: myInvoices.length,
              separatorBuilder:
                  (context, index) =>
                      const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final inv = myInvoices[index];
                bool isPaid =
                    inv['status'] ==
                    'ĐÃ THANH TOÁN';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TenantInvoiceDetailScreen(
                              invoice: inv,
                            ),
                      ),
                    );
                  },
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
                      border: Border.all(
                        color: isPaid
                            ? Colors.transparent
                            : Colors.redAccent
                                  .withOpacity(
                                    0.3,
                                  ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(
                                        8,
                                      ),
                                  decoration: BoxDecoration(
                                    color: isPaid
                                        ? AppColors
                                              .successGreen
                                              .withOpacity(
                                                0.1,
                                              )
                                        : Colors
                                              .redAccent
                                              .withOpacity(
                                                0.1,
                                              ),
                                    borderRadius:
                                        BorderRadius.circular(
                                          8,
                                        ),
                                  ),
                                  child: Icon(
                                    isPaid
                                        ? Icons
                                              .check_circle_outline
                                        : Icons
                                              .description_outlined,
                                    color: isPaid
                                        ? AppColors
                                              .successGreen
                                        : Colors
                                              .redAccent,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      'Tháng ${inv['month']}',
                                      style: const TextStyle(
                                        color: Colors
                                            .white,
                                        fontSize:
                                            16,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      isPaid
                                          ? 'Đã đóng: ${inv['paidDate']}'
                                          : 'Hạn: ${inv['dueDate']}',
                                      style: const TextStyle(
                                        color: AppColors
                                            .textSecondary,
                                        fontSize:
                                            12,
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
                                color: isPaid
                                    ? AppColors
                                          .successGreen
                                          .withOpacity(
                                            0.15,
                                          )
                                    : Colors
                                          .redAccent
                                          .withOpacity(
                                            0.15,
                                          ),
                                borderRadius:
                                    BorderRadius.circular(
                                      4,
                                    ),
                              ),
                              child: Text(
                                inv['status'],
                                style: TextStyle(
                                  color: isPaid
                                      ? AppColors
                                            .successGreen
                                      : Colors
                                            .redAccent,
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Text(
                              _formatCurrency(
                                inv['total'],
                              ),
                              style: TextStyle(
                                color: isPaid
                                    ? AppColors
                                          .textSecondary
                                    : AppColors
                                          .primaryBlue,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                        16,
                                    vertical: 8,
                                  ),
                              decoration: BoxDecoration(
                                color: isPaid
                                    ? AppColors
                                          .inputBackground
                                    : AppColors
                                          .primaryBlue,
                                borderRadius:
                                    BorderRadius.circular(
                                      8,
                                    ),
                              ),
                              child: Text(
                                isPaid
                                    ? 'Xem biên lai'
                                    : 'Chi tiết',
                                style: TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 13,
                                  fontWeight:
                                      isPaid
                                      ? FontWeight
                                            .normal
                                      : FontWeight
                                            .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
