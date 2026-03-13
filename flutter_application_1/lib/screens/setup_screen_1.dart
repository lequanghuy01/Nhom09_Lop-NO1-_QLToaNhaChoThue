import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart'; // Nhập Balo Dữ liệu
import 'setup_screen_2.dart';

class SetupScreen1 extends StatefulWidget {
  const SetupScreen1({Key? key})
    : super(key: key);

  @override
  State<SetupScreen1> createState() =>
      _SetupScreen1State();
}

class _SetupScreen1State
    extends State<SetupScreen1> {
  // Tạo các Controller để lấy chữ gõ vào
  final _nameController = TextEditingController();
  final _addressController =
      TextEditingController();
  final _ownerController =
      TextEditingController();
  final _aboveFloorController =
      TextEditingController();
  final _basementController =
      TextEditingController();
  final _descController = TextEditingController();

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
          'Thiết lập Tòa nhà',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // 1. TẠO BALO VÀ NHÉT DỮ LIỆU VÀO
                SetupData data = SetupData();
                data.buildingName =
                    _nameController.text.trim();
                data.address = _addressController
                    .text
                    .trim();
                data.owner = _ownerController.text
                    .trim();
                data.aboveFloors =
                    int.tryParse(
                      _aboveFloorController.text
                          .trim(),
                    ) ??
                    0;
                data.basementFloors =
                    int.tryParse(
                      _basementController.text
                          .trim(),
                    ) ??
                    0;
                data.description = _descController
                    .text
                    .trim();

                // Bắt buộc nhập tên và số tầng
                if (data.buildingName.isEmpty ||
                    data.aboveFloors == 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Vui lòng nhập Tên tòa nhà và Số tầng nổi > 0!',
                      ),
                    ),
                  );
                  return;
                }

                // 2. ĐẨY BALO SANG MÀN 2
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SetupScreen2(
                          setupData: data,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildInputField(
              'Tên tòa nhà *',
              'Ví dụ: Chung cư Harmony',
              Icons.business,
              _nameController,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Địa chỉ chi tiết *',
              'Nhập số nhà, tên đường...',
              Icons.location_on_outlined,
              _addressController,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'Chủ sở hữu',
              'Tên chủ sở hữu hoặc đơn vị',
              Icons.person_outline,
              _ownerController,
            ),
            const SizedBox(height: 16),

            // Chia đôi ô Số tầng
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'Số tầng nổi',
                    '0',
                    Icons.layers_outlined,
                    _aboveFloorController,
                    isNumber: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    'Số tầng hầm',
                    '0',
                    Icons.home_work_outlined,
                    _basementController,
                    isNumber: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ô Mô tả lớn
            const Text(
              'Mô tả chung',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText:
                    'Thông tin thêm về tòa nhà, tiện ích...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor:
                    AppColors.inputBackground,
                contentPadding:
                    const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm vẽ UI ô nhập liệu chuẩn ảnh thiết kế
  Widget _buildInputField(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber
              ? TextInputType.number
              : TextInputType.text,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.textSecondary,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
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
          ),
        ),
      ],
    );
  }
}
