import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class EkycScreen extends StatefulWidget {
  const EkycScreen({Key? key}) : super(key: key);

  @override
  State<EkycScreen> createState() =>
      _EkycScreenState();
}

class _EkycScreenState extends State<EkycScreen> {
  final SetupData appData = SetupData();
  final ImagePicker _picker = ImagePicker();

  // Biến chứa đường dẫn ảnh
  String? _avatarPath;
  String? _frontIdPath;
  String? _backIdPath;

  // Controllers
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _idNumberCtrl = TextEditingController();
  String _selectedGender = 'Nam';

  bool _isLoadingScan =
      false; // Trạng thái loading khi bấm Quét

  @override
  void initState() {
    super.initState();
    // Tự động điền dữ liệu đã có từ màn hình Thông tin chi tiết sang
    _nameCtrl.text = appData.owner;
    _phoneCtrl.text = appData.hotline;
    _emailCtrl.text = appData.supportEmail;
    _addressCtrl.text = appData.ownerAddress;
    _avatarPath = appData.ownerAvatarPath;

    // Dữ liệu eKYC
    _dobCtrl.text = appData.dateOfBirth;
    _idNumberCtrl.text = appData.idNumber;
    if (appData.gender.isNotEmpty)
      _selectedGender = appData.gender;
    _frontIdPath = appData.frontIdPath;
    _backIdPath = appData.backIdPath;
  }

  // Hàm chọn ảnh đa năng (0: Avatar, 1: Mặt trước, 2: Mặt sau)
  Future<void> _pickImage(int type) async {
    try {
      final XFile? pickedFile = await _picker
          .pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );
      if (pickedFile != null) {
        setState(() {
          if (type == 0)
            _avatarPath = pickedFile.path;
          else if (type == 1)
            _frontIdPath = pickedFile.path;
          else if (type == 2)
            _backIdPath = pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Lỗi chọn ảnh: $e');
    }
  }

  // TÍNH NĂNG "ĂN TIỀN": Giả lập quét CCCD bằng chip
  Future<void> _simulateScanQR() async {
    setState(() => _isLoadingScan = true);

    // Giả vờ đang quét mất 1.5 giây
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    setState(() {
      _idNumberCtrl.text = '038099012345';
      _nameCtrl.text = 'LÊ QUANG HUY';
      _dobCtrl.text = '15/08/2001';
      _selectedGender = 'Nam';
      _addressCtrl.text = 'Vĩnh Lộc, Nghệ An';
      _isLoadingScan = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.successGreen,
        content: Text(
          'Quét CCCD thành công! Dữ liệu đã được tự động điền.',
        ),
      ),
    );
  }

  // Lưu hoàn tất
  void _saveAndComplete(bool isDraft) {
    appData.owner = _nameCtrl.text.trim();
    appData.hotline = _phoneCtrl.text.trim();
    appData.supportEmail = _emailCtrl.text.trim();
    appData.ownerAddress = _addressCtrl.text
        .trim();
    appData.ownerAvatarPath = _avatarPath;

    appData.idNumber = _idNumberCtrl.text.trim();
    appData.dateOfBirth = _dobCtrl.text.trim();
    appData.gender = _selectedGender;
    appData.frontIdPath = _frontIdPath;
    appData.backIdPath = _backIdPath;

    if (!isDraft) {
      appData.isEkycVerified =
          true; // Bật tích xanh nếu bấm Hoàn tất
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hồ sơ eKYC đã được gửi duyệt thành công!',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu nháp hồ sơ!'),
        ),
      );
    }

    Navigator.pop(context, true);
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
          'Xác thực danh tính',
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
            // --- 1. AVATAR CHÂN DUNG ---
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment:
                        Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF5D2B8,
                          ),
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
                      GestureDetector(
                        onTap: () =>
                            _pickImage(0),
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
                  const SizedBox(height: 12),
                  const Text(
                    'Ảnh chân dung',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Nhấn để thay đổi ảnh',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 2. THÔNG TIN CƠ BẢN ---
            const Text(
              'THÔNG TIN CƠ BẢN',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Họ và tên',
              'Nhập họ và tên đầy đủ',
              _nameCtrl,
              TextInputType.name,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'Số điện thoại',
                    '090...',
                    _phoneCtrl,
                    TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    'Email',
                    'example@mail.com',
                    _emailCtrl,
                    TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'Ngày sinh',
                    'dd/mm/yyyy',
                    _dobCtrl,
                    TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Giới tính',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                        decoration: BoxDecoration(
                          color: AppColors
                              .inputBackground,
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value:
                                _selectedGender,
                            isExpanded: true,
                            dropdownColor: AppColors
                                .cardBackground,
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 15,
                                ),
                            icon: const Icon(
                              Icons
                                  .keyboard_arrow_down,
                              color: AppColors
                                  .textSecondary,
                            ),
                            items: ['Nam', 'Nữ']
                                .map(
                                  (
                                    String value,
                                  ) =>
                                      DropdownMenuItem<
                                        String
                                      >(
                                        value:
                                            value,
                                        child: Text(
                                          value,
                                        ),
                                      ),
                                )
                                .toList(),
                            onChanged:
                                (
                                  newValue,
                                ) => setState(
                                  () => _selectedGender =
                                      newValue!,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Quê quán (Địa chỉ thường trú)',
              'Số nhà, đường, phường/xã...',
              _addressCtrl,
              TextInputType.streetAddress,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // --- 3. GIẤY TỜ ĐỊNH DANH ---
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GIẤY TỜ ĐỊNH DANH',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue
                        .withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'YÊU CẦU EKYC',
                    style: TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ô nhập CCCD + Nút Quét
            const Text(
              'Số CCCD / Hộ chiếu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idNumberCtrl,
                    keyboardType:
                        TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhập số giấy tờ',
                      hintStyle: const TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors
                          .inputBackground,
                      contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingScan
                        ? null
                        : _simulateScanQR,
                    icon: _isLoadingScan
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(
                                  color: Colors
                                      .white,
                                  strokeWidth: 2,
                                ),
                          )
                        : const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 20,
                          ),
                    label: Text(
                      _isLoadingScan
                          ? 'Đang quét'
                          : 'Quét',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nút chụp mặt trước
            _buildIdUploadBox(
              'Mặt trước CCCD',
              'Hỗ trợ JPG, PNG',
              _frontIdPath,
              () => _pickImage(1),
            ),
            const SizedBox(height: 16),

            // Nút chụp mặt sau
            _buildIdUploadBox(
              'Mặt sau CCCD',
              'Hỗ trợ JPG, PNG',
              _backIdPath,
              () => _pickImage(2),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // NÚT LƯU TẠM VÀ HOÀN TẤT
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () =>
                    _saveAndComplete(true),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColors.primaryBlue,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Lưu tạm',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () =>
                    _saveAndComplete(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryBlue,
                  padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Hoàn tất',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Khối vẽ ô nhập liệu text
  Widget _buildInputField(
    String label,
    String hint,
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
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Khối vẽ khung Tải ảnh CCCD (Dùng viền solid mờ cho an toàn, không bị lỗi gạch nối)
  Widget _buildIdUploadBox(
    String title,
    String subtitle,
    String? imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue
                .withOpacity(0.3),
            width: 1.5,
          ), // Viền xanh mờ ảo
          image: imagePath != null
              ? DecorationImage(
                  image: FileImage(
                    File(imagePath),
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imagePath == null
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primaryBlue,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                    0.4,
                  ),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.successGreen,
                    size: 40,
                  ),
                ),
              ),
      ),
    );
  }
}
