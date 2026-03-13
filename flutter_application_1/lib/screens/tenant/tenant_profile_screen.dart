import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

// --- IMPORT CÁC MÀN HÌNH ĐÃ LÀM TỪ TRƯỚC (TÁI SỬ DỤNG) ---
import '../ekyc_screen.dart';
import '../change_password_screen.dart';
import '../notification_settings_screen.dart';
import '../terms_policy_screen.dart';
import '../contact_support_screen.dart';
import '../login_screen.dart';

class TenantProfileScreen
    extends StatelessWidget {
  const TenantProfileScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER: AVATAR & THÔNG TIN ---
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment:
                          Alignment.bottomRight,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape:
                                BoxShape.circle,
                            border: Border.all(
                              color: AppColors
                                  .primaryBlue
                                  .withOpacity(
                                    0.5,
                                  ),
                              width: 2,
                            ),
                            // --- ĐÃ XOÁ ẢNH CŨ Ở ĐÂY ---
                            // image: const DecorationImage(
                            //   // Ảnh sếp chê ghê =))
                            //   image: NetworkImage('https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          // --- ĐÃ THAY BẰNG ICON HÌNH NGƯỜI MẶC ĐỊNH Ở ĐÂY ---
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors
                                .textSecondary,
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.all(
                                4,
                              ),
                          decoration:
                              const BoxDecoration(
                                color: AppColors
                                    .primaryBlue,
                                shape: BoxShape
                                    .circle,
                              ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nguyễn Văn An',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Cư dân • P.101',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .successGreen
                            .withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.verified,
                            color: AppColors
                                .successGreen,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Đã xác thực eKYC',
                            style: TextStyle(
                              color: AppColors
                                  .successGreen,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- 2. CÀI ĐẶT CÁ NHÂN ---
              _buildSectionHeader(
                'CÀI ĐẶT CÁ NHÂN',
              ),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.person_outline,
                  iconColor: Colors.blueAccent,
                  title: 'Thông tin chi tiết',
                  onTap: () {
                    /* Chuyển đến màn sửa thông tin */
                  },
                ),
                _buildMenuItem(
                  icon: Icons.badge_outlined,
                  iconColor: Colors.lightBlue,
                  title:
                      'Xác thực danh tính (eKYC)',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const EkycScreen(),
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons
                      .directions_car_outlined,
                  iconColor: Colors.teal,
                  title: 'Quản lý phương tiện',
                  showDivider: false,
                  onTap: () {
                    /* Chuyển đến quản lý xe */
                  },
                ),
              ]),

              // --- 3. BẢO MẬT ---
              _buildSectionHeader('BẢO MẬT'),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  iconColor: Colors.blueAccent,
                  title: 'Đổi mật khẩu',
                  showDivider: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ChangePasswordScreen(),
                    ),
                  ),
                ),
              ]),

              // --- 4. HỆ THỐNG ---
              _buildSectionHeader('HỆ THỐNG'),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.translate,
                  iconColor: Colors.indigoAccent,
                  title: 'Ngôn ngữ',
                  trailingText: 'Tiếng Việt',
                  onTap: () =>
                      _showLanguageSheet(context),
                ),
                _buildMenuItem(
                  icon: Icons.dark_mode_outlined,
                  iconColor:
                      Colors.deepPurpleAccent,
                  title: 'Chế độ giao diện',
                  trailingText: 'Tối',
                  onTap: () =>
                      _showThemeSheet(context),
                ),
                _buildMenuItem(
                  icon: Icons
                      .notifications_none_outlined,
                  iconColor: Colors.blueAccent,
                  title: 'Cài đặt thông báo',
                  showDivider: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const NotificationSettingsScreen(),
                    ),
                  ),
                ),
              ]),

              // --- 5. HỖ TRỢ ---
              _buildSectionHeader('HỖ TRỢ'),
              _buildMenuCard([
                _buildMenuItem(
                  icon:
                      Icons.description_outlined,
                  iconColor:
                      Colors.tealAccent.shade400,
                  title:
                      'Điều khoản & Chính sách',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const TermsPolicyScreen(),
                    ),
                  ),
                ),
                _buildMenuItem(
                  icon:
                      Icons.headset_mic_outlined,
                  iconColor:
                      Colors.cyanAccent.shade400,
                  title: 'Liên hệ hỗ trợ',
                  showDivider: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ContactSupportScreen(),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 16),

              // --- 6. NÚT ĐĂNG XUẤT (MÀU ĐỎ MẬN SIÊU ĐEb) ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Đã đăng xuất!',
                        ),
                      ),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .redAccent
                        .withOpacity(
                          0.15,
                        ), // Nền đỏ mận
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Phiên bản
              const Center(
                child: Text(
                  'Phiên bản 2.4.1 (Build 108)',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI PHỤ TRỢ ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
        left: 4.0,
        top: 8.0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  // Cấu trúc Menu với Icon "nền đệm" cực xịn
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    bool showDivider = true,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              if (trailingText != null)
                const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            color: AppColors.borderColor,
            height: 1,
            indent: 60,
            endIndent: 16,
          ),
      ],
    );
  }

  // --- POPUP NGÔN NGỮ VÀ GIAO DIỆN (Tái sử dụng logic cũ) ---
  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Chọn ngôn ngữ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Text(
                '🇻🇳',
                style: TextStyle(fontSize: 24),
              ),
              title: Text(
                'Tiếng Việt',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            ListTile(
              leading: Text(
                '🇬🇧',
                style: TextStyle(fontSize: 24),
              ),
              title: Text(
                'English',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showThemeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Chọn giao diện',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(
                Icons.dark_mode,
                color: AppColors.primaryBlue,
              ),
              title: Text(
                'Giao diện Tối (Đang dùng)',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.light_mode,
                color: AppColors.textSecondary,
              ),
              title: Text(
                'Giao diện Sáng (Sắp ra mắt)',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
