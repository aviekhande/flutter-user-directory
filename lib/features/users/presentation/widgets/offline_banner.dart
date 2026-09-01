import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_style.dart';

class OfflineBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineBanner({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warning,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(AppIcons.wifiOff, color: AppColors.white, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              AppStrings.offlineBannerMessage,
              style: kTextStyleRoboto500.copyWith(color: AppColors.white, fontSize: 13.sp),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(AppStrings.retryButton, style: kTextStyleRoboto700.copyWith(fontSize: 13.sp)),
          ),
        ],
      ),
    );
  }
}
