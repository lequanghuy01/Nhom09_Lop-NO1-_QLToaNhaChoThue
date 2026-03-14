import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({Key? key})
    : super(key: key);

  @override
  State<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState
    extends State<ProfileDetailScreen> {
  final SetupData appData = SetupData();
  final ImagePicker _picker = ImagePicker();

  // Biến chứa đường dẫn ảnh đại diện
  String? _avatarPath;

  // Controllers cho form nhập liệu
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bơm dữ liệu cá nhân hiện tại vào các ô nhập
    _nameCtrl.text = appData.owner.isEmpty
        ? 'Nguyen Van A'
        : appData.owner;
    _phoneCtrl.text = appData.hotline;
    _emailCtrl.text = appData.supportEmail;
    _addressCtrl.text = appData.ownerAddress;
    _avatarPath = appData.ownerAvatarPath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  // Hàm chọn ảnh từ thư viện điện thoại
  Future<void> _pickAvatar() async {
    try {
      final XFile? pickedFile = await _picker
          .pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );
      if (pickedFile != null) {
        setState(() {
          _avatarPath = pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Lỗi chọn ảnh: $e');
    }
  }

  // Hàm Lưu thay đổi và Đồng bộ dữ liệu
  void _saveChanges() {
    setState(() {
      appData.owner = _nameCtrl.text.trim();
      appData.hotline = _phoneCtrl.text
          .trim(); // Đồng bộ số Hotline
      appData.supportEmail = _emailCtrl.text
          .trim(); // Đồng bộ Email hỗ trợ
      appData.ownerAddress = _addressCtrl.text
          .trim();
      appData.ownerAvatarPath = _avatarPath;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã cập nhật thông tin cá nhân & Đồng bộ hệ thống!',
        ),
      ),
    );
    Navigator.pop(
      context,
      true,
    ); // Trả về true để màn hình ngoài biết mà refresh
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
          'Thông tin chi tiết',
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
            // --- KHU VỰC AVATAR ---
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment:
                        Alignment.bottomRight,
                    children: [
                      // Vòng tròn Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF5D2B8,
                          ), // Màu nền cam nhạt giống thiết kế
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors
                                .primaryBlue
                                .withOpacity(0.5),
                            width: 2,
                          ),
                          image:
                              _avatarPath != null
                              ? DecorationImage(
                                  image: FileImage(
                                    File(
                                      _avatarPath!,
                                    ),
                                  ),
                                  fit: BoxFit
                                      .cover,
                                )
                              : null,
                        ),
                        child: _avatarPath == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color:
                                    Colors.white,
                              )
                            : null,
                      ),
                      // Nút Camera nhỏ
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Container(
                          padding:
                              const EdgeInsets.all(
                                6,
                              ),
                          decoration:
                              const BoxDecoration(
                                color: AppColors
                                    .primaryBlue,
                                shape: BoxShape
                                    .circle,
                              ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Đã sửa "CƯ DÂN TÒA NHÀ" thành "CHỦ TÒA NHÀ"
                  const Text(
                    'CHỦ TÒA NHÀ',
                    style: TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- FORM THÔNG TIN CÁ NHÂN ---
            Row(
              children: const [
                Icon(
                  Icons.person_outline,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'THÔNG TIN CÁ NHÂN',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Họ và tên',
              _nameCtrl,
              TextInputType.name,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Số điện thoại',
              _phoneCtrl,
              TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Email',
              _emailCtrl,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),

            // --- FORM ĐỊA CHỈ ---
            Row(
              children: const [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'ĐỊA CHỈ',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Quê quán / Thường trú',
              _addressCtrl,
              TextInputType.streetAddress,
              maxLines: 3,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      // NÚT LƯU Ở ĐÁY MÀN HÌNH
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
          ),
          child: const Text(
            'Lưu thay đổi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Hàm vẽ ô nhập liệu chuẩn UI
  Widget _buildInputField(
    String label,
    TextEditingController controller,
    TextInputType type, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
