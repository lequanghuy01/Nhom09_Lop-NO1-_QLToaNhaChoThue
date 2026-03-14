import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/setup_screen_1.dart';
import '../core/app_colors.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key})
    : super(key: key);

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  bool _isAgreed =
      false; // Trạng thái của checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // Logo Icon Tòa nhà (Giống màn hình login)
                Container(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  decoration: BoxDecoration(
                    color:
                        AppColors.cardBackground,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: AppColors.primaryBlue,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Tiêu đề
                const Text(
                  'Quản Lý Khu Trọ',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đăng ký tài khoản mới',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),

                // Form Đăng ký
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
                      const CustomTextField(
                        label: 'Họ và tên',
                        hintText: 'Nguyễn Văn A',
                        prefixIcon:
                            Icons.badge_outlined,
                      ),
                      const SizedBox(height: 16),

                      const CustomTextField(
                        label: 'Số điện thoại',
                        hintText: '0901234567',
                        prefixIcon:
                            Icons.phone_outlined,
                      ),
                      const SizedBox(height: 16),

                      const CustomTextField(
                        label: 'Email',
                        hintText:
                            'email@example.com',
                        prefixIcon:
                            Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),

                      const CustomTextField(
                        label: 'Mật khẩu',
                        hintText: '••••••••',
                        prefixIcon:
                            Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),

                      const CustomTextField(
                        label:
                            'Xác nhận mật khẩu',
                        hintText: '••••••••',
                        prefixIcon: Icons
                            .history, // Icon vòng mũi tên như hình
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),

                      // Checkbox Điều khoản
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _isAgreed,
                              onChanged: (value) {
                                setState(() {
                                  _isAgreed =
                                      value ??
                                      false;
                                });
                              },
                              activeColor:
                                  AppColors
                                      .primaryBlue,
                              checkColor:
                                  Colors.white,
                              side: const BorderSide(
                                color: AppColors
                                    .textSecondary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      4,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                const Text(
                                  'Tôi đồng ý với ',
                                  style: TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Mở điều khoản sử dụng
                                  },
                                  child: const Text(
                                    'điều khoản sử dụng',
                                    style: TextStyle(
                                      color: AppColors
                                          .primaryBlue,
                                      fontSize:
                                          13,
                                      fontWeight:
                                          FontWeight
                                              .w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Nút Đăng ký
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isAgreed
                              ? () {
                                  // Logic đăng ký tại đây
                                  // Có thể thêm logic gọi API đăng ký ở đây sau này

                                  /*// Hiển thị thông báo nhỏ báo thành công
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Đăng ký thành công! Đang chuyển về đăng nhập...',
                                      ),
                                    ),
                                  );

                                  // Trở lại màn hình Đăng nhập
                                  Navigator.pop(
                                    context,
                                  );*/
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (
                                            context,
                                          ) =>
                                              SetupScreen1(),
                                    ),
                                  );
                                }
                              : null, // Disable nút nếu chưa check đồng ý
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors
                                    .primaryBlue,
                            disabledBackgroundColor:
                                AppColors
                                    .primaryBlue
                                    .withOpacity(
                                      0.5,
                                    ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                          ),
                          child: const Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Link quay lại Đăng nhập
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Đã có tài khoản? ',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        ); // Quay lại màn hình trước đó
                      },
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: AppColors
                              .primaryBlue,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
