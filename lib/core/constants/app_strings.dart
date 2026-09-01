/// Centralized application string literals.
/// Ensures single source of truth for titles, labels, error messages, and routes.
abstract class AppStrings {
  // App & Titles
  static const String appTitle = 'User Directory';
  static const String usersTitle = 'Users';
  static const String userDetailsTitle = 'User Details';

  // Search
  static const String searchHint = 'Search by first or last name...';

  // User Details
  static const String userIdLabel = 'User ID';
  static const String firstNameLabel = 'First Name';
  static const String lastNameLabel = 'Last Name';
  static const String emailLabel = 'Email Address';
  static const String phoneLabel = 'Phone Number';
  static const String copyEmailTooltip = 'Copy Email';
  static const String copyPhoneTooltip = 'Copy Phone';
  static const String emailCopiedMessage = 'Email copied to clipboard';
  static const String phoneCopiedMessage = 'Phone number copied to clipboard';

  // Offline Banner
  static const String offlineBannerMessage =
      'No internet connection. Showing offline data.';

  // Error Messages & Titles
  static const String defaultServerError =
      'Server error occurred. Please try again.';
  static const String defaultCacheError =
      'Cache failure. No local data found.';
  static const String defaultNetworkError =
      'No internet connection. Please check your connection.';
  static const String defaultTimeoutError = 'Request timed out. Try again.';
  static const String defaultUnexpectedError = 'An unexpected error occurred.';

  static const String errorTitleDefault = 'Something went wrong';
  static const String errorTitleTimeout = 'Request Timed Out';

  // Buttons
  static const String retryButton = 'Retry';
  static const String tryAgainButton = 'Try Again';
  static const String refreshButton = 'Refresh';

  // Empty State
  static const String emptyStateTitle = 'No Users Found';
  static const String emptyStateSubtitle =
      'We couldn\'t find any users matching your criteria.';

  // Storage & Keys
  static const String usersBoxKey = 'users_box';
  static const String cachedUsersKey = 'CACHED_USERS';

  // Routes
  static const String initialRoute = '/';
  static const String userDetailRoute = '/detail';
}
