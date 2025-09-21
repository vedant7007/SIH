import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notification_empty_state_widget.dart';
import './widgets/notification_filter_tabs_widget.dart';
import './widgets/notification_search_widget.dart';
import './widgets/notification_section_header_widget.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({Key? key}) : super(key: key);

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isMultiSelectMode = false;
  Set<String> _selectedNotifications = {};
  bool _isRefreshing = false;
  String _userRole = 'ngo';

  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshAnimation;

  // Empty notification data - user will add their own
  final List<Map<String, dynamic>> _allNotifications = [];

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _refreshAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _loadUserRole();
    _deleteAllNotifications();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('user_role') ?? 'ngo';
    });
  }

  Future<void> _deleteAllNotifications() async {
    // Clear all existing notifications as requested
    setState(() {
      _allNotifications.clear();
    });
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    List<Map<String, dynamic>> filtered = _allNotifications;

    // Role-based filtering - NGO gets only NGO notifications, Company gets only Company notifications
    filtered =
        filtered.where((notification) {
          final notificationRole =
              notification['target_role'] as String? ?? 'all';
          return notificationRole == 'all' || notificationRole == _userRole;
        }).toList();

    // Apply filter
    switch (_selectedFilter) {
      case 'Unread':
        filtered = filtered.where((n) => n['isUnread'] == true).toList();
        break;
      case 'Project Related':
        filtered =
            filtered
                .where(
                  (n) => [
                    'Project Updates',
                    'Verification Results',
                  ].contains(n['category']),
                )
                .toList();
        break;
      case 'System Messages':
        filtered =
            filtered.where((n) => n['category'] == 'System Alerts').toList();
        break;
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((n) {
            final title = (n['title'] ?? '').toLowerCase();
            final sender = (n['sender'] ?? '').toLowerCase();
            final preview = (n['preview'] ?? '').toLowerCase();
            final query = _searchQuery.toLowerCase();

            return title.contains(query) ||
                sender.contains(query) ||
                preview.contains(query);
          }).toList();
    }

    return filtered;
  }

  Map<String, int> get _filterCounts {
    final roleFilteredNotifications =
        _allNotifications.where((notification) {
          final notificationRole =
              notification['target_role'] as String? ?? 'all';
          return notificationRole == 'all' || notificationRole == _userRole;
        }).toList();

    return {
      'All': roleFilteredNotifications.length,
      'Unread':
          roleFilteredNotifications.where((n) => n['isUnread'] == true).length,
      'Project Related':
          roleFilteredNotifications
              .where(
                (n) => [
                  'Project Updates',
                  'Verification Results',
                ].contains(n['category']),
              )
              .length,
      'System Messages':
          roleFilteredNotifications
              .where((n) => n['category'] == 'System Alerts')
              .length,
    };
  }

  Map<String, List<Map<String, dynamic>>> get _groupedNotifications {
    final notifications = _filteredNotifications;
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'Earlier': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(const Duration(days: 7));

    for (final notification in notifications) {
      final timestamp = notification['timestamp'] as DateTime;
      final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

      if (date == today) {
        grouped['Today']!.add(notification);
      } else if (date == yesterday) {
        grouped['Yesterday']!.add(notification);
      } else if (date.isAfter(thisWeek)) {
        grouped['This Week']!.add(notification);
      } else {
        grouped['Earlier']!.add(notification);
      }
    }

    // Remove empty sections
    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshAnimationController.forward();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Provide haptic feedback
    HapticFeedback.mediumImpact();

    _refreshAnimationController.reverse();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        final notificationRole =
            notification['target_role'] as String? ?? 'all';
        if (notificationRole == 'all' || notificationRole == _userRole) {
          notification['isUnread'] = false;
        }
      }
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    if (_isMultiSelectMode) {
      _toggleNotificationSelection(notification['id']);
      return;
    }

    // Mark as read
    setState(() {
      notification['isUnread'] = false;
    });

    // Navigate to related screen with proper route handling
    final String? relatedScreen = notification['relatedScreen'];
    if (relatedScreen != null) {
      // Fix redirect issues by using proper route names
      String routeName;
      switch (relatedScreen) {
        case '/project-detail-screen':
          routeName = AppRoutes.projectDetail;
          break;
        case '/carbon-credit-marketplace-screen':
          routeName = AppRoutes.carbonCreditMarketplace;
          break;
        case '/project-submission-screen':
          routeName = AppRoutes.projectSubmission;
          break;
        case '/admin-dashboard-screen':
          routeName = AppRoutes.adminDashboard;
          break;
        case '/profile-settings-screen':
          routeName = AppRoutes.profileSettings;
          break;
        default:
          routeName = AppRoutes.ngoHome;
      }
      Navigator.pushNamed(context, routeName);
    }
  }

  void _handleLongPress(String notificationId) {
    if (!_isMultiSelectMode) {
      setState(() {
        _isMultiSelectMode = true;
        _selectedNotifications.add(notificationId);
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _toggleNotificationSelection(String notificationId) {
    setState(() {
      if (_selectedNotifications.contains(notificationId)) {
        _selectedNotifications.remove(notificationId);
      } else {
        _selectedNotifications.add(notificationId);
      }

      if (_selectedNotifications.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedNotifications.clear();
    });
  }

  void _handleBulkAction(String action) {
    switch (action) {
      case 'markAsRead':
        setState(() {
          for (var notification in _allNotifications) {
            if (_selectedNotifications.contains(notification['id'])) {
              notification['isUnread'] = false;
            }
          }
        });
        break;
      case 'archive':
        // Implement archive functionality
        break;
      case 'delete':
        setState(() {
          _allNotifications.removeWhere(
            (n) => _selectedNotifications.contains(n['id']),
          );
        });
        break;
    }

    _exitMultiSelectMode();
    HapticFeedback.lightImpact();
  }

  void _handleNotificationAction(String notificationId, String action) {
    final notification = _allNotifications.firstWhere(
      (n) => n['id'] == notificationId,
    );

    switch (action) {
      case 'markAsRead':
        setState(() {
          notification['isUnread'] = false;
        });
        break;
      case 'archive':
        // Implement archive functionality
        break;
      case 'delete':
        setState(() {
          _allNotifications.removeWhere((n) => n['id'] == notificationId);
        });
        // Show undo option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _allNotifications.add(notification);
                });
              },
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        break;
      case 'reply':
        // Navigate to reply screen or show reply dialog
        break;
    }

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          NotificationSearchWidget(
            searchQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          NotificationFilterTabsWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            filterCounts: _filterCounts,
          ),
          Expanded(
            child:
                _filteredNotifications.isEmpty
                    ? NotificationEmptyStateWidget(
                      filterType: _selectedFilter,
                      onEnableNotifications: () {
                        // Handle enable notifications
                      },
                    )
                    : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                      child: _buildNotificationsList(),
                    ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading:
          _isMultiSelectMode
              ? IconButton(
                onPressed: _exitMultiSelectMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              )
              : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              ),
      title: Text(
        _isMultiSelectMode
            ? '${_selectedNotifications.length} selected'
            : 'Notifications ($_userRole)',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions:
          _isMultiSelectMode
              ? [
                IconButton(
                  onPressed: () => _handleBulkAction('markAsRead'),
                  icon: CustomIconWidget(
                    iconName: 'mark_email_read',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
                IconButton(
                  onPressed: () => _handleBulkAction('archive'),
                  icon: CustomIconWidget(
                    iconName: 'archive',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
                IconButton(
                  onPressed: () => _handleBulkAction('delete'),
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 6.w,
                  ),
                ),
              ]
              : [
                if (_filterCounts['Unread']! > 0)
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: Text(
                      'Mark all read',
                      style: AppTheme.lightTheme.textTheme.labelMedium
                          ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
    );
  }

  Widget _buildNotificationsList() {
    final groupedNotifications = _groupedNotifications;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groupedNotifications.entries
          .map((entry) => entry.value.length + 1)
          .fold<int>(0, (sum, count) => sum + count),
      itemBuilder: (context, index) {
        int currentIndex = 0;

        for (final entry in groupedNotifications.entries) {
          final sectionTitle = entry.key;
          final notifications = entry.value;

          // Section header
          if (index == currentIndex) {
            return NotificationSectionHeaderWidget(
              title: sectionTitle,
              count: notifications.length,
            );
          }
          currentIndex++;

          // Notification cards
          if (index < currentIndex + notifications.length) {
            final notificationIndex = index - currentIndex;
            final notification = notifications[notificationIndex];

            return NotificationCardWidget(
              notification: notification,
              onTap: () => _handleNotificationTap(notification),
              onMarkAsRead:
                  () => _handleNotificationAction(
                    notification['id'],
                    'markAsRead',
                  ),
              onArchive:
                  () =>
                      _handleNotificationAction(notification['id'], 'archive'),
              onDelete:
                  () => _handleNotificationAction(notification['id'], 'delete'),
              onReply:
                  () => _handleNotificationAction(notification['id'], 'reply'),
              isSelected: _selectedNotifications.contains(notification['id']),
              isMultiSelectMode: _isMultiSelectMode,
              onSelectionChanged: (selected) {
                if (selected == true) {
                  _handleLongPress(notification['id']);
                } else {
                  _toggleNotificationSelection(notification['id']);
                }
              },
            );
          }
          currentIndex += notifications.length;
        }

        return const SizedBox.shrink();
      },
    );
  }
}
