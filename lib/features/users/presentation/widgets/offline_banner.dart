import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';

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
      color: Colors.amber.shade900,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              AppStrings.offlineBannerMessage,
              style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(AppStrings.retryButton, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
