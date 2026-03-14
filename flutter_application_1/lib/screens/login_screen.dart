import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import 'tenant/tenant_main_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  // Biến lưu trạng thái: true là Quản lý, false là Khách thuê
  bool isManager = true;

  // Controllers để lấy dữ liệu
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePass =
      true; // Biến để nhắm/mở mắt mật khẩu

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // --- HÀM XỬ LÝ LOGIC ĐĂNG NHẬP ---
  Future<void> _handleLogin() async {
    String phone = _phoneCtrl.text.trim();
    String pass = _passCtrl.text.trim();

    if (phone.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Vui lòng nhập đầy đủ Số điện thoại và Mật khẩu!',
          ),
        ),
      );
      return;
    }

    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Mật khẩu phải có ít nhất 6 ký tự!',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(
      const Duration(seconds: 1),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.successGreen,
        content: Text(
          'Đăng nhập thành công với tư cách ${isManager ? "QUẢN LÝ" : "KHÁCH THUÊ"}!',
        ),
      ),
    );

    if (isManager) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MainScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TenantMainScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // Logo & Title
                const Icon(
                  Icons.business,
                  color: AppColors.primaryBlue,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'QUẢN LÝ KHU TRỌ',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'APARTMENT MANAGEMENT SYSTEM',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(
                    24,
                  ),
                  decoration: BoxDecoration(
                    color:
                        AppColors.cardBackground,
                    borderRadius:
                        BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      // Toggle Button: Quản lý / Khách thuê
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors
                              .inputBackground,
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child:
                                  _buildRoleButton(
                                    'Quản lý',
                                    true,
                                  ),
                            ),
                            Expanded(
                              child:
                                  _buildRoleButton(
                                    'Khách thuê',
                                    false,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- FIX LỖI CHÍNH MẠNG SỐ 1 Ở ĐÂY ---
                      // Tách chữ Nhãn (Label) ra khỏi TextField, đặt ở trên cùng
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'TÊN ĐĂNG NHẬP HOẶC EMAIL',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            controller:
                                _phoneCtrl,
                            keyboardType:
                                TextInputType
                                    .emailAddress,
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 15,
                                ),
                            decoration: InputDecoration(
                              hintText:
                                  'nguyenvan@email.com',
                              hintStyle:
                                  const TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 14,
                                  ),
                              prefixIcon: const Icon(
                                Icons
                                    .person_outline,
                                color: AppColors
                                    .textSecondary,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppColors
                                  .inputBackground,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                                borderSide:
                                    BorderSide
                                        .none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tách chữ Nhãn (Label) cho Mật khẩu
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'MẬT KHẨU',
                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            controller: _passCtrl,
                            obscureText:
                                _obscurePass,
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 15,
                                ),
                            decoration: InputDecoration(
                              hintText:
                                  '••••••••',
                              hintStyle:
                                  const TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 14,
                                  ),
                              prefixIcon: const Icon(
                                Icons
                                    .lock_outline,
                                color: AppColors
                                    .textSecondary,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass
                                      ? Icons
                                            .visibility_off
                                      : Icons
                                            .visibility,
                                  color: AppColors
                                      .textSecondary,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePass =
                                      !_obscurePass,
                                ),
                              ),
                              filled: true,
                              fillColor: AppColors
                                  .inputBackground,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                                borderSide:
                                    BorderSide
                                        .none,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // --- KẾT THÚC FIX LỖI ---
                      Align(
                        alignment:
                            Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: AppColors
                                  .primaryBlue,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors
                                    .primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    8,
                                  ),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors
                                        .white,
                                    strokeWidth:
                                        2,
                                  ),
                                )
                              : const Text(
                                  'ĐĂNG NHẬP',
                                  style: TextStyle(
                                    color: Colors
                                        .white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Ẩn hiện nút Đăng ký
                if (isManager)
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chưa có tài khoản? ',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                            color: AppColors
                                .primaryBlue,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                    'Tài khoản do Ban quản lý cấp phát',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm tạo nút bấm chuyển đổi
  Widget _buildRoleButton(
    String title,
    bool isManagerRole,
  ) {
    bool isSelected = isManager == isManagerRole;
    return GestureDetector(
      onTap: () => setState(
        () => isManager = isManagerRole,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : AppColors.textSecondary,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
