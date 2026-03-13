import 'dart:io'; // Thêm để xử lý File ảnh thật
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Thêm thư viện chọn ảnh
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class EditBuildingInfoScreen
    extends StatefulWidget {
  const EditBuildingInfoScreen({Key? key})
    : super(key: key);

  @override
  State<EditBuildingInfoScreen> createState() =>
      _EditBuildingInfoScreenState();
}

class _EditBuildingInfoScreenState
    extends State<EditBuildingInfoScreen> {
  final SetupData appData = SetupData();
  final _picker =
      ImagePicker(); // Khởi tạo đối tượng chọn ảnh

  // Biến chứa đường dẫn ảnh tạm thời (Local Path)
  String? _tempImgPath;

  // Controllers cho các ô nhập liệu
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _inaugDateCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _hotlineCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bơm dữ liệu hiện tại từ kho vào các ô nhập
    _nameCtrl.text = appData.buildingName;
    _addressCtrl.text = appData.address;
    _tempImgPath = appData
        .buildingCoverImgPath; // Lấy ảnh thật hiện tại (nếu có)
    _inaugDateCtrl.text =
        appData.inaugurationDate;
    _areaCtrl.text = appData.totalArea;
    _typeCtrl.text = appData.buildingType;
    _hotlineCtrl.text = appData.hotline;
    _emailCtrl.text = appData.supportEmail;
    _descCtrl.text = appData.buildingDescription;
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ controllers
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _inaugDateCtrl.dispose();
    _areaCtrl.dispose();
    _typeCtrl.dispose();
    _hotlineCtrl.dispose();
    _emailCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // --- HÀM CHÍNH: GỌI THƯ VIỆN CHỌN ẢNH TỪ ĐIỆN THOẠI ---
  Future<void> _pickImage() async {
    try {
      // Mở thư viện ảnh (Gallery)
      final XFile? pickedFile = await _picker
          .pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          ); // Giảm chất lượng tý cho nhẹ

      if (pickedFile != null) {
        setState(() {
          _tempImgPath = pickedFile
              .path; // Lấy đường dẫn File thật trên điện thoại
        });
      }
    } catch (e) {
      debugPrint('Lỗi chọn ảnh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không thể mở thư viện ảnh.',
          ),
        ),
      );
    }
  }

  // --- HÀM LƯU TẤT CẢ THÔNG TIN ---
  void _saveData() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tên tòa nhà không được để trống!',
          ),
        ),
      );
      return;
    }

    setState(() {
      // 1. Lưu đường dẫn ảnh thật (File path) vào kho dữ liệu chính
      appData.buildingCoverImgPath = _tempImgPath;

      // 2. Cập nhật các thông tin văn bản
      appData.buildingName = _nameCtrl.text
          .trim();
      appData.address = _addressCtrl.text.trim();
      appData.inaugurationDate = _inaugDateCtrl
          .text
          .trim();
      appData.totalArea = _areaCtrl.text.trim();
      appData.buildingType = _typeCtrl.text
          .trim();
      appData.hotline = _hotlineCtrl.text.trim();
      appData.supportEmail = _emailCtrl.text
          .trim();
      appData.buildingDescription = _descCtrl.text
          .trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã cập nhật thông tin tòa nhà thành công!',
        ),
      ),
    );
    Navigator.pop(
      context,
      true,
    ); // Trả về true để màn hình trước biết mà refresh dữ liệu
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
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveData,
            child: const Text(
              'Lưu',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- KHU VỰC CHỌN ẢNH BÌA TỪ ĐIỆN THOẠI ---
            Stack(
              alignment: Alignment.center,
              children: [
                // Hiển thị ảnh bìa thật (nếu có) hoặc nền xám mẫu
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey
                        .withOpacity(0.3),
                  ),
                  child: _tempImgPath != null
                      ? Image.file(
                          File(_tempImgPath!),
                          fit: BoxFit.cover,
                        ) // HIỂN THỊ FILE ẢNH THẬT TỪ ĐIỆN THOẠI
                      : const Icon(
                          Icons.business,
                          color: Colors.blueGrey,
                          size: 60,
                        ), // Placeholder
                ),
                // Lớp phủ mờ (Overlay)
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.black.withOpacity(
                    0.4,
                  ),
                ),
                // NÚT MÁY ẢNH ĐỂ BẤM CHỌN ẢNH
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            // --- CÁC FORM NHẬP LIỆU ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THÔNG TIN CHÍNH',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    'Tên tòa nhà',
                    _nameCtrl,
                    'Ví dụ: Chung cư Phenikaa',
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    'Địa chỉ',
                    _addressCtrl,
                    'P. Đồng Mai, Q. Hà Đông...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'THÔNG TIN VẬN HÀNH',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          'Ngày khánh thành',
                          _inaugDateCtrl,
                          'dd/mm/yyyy',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          'Tổng diện tích',
                          _areaCtrl,
                          '250 m²',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    'Loại hình',
                    _typeCtrl,
                    'Căn hộ dịch vụ, Chung cư...',
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'LIÊN HỆ BAN QUẢN LÝ (Sẽ đồng bộ với Tài khoản)',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    'Số Hotline',
                    _hotlineCtrl,
                    '0912...',
                    keyboardType:
                        TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    'Email hỗ trợ',
                    _emailCtrl,
                    'admin@phenikaa.com',
                    keyboardType: TextInputType
                        .emailAddress,
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'MÔ TẢ',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    '',
                    _descCtrl,
                    'Nhập mô tả chi tiết cho tòa nhà...',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType =
        TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
              borderSide: const BorderSide(
                color: AppColors.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
          ),
        ),
      ],
    );
  }
}
