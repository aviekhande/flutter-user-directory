import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';
import '../widgets/widgets.dart';

class UserDetailScreen extends StatelessWidget {
  final UserEntity user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = '${user.firstName} ${user.lastName}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          fullName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            // Hero Avatar with Ring Container
            Center(
              child: Hero(
                tag: 'user-avatar-${user.id}',
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withAlpha(100),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: user.avatar,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 64.r,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      radius: 64.r,
                      child: const CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 64.r,
                      backgroundColor: AppColors.primary.withAlpha(50),
                      child: Text(
                        user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              fullName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            // User Information Cards
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.userDetailsTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16.sp,
                      ),
                    ),
                    Divider(height: 24.h),
                    UserDetailRow(
                      icon: Icons.badge_outlined,
                      label: AppStrings.userIdLabel,
                      value: '#${user.id}',
                    ),
                    SizedBox(height: 16.h),
                    UserDetailRow(
                      icon: Icons.person_outline,
                      label: AppStrings.firstNameLabel,
                      value: user.firstName,
                    ),
                    SizedBox(height: 16.h),
                    UserDetailRow(
                      icon: Icons.person_outline,
                      label: AppStrings.lastNameLabel,
                      value: user.lastName,
                    ),
                    SizedBox(height: 16.h),
                    UserDetailRow(
                      icon: Icons.email_outlined,
                      label: AppStrings.emailLabel,
                      value: user.email,
                      trailing: IconButton(
                        icon: Icon(Icons.copy_outlined, size: 20.r),
                        tooltip: AppStrings.copyEmailTooltip,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: user.email));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.emailCopiedMessage),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
