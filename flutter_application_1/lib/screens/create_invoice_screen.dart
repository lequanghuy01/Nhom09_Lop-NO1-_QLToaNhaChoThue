import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';
import 'preview_invoice_screen.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({Key? key})
    : super(key: key);

  @override
  State<CreateInvoiceScreen> createState() =>
      _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState
    extends State<CreateInvoiceScreen> {
  final SetupData appData = SetupData();

  // Biến ngày tháng
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(
    const Duration(days: 5),
  ); // Hạn nộp mặc định sau 5 ngày

  // Cư dân/Phòng đang được chọn
  Map<String, dynamic>? _selectedResident;

  // Controllers cho các khoản tiền và chỉ số (Để có thể sửa tay)
  final _rentCtrl = TextEditingController(
    text: '0',
  );

  final _oldElecCtrl = TextEditingController(
    text: '0',
  );
  final _newElecCtrl = TextEditingController(
    text: '0',
  );
  int _elecPrice =
      3500; // Đơn giá điện (Mock data)

  final _oldWaterCtrl = TextEditingController(
    text: '0',
  );
  final _newWaterCtrl = TextEditingController(
    text: '0',
  );
  int _waterPrice =
      20000; // Đơn giá nước (Mock data)

  final _serviceFeeCtrl = TextEditingController(
    text: '150000',
  ); // Phí dịch vụ mặc định
  final _noteCtrl = TextEditingController();

  // Biến tổng tiền
  int _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự thay đổi của các ô nhập liệu để tính toán lại Tổng tiền
    _rentCtrl.addListener(_calculateTotal);
    _oldElecCtrl.addListener(_calculateTotal);
    _newElecCtrl.addListener(_calculateTotal);
    _oldWaterCtrl.addListener(_calculateTotal);
    _newWaterCtrl.addListener(_calculateTotal);
    _serviceFeeCtrl.addListener(_calculateTotal);

    // Tìm các đơn giá từ cài đặt ban đầu (nếu có)
    for (var service in appData.services) {
      if (service.name.toLowerCase().contains(
        'điện',
      )) {
        _elecPrice =
            int.tryParse(
              service.price.replaceAll('.', ''),
            ) ??
            3500;
      }
      if (service.name.toLowerCase().contains(
        'nước',
      )) {
        _waterPrice =
            int.tryParse(
              service.price.replaceAll('.', ''),
            ) ??
            20000;
      }
    }
  }

  @override
  void dispose() {
    _rentCtrl.dispose();
    _oldElecCtrl.dispose();
    _newElecCtrl.dispose();
    _oldWaterCtrl.dispose();
    _newWaterCtrl.dispose();
    _serviceFeeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  // --- HÀM TÍNH TOÁN REAL-TIME ---
  void _calculateTotal() {
    int rent =
        int.tryParse(
          _rentCtrl.text.replaceAll('.', ''),
        ) ??
        0;

    int oldE =
        int.tryParse(_oldElecCtrl.text) ?? 0;
    int newE =
        int.tryParse(_newElecCtrl.text) ?? 0;
    int elecConsumed = (newE - oldE) > 0
        ? (newE - oldE)
        : 0;
    int elecTotal = elecConsumed * _elecPrice;

    int oldW =
        int.tryParse(_oldWaterCtrl.text) ?? 0;
    int newW =
        int.tryParse(_newWaterCtrl.text) ?? 0;
    int waterConsumed = (newW - oldW) > 0
        ? (newW - oldW)
        : 0;
    int waterTotal = waterConsumed * _waterPrice;

    int serviceFee =
        int.tryParse(
          _serviceFeeCtrl.text.replaceAll(
            '.',
            '',
          ),
        ) ??
        0;

    setState(() {
      _totalAmount =
          rent +
          elecTotal +
          waterTotal +
          serviceFee;
    });
  }

  // --- HÀM CHỌN PHÒNG/KHÁCH THUÊ ---
  void _selectResident() {
    // Lọc ra những người đang ở (Không lấy những người Đã thanh lý)
    List<Map<String, dynamic>> activeResidents =
        appData.residents
            .where(
              (res) =>
                  res['status'] != 'Đã thanh lý',
            )
            .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn phòng xuất hóa đơn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              activeResidents.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Chưa có khách thuê nào',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: activeResidents
                            .length,
                        itemBuilder: (context, index) {
                          var res =
                              activeResidents[index];
                          return ListTile(
                            leading: Container(
                              padding:
                                  const EdgeInsets.all(
                                    8,
                                  ),
                              decoration: BoxDecoration(
                                color: AppColors
                                    .primaryBlue
                                    .withOpacity(
                                      0.2,
                                    ),
                                shape: BoxShape
                                    .circle,
                              ),
                              child: const Icon(
                                Icons
                                    .meeting_room,
                                color: AppColors
                                    .primaryBlue,
                              ),
                            ),
                            title: Text(
                              res['room'] ??
                                  'Không rõ',
                              style:
                                  const TextStyle(
                                    color: Colors
                                        .white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                            ),
                            subtitle: Text(
                              res['name'] ?? '',
                              style: const TextStyle(
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(
                                context,
                              );
                              _applyResidentData(
                                res,
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  // --- HÀM BƠM DỮ LIỆU VÀO FORM SAU KHI CHỌN PHÒNG ---
  void _applyResidentData(
    Map<String, dynamic> resident,
  ) {
    setState(() {
      _selectedResident = resident;
      String roomName = resident['room'] ?? '';

      // 1. Bơm tiền phòng
      String rentString =
          (resident['rentPrice'] ?? '0')
              .toString()
              .replaceAll(RegExp(r'[^0-9]'), '');
      _rentCtrl.text = rentString.isNotEmpty
          ? rentString
          : '0';

      // 2. Bơm số điện nước (Nếu có)
      if (appData.utilityData.containsKey(
        roomName,
      )) {
        var util = appData.utilityData[roomName]!;
        _oldElecCtrl.text = util.oldElec
            .toString();
        _newElecCtrl.text = util.newElec
            .toString();
        _oldWaterCtrl.text = util.oldWater
            .toString();
        _newWaterCtrl.text = util.newWater
            .toString();
      } else {
        _oldElecCtrl.text = '0';
        _newElecCtrl.text = '0';
        _oldWaterCtrl.text = '0';
        _newWaterCtrl.text = '0';
      }

      // Ép hệ thống tính lại tiền ngay lập tức
      _calculateTotal();
    });
  }

  Future<void> _pickDate(
    bool isInvoiceDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate
          ? _invoiceDate
          : _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryBlue,
            onPrimary: Colors.white,
            surface: AppColors.cardBackground,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isInvoiceDate)
          _invoiceDate = picked;
        else
          _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format tiền tệ
    final formatter = NumberFormat(
      '#,###',
      'vi_VN',
    );

    // Tính toán lượng tiêu thụ và thành tiền từng phần (để in ra màn hình)
    int oldE =
        int.tryParse(_oldElecCtrl.text) ?? 0;
    int newE =
        int.tryParse(_newElecCtrl.text) ?? 0;
    int elecConsumed = (newE - oldE) > 0
        ? (newE - oldE)
        : 0;
    int elecTotal = elecConsumed * _elecPrice;

    int oldW =
        int.tryParse(_oldWaterCtrl.text) ?? 0;
    int newW =
        int.tryParse(_newWaterCtrl.text) ?? 0;
    int waterConsumed = (newW - oldW) > 0
        ? (newW - oldW)
        : 0;
    int waterTotal = waterConsumed * _waterPrice;

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
          'Tạo hóa đơn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
              top: BorderSide(
                color: AppColors.borderColor
                    .withOpacity(0.5),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'TỔNG CỘNG',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${formatter.format(_totalAmount)}đ',
                    style: const TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_selectedResident ==
                        null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng chọn Đối tượng (Phòng)!',
                          ),
                        ),
                      );
                      return;
                    }

                    // GÓI DỮ LIỆU ĐỂ TRUYỀN SANG MÀN PREVIEW
                    Map<String, dynamic>
                    package = {
                      'invoiceId':
                          'INV-${DateFormat('yyyyMM').format(_invoiceDate)}${_selectedResident!['room']}',
                      'room':
                          _selectedResident!['room'],
                      'residentName':
                          _selectedResident!['name'],
                      'monthStr': DateFormat(
                        'MM/yyyy',
                      ).format(_invoiceDate),
                      'dueDate': DateFormat(
                        'dd/MM/yyyy',
                      ).format(_dueDate),
                      'rentAmount':
                          int.tryParse(
                            _rentCtrl.text
                                .replaceAll(
                                  '.',
                                  '',
                                ),
                          ) ??
                          0,
                      'eOld':
                          int.tryParse(
                            _oldElecCtrl.text,
                          ) ??
                          0,
                      'eNew':
                          int.tryParse(
                            _newElecCtrl.text,
                          ) ??
                          0,
                      'eUse':
                          (int.tryParse(
                                _newElecCtrl.text,
                              ) ??
                              0) -
                          (int.tryParse(
                                _oldElecCtrl.text,
                              ) ??
                              0),
                      'ePrice': _elecPrice,
                      'elecAmount':
                          ((int.tryParse(
                                    _newElecCtrl
                                        .text,
                                  ) ??
                                  0) -
                              (int.tryParse(
                                    _oldElecCtrl
                                        .text,
                                  ) ??
                                  0)) *
                          _elecPrice,
                      'wOld':
                          int.tryParse(
                            _oldWaterCtrl.text,
                          ) ??
                          0,
                      'wNew':
                          int.tryParse(
                            _newWaterCtrl.text,
                          ) ??
                          0,
                      'wUse':
                          (int.tryParse(
                                _newWaterCtrl
                                    .text,
                              ) ??
                              0) -
                          (int.tryParse(
                                _oldWaterCtrl
                                    .text,
                              ) ??
                              0),
                      'wPrice': _waterPrice,
                      'waterAmount':
                          ((int.tryParse(
                                    _newWaterCtrl
                                        .text,
                                  ) ??
                                  0) -
                              (int.tryParse(
                                    _oldWaterCtrl
                                        .text,
                                  ) ??
                                  0)) *
                          _waterPrice,
                      'serviceAmount':
                          int.tryParse(
                            _serviceFeeCtrl.text
                                .replaceAll(
                                  '.',
                                  '',
                                ),
                          ) ??
                          0,
                      'totalAmount': _totalAmount,
                    };

                    // Chuyển sang màn Preview, nếu màn kia chốt (trả về true) thì màn này cũng tự động đóng theo
                    bool? isConfirmed =
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PreviewInvoiceScreen(
                                  invoiceData:
                                      package,
                                ),
                          ),
                        );
                    if (isConfirmed == true) {
                      Navigator.pop(
                        context,
                        true,
                      );
                    }
                  },
                  /**{
                    if (_selectedResident ==
                        null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng chọn Đối tượng (Phòng)!',
                          ),
                        ),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tính năng Gửi hóa đơn & Tạo PDF đang được phát triển.',
                        ),
                      ),
                    );
                  },*/
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Xem trước & Gửi hóa đơn',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- KHỐI NGÀY THÁNG ---
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(true),
                    child: _buildDateBox(
                      'KỲ HÓA ĐƠN',
                      _invoiceDate,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(false),
                    child: _buildDateBox(
                      'HẠN THANH TOÁN',
                      _dueDate,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- KHỐI ĐỐI TƯỢNG (CHỌN PHÒNG) ---
            const Text(
              'ĐỐI TƯỢNG',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectResident,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue
                      .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryBlue
                        .withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .door_front_door_outlined,
                          color: AppColors
                              .primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedResident !=
                                  null
                              ? 'Phòng ${_selectedResident!['room']}'
                              : 'Chọn phòng...',
                          style: TextStyle(
                            color:
                                _selectedResident !=
                                    null
                                ? AppColors
                                      .primaryBlue
                                : AppColors
                                      .textSecondary,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.edit,
                      color:
                          AppColors.primaryBlue,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- CHI TIẾT CÁC KHOẢN PHÍ ---
            const Text(
              'CHI TIẾT CÁC KHOẢN PHÍ',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 1. Tiền thuê nhà
            _buildFeeRow(
              title: 'Tiền thuê nhà',
              subtitle: 'Cố định hàng tháng',
              valueText:
                  '${formatter.format(int.tryParse(_rentCtrl.text.replaceAll('.', '')) ?? 0)}đ',
              customEditor: TextField(
                controller: _rentCtrl,
                keyboardType:
                    TextInputType.number,
                style: const TextStyle(
                  color: Colors.transparent,
                  fontSize: 1,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: Colors.transparent,
              ), // Ẩn input đi, chỉ dùng controller để bắt sự kiện thay đổi ngầm nếu cần
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Divider(
                color: AppColors.borderColor,
                height: 1,
              ),
            ),

            // 2. Tiền Điện
            _buildFeeRow(
              title: 'Tiền Điện',
              subtitle: '',
              valueText:
                  '${formatter.format(elecTotal)}đ',
              content: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallInput(
                          'SỐ ĐIỆN CŨ',
                          _oldElecCtrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSmallInput(
                          'SỐ ĐIỆN MỚI',
                          _newElecCtrl,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Text(
                        'TIÊU THỤ: $elecConsumed kWh',
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'ĐƠN GIÁ: ${formatter.format(_elecPrice)}đ',
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Divider(
                color: AppColors.borderColor,
                height: 1,
              ),
            ),

            // 3. Tiền Nước
            _buildFeeRow(
              title: 'Tiền Nước',
              subtitle: '',
              valueText:
                  '${formatter.format(waterTotal)}đ',
              content: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallInput(
                          'SỐ NƯỚC CŨ',
                          _oldWaterCtrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSmallInput(
                          'SỐ NƯỚC MỚI',
                          _newWaterCtrl,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Text(
                        'TIÊU THỤ: $waterConsumed m³',
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'ĐƠN GIÁ: ${formatter.format(_waterPrice)}đ',
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Divider(
                color: AppColors.borderColor,
                height: 1,
              ),
            ),

            // 4. Phí dịch vụ
            _buildFeeRow(
              title: 'Phí dịch vụ',
              subtitle:
                  'Vệ sinh & tiện ích chung',
              valueText:
                  '${formatter.format(int.tryParse(_serviceFeeCtrl.text.replaceAll('.', '')) ?? 0)}đ',
            ),
            const SizedBox(height: 32),

            // --- GHI CHÚ ---
            const Text(
              'GHI CHÚ',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              minLines: 3,
              maxLines: null,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText:
                    'Nhập ghi chú cho các khoản phát sinh hoặc lời nhắn cho cư dân...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor:
                    AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              8,
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

  Widget _buildFeeRow({
    required String title,
    required String subtitle,
    required String valueText,
    Widget? content,
    Widget? customEditor,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                if (customEditor != null)
                  SizedBox(
                    width: 100,
                    child: customEditor,
                  ), // Đặt input ẩn để sửa tiền phòng/dịch vụ nếu cần
                Text(
                  valueText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (content != null) ...[
          const SizedBox(height: 16),
          content,
        ],
      ],
    );
  }

  Widget _buildSmallInput(
    String label,
    TextEditingController ctrl,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 44,
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
