import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Hero Avatar with Ring Container
            Center(
              child: Hero(
                tag: 'user-avatar-${user.id}',
                child: Container(
                  padding: const EdgeInsets.all(4),
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
                      radius: 64,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 64,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 64,
                      backgroundColor: AppColors.primary.withAlpha(50),
                      child: Text(
                        user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              fullName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // User Information Cards
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.userDetailsTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Divider(height: 24),
                    UserDetailRow(
                      icon: Icons.badge_outlined,
                      label: AppStrings.userIdLabel,
                      value: '#${user.id}',
                    ),
                    const SizedBox(height: 16),
                    UserDetailRow(
                      icon: Icons.person_outline,
                      label: AppStrings.firstNameLabel,
                      value: user.firstName,
                    ),
                    const SizedBox(height: 16),
                    UserDetailRow(
                      icon: Icons.person_outline,
                      label: AppStrings.lastNameLabel,
                      value: user.lastName,
                    ),
                    const SizedBox(height: 16),
                    UserDetailRow(
                      icon: Icons.email_outlined,
                      label: AppStrings.emailLabel,
                      value: user.email,
                      trailing: IconButton(
                        icon: const Icon(Icons.copy_outlined, size: 20),
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
