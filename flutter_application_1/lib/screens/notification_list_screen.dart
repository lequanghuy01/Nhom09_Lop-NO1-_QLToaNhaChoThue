import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class NotificationListScreen
    extends StatefulWidget {
  const NotificationListScreen({Key? key})
    : super(key: key);

  @override
  State<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends State<NotificationListScreen> {
  final SetupData appData = SetupData();
  String _selectedFilter = 'Tất cả';

  // Hàm tính toán thời gian (vd: 2 giờ trước)
  String _timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 0)
      return '${diff.inDays} ngày trước';
    if (diff.inHours > 0)
      return '${diff.inHours} giờ trước';
    if (diff.inMinutes > 0)
      return '${diff.inMinutes} phút trước';
    return 'Vừa xong';
  }

  // Cấu hình Icon và Màu sắc cho từng Nhãn
  Map<String, dynamic> _getCategoryStyle(
    String category,
  ) {
    switch (category) {
      case 'Tài chính':
        return {
          'icon': Icons.account_balance_wallet,
          'color': Colors.teal,
        };
      case 'Bảo trì':
        return {
          'icon': Icons.build,
          'color': Colors.orange,
        };
      case 'Hợp đồng':
        return {
          'icon': Icons.description,
          'color': Colors.pinkAccent,
        };
      default:
        return {
          'icon': Icons.info_outline,
          'color': AppColors.primaryBlue,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Lọc danh sách theo Tab
    List<Map<String, dynamic>> filteredList =
        appData.notifications.where((n) {
          if (_selectedFilter == 'Tất cả')
            return true;
          return n['category'] == _selectedFilter;
        }).toList();

    // 2. Phân loại theo HÔM NAY và HÔM QUA
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> todayList = [];
    List<Map<String, dynamic>> olderList = [];

    for (var n in filteredList) {
      DateTime time = n['time'];
      if (time.year == now.year &&
          time.month == now.month &&
          time.day == now.day) {
        todayList.add(n);
      } else {
        olderList.add(n);
      }
    }

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
          'Thông báo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // --- BỘ LỌC TABS ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              children:
                  [
                    'Tất cả',
                    'Tài chính',
                    'Bảo trì',
                    'Hợp đồng',
                  ].map((filter) {
                    bool isSelected =
                        _selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(
                        () => _selectedFilter =
                            filter,
                      ),
                      child: Container(
                        margin:
                            const EdgeInsets.only(
                              right: 12,
                            ),
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors
                                    .primaryBlue
                              : AppColors
                                    .cardBackground,
                          borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors
                                      .textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight
                                      .normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // --- DANH SÁCH THÔNG BÁO THEO THỜI GIAN ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (todayList.isNotEmpty) ...[
                    const Text(
                      'HÔM NAY',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...todayList
                        .map(
                          (n) =>
                              _buildNotificationCard(
                                n,
                              ),
                        )
                        .toList(),
                    const SizedBox(height: 16),
                  ],
                  if (olderList.isNotEmpty) ...[
                    const Text(
                      'HÔM QUA & CŨ HƠN',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...olderList
                        .map(
                          (n) =>
                              _buildNotificationCard(
                                n,
                              ),
                        )
                        .toList(),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> notif,
  ) {
    var style = _getCategoryStyle(
      notif['category'],
    );
    Color bgColor = style['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              style['icon'],
              color: bgColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
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
                        notif['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _timeAgo(notif['time']),
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notif['content'],
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
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
