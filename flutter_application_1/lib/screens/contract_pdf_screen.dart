import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class ContractPdfScreen extends StatelessWidget {
  final Map<String, dynamic> contractData;

  const ContractPdfScreen({
    Key? key,
    required this.contractData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SetupData appData = SetupData();
    String roomName = contractData['room'] ?? '';
    String ownerName = appData.owner.isNotEmpty
        ? appData.owner.toUpperCase()
        : 'LÊ HOÀNG NAM';
    String tenantName =
        (contractData['name'] ?? '')
            .toUpperCase();
    String buildingName =
        appData.buildingName.isNotEmpty
        ? appData.buildingName
        : 'SkyView';

    return Scaffold(
      backgroundColor: const Color(
        0xFF2C323F,
      ), // Màu nền tối để tôn trang giấy trắng lên
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E232E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hợp đồng $roomName',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.ios_share,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Khu vực cuộn hiển thị trang A4
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 80,
              left: 16,
              right: 16,
            ),
            child: Column(
              children: [
                // --- TRANG 1 ---
                _buildA4Page(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Độc lập - Tự do - Hạnh phúc',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                        width: 150,
                        height: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'HỢP ĐỒNG THUÊ NHÀ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          fontFamily:
                              'Times New Roman',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '(Số: $roomName/2026/HĐTN-CH)',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontStyle:
                              FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 32),

                      const Align(
                        alignment:
                            Alignment.centerLeft,
                        child: Text(
                          'Hôm nay, ngày ... tháng ... năm ..., tại TP. Hà Nội, chúng tôi gồm:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // BÊN CHO THUÊ
                      Align(
                        alignment:
                            Alignment.centerLeft,
                        child: Text(
                          'BÊN CHO THUÊ (BÊN A):',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextLine(
                        'Ông/Bà: ',
                        ownerName,
                      ),
                      _buildTextLine(
                        'CCCD số: ',
                        '079192000xxx cấp ngày 15/06/2021',
                      ),
                      _buildTextLine(
                        'Địa chỉ: ',
                        appData.address.isNotEmpty
                            ? appData.address
                            : '123 Đường số 4, TP.HN',
                      ),
                      const SizedBox(height: 16),

                      // BÊN THUÊ
                      Align(
                        alignment:
                            Alignment.centerLeft,
                        child: Text(
                          'BÊN THUÊ (BÊN B):',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextLine(
                        'Ông/Bà: ',
                        tenantName,
                      ),
                      _buildTextLine(
                        'CCCD số: ',
                        contractData['cccd'] ??
                            'Đang cập nhật',
                      ),
                      _buildTextLine(
                        'Hộ khẩu thường trú: ',
                        contractData['address'] ??
                            'Đang cập nhật',
                      ),
                      const SizedBox(height: 24),

                      // ĐIỀU 1
                      Align(
                        alignment:
                            Alignment.centerLeft,
                        child: Text(
                          'ĐIỀU 1: ĐỐI TƯỢNG HỢP ĐỒNG',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment:
                            Alignment.centerLeft,
                        child: Text(
                          'Bên A đồng ý cho bên B thuê căn hộ số $roomName tại địa chỉ Chung cư $buildingName để sử dụng làm nơi ở.',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ), // Khoảng cách giữa các trang
                // --- TRANG 2 ---
                _buildA4Page(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ĐIỀU 3: TIỀN ĐẶT CỌC',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bên B đặt cọc cho bên A số tiền là ${contractData['deposit']} đồng ngay sau khi ký hợp đồng này.',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'ĐIỀU 4: QUYỀN VÀ NGHĨA VỤ CỦA CÁC BÊN',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '4.1. Bên B có trách nhiệm thanh toán tiền nhà đúng hạn vào ngày 05 hàng tháng.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '4.2. Bên B không được tự ý sửa đổi cấu trúc căn hộ khi chưa có sự đồng ý bằng văn bản của Bên A.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 40),
                      // Khung mờ "Các điều khoản pháp lý chi tiết tiếp theo..."
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey
                              .withOpacity(0.05),
                          border: Border.all(
                            color: Colors.grey
                                .withOpacity(0.2),
                            style:
                                BorderStyle.solid,
                          ),
                        ),
                        alignment:
                            Alignment.center,
                        child: Text(
                          'Các điều khoản pháp lý chi tiết tiếp theo...',
                          style: TextStyle(
                            color: Colors.grey
                                .withOpacity(0.5),
                            fontSize: 13,
                            fontStyle:
                                FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ), // Chỗ để chữ ký
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceAround,
                        children: const [
                          Text(
                            'BÊN A\n(Ký, ghi rõ họ tên)',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          Text(
                            'BÊN B\n(Ký, ghi rõ họ tên)',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Badge "Trang 1/5" nổi ở dưới cùng
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                    0.6,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Text(
                  'Trang 1/5',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Khung trang A4 Trắng
  Widget _buildA4Page({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        32,
      ), // Padding lề giấy A4
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Dòng text Bơm dữ liệu
  Widget _buildTextLine(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
