import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'select_room_screen.dart';

class CreateContractScreen
    extends StatefulWidget {
  const CreateContractScreen({Key? key})
    : super(key: key);

  @override
  State<CreateContractScreen> createState() =>
      _CreateContractScreenState();
}

class _CreateContractScreenState
    extends State<CreateContractScreen> {
  final SetupData appData = SetupData();

  // --- Controllers cho CHỦ NHÀ (Bên cho thuê) ---
  final _ownerNameCtrl = TextEditingController();
  final _ownerPhoneCtrl = TextEditingController();
  final _ownerCCCDCtrl = TextEditingController();
  final _ownerAddressCtrl =
      TextEditingController();

  // --- Controllers cho NGƯỜI THUÊ (Bên thuê) ---
  final _tenantNameCtrl = TextEditingController();
  final _tenantPhoneCtrl =
      TextEditingController();
  final _tenantCCCDCtrl = TextEditingController();
  final _tenantAddressCtrl =
      TextEditingController();

  // Controllers cho chi phí
  final _rentPriceCtrl = TextEditingController();
  final _depositCtrl = TextEditingController(
    text: '0',
  );
  final _noteCtrl = TextEditingController();

  String? _selectedRoomName;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(
    const Duration(days: 365),
  );

  List<bool> _selectedServices = [];

  @override
  void initState() {
    super.initState();
    _selectedServices = List.generate(
      appData.services.length,
      (index) => true,
    );

    // Tự động điền thông tin Chủ trọ từ Balo (Setup 1) vào Form
    _ownerNameCtrl.text = appData.owner.isNotEmpty
        ? appData.owner
        : 'Tên chủ trọ';
    _ownerAddressCtrl.text =
        appData.address.isNotEmpty
        ? appData.address
        : '';
  }

  Future<void> _selectDate(
    BuildContext context,
    bool isStart,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? _startDate
          : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
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
        if (isStart)
          _startDate = picked;
        else
          _endDate = picked;
      });
    }
  }

  void _saveContract() {
    if (_tenantNameCtrl.text.isEmpty ||
        _selectedRoomName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập tên người thuê và chọn phòng!',
          ),
        ),
      );
      return;
    }

    String status = 'Đang hiệu lực';
    String badge = 'ĐANG Ở';
    Color badgeColor = AppColors.successGreen;

    if (_endDate
            .difference(DateTime.now())
            .inDays <=
        30) {
      status = 'Sắp hết hạn';
      badge = 'SẮP HẾT HẠN';
      badgeColor = Colors.orange;
    }

    Map<String, dynamic> newContract = {
      'name': _tenantNameCtrl.text.trim(),
      'phone': _tenantPhoneCtrl.text.trim(),
      'cccd': _tenantCCCDCtrl.text.trim(),
      'address': _tenantAddressCtrl.text.trim(),
      'room': _selectedRoomName,
      'startDate': DateFormat(
        'dd/MM/yyyy',
      ).format(_startDate),
      'endDate': DateFormat(
        'dd/MM/yyyy',
      ).format(_endDate),
      'rentPrice': _rentPriceCtrl.text.trim(),
      'deposit': _depositCtrl.text.trim(),
      'status': status,
      'badge': badge,
      'badgeColor': badgeColor,
    };

    Navigator.pop(context, newContract);
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
          'Tạo hợp đồng thuê',
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
                  onPressed: () =>
                      Navigator.pop(context),
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
                    'Lưu bản nháp',
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
                child: ElevatedButton.icon(
                  onPressed: _saveContract,
                  icon: const Icon(
                    Icons.edit_document,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Hoàn tất & Ký HĐ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- KHỐI BÊN CHO THUÊ (MỚI THÊM) ---
            Row(
              children: const [
                Icon(
                  Icons.real_estate_agent,
                  color: AppColors.primaryBlue,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'THÔNG TIN BÊN CHO THUÊ',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              'Họ và tên *',
              'Nguyễn Văn A (Chủ nhà)',
              _ownerNameCtrl,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputRow(
                    'Số CCCD',
                    'Nhập CCCD',
                    _ownerCCCDCtrl,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputRow(
                    'Số điện thoại',
                    'Nhập SĐT',
                    _ownerPhoneCtrl,
                  ),
                ),
              ],
            ),
            _buildInputRow(
              'Hộ khẩu thường trú / Địa chỉ',
              'Nhập địa chỉ',
              _ownerAddressCtrl,
            ),
            const SizedBox(height: 24),

            // --- KHỐI BÊN THUÊ ---
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: AppColors.primaryBlue,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'THÔNG TIN BÊN THUÊ',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              'Họ và tên *',
              'Tên khách thuê',
              _tenantNameCtrl,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputRow(
                    'Số CCCD',
                    'Nhập CCCD',
                    _tenantCCCDCtrl,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputRow(
                    'Số điện thoại',
                    'Nhập SĐT',
                    _tenantPhoneCtrl,
                  ),
                ),
              ],
            ),
            _buildInputRow(
              'Hộ khẩu thường trú',
              'Nhập địa chỉ khách',
              _tenantAddressCtrl,
            ),
            const SizedBox(height: 24),

            // --- KHỐI HỢP ĐỒNG & PHÒNG ---
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.description,
                      color:
                          AppColors.primaryBlue,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'THÔNG TIN HỢP ĐỒNG',
                      style: TextStyle(
                        color:
                            AppColors.primaryBlue,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    final selectedRoom =
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SelectRoomScreen(),
                          ),
                        );
                    if (selectedRoom != null) {
                      setState(() {
                        _selectedRoomName =
                            selectedRoom;
                        for (var floor
                            in appData.floors) {
                          for (var room
                              in floor.rooms) {
                            if (room.name ==
                                _selectedRoomName) {
                              _rentPriceCtrl
                                      .text =
                                  room
                                      .customPrice
                                      .isNotEmpty
                                  ? room.customPrice
                                  : appData
                                        .defaultPrice;
                            }
                          }
                        }
                      });
                    }
                  },
                  child: const Text(
                    'Chọn phòng >',
                    style: TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue
                    .withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue
                      .withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryBlue,
                      borderRadius:
                          BorderRadius.circular(
                            8,
                          ),
                    ),
                    child: const Icon(
                      Icons.meeting_room,
                      color: Colors.white,
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
                          _selectedRoomName ??
                              'Chưa chọn phòng',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedRoomName ==
                                  null
                              ? 'Vui lòng chọn phòng trống'
                              : 'Trạng thái: Sẵn sàng bàn giao',
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(
                      context,
                      true,
                    ),
                    child: _buildDateBox(
                      'Ngày bắt đầu',
                      _startDate,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(
                      context,
                      false,
                    ),
                    child: _buildDateBox(
                      'Ngày kết thúc',
                      _endDate,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- KHỐI CHI PHÍ ---
            const Text(
              'CHI PHÍ THUÊ',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              'Giá thuê (VND/tháng)',
              'Nhập giá thuê',
              _rentPriceCtrl,
              isNumber: true,
              prefixIcon: Icons.payments_outlined,
            ),
            _buildInputRow(
              'Tiền cọc (VND)',
              '0',
              _depositCtrl,
              isNumber: true,
              prefixIcon: Icons
                  .account_balance_wallet_outlined,
            ),
            const SizedBox(height: 24),

            // --- KHỐI TIỆN ÍCH KÈM THEO ---
            const Text(
              'TIỆN ÍCH KÈM THEO',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(
                  appData.services.length,
                  (index) {
                    final service =
                        appData.services[index];
                    return CheckboxListTile(
                      title: Text(
                        service.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        '${service.price} ${service.unit}',
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      value:
                          _selectedServices[index],
                      activeColor:
                          AppColors.primaryBlue,
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color:
                            AppColors.borderColor,
                      ),
                      onChanged: (bool? value) {
                        setState(
                          () =>
                              _selectedServices[index] =
                                  value!,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- KHỐI GHI CHÚ ---
            const Text(
              'GHI CHÚ HỢP ĐỒNG',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              minLines: 3,
              maxLines:
                  null, // ĐÂY LÀ CHÌA KHÓA: Cho phép ô nhập liệu tự động giãn nở khi gõ nhiều
              keyboardType:
                  TextInputType.multiline,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText:
                    'VD: Quy định về vật nuôi, giờ giấc...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                filled: true,
                fillColor:
                    AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    String hint,
    TextEditingController ctrl, {
    bool isNumber = false,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            // Để trống chiều cao (height) ở đây nếu muốn input này giãn nở, nhưng với input thường (1 dòng) thì fix 48 là chuẩn UI.
            height: 48,
            child: TextField(
              controller: ctrl,
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
                ),
                prefixIcon: prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color: AppColors
                            .textSecondary,
                        size: 18,
                      )
                    : null,
                filled: true,
                fillColor:
                    AppColors.inputBackground,
                contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildDateBox(
    String label,
    DateTime date,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(
              8,
            ),
            border: Border.all(
              color: AppColors.borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat(
                  'dd/MM/yyyy',
                ).format(date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.calendar_today,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
