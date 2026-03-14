import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class TenantNotificationScreen
    extends StatefulWidget {
  const TenantNotificationScreen({Key? key})
    : super(key: key);

  @override
  State<TenantNotificationScreen> createState() =>
      _TenantNotificationScreenState();
}

class _TenantNotificationScreenState
    extends State<TenantNotificationScreen> {
  // --- MOCK DATA: DỮ LIỆU GIẢ LẬP CHO KHÁCH THUÊ ---
  List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "Hóa đơn tháng này đã có!",
      "message":
          "Bạn có hóa đơn mới tháng 03/2026 với số tiền 2.540.000 VNĐ. Vui lòng thanh toán trước ngày 05/04/2026.",
      "time": "10:30 - Hôm nay",
      "type": "invoice",
      "isRead": false,
    },
    {
      "id": 2,
      "title": "Thông báo bảo trì thang máy",
      "message":
          "Ban quản lý xin thông báo: Thang máy số 1 sẽ được bảo trì định kỳ từ 14:00 đến 16:00 chiều nay. Mong quý cư dân thông cảm.",
      "time": "08:15 - Hôm nay",
      "type": "system",
      "isRead": false,
    },
    {
      "id": 3,
      "title": "Yêu cầu sửa chữa đã hoàn thành",
      "message":
          "Kỹ thuật viên đã hoàn tất việc thay bóng đèn phòng khách cho căn hộ P.101 của bạn. Vui lòng đánh giá dịch vụ.",
      "time": "15:20 - Hôm qua",
      "type": "maintenance",
      "isRead": true,
    },
    {
      "id": 4,
      "title": "Nhắc nhở nội quy",
      "message":
          "Kính đề nghị cư dân không để rác thải sinh hoạt ngoài hành lang gây mất vệ sinh chung. Xin cảm ơn!",
      "time": "09:00 - 10/03/2026",
      "type": "warning",
      "isRead": true,
    },
  ];

  // Hàm đánh dấu tất cả đã đọc (Mock logic)
  void _markAllAsRead() {
    setState(() {
      for (var note in notifications) {
        note['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã đánh dấu tất cả là đã đọc!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách thông báo chưa đọc
    final unreadNotifications = notifications
        .where((n) => n['isRead'] == false)
        .toList();

    return DefaultTabController(
      length: 2, // 2 Tabs: Tất cả & Chưa đọc
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor:
              AppColors.cardBackground,
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
            'Thông báo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // Nút "Đánh dấu tất cả đã đọc"
            IconButton(
              icon: const Icon(
                Icons.checklist_rtl,
                color: AppColors.primaryBlue,
              ),
              tooltip: 'Đánh dấu đã đọc',
              onPressed: _markAllAsRead,
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primaryBlue,
            indicatorWeight: 3,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor:
                AppColors.textSecondary,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Chưa đọc'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Tất cả
            _buildNotificationList(notifications),
            // Tab 2: Chưa đọc
            _buildNotificationList(
              unreadNotifications,
            ),
          ],
        ),
      ),
    );
  }

  // Hàm dựng danh sách (ListView)
  Widget _buildNotificationList(
    List<Map<String, dynamic>> listData,
  ) {
    if (listData.isEmpty) {
      return const Center(
        child: Text(
          'Không có thông báo nào.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      itemCount: listData.length,
      separatorBuilder: (context, index) =>
          const Divider(
            color: AppColors.borderColor,
            height: 1,
            indent:
                72, // Canh lề cho đẹp (bỏ qua icon)
          ),
      itemBuilder: (context, index) {
        final item = listData[index];
        return _buildNotificationItem(item);
      },
    );
  }

  // Hàm dựng từng dòng thông báo (Item)
  Widget _buildNotificationItem(
    Map<String, dynamic> item,
  ) {
    final bool isRead = item['isRead'];

    // Chọn Icon và Màu sắc tùy theo loại thông báo
    IconData iconData;
    Color iconColor;

    switch (item['type']) {
      case 'invoice':
        iconData = Icons.receipt_long;
        iconColor = Colors.blueAccent;
        break;
      case 'maintenance':
        iconData = Icons.build_circle;
        iconColor = Colors.orangeAccent;
        break;
      case 'warning':
        iconData = Icons.warning_amber_rounded;
        iconColor = Colors.redAccent;
        break;
      default:
        iconData = Icons.campaign;
        iconColor = Colors.tealAccent;
    }

    return InkWell(
      onTap: () {
        // Khi click vào thì chuyển trạng thái thành đã đọc
        setState(() {
          item['isRead'] = true;
        });
        // Ở đây sếp có thể code thêm logic chuyển trang chi tiết (ví dụ nhảy sang màn hóa đơn)
      },
      child: Container(
        color: isRead
            ? Colors.transparent
            : AppColors.primaryBlue.withOpacity(
                0.05,
              ), // Nền hơi sáng nếu chưa đọc
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- Icon ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(
                  0.15,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // --- Nội dung ---
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['title'],
                          style: TextStyle(
                            color: isRead
                                ? Colors.white70
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: isRead
                                ? FontWeight
                                      .normal
                                : FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis,
                        ),
                      ),
                      if (!isRead)
                        Container(
                          margin:
                              const EdgeInsets.only(
                                left: 8,
                              ),
                          width: 8,
                          height: 8,
                          decoration:
                              const BoxDecoration(
                                color: AppColors
                                    .primaryBlue,
                                shape: BoxShape
                                    .circle,
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['message'],
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['time'],
                    style: TextStyle(
                      color: AppColors
                          .textSecondary
                          .withOpacity(0.6),
                      fontSize: 12,
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
