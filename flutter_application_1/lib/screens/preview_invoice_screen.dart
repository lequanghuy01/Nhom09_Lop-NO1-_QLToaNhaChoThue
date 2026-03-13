import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class PreviewInvoiceScreen
    extends StatefulWidget {
  final Map<String, dynamic> invoiceData;

  const PreviewInvoiceScreen({
    Key? key,
    required this.invoiceData,
  }) : super(key: key);

  @override
  State<PreviewInvoiceScreen> createState() =>
      _PreviewInvoiceScreenState();
}

class _PreviewInvoiceScreenState
    extends State<PreviewInvoiceScreen> {
  final SetupData appData = SetupData();
  final formatter = NumberFormat(
    '#,###',
    'vi_VN',
  );

  bool sendApp = true;
  bool sendEmail = true;
  bool sendSMS = false;

  void _confirmAndSend() {
    // 1. Gắn trạng thái cho hóa đơn là "Chưa thanh toán"
    Map<String, dynamic> finalInvoice = Map.from(
      widget.invoiceData,
    );
    finalInvoice['status'] = 'Chưa thanh toán';

    // 2. Đẩy vào Kho dữ liệu chung
    appData.invoices.insert(0, finalInvoice);

    // 3. LOGIC MỚI: Chốt sổ gối đầu Điện/Nước cho phòng này (Cách 1)
    String roomName = finalInvoice['room'];
    if (appData.utilityData.containsKey(
      roomName,
    )) {
      appData.utilityData[roomName]!
          .rolloverToNextMonth();
    }

    // 4. Thông báo và văng về
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã tạo hóa đơn và chốt số Điện/Nước thành công!',
        ),
      ),
    );
    Navigator.pop(context, true);
    /*// 1. Gắn trạng thái cho hóa đơn là "Chưa thu"
    Map<String, dynamic> finalInvoice = Map.from(
      widget.invoiceData,
    );
    finalInvoice['status'] = 'Chưa thanh toán';

    // 2. Đẩy vào Kho dữ liệu chung
    appData.invoices.insert(0, finalInvoice);

    // 3. Thông báo và văng về màn hình Danh sách
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã tạo và gửi hóa đơn thành công!',
        ),
      ),
    );
    Navigator.pop(
      context,
      true,
    ); // Trả về true để báo là đã chốt*/
  }

  @override
  Widget build(BuildContext context) {
    String invoiceId =
        widget.invoiceData['invoiceId'];
    String room = widget.invoiceData['room'];
    String residentName =
        widget.invoiceData['residentName'];
    String monthStr =
        widget.invoiceData['monthStr'];
    String dueDate =
        widget.invoiceData['dueDate'];
    String buildingName =
        appData.buildingName.isNotEmpty
        ? appData.buildingName
        : 'Tòa nhà trọ';
    String address = appData.address.isNotEmpty
        ? appData.address
        : 'Địa chỉ đang cập nhật';

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
          'Xem trước Hóa đơn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- TỜ BIÊN LAI TRẮNG ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(
                                    12,
                                  ),
                              decoration: BoxDecoration(
                                color:
                                    const Color(
                                      0xFFF0F4F8,
                                    ),
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                              ),
                              child: const Icon(
                                Icons.business,
                                color: Colors
                                    .black54,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    buildingName,
                                    style: const TextStyle(
                                      color: Colors
                                          .black87,
                                      fontSize:
                                          16,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                  Text(
                                    address,
                                    style: const TextStyle(
                                      color: Colors
                                          .black54,
                                      fontSize:
                                          12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,
                        children: [
                          const Text(
                            'HÓA ĐƠN ĐIỆN TỬ',
                            style: TextStyle(
                              color:
                                  Colors.black45,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          Text(
                            '#$invoiceId',
                            style:
                                const TextStyle(
                                  color: Colors
                                      .black87,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'KHÁCH HÀNG',
                            style: TextStyle(
                              color:
                                  Colors.black45,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            residentName,
                            style:
                                const TextStyle(
                                  color: Colors
                                      .black87,
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),
                          Text(
                            'Phòng $room',
                            style:
                                const TextStyle(
                                  color: Colors
                                      .black54,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,
                        children: [
                          const Text(
                            'KỲ THANH TOÁN',
                            style: TextStyle(
                              color:
                                  Colors.black45,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Tháng $monthStr',
                            style:
                                const TextStyle(
                                  color: Colors
                                      .black87,
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),
                          Text(
                            'Hạn: $dueDate',
                            style:
                                const TextStyle(
                                  color: Colors
                                      .black54,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    child: Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                  ),

                  // BẢNG KÊ CHI TIẾT
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: const [
                      Text(
                        'MÔ TẢ CHI TIẾT',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        'THÀNH TIỀN',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildReceiptItem(
                    'Tiền thuê nhà',
                    'Cố định hàng tháng',
                    widget
                        .invoiceData['rentAmount'],
                  ),
                  const SizedBox(height: 16),
                  _buildReceiptItem(
                    'Tiền điện',
                    'Cũ: ${widget.invoiceData['eOld']} | Mới: ${widget.invoiceData['eNew']} | SD: ${widget.invoiceData['eUse']} kWh\nĐơn giá: ${formatter.format(widget.invoiceData['ePrice'])}đ/kWh',
                    widget
                        .invoiceData['elecAmount'],
                  ),
                  const SizedBox(height: 16),
                  _buildReceiptItem(
                    'Tiền nước',
                    'Cũ: ${widget.invoiceData['wOld']} | Mới: ${widget.invoiceData['wNew']} | SD: ${widget.invoiceData['wUse']} m³\nĐơn giá: ${formatter.format(widget.invoiceData['wPrice'])}đ/m³',
                    widget
                        .invoiceData['waterAmount'],
                  ),
                  const SizedBox(height: 16),
                  _buildReceiptItem(
                    'Phí quản lý & dịch vụ',
                    'Vệ sinh, bảo vệ, rác...',
                    widget
                        .invoiceData['serviceAmount'],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      const Text(
                        'TỔNG CỘNG',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${formatter.format(widget.invoiceData['totalAmount'])}đ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                      thickness: 2,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Vui lòng thanh toán trước ngày hạn nộp. Trân trọng!',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 11,
                        fontStyle:
                            FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- TÙY CHỌN GỬI ---
            const Text(
              'TÙY CHỌN GỬI HÓA ĐƠN',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildOptionCheck(
              'Gửi qua App (Push)',
              'Thông báo trực tiếp trên thiết bị',
              sendApp,
              (val) =>
                  setState(() => sendApp = val!),
            ),
            _buildOptionCheck(
              'Gửi qua Email',
              'Bản PDF lưu trữ chính thức',
              sendEmail,
              (val) => setState(
                () => sendEmail = val!,
              ),
            ),
            _buildOptionCheck(
              'Gửi qua SMS',
              'Phí dịch vụ 500đ/tin',
              sendSMS,
              (val) =>
                  setState(() => sendSMS = val!),
            ),
            const SizedBox(height: 32),

            // --- CÁC NÚT HÀNH ĐỘNG ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () =>
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tính năng xuất PDF đang phát triển',
                        ),
                      ),
                    ),
                icon: const Icon(
                  Icons.download,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                label: const Text(
                  'Tải xuống PDF',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColors.primaryBlue,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _confirmAndSend,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'Gửi hóa đơn ngay',
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
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child: const Text(
                  'Chỉnh sửa lại',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptItem(
    String title,
    String subtitle,
    int amount,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${formatter.format(amount)}đ',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCheck(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        value: value,
        activeColor: AppColors.primaryBlue,
        checkColor: Colors.white,
        side: const BorderSide(
          color: AppColors.borderColor,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
