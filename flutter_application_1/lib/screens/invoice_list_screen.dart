import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'create_invoice_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({Key? key})
    : super(key: key);

  @override
  State<InvoiceListScreen> createState() =>
      _InvoiceListScreenState();
}

class _InvoiceListScreenState
    extends State<InvoiceListScreen> {
  final SetupData appData = SetupData();
  final formatter = NumberFormat(
    '#,###',
    'vi_VN',
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.pop(context),
          ),
          title: const Text(
            'Quản lý hóa đơn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.tune,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor:
                AppColors.textSecondary,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Chưa thanh toán'),
              Tab(text: 'Đã thanh toán'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                8,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'Danh sách hóa đơn',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tháng ${DateFormat('MM/yyyy').format(DateTime.now())}',
                    style: const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList('Tất cả'),
                  _buildList('Chưa thanh toán'),
                  _buildList(
                    'Đã thanh toán',
                  ), // (Đã thu)
                ],
              ),
            ),
          ],
        ),
        // Nút (+) Tạo mới hóa đơn
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Mở màn hình Tạo Hóa Đơn, đợi nếu có hóa đơn mới tạo thì refresh lại màn này
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CreateInvoiceScreen(),
              ),
            );
            if (result == true) {
              setState(() {});
            }
          },
          backgroundColor: AppColors.primaryBlue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildList(String filter) {
    List<Map<String, dynamic>> filteredList =
        appData.invoices.where((inv) {
          if (filter == 'Tất cả') return true;
          return inv['status'] == filter;
        }).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có hóa đơn nào',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
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
            border: Border.all(
              color: AppColors.borderColor
                  .withOpacity(0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue
                          .withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color:
                          AppColors.primaryBlue,
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
                          '${inv['room']} - ${inv['residentName']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'THÁNG ${inv['monthStr']}',
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                    decoration: BoxDecoration(
                      color: isUnpaid
                          ? Colors.redAccent
                                .withOpacity(0.15)
                          : AppColors.successGreen
                                .withOpacity(
                                  0.15,
                                ),
                      borderRadius:
                          BorderRadius.circular(
                            6,
                          ),
                      border: Border.all(
                        color: isUnpaid
                            ? Colors.redAccent
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
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Divider(
                  color: AppColors.borderColor,
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'Tổng cộng',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${formatter.format(inv['totalAmount'])} ',
                          style: const TextStyle(
                            color: AppColors
                                .primaryBlue,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: 'VNĐ',
                          style: TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
