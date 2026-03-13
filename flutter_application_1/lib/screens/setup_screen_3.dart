import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart'; // Import Balo
import 'setup_screen_3_1.dart';
import 'setup_screen_4.dart';

class SetupScreen3 extends StatefulWidget {
  final SetupData setupData; // Nhận balo
  const SetupScreen3({
    Key? key,
    required this.setupData,
  }) : super(key: key);

  @override
  State<SetupScreen3> createState() =>
      _SetupScreen3State();
}

class _SetupScreen3State
    extends State<SetupScreen3> {
  final TextEditingController
  _defaultPriceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load dữ liệu cũ nếu đã nhập (khi ấn back từ màn 4 về)
    _defaultPriceController.text =
        widget.setupData.defaultPrice.isNotEmpty
        ? widget.setupData.defaultPrice
        : '5000000';

    // Khởi tạo dịch vụ mặc định nếu balo đang trống
    if (widget.setupData.services.isEmpty) {
      widget.setupData.services = [
        ServiceModel(
          name: 'Điện',
          price: '3500',
          unit: 'VND/kWh',
          icon: Icons.bolt,
        ),
        ServiceModel(
          name: 'Nước',
          price: '20000',
          unit: 'VND/m³',
          icon: Icons.water_drop_outlined,
        ),
        ServiceModel(
          name: 'Phí vệ sinh',
          price: '50000',
          unit: 'VND/tháng',
          icon: Icons.cleaning_services_outlined,
        ),
        ServiceModel(
          name: 'Phí gửi xe',
          price: '100000',
          unit: 'VND/xe',
          icon: Icons.motorcycle_outlined,
        ),
      ];
    }
  }

  // Hàm mở Dialog thêm dịch vụ
  void _showAddServiceDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final unitCtrl = TextEditingController(
      text: 'VND/tháng',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Thêm dịch vụ mới',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText:
                    'Tên dịch vụ (VD: Wifi)',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Giá tiền (VD: 100000)',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: unitCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText:
                    'Đơn vị (VD: VND/phòng)',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
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
              backgroundColor:
                  AppColors.primaryBlue,
            ),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty &&
                  priceCtrl.text.isNotEmpty) {
                setState(() {
                  widget.setupData.services.add(
                    ServiceModel(
                      name: nameCtrl.text,
                      price: priceCtrl.text,
                      unit: unitCtrl.text,
                      icon: Icons
                          .add_circle_outline,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Thêm',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
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
          'Thiết lập',
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
                    // Cập nhật giá mặc định vào balo và đi tiếp
                    widget
                            .setupData
                            .defaultPrice =
                        _defaultPriceController
                            .text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SetupScreen4(
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
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Tiếp theo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
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
              'Giá thuê & Dịch vụ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thiết lập giá thuê cơ bản và các chi phí dịch vụ định kỳ cho tòa nhà của bạn.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // KHỐI GIÁ MẶC ĐỊNH
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
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(
                              8,
                            ),
                        decoration: BoxDecoration(
                          color: AppColors
                              .primaryBlue
                              .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        child: const Icon(
                          Icons.payments,
                          color: AppColors
                              .primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: const [
                          Text(
                            'Giá thuê mặc định',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Áp dụng cho các phòng chưa có giá riêng',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mức giá thuê (VND/tháng)',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller:
                        _defaultPriceController,
                    keyboardType:
                        TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      suffixText: 'đ',
                      suffixStyle:
                          const TextStyle(
                            color: AppColors
                                .textSecondary,
                          ),
                      filled: true,
                      fillColor: AppColors
                          .inputBackground,
                      contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                      enabledBorder:
                          OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  8,
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
                                  8,
                                ),
                            borderSide:
                                const BorderSide(
                                  color: AppColors
                                      .primaryBlue,
                                ),
                          ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: Divider(
                      color:
                          AppColors.borderColor,
                      height: 1,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // Ném balo sang Màn 3.1
                      widget
                              .setupData
                              .defaultPrice =
                          _defaultPriceController
                              .text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SetupScreen31(
                                setupData: widget
                                    .setupData,
                              ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.tune,
                              color: AppColors
                                  .primaryBlue,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tùy chỉnh giá riêng cho từng phòng',
                              style: TextStyle(
                                color: AppColors
                                    .primaryBlue,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors
                              .textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // KHỐI DỊCH VỤ
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
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(
                              8,
                            ),
                        decoration: BoxDecoration(
                          color: AppColors
                              .successGreen
                              .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: AppColors
                              .successGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: const [
                          Text(
                            'Giá dịch vụ hàng tháng',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Chi phí điện, nước và tiện ích khác',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Render danh sách dịch vụ động
                  ...widget.setupData.services.map((
                    service,
                  ) {
                    TextEditingController
                    priceCtrl =
                        TextEditingController(
                          text: service.price,
                        );
                    priceCtrl.addListener(
                      () => service.price =
                          priceCtrl.text,
                    ); // Cập nhật ngược lại model

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                            bottom: 12,
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
                              Row(
                                children: [
                                  Icon(
                                    service.icon,
                                    color: AppColors
                                        .textSecondary,
                                    size: 16,
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
                                          13,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => setState(
                                  () => widget
                                      .setupData
                                      .services
                                      .remove(
                                        service,
                                      ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors
                                      .textSecondary,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 48,
                            child: TextField(
                              controller:
                                  priceCtrl,
                              keyboardType:
                                  TextInputType
                                      .number,
                              style:
                                  const TextStyle(
                                    color: Colors
                                        .white,
                                  ),
                              decoration: InputDecoration(
                                suffixText:
                                    service.unit,
                                suffixStyle:
                                    const TextStyle(
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                filled: true,
                                fillColor: AppColors
                                    .inputBackground,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                      horizontal:
                                          12,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        8,
                                      ),
                                  borderSide: const BorderSide(
                                    color: AppColors
                                        .borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        8,
                                      ),
                                  borderSide: const BorderSide(
                                    color: AppColors
                                        .primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed:
                          _showAddServiceDialog,
                      icon: const Icon(
                        Icons.add,
                        color:
                            AppColors.primaryBlue,
                        size: 18,
                      ),
                      label: const Text(
                        'Thêm loại dịch vụ khác',
                        style: TextStyle(
                          color: AppColors
                              .primaryBlue,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors
                              .borderColor,
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
      ),
    );
  }
}
