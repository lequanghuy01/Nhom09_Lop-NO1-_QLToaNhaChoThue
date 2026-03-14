import 'package:flutter/material.dart';
// Thay đổi đường dẫn import AppColors cho đúng với cấu trúc thư mục của sếp nhé
import '../../core/app_colors.dart';

class ForgotPasswordScreen
    extends StatefulWidget {
  const ForgotPasswordScreen({Key? key})
    : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  // Hàm xử lý khi bấm nút "Gửi yêu cầu"
  void _handleResetPassword() {
    final email = _emailController.text.trim();

    // 1. Kiểm tra rỗng
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập email của bạn!',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2. Giả lập gọi Firebase gửi link reset (Sau này thay bằng FirebaseAuth.instance.sendPasswordResetEmail)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đã gửi liên kết đặt lại mật khẩu. Vui lòng kiểm tra hộp thư của bạn!',
              ),
            ),
          ],
        ),
        backgroundColor: Colors
            .green, // Dùng màu xanh thành công
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // 3. Đá người dùng quay lại màn hình Đăng nhập
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // --- 1. ICON Ổ KHÓA CÓ VIỀN GLOW LẤP LÁNH ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue
                      .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primaryBlue
                        .withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue
                          .withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_reset_outlined,
                  size: 48,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 40),

              // --- 2. TIÊU ĐỀ & MÔ TẢ ---
              const Text(
                'Quên mật khẩu?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đừng lo lắng! Hãy nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // --- 3. Ô NHẬP EMAIL ---
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType
                        .emailAddress,
                    decoration: InputDecoration(
                      hintText: 'nhap@email.com',
                      hintStyle: TextStyle(
                        color: AppColors
                            .textSecondary
                            .withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors
                            .textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors
                          .cardBackground,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                        borderSide:
                            BorderSide.none,
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
                                  width: 1.5,
                                ),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- 4. NÚT GỬI YÊU CẦU ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .blueAccent, // Màu xanh như thiết kế
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blueAccent
                        .withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Gửi yêu cầu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- 5. NÚT QUAY LẠI ĐĂNG NHẬP ---
              TextButton.icon(
                onPressed: () =>
                    Navigator.pop(context),
                icon: const Icon(
                  Icons.login_rounded,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                label: const Text(
                  'Quay lại Đăng nhập',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
