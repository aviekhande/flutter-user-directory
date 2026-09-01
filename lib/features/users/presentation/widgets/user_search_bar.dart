import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_style.dart';

class UserSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const UserSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: kTextStyleRoboto400.copyWith(fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: kTextStyleRoboto400.copyWith(fontSize: 14.sp),
          prefixIcon: Icon(AppIcons.search, size: 22.r),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(AppIcons.clear, size: 20.r),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
