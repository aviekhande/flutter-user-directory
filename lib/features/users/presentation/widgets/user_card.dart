import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../domain/entities/user_entity.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        onTap: () {
          context.push(AppRoutes.userDetail, extra: user);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Hero(
          tag: 'user-avatar-${user.id}',
          child: CachedNetworkImage(
            imageUrl: user.avatar,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 26.r,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => CircleAvatar(
              radius: 26.r,
              child: SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 26.r,
              backgroundColor: AppColors.primary.withAlpha(50),
              child: Text(
                user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                style: kTextStyleRoboto700.copyWith(
                  color: AppColors.primary,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: kTextStyleRoboto600.copyWith(
            fontSize: 16.sp,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            user.email,
            style: kTextStyleRoboto400.copyWith(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
