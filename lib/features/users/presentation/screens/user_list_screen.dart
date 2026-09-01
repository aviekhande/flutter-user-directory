import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_style.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../widgets/widgets.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const FetchUsersEvent(page: 1));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserBloc>().add(LoadMoreUsersEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppStrings.usersTitle,
          style: kTextStyleRoboto700.copyWith(fontSize: 20.sp),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          UserSearchBar(
            controller: _searchController,
            onChanged: (query) {
              context.read<UserBloc>().add(SearchUsersEvent(query));
            },
            onClear: () {
              _searchController.clear();
              context.read<UserBloc>().add(const SearchUsersEvent(''));
            },
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial || state is UserLoading) {
                  return const UserSkeletonLoader();
                } else if (state is UserError) {
                  final isNetworkError = state.message.toLowerCase().contains('connection') ||
                      state.message.toLowerCase().contains('internet');
                  return Column(
                    children: [
                      if (isNetworkError)
                        OfflineBanner(
                          onRetry: () {
                            context.read<UserBloc>().add(const FetchUsersEvent(page: 1));
                          },
                        ),
                      Expanded(
                        child: UserErrorWidget(
                          message: state.message,
                          onRetry: () {
                            _searchController.clear();
                            context.read<UserBloc>().add(const FetchUsersEvent(page: 1));
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is UserEmpty) {
                  return UserEmptyStateWidget(
                    onRefresh: () {
                      _searchController.clear();
                      context.read<UserBloc>().add(RefreshUsersEvent());
                    },
                  );
                } else if (state is UserLoaded || state is UserLoadingMore) {
                  final List<UserEntity> users = state is UserLoaded
                      ? state.users
                      : (state as UserLoadingMore).users;

                  final bool hasMore = state is UserLoaded ? state.hasMore : true;
                  final bool isLoadingMore = state is UserLoadingMore;

                  return RefreshIndicator(
                    onRefresh: () async {
                      _searchController.clear();
                      context.read<UserBloc>().add(RefreshUsersEvent());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: users.length + (hasMore || isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < users.length) {
                          return UserCard(user: users[index]);
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
