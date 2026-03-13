import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class NotificationSettingsScreen
    extends StatefulWidget {
  const NotificationSettingsScreen({Key? key})
    : super(key: key);
  @override
  State<NotificationSettingsScreen>
  createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotif = true;
  bool _billNotif = true;
  bool _maintenanceNotif = true;
  bool _promoNotif = false;

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
          'Cài đặt thông báo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSwitch(
            'Nhận thông báo đẩy (Push Notifications)',
            'Hiển thị thông báo trên màn hình khóa',
            _pushNotif,
            (val) =>
                setState(() => _pushNotif = val),
          ),
          const Divider(
            color: AppColors.borderColor,
            height: 30,
          ),
          _buildSwitch(
            'Thông báo Hóa đơn & Thanh toán',
            'Nhắc nhở khi có hóa đơn mới hoặc quá hạn',
            _billNotif,
            (val) =>
                setState(() => _billNotif = val),
          ),
          const Divider(
            color: AppColors.borderColor,
            height: 30,
          ),
          _buildSwitch(
            'Thông báo Sự cố & Sửa chữa',
            'Cập nhật trạng thái các yêu cầu bảo trì',
            _maintenanceNotif,
            (val) => setState(
              () => _maintenanceNotif = val,
            ),
          ),
          const Divider(
            color: AppColors.borderColor,
            height: 30,
          ),
          _buildSwitch(
            'Cập nhật hệ thống & Khuyến mãi',
            'Tin tức mới nhất từ ban quản lý phần mềm',
            _promoNotif,
            (val) =>
                setState(() => _promoNotif = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
      value: value,
      activeColor: AppColors.primaryBlue,
      contentPadding: EdgeInsets.zero,
      onChanged: onChanged,
    );
  }
}
