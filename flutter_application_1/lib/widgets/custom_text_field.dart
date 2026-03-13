import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController?
  controller; // << Thêm dòng này

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller, // << Thêm dòng này
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller:
              controller, // << Gắn controller vào TextField
          obscureText: isPassword,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: isPassword
                ? const Icon(
                    Icons.visibility_outlined,
                    color:
                        AppColors.textSecondary,
                    size: 20,
                  )
                : null,
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
