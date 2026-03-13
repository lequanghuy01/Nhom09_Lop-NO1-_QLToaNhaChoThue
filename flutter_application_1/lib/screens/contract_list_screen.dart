import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'create_contract_screen.dart'; // Import màn hình tạo hợp đồng
import 'contract_detail_screen.dart';

class ContractListScreen extends StatefulWidget {
  const ContractListScreen({Key? key})
    : super(key: key);

  @override
  State<ContractListScreen> createState() =>
      _ContractListScreenState();
}

class _ContractListScreenState
    extends State<ContractListScreen> {
  final SetupData appData = SetupData();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Đếm số lượng hợp đồng "Sắp hết hạn" để hiển thị Badge đỏ
    int expiringCount = appData.residents
        .where(
          (res) => res['status'] == 'Sắp hết hạn',
        )
        .length;

    return DefaultTabController(
      length: 4,
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
            'Quản lý hợp đồng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor:
                AppColors.textSecondary,
            tabs: [
              const Tab(text: 'Tất cả'),
              const Tab(text: 'Đang hiệu lực'),
              Tab(
                child: Row(
                  children: [
                    const Text('Sắp hết hạn'),
                    if (expiringCount > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding:
                            const EdgeInsets.all(
                              6,
                            ),
                        decoration:
                            const BoxDecoration(
                              color: Colors
                                  .redAccent,
                              shape:
                                  BoxShape.circle,
                            ),
                        child: Text(
                          '$expiringCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Tab(text: 'Đã thanh lý'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Thanh tìm kiếm
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (val) => setState(
                  () => _searchQuery = val,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Tìm theo tên, số phòng...',
                  hintStyle: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color:
                        AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor:
                      AppColors.inputBackground,
                  contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                  enabledBorder:
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              12,
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
                              12,
                            ),
                        borderSide:
                            const BorderSide(
                              color: AppColors
                                  .primaryBlue,
                            ),
                      ),
                ),
              ),
            ),

            // Nội dung các Tab
            Expanded(
              child: TabBarView(
                children: [
                  _buildContractList('Tất cả'),
                  _buildContractList(
                    'Đang hiệu lực',
                  ),
                  _buildContractList(
                    'Sắp hết hạn',
                  ),
                  _buildContractList(
                    'Đã thanh lý',
                  ), // Hiện tại chưa có luồng đẩy vào đây, nhưng cứ để sẵn
                ],
              ),
            ),
          ],
        ),

        // NÚT TẠO HỢP ĐỒNG NỔI (+)
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Mở màn hình tạo hợp đồng và chờ dữ liệu
            final newContract = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CreateContractScreen(),
              ),
            );

            if (newContract != null) {
              setState(() {
                appData.residents.insert(
                  0,
                  newContract,
                );
                if (appData.totalRooms >
                    appData.occupiedRooms)
                  appData.occupiedRooms++;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Tạo hợp đồng thành công!',
                  ),
                ),
              );
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

  // Hàm Lọc và hiển thị danh sách theo Tab
  Widget _buildContractList(String filterStatus) {
    List<Map<String, dynamic>>
    filteredList = appData.residents.where((res) {
      // Mặc định các resident cũ (nếu có) sẽ coi là "Đang hiệu lực"
      String status =
          res['status'] ?? 'Đang hiệu lực';

      bool matchStatus =
          filterStatus == 'Tất cả' ||
          status == filterStatus;
      bool matchSearch =
          (res['name'] ?? '')
              .toLowerCase()
              .contains(
                _searchQuery.toLowerCase(),
              ) ||
          (res['room'] ?? '')
              .toLowerCase()
              .contains(
                _searchQuery.toLowerCase(),
              );

      return matchStatus && matchSearch;
    }).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          'Không có hợp đồng nào',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return _buildContractCard(
          filteredList[index],
        );
      },
    );
  }

  // Giao diện Thẻ Hợp Đồng
  Widget _buildContractCard(
    Map<String, dynamic> data,
  ) {
    String status =
        data['status'] ?? 'Đang hiệu lực';
    Color statusColor = status == 'Sắp hết hạn'
        ? Colors.orange
        : (status == 'Đã thanh lý'
              ? AppColors.textSecondary
              : AppColors.successGreen);

    // ĐÃ THÊM GESTURE DETECTOR Ở ĐÂY ĐỂ BẤM VÀO ĐƯỢC THẺ
    return GestureDetector(
      onTap: () async {
        // Mở màn Chi tiết Hợp đồng và chờ tín hiệu trả về
        final needRefresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContractDetailScreen(
                  contractData: data,
                ),
          ),
        );

        // Nếu bên màn chi tiết bấm "Thanh lý", nó trả về true -> tải lại màn hình
        if (needRefresh == true) {
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.apartment,
                      color:
                          AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data['room'] ??
                          'Chưa gán phòng',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
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
                    color: statusColor
                        .withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(4),
                    border: Border.all(
                      color: statusColor,
                    ),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  data['name'] ?? '',
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: Divider(
                color: AppColors.borderColor,
                height: 1,
              ),
            ),
            _buildDetailRow(
              Icons.calendar_today,
              'Thời hạn',
              '${data['startDate'] ?? '01/01/2024'} - ${data['endDate'] ?? '01/01/2025'}',
              Colors.white,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.payments_outlined,
              'Giá thuê',
              '${data['rentPrice'] ?? '0'} đ/tháng',
              AppColors.primaryBlue,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons
                  .account_balance_wallet_outlined,
              'Tiền cọc',
              '${data['deposit'] ?? '0'} đ',
              Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color valueColor,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
