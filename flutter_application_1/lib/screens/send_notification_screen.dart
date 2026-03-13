import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../core/app_colors.dart';
import '../models/setup_model.dart';

class SendNotificationScreen
    extends StatefulWidget {
  const SendNotificationScreen({Key? key})
    : super(key: key);

  @override
  State<SendNotificationScreen> createState() =>
      _SendNotificationScreenState();
}

class _SendNotificationScreenState
    extends State<SendNotificationScreen> {
  final SetupData appData = SetupData();

  String _selectedTarget = 'Tất cả cư dân';
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  bool pushApp = true;
  bool sendEmail = false;
  bool sendSMS = false;

  void _sendNotification() {
    if (_titleCtrl.text.isEmpty ||
        _contentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập Tiêu đề và Nội dung!',
          ),
        ),
      );
      return;
    }

    // Đẩy thông báo vào Kho dữ liệu
    setState(() {
      appData.notifications.insert(0, {
        'title': _titleCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'category':
            'Tin tức', // Gắn mác là Tin tức/Hệ thống
        'time': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã gửi thông báo thành công!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách đối tượng nhận (Tất cả, Tầng, Phòng)
    List<String> targetOptions = [
      'Tất cả cư dân',
    ];
    for (var floor in appData.floors) {
      targetOptions.add('Toàn bộ ${floor.name}');
      for (var room in floor.rooms) {
        targetOptions.add('Phòng ${room.name}');
      }
    }

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
          'Gửi thông báo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // --- ĐỐI TƯỢNG NHẬN ---
            const Text(
              'Đối tượng nhận',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTarget,
                  isExpanded: true,
                  dropdownColor:
                      AppColors.cardBackground,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color:
                        AppColors.textSecondary,
                  ),
                  items: targetOptions
                      .map(
                        (String value) =>
                            DropdownMenuItem<
                              String
                            >(
                              value: value,
                              child: Text(value),
                            ),
                      )
                      .toList(),
                  onChanged: (newValue) =>
                      setState(
                        () => _selectedTarget =
                            newValue!,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- TIÊU ĐỀ ---
            const Text(
              'Tiêu đề thông báo',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText:
                    'Ví dụ: Thông báo tạm ngưng cung cấp nước',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor:
                    AppColors.inputBackground,
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- NỘI DUNG ---
            const Text(
              'Nội dung chi tiết',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentCtrl,
              maxLines: 6,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText:
                    'Nhập nội dung thông báo tại đây...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor:
                    AppColors.inputBackground,
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- ĐÍNH KÈM (DOTTED BORDER) ---
            GestureDetector(
              onTap: () =>
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Chức năng đính kèm đang phát triển',
                      ),
                    ),
                  ),
              child: DottedBorder(
                color: AppColors.textSecondary,
                strokeWidth: 1,
                dashPattern: const [6, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                  decoration: BoxDecoration(
                    color: AppColors
                        .inputBackground
                        .withOpacity(0.5),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.attach_file,
                        color: AppColors
                            .textSecondary,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Đính kèm hình ảnh/tài liệu',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- PHƯƠNG THỨC GỬI ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phương thức gửi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCheckbox(
                    'Gửi thông báo đẩy (Push)',
                    pushApp,
                    (val) => setState(
                      () => pushApp = val!,
                    ),
                  ),
                  _buildCheckbox(
                    'Gửi qua Email',
                    sendEmail,
                    (val) => setState(
                      () => sendEmail = val!,
                    ),
                  ),
                  _buildCheckbox(
                    'Gửi qua SMS',
                    sendSMS,
                    (val) => setState(
                      () => sendSMS = val!,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- NÚT GỬI ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _sendNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Gửi thông báo ngay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor:
            AppColors.textSecondary,
      ),
      child: CheckboxListTile(
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        value: value,
        activeColor: AppColors.primaryBlue,
        checkColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        controlAffinity:
            ListTileControlAffinity.leading,
        onChanged: onChanged,
      ),
    );
  }
}
