import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class TenantInvoiceDetailScreen
    extends StatelessWidget {
  final Map<String, dynamic>
  invoice; // Nhận dữ liệu hóa đơn truyền sang

  const TenantInvoiceDetailScreen({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  // Hàm hiển thị Popup QR Code Thanh toán
  void _showPaymentQR(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary
                    .withOpacity(0.5),
                borderRadius:
                    BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thanh toán hóa đơn',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quét mã QR dưới đây bằng App Ngân hàng',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            // Mã QR Giả lập
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 200,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            // Thông tin chuyển khoản
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildBankInfoRow(
                    'Ngân hàng:',
                    'Vietcombank',
                  ),
                  const SizedBox(height: 8),
                  _buildBankInfoRow(
                    'Chủ tài khoản:',
                    'LÊ QUANG HUY',
                  ),
                  const SizedBox(height: 8),
                  _buildBankInfoRow(
                    'Số tài khoản:',
                    '0909123456',
                    isHighlight: true,
                  ),
                  const SizedBox(height: 8),
                  _buildBankInfoRow(
                    'Số tiền:',
                    _formatCurrency(
                      invoice['total'],
                    ),
                    isHighlight: true,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 8),
                  _buildBankInfoRow(
                    'Nội dung:',
                    'P101 ${invoice['month']}',
                    isHighlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Đã chuyển khoản xong',
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
    );
  }

  Widget _buildBankInfoRow(
    String title,
    String value, {
    bool isHighlight = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: isHighlight ? 16 : 14,
            fontWeight: isHighlight
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }

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
    bool isPaid =
        invoice['status'] == 'ĐÃ THANH TOÁN';

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
          'Chi tiết hóa đơn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Mã Hóa đơn
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue
                          .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(
                            8,
                          ),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color:
                          AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã hóa đơn: ${invoice['id']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kỳ thanh toán: Tháng ${invoice['month']}',
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
            const SizedBox(height: 16),

            // Trạng thái
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TRẠNG THÁI',
                        style: TextStyle(
                          color: AppColors
                              .primaryBlue,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invoice['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPaid
                            ? 'Đã đóng: ${invoice['paidDate']}'
                            : 'Hạn thanh toán: ${invoice['dueDate']}',
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (!isPaid &&
                      invoice['isLate'] == true)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent
                            .withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.circle,
                            color:
                                Colors.redAccent,
                            size: 8,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Quá hạn',
                            style: TextStyle(
                              color: Colors
                                  .redAccent,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tổng tiền
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    AppColors.primaryBlue,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng số tiền cần đóng',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(
                          invoice['total'],
                        ).replaceAll(' đ', ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 6,
                          left: 8,
                        ),
                        child: Text(
                          'VNĐ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Chi tiết khoản phí
            const Text(
              'Chi tiết các khoản phí',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 1. Tiền thuê
            _buildDetailSection(
              'Tiền thuê nhà',
              Icons.home_outlined,
              invoice['rent'],
              'Giá thuê cố định theo hợp đồng tháng ${invoice['month'].split('/')[0]}.',
            ),
            // 2. Tiền điện
            _buildUtilitySection(
              'Tiền điện',
              Icons.bolt,
              invoice['elec'],
              invoice['elecOld'],
              invoice['elecNew'],
              3500,
              'kWh',
              Colors.amber,
            ),
            // 3. Tiền nước
            _buildUtilitySection(
              'Tiền nước',
              Icons.water_drop_outlined,
              invoice['water'],
              invoice['waterOld'],
              invoice['waterNew'],
              25000,
              'm³',
              Colors.blueAccent,
            ),
            // 4. Phí dịch vụ
            _buildServiceSection(
              'Phí dịch vụ & Tiện ích',
              Icons.widgets_outlined,
              invoice['services'],
            ),

            const SizedBox(height: 24),
            // Ghi chú
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue
                    .withOpacity(0.05),
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue
                      .withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color:
                            AppColors.primaryBlue,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ghi chú từ quản lý',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '"Vui lòng thanh toán hóa đơn đúng hạn trước ngày 05 để tránh phát sinh phí phạt trả chậm. Nếu có thắc mắc về chỉ số điện nước, vui lòng liên hệ Ban quản lý tại tầng G."',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ), // Khoảng trống cho nút nổi
          ],
        ),
      ),
      // Nút thanh toán cố định ở đáy (Chỉ hiện khi chưa thanh toán)
      floatingActionButton: isPaid
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              color: AppColors.background,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showPaymentQR(context),
                  icon: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Thanh toán ngay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                ),
              ),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerDocked,
    );
  }

  // Khối vẽ Tiền thuê
  Widget _buildDetailSection(
    String title,
    IconData icon,
    double amount,
    String desc,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              _formatCurrency(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          desc,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const Divider(
          color: AppColors.borderColor,
          height: 32,
        ),
      ],
    );
  }

  // Khối vẽ Điện/Nước
  Widget _buildUtilitySection(
    String title,
    IconData icon,
    double amount,
    int oldIdx,
    int newIdx,
    int price,
    String unit,
    Color iconColor,
  ) {
    int consumed = newIdx - oldIdx;
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              _formatCurrency(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chỉ số cũ',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$oldIdx $unit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chỉ số mới',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$newIdx $unit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiêu thụ: $consumed $unit x ${_formatCurrency(price.toDouble())}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              _formatCurrency(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(
          color: AppColors.borderColor,
          height: 32,
        ),
      ],
    );
  }

  // Khối vẽ Dịch vụ
  Widget _buildServiceSection(
    String title,
    IconData icon,
    double amount,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.purpleAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              _formatCurrency(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Internet băng thông rộng',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(
              '200.000 đ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Phí vệ sinh & Rác',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(
              '100.000 đ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Phí gửi xe (1 xe máy)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(
              '150.000 đ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
