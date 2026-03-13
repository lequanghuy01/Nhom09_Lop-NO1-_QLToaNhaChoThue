import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_text_field.dart';
import 'select_room_screen.dart';

class AddResidentScreen extends StatefulWidget {
  const AddResidentScreen({Key? key})
    : super(key: key);

  @override
  State<AddResidentScreen> createState() =>
      _AddResidentScreenState();
}

class _AddResidentScreenState
    extends State<AddResidentScreen> {
  String? _assignedRoom;
  String _selectedDob = 'mm/dd/yyyy';
  String _selectedGender = 'Nam';

  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController();
  final TextEditingController _cccdController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // << Đã thêm Controller cho Email
  final TextEditingController _addressController =
      TextEditingController();
  Future<void> _selectDate(
    BuildContext context,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              surface: AppColors.cardBackground,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
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
          'Thêm cư dân mới',
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
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                    side: const BorderSide(
                      color:
                          AppColors.borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                  ),
                  child: const Text(
                    'Lưu tạm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    String inputName =
                        _nameController.text
                            .trim();
                    String inputPhone =
                        _phoneController.text
                            .trim();
                    String
                    inputEmail = _emailController
                        .text
                        .trim(); // Lấy dữ liệu Email
                    String
                    inputCccd = _cccdController
                        .text
                        .trim(); // Lấy dữ liệu CCCD
                    String inputAddress =
                        _addressController.text
                            .trim();
                    if (inputName.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng nhập họ tên!',
                          ),
                        ),
                      );
                      return;
                    }

                    // Đóng gói toàn bộ dữ liệu mang về
                    Navigator.pop(context, {
                      'name': inputName,
                      'phone':
                          inputPhone.isNotEmpty
                          ? inputPhone
                          : 'Chưa cập nhật',
                      'email':
                          inputEmail.isNotEmpty
                          ? inputEmail
                          : 'Chưa cập nhật',
                      'cccd': inputCccd.isNotEmpty
                          ? inputCccd
                          : 'Chưa cập nhật',
                      // THÊM DÒNG NÀY VÀO TRONG MAP ĐỂ GỬI ĐI:
                      'address':
                          inputAddress.isNotEmpty
                          ? inputAddress
                          : 'Chưa cập nhật',
                      'room':
                          _assignedRoom != null
                          ? 'Phòng $_assignedRoom'
                          : 'Chưa gán phòng',
                      'building': 'Tòa nhà mới',
                      'status': 'Đang ở',
                      'badge': 'MỚI THÊM',
                      'badgeColor':
                          AppColors.primaryBlue,
                      'dob': _selectedDob,
                      'gender': _selectedGender,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryBlue,
                    padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Hoàn tất',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors
                          .inputBackground,
                      border: Border.all(
                        color:
                            AppColors.borderColor,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(
                      6,
                    ),
                    decoration:
                        const BoxDecoration(
                          color: AppColors
                              .primaryBlue,
                          shape: BoxShape.circle,
                        ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'THÔNG TIN CƠ BẢN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _nameController,
              label: 'Họ và tên *',
              hintText: 'Nguyễn Văn A',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _phoneController,
              label: 'Số điện thoại *',
              hintText: '0909 xxx xxx',
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),

            // << ĐÃ BỔ SUNG Ô NHẬP EMAIL VÀO ĐÂY >>
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'example@gmail.com',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),

            const Text(
              'Số CCCD/Passport *',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cccdController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: '012345678910',
                      hintStyle: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: AppColors
                            .textSecondary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors
                          .inputBackground,
                      enabledBorder:
                          OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                            borderSide:
                                const BorderSide(
                                  color: AppColors
                                      .borderColor,
                                ),
                          ),
                      focusedBorder:
                          OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                            borderSide:
                                const BorderSide(
                                  color: AppColors
                                      .primaryBlue,
                                ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color:
                        AppColors.inputBackground,
                    border: Border.all(
                      color:
                          AppColors.borderColor,
                    ),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons
                            .document_scanner_outlined,
                        color:
                            AppColors.primaryBlue,
                        size: 20,
                      ),
                      Text(
                        'eKYC',
                        style: TextStyle(
                          color: AppColors
                              .primaryBlue,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày sinh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () =>
                            _selectDate(context),
                        child: Container(
                          height: 52,
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                          decoration: BoxDecoration(
                            color: AppColors
                                .inputBackground,
                            border: Border.all(
                              color: AppColors
                                  .borderColor,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .calendar_today_outlined,
                                color: AppColors
                                    .textSecondary,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  _selectedDob,
                                  style: TextStyle(
                                    color:
                                        _selectedDob ==
                                            'mm/dd/yyyy'
                                        ? AppColors
                                              .textSecondary
                                        : Colors
                                              .white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 52,
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                        decoration: BoxDecoration(
                          color: AppColors
                              .inputBackground,
                          border: Border.all(
                            color: AppColors
                                .borderColor,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons
                                  .people_outline,
                              color: AppColors
                                  .textSecondary,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value:
                                      _selectedGender,
                                  dropdownColor:
                                      AppColors
                                          .cardBackground,
                                  icon: const Icon(
                                    Icons
                                        .keyboard_arrow_down,
                                    color: AppColors
                                        .textSecondary,
                                    size: 20,
                                  ),
                                  style: const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize: 14,
                                  ),
                                  onChanged:
                                      (
                                        String?
                                        newValue,
                                      ) {
                                        setState(
                                          () => _selectedGender =
                                              newValue!,
                                        );
                                      },
                                  items:
                                      <String>[
                                        'Nam',
                                        'Nữ',
                                        'Khác',
                                      ].map<
                                        DropdownMenuItem<
                                          String
                                        >
                                      >((
                                        String
                                        value,
                                      ) {
                                        return DropdownMenuItem<
                                          String
                                        >(
                                          value:
                                              value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _addressController,
              label:
                  'Quê quán/Địa chỉ thường trú',
              hintText: 'Nhập địa chỉ...',
              prefixIcon:
                  Icons.location_on_outlined,
            ),
            const SizedBox(height: 32),

            const Text(
              'PHÒNG THUÊ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final selectedRoom =
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SelectRoomScreen(),
                      ),
                    );
                if (selectedRoom != null) {
                  setState(
                    () => _assignedRoom =
                        selectedRoom,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _assignedRoom != null
                      ? AppColors.cardBackground
                      : AppColors.inputBackground,
                  borderRadius:
                      BorderRadius.circular(12),
                  border: Border.all(
                    color: _assignedRoom != null
                        ? AppColors.primaryBlue
                        : AppColors.borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                            12,
                          ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .primaryBlue
                            .withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons
                            .door_front_door_outlined,
                        color:
                            AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            _assignedRoom != null
                                ? 'Phòng P.$_assignedRoom'
                                : 'Gán vào phòng',
                            style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            _assignedRoom != null
                                ? 'Đã gắn phòng thành công'
                                : 'Chọn phòng trống để gán cư dân',
                            style: TextStyle(
                              color:
                                  _assignedRoom !=
                                      null
                                  ? AppColors
                                        .successGreen
                                  : AppColors
                                        .textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _assignedRoom != null
                          ? Icons.edit_outlined
                          : Icons
                                .add_circle_outline,
                      color: _assignedRoom != null
                          ? AppColors.primaryBlue
                          : AppColors
                                .textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
