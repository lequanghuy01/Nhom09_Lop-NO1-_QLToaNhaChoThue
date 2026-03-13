import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class TenantCreateRequestScreen
    extends StatefulWidget {
  const TenantCreateRequestScreen({Key? key})
    : super(key: key);

  @override
  State<TenantCreateRequestScreen>
  createState() =>
      _TenantCreateRequestScreenState();
}

class _TenantCreateRequestScreenState
    extends State<TenantCreateRequestScreen> {
  int _selectedCategory =
      0; // 0: Điện, 1: Nước, 2: Nội thất, 3: Khác
  bool _isUrgent = false;
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Vui lòng nhập mô tả sự cố!',
          ),
        ),
      );
      return;
    }

    // Giả lập gửi thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.successGreen,
        content: Text(
          'Đã gửi yêu cầu thành công! Ban quản lý sẽ sớm xử lý.',
        ),
      ),
    );
    Navigator.pop(context);
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
          'Tạo yêu cầu mới',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- 1. DANH MỤC SỰ CỐ ---
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'DANH MỤC SỰ CỐ',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  'Bắt buộc',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.6,
              children: [
                _buildCategoryItem(
                  0,
                  'Điện',
                  Icons.bolt,
                ),
                _buildCategoryItem(
                  1,
                  'Nước',
                  Icons.water_drop_outlined,
                ),
                _buildCategoryItem(
                  2,
                  'Nội thất',
                  Icons.chair_outlined,
                ),
                _buildCategoryItem(
                  3,
                  'Khác',
                  Icons.more_horiz,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- 2. MÔ TẢ CHI TIẾT ---
            const Text(
              'MÔ TẢ CHI TIẾT SỰ CỐ',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              maxLines: 5,
              maxLength: 500,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText:
                    'Vui lòng mô tả chi tiết tình trạng bạn đang gặp phải...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor:
                    AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                counterStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 3. HÌNH ẢNH MINH HỌA ---
            const Text(
              'HÌNH ẢNH MINH HỌA',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Nút Thêm ảnh (Viền đứt nét)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        AppColors.inputBackground,
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors
                          .textSecondary
                          .withOpacity(0.5),
                      style: BorderStyle.solid,
                    ),
                  ), // Viền đứt nét trong Flutter hơi phức tạp, dùng viền solid mờ cho nhẹ app
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors
                            .textSecondary,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Thêm ảnh',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Ảnh Easter Egg
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://i.pravatar.cc/150?img=11',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding:
                            const EdgeInsets.all(
                              2,
                            ),
                        decoration:
                            const BoxDecoration(
                              color:
                                  Colors.black54,
                              shape:
                                  BoxShape.circle,
                            ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Ô trống
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        AppColors.inputBackground,
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors
                          .textSecondary
                          .withOpacity(0.2),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --- 4. YÊU CẦU KHẨN CẤP ---
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isUrgent,
                    onChanged: (val) => setState(
                      () => _isUrgent =
                          val ?? false,
                    ),
                    activeColor:
                        AppColors.primaryBlue,
                    side: const BorderSide(
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Yêu cầu khẩn cấp',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _submitRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Gửi yêu cầu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Nút Danh mục
  Widget _buildCategoryItem(
    int index,
    String title,
    IconData icon,
  ) {
    bool isSelected = _selectedCategory == index;
    return GestureDetector(
      onTap: () => setState(
        () => _selectedCategory = index,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(
                  0.1,
                )
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.textSecondary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primaryBlue,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
