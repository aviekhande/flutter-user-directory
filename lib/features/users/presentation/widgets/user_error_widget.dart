import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_style.dart';

class UserErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const UserErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isTimeout = message.toLowerCase().contains('timed out');
    final icon = isTimeout ? AppIcons.timerOff : AppIcons.error;
    final title = isTimeout ? AppStrings.errorTitleTimeout : AppStrings.errorTitleDefault;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.r,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: kTextStyleRoboto700.copyWith(
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: kTextStyleRoboto400.copyWith(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(AppIcons.refresh, size: 20.r),
              label: Text(AppStrings.tryAgainButton, style: kTextStyleRoboto500.copyWith(fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
