import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ChangePasswordScreen
    extends StatefulWidget {
  const ChangePasswordScreen({Key? key})
    : super(key: key);

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  // Các bộ điều khiển Text
  final _currentPassCtrl =
      TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl =
      TextEditingController();

  // Trạng thái Ẩn/Hiện mật khẩu (Mặc định là Ẩn - true)
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Trạng thái Loading khi bấm nút
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  // Hàm xử lý Logic Cập nhật mật khẩu
  Future<void> _updatePassword() async {
    // 1. Thu thập dữ liệu
    String currentPass = _currentPassCtrl.text
        .trim();
    String newPass = _newPassCtrl.text.trim();
    String confirmPass = _confirmPassCtrl.text
        .trim();

    // 2. Validate (Kiểm tra lỗi)
    if (currentPass.isEmpty ||
        newPass.isEmpty ||
        confirmPass.isEmpty) {
      _showError(
        'Vui lòng điền đầy đủ tất cả các trường!',
      );
      return;
    }
    if (newPass.length < 8) {
      _showError(
        'Mật khẩu mới phải chứa ít nhất 8 ký tự!',
      );
      return;
    }
    if (newPass != confirmPass) {
      _showError('Xác nhận mật khẩu không khớp!');
      return;
    }
    if (currentPass == newPass) {
      _showError(
        'Mật khẩu mới không được trùng với mật khẩu cũ!',
      );
      return;
    }

    // 3. Giả lập gọi API đổi pass
    setState(() => _isLoading = true);
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Xoay 1 giây cho xịn
    setState(() => _isLoading = false);

    // 4. Thành công & Quay về
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.successGreen,
        content: Text(
          'Cập nhật mật khẩu thành công!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  // Hàm hiện lỗi
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
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
          'Đổi mật khẩu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- 1. ICON VÀ TIÊU ĐỀ ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue
                    .withOpacity(0.15),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lock_reset,
                color: AppColors.primaryBlue,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thiết lập mật khẩu mới',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Vui lòng nhập mật khẩu hiện tại và mật khẩu mới để bảo mật tài khoản quản lý tòa nhà của bạn.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // --- 2. CÁC Ô NHẬP LIỆU ĐÃ ĐƯỢC CHỮA LỖI CHÍNH TẢ ---
            _buildPasswordField(
              'Mật khẩu hiện tại',
              'Nhập mật khẩu hiện tại',
              _currentPassCtrl,
              _obscureCurrent,
              () {
                setState(
                  () => _obscureCurrent =
                      !_obscureCurrent,
                );
              },
            ),
            const SizedBox(height: 20),

            _buildPasswordField(
              'Mật khẩu mới',
              'Nhập mật khẩu mới',
              _newPassCtrl,
              _obscureNew,
              () {
                setState(
                  () =>
                      _obscureNew = !_obscureNew,
                );
              },
            ),
            const SizedBox(height: 20),

            _buildPasswordField(
              'Xác nhận mật khẩu mới',
              'Xác nhận mật khẩu mới',
              _confirmPassCtrl,
              _obscureConfirm,
              () {
                setState(
                  () => _obscureConfirm =
                      !_obscureConfirm,
                );
              },
            ),
            const SizedBox(height: 32),

            // --- 3. KHỐI YÊU CẦU BẢO MẬT ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors
                    .cardBackground, // Hoặc dùng màu xanh đen nếu có
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue
                      .withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: const [
                        Text(
                          'YÊU CẦU BẢO MẬT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ cái, chữ số và ít nhất một ký tự đặc biệt.',
                          style: TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // NÚT LƯU VÀ NÚT HỦY
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : _updatePassword,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                      )
                    : const Icon(
                        Icons
                            .check_circle_outline,
                        color: Colors.white,
                      ),
                label: Text(
                  _isLoading
                      ? 'Đang xử lý...'
                      : 'Cập nhật mật khẩu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text(
                'Hủy bỏ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Khối vẽ ô nhập liệu mật khẩu (Tích hợp con mắt)
  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
    bool isObscure,
    VoidCallback onToggleVisibility,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            letterSpacing: 1.0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              letterSpacing: 0,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
              borderSide: BorderSide.none,
            ),
            // NÚT CON MẮT NẰM Ở ĐÂY
            suffixIcon: IconButton(
              icon: Icon(
                isObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
