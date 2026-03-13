import 'dart:io'; // Thêm dòng này để đọc file ảnh
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart'; // Thêm kho dữ liệu
import 'login_screen.dart';
import 'profile_detail_screen.dart';
import 'ekyc_screen.dart';
import 'change_password_screen.dart';
import 'notification_settings_screen.dart';
import 'terms_policy_screen.dart';
import 'contact_support_screen.dart';

// ĐÃ NÂNG CẤP LÊN STATEFUL WIDGET
class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key})
    : super(key: key);

  @override
  State<AccountScreen> createState() =>
      _AccountScreenState();
}

class _AccountScreenState
    extends State<AccountScreen> {
  // Gọi kho dữ liệu ra để lấy Tên và Avatar
  final SetupData appData = SetupData();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // 1. Header
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tài khoản',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Avatar & Thông tin cơ bản
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment:
                        Alignment.bottomRight,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors
                                .borderColor,
                            width: 2,
                          ),
                          color: AppColors
                              .cardBackground,
                          // Tự động load ảnh nếu sếp đã chọn ảnh ở màn hình Chi tiết
                          image:
                              appData.ownerAvatarPath !=
                                  null
                              ? DecorationImage(
                                  image: FileImage(
                                    File(
                                      appData
                                          .ownerAvatarPath!,
                                    ),
                                  ),
                                  fit: BoxFit
                                      .cover,
                                )
                              : null,
                        ),
                        child:
                            appData.ownerAvatarPath ==
                                null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors
                                    .textSecondary,
                              )
                            : null,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.all(
                              2,
                            ),
                        decoration:
                            const BoxDecoration(
                              color: AppColors
                                  .background,
                              shape:
                                  BoxShape.circle,
                            ),
                        child: const Icon(
                          Icons.check_circle,
                          color: AppColors
                              .primaryBlue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tự động load tên từ kho dữ liệu
                  Text(
                    appData.owner.isEmpty
                        ? 'Lê Quang Huy'
                        : appData.owner,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chủ tòa nhà  •  ',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.verified,
                        color: AppColors
                            .successGreen,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Đã xác minh',
                        style: TextStyle(
                          color: AppColors
                              .successGreen
                              .withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 3. Các nhóm Menu cài đặt
            _buildSectionHeader(
              'CÀI ĐẶT CÁ NHÂN',
            ),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Thông tin chi tiết',
                // NỐI LUỒNG Ở ĐÂY: Bấm vào chuyển trang, lúc về gọi setState để refresh ảnh/tên
                onTap: () async {
                  bool?
                  isUpdated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfileDetailScreen(),
                    ),
                  );
                  if (isUpdated == true) {
                    setState(() {});
                  }
                },
              ),
              _buildMenuItem(
                icon: Icons.badge_outlined,
                title:
                    'Xác thực danh tính (eKYC)',
                onTap: () async {
                  bool? isUpdated =
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EkycScreen(),
                        ),
                      );
                  if (isUpdated == true) {
                    setState(
                      () {},
                    ); // Refresh màn hình để nhận tích xanh (nếu có update)
                  }
                },
              ),
              /*_buildMenuItem(
                icon:
                    Icons.directions_car_outlined,
                title: 'Quản lý xe',
                showDivider: false,
              ),*/
            ]),

            _buildSectionHeader('BẢO MẬT'),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.lock_reset_outlined,
                title: 'Đổi mật khẩu',
                showDivider: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
            ]),

            _buildSectionHeader('TÙY CHỈNH'),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Giao diện',
                trailingText: 'Tối',
                onTap: () {
                  // Hiện Popup chọn Giao diện
                  showModalBottomSheet(
                    context: context,
                    backgroundColor:
                        AppColors.cardBackground,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(
                            top: Radius.circular(
                              20,
                            ),
                          ),
                    ),
                    builder: (context) => Padding(
                      padding:
                          const EdgeInsets.all(
                            24,
                          ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: const [
                          Text(
                            'Chọn giao diện',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24),
                          ListTile(
                            leading: Icon(
                              Icons.dark_mode,
                              color: AppColors
                                  .primaryBlue,
                            ),
                            title: Text(
                              'Giao diện Tối (Đang dùng)',
                              style: TextStyle(
                                color: AppColors
                                    .primaryBlue,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.light_mode,
                              color: AppColors
                                  .textSecondary,
                            ),
                            title: Text(
                              'Giao diện Sáng (Sắp ra mắt)',
                              style: TextStyle(
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.language_outlined,
                title: 'Ngôn ngữ',
                trailingText: 'Tiếng Việt',
                onTap: () {
                  // Hiện Popup chọn Ngôn ngữ
                  showModalBottomSheet(
                    context: context,
                    backgroundColor:
                        AppColors.cardBackground,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(
                            top: Radius.circular(
                              20,
                            ),
                          ),
                    ),
                    builder: (context) => Padding(
                      padding:
                          const EdgeInsets.all(
                            24,
                          ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: const [
                          Text(
                            'Chọn ngôn ngữ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24),
                          ListTile(
                            leading: Text(
                              '🇻🇳',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            title: Text(
                              'Tiếng Việt',
                              style: TextStyle(
                                color: AppColors
                                    .primaryBlue,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              '🇬🇧',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            title: Text(
                              'English',
                              style: TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons
                    .notifications_none_outlined,
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

            _buildSectionHeader('HỖ TRỢ'),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'Điều khoản & Chính sách',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TermsPolicyScreen(),
                  ),
                ),
              ),
              _buildMenuItem(
                icon: Icons.headset_mic_outlined,
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

            const SizedBox(height: 24),

            // 4. Phiên bản & Nút Đăng xuất
            const Center(
              child: Text(
                'Phiên bản 1.0.2',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Đã đăng xuất thành công!',
                      ),
                    ),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen(),
                    ),
                    (Route<dynamic> route) =>
                        false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors
                      .redAccent
                      .withOpacity(0.05),
                ),
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- CÁC HÀM HỖ TRỢ XÂY DỰNG UI ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
        left: 4.0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
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

  // ĐÃ VÁ LỖI: Thêm thuộc tính onTap vào đây
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
    bool showDivider = true,
    VoidCallback?
    onTap, // Cánh cửa để truyền lệnh chuyển trang
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
          leading: Icon(
            icon,
            color: AppColors.textSecondary,
            size: 24,
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
          onTap:
              onTap, // Sử dụng biến onTap ở đây
        ),
        if (showDivider)
          const Divider(
            color: AppColors.borderColor,
            height: 1,
            indent: 56,
            endIndent: 16,
          ),
      ],
    );
  }
}
