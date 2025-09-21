import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dome_gallery_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_action_buttons_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/search_bar_widget.dart';

class NgoHomeScreen extends StatefulWidget {
  const NgoHomeScreen({Key? key}) : super(key: key);

  @override
  State<NgoHomeScreen> createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  bool _isSearchVisible = false;
  bool _isSyncing = false;
  double _syncProgress = 0.0;
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredProjects = [];
  Set<int> _selectedProjects = {};

  // Mock data
  final List<Map<String, dynamic>> _projects = [];

  final List<Map<String, dynamic>> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredProjects = List.from(_projects);

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_isSearchVisible) {
        setState(() => _isSearchVisible = true);
      } else if (_scrollController.offset <= 100 && _isSearchVisible) {
        setState(() => _isSearchVisible = false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHomeTab(),
                  _buildProjectsTab(),
                  _buildMapTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'home',
              size: 20,
              color: _tabController.index == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Home',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'folder',
              size: 20,
              color: _tabController.index == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Projects',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'map',
              size: 20,
              color: _tabController.index == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Map',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              size: 20,
              color: _tabController.index == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    GreetingHeaderWidget(
                      userName: 'Priya Sharma',
                      notificationCount: 3,
                      onNotificationTap: _handleNotificationTap,
                    ),
                    DomeGalleryWidget(
                      projects: _filteredProjects,
                      onProjectTap: _handleProjectTap,
                      onProjectLongPress: _handleProjectLongPress,
                    ),
                    SizedBox(height: 2.h),
                    RecentActivityWidget(activities: _recentActivities),
                    SizedBox(height: 15.h), // Space for floating buttons
                  ],
                ),
              ),
            ],
          ),
          SearchBarWidget(
            isVisible: _isSearchVisible,
            onSearchChanged: _handleSearchChanged,
            onClear: _handleSearchClear,
          ),
          QuickActionButtonsWidget(
            onCameraPressed: _handleCameraPressed,
            onAddPressed: _handleAddPressed,
            onSyncPressed: _handleSyncPressed,
            isSyncing: _isSyncing,
            syncProgress: _syncProgress,
          ),
          if (_selectedProjects.isNotEmpty) _buildBulkActionSheet(),
        ],
      ),
    );
  }

  Widget _buildProjectsTab() {
    // Navigate to the projects list screen.
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.projectList),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'folder',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'View Projects',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap to see all your projects',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTab() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.interactiveMap),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'map',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'Interactive Map',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap to view projects on the map',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.profileSettings),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'person',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'Profile Settings',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap to manage your profile',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkActionSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${_selectedProjects.length} projects selected',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedProjects.clear()),
              child: Text('Cancel'),
            ),
            SizedBox(width: 2.w),
            ElevatedButton(
              onPressed: _handleBulkAction,
              child: Text('Actions'),
            ),
          ],
        ),
      ),
    );
  }

  // Event handlers
  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _filteredProjects = List.from(_projects);
    });
  }

  void _handleNotificationTap() {
    Navigator.pushNamed(context, '/notification-center-screen');
  }

  void _handleProjectTap(Map<String, dynamic> project) {
    Navigator.pushNamed(
      context,
      '/project-detail-screen',
      arguments: project,
    );
  }

  void _handleProjectLongPress(Map<String, dynamic> project) {
    final projectId = project['id'] as int;
    setState(() {
      if (_selectedProjects.contains(projectId)) {
        _selectedProjects.remove(projectId);
      } else {
        _selectedProjects.add(projectId);
      }
    });

    _showContextMenu(project);
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProjects = List.from(_projects);
      } else {
        _filteredProjects = _projects.where((project) {
          final title = (project['title'] as String? ?? '').toLowerCase();
          final location = (project['location'] as String? ?? '').toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || location.contains(searchLower);
        }).toList();
      }
    });
  }

  void _handleSearchClear() {
    setState(() {
      _searchQuery = '';
      _filteredProjects = List.from(_projects);
    });
  }

  void _handleCameraPressed() {
    Navigator.pushNamed(context, '/camera-capture-screen');
  }

  void _handleAddPressed() {
    Navigator.pushNamed(context, '/project-submission-screen');
  }

  Future<void> _handleSyncPressed() async {
    setState(() => _isSyncing = true);

    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() => _syncProgress = i / 100);
    }

    setState(() {
      _isSyncing = false;
      _syncProgress = 0.0;
    });
  }

  void _handleBulkAction() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'delete',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.error),
              title: Text('Delete Selected'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'share',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.primary),
              title: Text('Share Selected'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'archive',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.secondary),
              title: Text('Archive Selected'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'visibility',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.primary),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _handleProjectTap(project);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'edit',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.secondary),
              title: Text('Edit'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'content_copy',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.tertiary),
              title: Text('Duplicate'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'share',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
              title: Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
