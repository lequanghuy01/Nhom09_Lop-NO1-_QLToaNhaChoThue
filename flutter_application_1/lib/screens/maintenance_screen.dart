import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({Key? key})
    : super(key: key);

  @override
  State<MaintenanceScreen> createState() =>
      _MaintenanceScreenState();
}

class _MaintenanceScreenState
    extends State<MaintenanceScreen> {
  final SetupData appData = SetupData();
  String _searchQuery = '';

  // --- HÀM 1: PHÂN CÔNG KỸ THUẬT ---
  void _assignTechnician(
    Map<String, dynamic> req,
  ) {
    TextEditingController techCtrl =
        TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Phân công kỹ thuật',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: techCtrl,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText:
                'Nhập tên thợ (VD: Anh Nam thợ điện)',
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
              borderSide: BorderSide.none,
            ),
          ),
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
              if (techCtrl.text.trim().isEmpty)
                return;
              setState(() {
                req['status'] = 'Đang thực hiện';
                req['technician'] = techCtrl.text
                    .trim();
                // Bắn log vào Cái Chuông
                appData.notifications.insert(0, {
                  'title': 'Đã phân công thợ',
                  'content':
                      'Đã phân công ${req['technician']} xử lý sự cố tại ${req['room']}.',
                  'category': 'Bảo trì',
                  'time': DateTime.now(),
                });
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Đã phân công thành công!',
                  ),
                ),
              );
            },
            child: const Text(
              'Xác nhận',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HÀM 2: ĐÁNH DẤU HOÀN THÀNH & CHỐT PHÍ ---
  void _completeRequest(
    Map<String, dynamic> req,
  ) {
    TextEditingController costCtrl =
        TextEditingController(text: '0');
    String selectedPayer = 'Chủ nhà'; // Mặc định

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor:
                AppColors.cardBackground,
            title: const Text(
              'Nghiệm thu & Chốt phí',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng chi phí sửa chữa (VNĐ)',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: costCtrl,
                  keyboardType:
                      TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        AppColors.inputBackground,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            8,
                          ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ai là người chịu phí?',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                RadioListTile(
                  title: const Text(
                    'Chủ nhà (Hao mòn tự nhiên)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  value: 'Chủ nhà',
                  groupValue: selectedPayer,
                  activeColor:
                      AppColors.primaryBlue,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) =>
                      setDialogState(
                        () => selectedPayer = val
                            .toString(),
                      ),
                ),
                RadioListTile(
                  title: const Text(
                    'Khách thuê (Làm hỏng)',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 13,
                    ),
                  ),
                  value: 'Khách thuê',
                  groupValue: selectedPayer,
                  activeColor:
                      AppColors.primaryBlue,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) =>
                      setDialogState(
                        () => selectedPayer = val
                            .toString(),
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
                    color:
                        AppColors.textSecondary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.successGreen,
                ),
                onPressed: () {
                  setState(() {
                    req['status'] = 'Hoàn thành';
                    req['cost'] =
                        int.tryParse(
                          costCtrl.text,
                        ) ??
                        0;
                    req['payer'] = selectedPayer;
                    // Bắn log vào Cái Chuông
                    appData.notifications.insert(
                      0,
                      {
                        'title':
                            'Sửa chữa hoàn tất',
                        'content':
                            'Sự cố tại ${req['room']} đã xử lý xong. Chi phí: ${costCtrl.text}đ ($selectedPayer chịu).',
                        'category': 'Bảo trì',
                        'time': DateTime.now(),
                      },
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Đã hoàn thành yêu cầu!',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Chốt sổ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- HÀM 3: TẠO MỚI YÊU CẦU (Thay cho Khách thuê) ---
  void _createNewRequest() {
    TextEditingController roomCtrl =
        TextEditingController();
    TextEditingController titleCtrl =
        TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Tạo Yêu cầu mới',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roomCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Phòng (VD: P.101)',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Nội dung sự cố',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    appData.maintenanceRequests
                        .insert(0, {
                          'id': 'REQ004',
                          'room': roomCtrl.text,
                          'title': titleCtrl.text,
                          'description':
                              'Chủ trọ tự ghi nhận.',
                          'date': DateFormat(
                            'HH:mm, dd/MM/yyyy',
                          ).format(DateTime.now()),
                          'priority':
                              'BÌNH THƯỜNG',
                          'status': 'Chờ xử lý',
                          'technician': '',
                          'cost': 0,
                          'payer': '',
                        });
                    appData.notifications.insert(
                      0,
                      {
                        'title':
                            'Yêu cầu bảo trì mới',
                        'content':
                            'Yêu cầu từ ${roomCtrl.text}: ${titleCtrl.text}',
                        'category': 'Bảo trì',
                        'time': DateTime.now(),
                      },
                    );
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryBlue,
                ),
                child: const Text(
                  'Thêm yêu cầu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Đếm số lượng chờ xử lý để làm Badge đỏ
    int pendingCount = appData.maintenanceRequests
        .where((r) => r['status'] == 'Chờ xử lý')
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
            'Yêu cầu & Bảo trì',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor:
                AppColors.textSecondary,
            tabs: [
              const Tab(text: 'Tất cả'),
              Tab(
                child: Row(
                  children: [
                    const Text('Chờ xử lý'),
                    if (pendingCount > 0) ...[
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
                          '$pendingCount',
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
              const Tab(text: 'Đang thực hiện'),
              const Tab(text: 'Hoàn thành'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (val) => setState(
                  () => _searchQuery = val,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Tìm theo mã yêu cầu hoặc số phòng...',
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
            Expanded(
              child: TabBarView(
                children: [
                  _buildList('Tất cả'),
                  _buildList('Chờ xử lý'),
                  _buildList('Đang thực hiện'),
                  _buildList('Hoàn thành'),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton:
            FloatingActionButton(
              onPressed: _createNewRequest,
              backgroundColor:
                  AppColors.primaryBlue,
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
        appData.maintenanceRequests.where((req) {
          bool matchFilter =
              filter == 'Tất cả' ||
              req['status'] == filter;
          bool matchSearch =
              req['room']
                  .toString()
                  .toLowerCase()
                  .contains(
                    _searchQuery.toLowerCase(),
                  ) ||
              req['title']
                  .toString()
                  .toLowerCase()
                  .contains(
                    _searchQuery.toLowerCase(),
                  );
          return matchFilter && matchSearch;
        }).toList();

    if (filteredList.isEmpty)
      return const Center(
        child: Text(
          'Không có dữ liệu',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      itemCount: filteredList.length,
      itemBuilder: (context, index) =>
          _buildRequestCard(filteredList[index]),
    );
  }

  Widget _buildRequestCard(
    Map<String, dynamic> req,
  ) {
    // Config màu sắc ưu tiên
    Color priorityColor = Colors.grey;
    if (req['priority'] == 'KHẨN CẤP')
      priorityColor = Colors.redAccent;
    if (req['priority'] == 'TRUNG BÌNH')
      priorityColor = Colors.orange;
    if (req['priority'] == 'BÌNH THƯỜNG')
      priorityColor = Colors.blueGrey;

    return Container(
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
              Text(
                req['room'],
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                decoration: BoxDecoration(
                  color: priorityColor
                      .withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(4),
                ),
                child: Text(
                  req['priority'],
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            req['title'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      AppColors.inputBackground,
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: AppColors
                              .textSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          req['date'],
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      req['description'],
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // KHU VỰC NÚT BẤM DỰA VÀO TRẠNG THÁI
          if (req['status'] == 'Chờ xử lý')
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _assignTechnician(req),
                icon: const Icon(
                  Icons.engineering,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  'Phân công kỹ thuật',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          else if (req['status'] ==
              'Đang thực hiện')
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.orange,
                      size: 10,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Đang thực hiện - Kỹ thuật: ${req['technician']}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _completeRequest(req),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color:
                          AppColors.successGreen,
                      size: 18,
                    ),
                    label: const Text(
                      'Đánh dấu hoàn thành',
                      style: TextStyle(
                        color: AppColors
                            .successGreen,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors
                            .successGreen,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                              8,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (req['status'] == 'Hoàn thành')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.successGreen
                    .withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: AppColors
                            .successGreen,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Đã hoàn thành',
                        style: TextStyle(
                          color: AppColors
                              .successGreen,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chi phí: ${NumberFormat('#,###', 'vi_VN').format(req['cost'])}đ (${req['payer']})',
                    style: const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
