import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'tenant_create_request_screen.dart';

class TenantRequestScreen extends StatefulWidget {
  const TenantRequestScreen({Key? key})
    : super(key: key);

  @override
  State<TenantRequestScreen> createState() =>
      _TenantRequestScreenState();
}

class _TenantRequestScreenState
    extends State<TenantRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data: Danh sách yêu cầu
  final List<Map<String, dynamic>> myRequests = [
    {
      'id': '#RQ1024',
      'category': 'SỬA ĐIỆN',
      'status': 'ĐANG THỰC HIỆN',
      'title': 'Thay bóng đèn phòng...',
      'desc':
          'Bóng đèn chùm chính bị cháy cần thợ đến thay thế gấp vì tối...',
      'date': '12/10/2023',
      'imageUrl':
          'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
      'statusColor': Colors.orangeAccent,
    },
    {
      'id': '#RQ1025',
      'category': 'SỬA NƯỚC',
      'status': 'CHỜ XỬ LÝ',
      'title': 'Rò rỉ vòi nước bồn rửa',
      'desc':
          'Vòi nước ở bếp bị rò rỉ liên tục gây lãng phí nước...',
      'date': '11/10/2023',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
      'statusColor': AppColors.textSecondary,
    },
    {
      'id': '#RQ1021',
      'category': 'INTERNET',
      'status': 'HOÀN THÀNH',
      'title': 'Mạng wifi chập chờn',
      'desc':
          'Mạng wifi không kết nối được từ phòng ngủ phía sau...',
      'date': '10/10/2023',
      'imageUrl':
          'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
      'statusColor': AppColors.successGreen,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Yêu cầu của tôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor:
              AppColors.textSecondary,
          indicatorColor: AppColors.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Chờ xử lý'),
            Tab(text: 'Đang thực hiện'),
            Tab(text: 'Hoàn thành'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList(
            myRequests,
          ), // Tab Tất cả
          _buildRequestList(
            myRequests
                .where(
                  (r) =>
                      r['status'] == 'CHỜ XỬ LÝ',
                )
                .toList(),
          ), // Tab Chờ xử lý
          _buildRequestList(
            myRequests
                .where(
                  (r) =>
                      r['status'] ==
                      'ĐANG THỰC HIỆN',
                )
                .toList(),
          ), // Tab Đang thực hiện
          _buildRequestList(
            myRequests
                .where(
                  (r) =>
                      r['status'] == 'HOÀN THÀNH',
                )
                .toList(),
          ), // Tab Hoàn thành
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const TenantCreateRequestScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildRequestList(
    List<Map<String, dynamic>> requests,
  ) {
    if (requests.isEmpty) {
      return const Center(
        child: Text(
          'Không có yêu cầu nào.',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: requests.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final req = requests[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Ảnh minh họa bên trái
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      req['imageUrl'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Thông tin bên phải
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
                        Text(
                          '${req['id']} • ${req['category']}',
                          style: const TextStyle(
                            color: AppColors
                                .primaryBlue,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                          decoration: BoxDecoration(
                            color:
                                req['statusColor']
                                    .withOpacity(
                                      0.1,
                                    ),
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                            border: Border.all(
                              color:
                                  req['statusColor']
                                      .withOpacity(
                                        0.5,
                                      ),
                            ),
                          ),
                          child: Text(
                            req['status'],
                            style: TextStyle(
                              color:
                                  req['statusColor'],
                              fontSize: 9,
                              fontWeight:
                                  FontWeight.bold,
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
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      req['desc'],
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .calendar_today,
                              color: AppColors
                                  .textSecondary,
                              size: 12,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
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
                        const Text(
                          'Chi tiết >',
                          style: TextStyle(
                            color: AppColors
                                .primaryBlue,
                            fontSize: 12,
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
        );
      },
    );
  }
}
