import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({Key? key})
    : super(key: key);

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
          'Điều khoản & Chính sách',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: const [
            Text(
              '1. Điều khoản sử dụng',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Bằng việc sử dụng ứng dụng, bạn đồng ý tuân thủ các quy định về quản lý tòa nhà và pháp luật hiện hành. Không sử dụng ứng dụng cho các mục đích vi phạm pháp luật.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            SizedBox(height: 24),
            Text(
              '2. Chính sách bảo mật',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Chúng tôi cam kết bảo mật tuyệt đối thông tin cá nhân của chủ nhà và cư dân. Dữ liệu eKYC, mật khẩu và các thông tin tài chính được mã hóa chuẩn ngân hàng.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            SizedBox(height: 24),
            Text(
              '3. Quyền và nghĩa vụ',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Ban quản lý phần mềm có quyền tạm ngưng tài khoản nếu phát hiện dấu hiệu gian lận. Người dùng có trách nhiệm bảo mật thông tin đăng nhập của mình.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
