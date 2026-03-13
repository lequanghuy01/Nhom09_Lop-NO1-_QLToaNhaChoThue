import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'edit_price_service_screen.dart'; // Import màn hình sửa

class PriceServiceScreen extends StatefulWidget {
  const PriceServiceScreen({Key? key})
    : super(key: key);

  @override
  State<PriceServiceScreen> createState() =>
      _PriceServiceScreenState();
}

class _PriceServiceScreenState
    extends State<PriceServiceScreen> {
  final SetupData appData = SetupData();

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
          'Giá thuê & Dịch vụ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              // Mở luồng Chỉnh sửa. Đợi khi sửa xong quay lại thì Refresh trang
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EditPriceServiceScreen(),
                ),
              );
              setState(() {});
            },
            child: const Text(
              'Chỉnh sửa',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
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
            // --- 1. GIÁ THUÊ MẶC ĐỊNH ---
            const Text(
              'GIÁ THUÊ MẶC ĐỊNH',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryBlue
                      .withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color:
                            AppColors.primaryBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${appData.defaultPrice} đ',
                        style: const TextStyle(
                          color: AppColors
                              .primaryBlue,
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Áp dụng chung cho các phòng chưa có giá riêng.',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 2. BẢNG GIÁ DỊCH VỤ ---
            const Text(
              'DỊCH VỤ HÀNG THÁNG',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: appData.services.isEmpty
                  ? const Text(
                      'Chưa có dịch vụ nào được thiết lập.',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontStyle:
                            FontStyle.italic,
                      ),
                    )
                  : Column(
                      children: appData.services.asMap().entries.map((
                        entry,
                      ) {
                        int index = entry.key;
                        ServiceModel svc =
                            entry.value;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      svc.icon,
                                      color: AppColors
                                          .textSecondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      svc.name,
                                      style: const TextStyle(
                                        color: Colors
                                            .white,
                                        fontSize:
                                            15,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${svc.price} ${svc.unit}',
                                  style: const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                            if (index <
                                appData
                                        .services
                                        .length -
                                    1)
                              const Padding(
                                padding:
                                    EdgeInsets.symmetric(
                                      vertical:
                                          12,
                                    ),
                                child: Divider(
                                  color: AppColors
                                      .borderColor,
                                  height: 1,
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 24),

            // --- 3. TÙY CHỈNH GIÁ RIÊNG TỪNG PHÒNG ---
            const Text(
              'CHI TIẾT GIÁ TỪNG PHÒNG',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...appData.floors.map((floor) {
              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.layers,
                          color: AppColors
                              .primaryBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          floor.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...floor.rooms.map((room) {
                    bool isCustom = room
                        .customPrice
                        .isNotEmpty;
                    return Container(
                      margin:
                          const EdgeInsets.only(
                            bottom: 8,
                          ),
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .cardBackground,
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
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                room.name,
                                style: const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              if (room
                                  .area
                                  .isNotEmpty) ...[
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  room.area,
                                  style: const TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          // ĐIỂM NHẤN: Nếu có giá riêng thì in đậm màu Xanh, không thì in mờ "Mặc định"
                          isCustom
                              ? Text(
                                  '${room.customPrice} đ',
                                  style: const TextStyle(
                                    color: AppColors
                                        .primaryBlue,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                )
                              : const Text(
                                  'Mặc định',
                                  style: TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 14,
                                    fontStyle:
                                        FontStyle
                                            .italic,
                                  ),
                                ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
