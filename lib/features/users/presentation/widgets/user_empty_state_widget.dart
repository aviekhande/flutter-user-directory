import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

class UserEmptyStateWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const UserEmptyStateWidget({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 64.r,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.emptyStateTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.emptyStateSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh, size: 20.r),
              label: Text(AppStrings.refreshButton, style: TextStyle(fontSize: 14.sp)),
              style: OutlinedButton.styleFrom(
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
