import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';
import '../screens/user_detail_screen.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserDetailScreen(user: user),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: 'user-avatar-${user.id}',
          child: CachedNetworkImage(
            imageUrl: user.avatar,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 26,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => const CircleAvatar(
              radius: 26,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary.withAlpha(50),
              child: Text(
                user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            user.email,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
