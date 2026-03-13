import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'edit_room_price_screen.dart'; // Import màn hình sửa giá phòng (bước 2)

class EditPriceServiceScreen
    extends StatefulWidget {
  const EditPriceServiceScreen({Key? key})
    : super(key: key);

  @override
  State<EditPriceServiceScreen> createState() =>
      _EditPriceServiceScreenState();
}

class _EditPriceServiceScreenState
    extends State<EditPriceServiceScreen> {
  final SetupData appData = SetupData();
  final TextEditingController _defaultPriceCtrl =
      TextEditingController();

  // Danh sách chứa các ô nhập liệu Dịch vụ
  List<Map<String, dynamic>> _serviceControllers =
      [];

  @override
  void initState() {
    super.initState();
    _defaultPriceCtrl.text = appData.defaultPrice;
    // Bơm dữ liệu dịch vụ cũ vào các ô nhập
    for (var svc in appData.services) {
      _serviceControllers.add({
        'nameCtrl': TextEditingController(
          text: svc.name,
        ),
        'priceCtrl': TextEditingController(
          text: svc.price,
        ),
        'unitCtrl': TextEditingController(
          text: svc.unit,
        ),
        'icon': svc.icon,
      });
    }
  }

  void _addService() {
    setState(() {
      _serviceControllers.add({
        'nameCtrl': TextEditingController(),
        'priceCtrl': TextEditingController(),
        'unitCtrl': TextEditingController(
          text: 'VND/tháng',
        ),
        'icon':
            Icons.star_border, // Icon mặc định
      });
    });
  }

  void _removeService(int index) {
    setState(
      () => _serviceControllers.removeAt(index),
    );
  }

  void _goToNextStep() {
    // 1. Lưu Giá mặc định
    appData.defaultPrice = _defaultPriceCtrl.text
        .trim();
    // 2. Lưu danh sách Dịch vụ mới
    appData.services.clear();
    for (var sc in _serviceControllers) {
      if (sc['nameCtrl'].text.trim().isNotEmpty) {
        appData.services.add(
          ServiceModel(
            name: sc['nameCtrl'].text.trim(),
            price: sc['priceCtrl'].text.trim(),
            unit: sc['unitCtrl'].text.trim(),
            icon: sc['icon'],
          ),
        );
      }
    }
    // 3. Chuyển sang màn hình Tùy chỉnh giá phòng (Bước 2)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EditRoomPriceScreen(),
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
          'Thiết lập Dịch vụ',
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
            const Text(
              'Giá thuê & Dịch vụ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
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

            // KHỐI 1: GIÁ MẶC ĐỊNH
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
                    children: const [
                      Icon(
                        Icons.monetization_on,
                        color:
                            AppColors.primaryBlue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Giá thuê mặc định',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
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
                    controller: _defaultPriceCtrl,
                    keyboardType:
                        TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhập số tiền',
                      hintStyle: const TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors
                          .inputBackground,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              8,
                            ),
                        borderSide:
                            BorderSide.none,
                      ),
                      suffixText: 'đ',
                      suffixStyle:
                          const TextStyle(
                            color: AppColors
                                .textSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // KHỐI 2: DỊCH VỤ
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
                    children: const [
                      Icon(
                        Icons.receipt_long,
                        color: AppColors
                            .successGreen,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Giá dịch vụ hàng tháng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // In ra danh sách các ô nhập
                  ..._serviceControllers.asMap().entries.map((
                    entry,
                  ) {
                    int idx = entry.key;
                    var sc = entry.value;
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                            bottom: 20,
                          ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                sc['icon'],
                                color: AppColors
                                    .textSecondary,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: TextField(
                                  controller:
                                      sc['nameCtrl'],
                                  style: const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Tên dịch vụ (VD: Điện)',
                                    hintStyle: TextStyle(
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                    isDense: true,
                                    border:
                                        InputBorder
                                            .none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors
                                      .redAccent,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    _removeService(
                                      idx,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller:
                                      sc['priceCtrl'],
                                  keyboardType:
                                      TextInputType
                                          .number,
                                  style: const TextStyle(
                                    color: Colors
                                        .white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Giá tiền',
                                    filled: true,
                                    fillColor:
                                        AppColors
                                            .inputBackground,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                            8,
                                          ),
                                      borderSide:
                                          BorderSide
                                              .none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller:
                                      sc['unitCtrl'],
                                  style: const TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        AppColors
                                            .inputBackground,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                            8,
                                          ),
                                      borderSide:
                                          BorderSide
                                              .none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Nút thêm dịch vụ
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _addService,
                      icon: const Icon(
                        Icons.add,
                        color:
                            AppColors.primaryBlue,
                      ),
                      label: const Text(
                        'Thêm loại dịch vụ khác',
                        style: TextStyle(
                          color: AppColors
                              .primaryBlue,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors
                              .primaryBlue
                              .withOpacity(0.5),
                          style:
                              BorderStyle.solid,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                      ),
                    ),
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
        child: ElevatedButton(
          onPressed: _goToNextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
          ),
          child: const Text(
            'Xác Nhận ->',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
