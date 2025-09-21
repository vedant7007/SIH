import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/admin_header_widget.dart';
import './widgets/bulk_actions_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/project_card_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/search_sort_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _selectedSort = 'Submission Date';
  final List<String> _sortOptions = [
    'Submission Date',
    'Priority',
    'AI Score',
    'Alphabetical'
  ];

  final Set<String> _selectedProjects = <String>{};
  bool _isRefreshing = false;

  List<Map<String, dynamic>> _pendingProjects = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _loadPendingProjects();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<Map<String, dynamic>> get _filteredProjects {
    List<Map<String, dynamic>> filtered = _pendingProjects;

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((project) => project['status'] == _selectedFilter)
          .toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered
          .where((project) =>
              (project['title'] as String).toLowerCase().contains(searchTerm) ||
              (project['ngoName'] as String)
                  .toLowerCase()
                  .contains(searchTerm) ||
              (project['location'] as String)
                  .toLowerCase()
                  .contains(searchTerm))
          .toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Submission Date':
        filtered.sort((a, b) => DateTime.parse(b['submissionDate'] as String)
            .compareTo(DateTime.parse(a['submissionDate'] as String)));
        break;
      case 'Priority':
        filtered.sort((a, b) {
          final aPriority = a['isPriority'] as bool;
          final bPriority = b['isPriority'] as bool;
          if (aPriority && !bPriority) return -1;
          if (!aPriority && bPriority) return 1;
          return 0;
        });
        break;
      case 'AI Score':
        filtered.sort((a, b) =>
            (b['aiScore'] as double).compareTo(a['aiScore'] as double));
        break;
      case 'Alphabetical':
        filtered.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _filterOptions {
    final Map<String, int> statusCounts = {};
    for (final project in _pendingProjects) {
      final status = project['status'] as String;
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    return [
      {'status': 'All', 'count': _pendingProjects.length},
      {
        'status': 'SUBMITTED',
        'count': statusCounts['SUBMITTED'] ?? 0,
        'label': 'Pending'
      },
      {'status': 'APPROVED', 'count': statusCounts['APPROVED'] ?? 0},
      {'status': 'REJECTED', 'count': statusCounts['REJECTED'] ?? 0},
    ];
  }

  int get _pendingReviews =>
      _pendingProjects.where((p) => p['status'] == 'SUBMITTED').length;

  int get _approvedProjects =>
      _pendingProjects.where((p) => p['status'] == 'APPROVED').length;

  // Assuming 'saplings' is a proxy for credits until defined
  int get _totalCreditsMinted => _pendingProjects
      .where((p) => p['status'] == 'APPROVED')
      .fold(0, (sum, p) => sum + (p['saplings'] as int? ?? 0));

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isRefreshing = false);
  }

  void _onProjectLongPress(String projectId) {
    setState(() {
      if (_selectedProjects.contains(projectId)) {
        _selectedProjects.remove(projectId);
      } else {
        _selectedProjects.add(projectId);
      }
    });
  }

  void _showBulkActionDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Bulk $action'),
          content: Text(
              'Are you sure you want to $action ${_selectedProjects.length} selected project${_selectedProjects.length > 1 ? 's' : ''}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _selectedProjects.clear());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${_selectedProjects.length} projects ${action.toLowerCase()}d successfully'),
                  ),
                );
              },
              child: Text(action),
            ),
          ],
        );
      },
    );
  }

  void _showActionDialog(String action, Map<String, dynamic> project) async {
    final newStatus = action.toUpperCase();
    final projectId = project['id'];
    final projectTitle = project['title'];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action Project'),
          content: Text('Are you sure you want to $action "$projectTitle"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(action),
              style: ElevatedButton.styleFrom(
                  backgroundColor: action == 'Reject' ? Colors.red : null),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("auth_token");
        final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

        await dio.post(
          "/admin/projects/$projectId/status",
          data: {"status": newStatus, "notes": "$action by admin"},
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project ${action.toLowerCase()}ed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadPendingProjects(); // Refresh list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to $action project: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadPendingProjects() async {
    setState(() => _isRefreshing = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await dio.get(
        '/admin/projects/pending',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data['pending'] as List<dynamic>? ?? [];

      setState(() {
        _pendingProjects = data.map((d) {
          final p = d as Map<String, dynamic>;
          // Flatten nested owner object for easier access
          return {
            ...p,
            'ngoName': p['owner']?['name'] ?? 'Unknown NGO',
            'submissionDate': p['createdAt']
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load projects: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          AdminHeaderWidget(
            adminName: 'Dr. Rajesh Kumar',
            notificationCount: 12,
            onNotificationTap: () =>
                Navigator.pushNamed(context, '/notification-center-screen'),
          ),
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Dashboard'),
                Tab(text: 'Analytics'),
                Tab(text: 'Config'),
                Tab(text: 'Profile'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildAnalyticsTab(),
                _buildConfigTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Advanced Filters',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  Text('Advanced filtering options would be implemented here'),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Apply Filters'),
                  ),
                ],
              ),
            ),
          );
        },
        child: CustomIconWidget(
          iconName: 'tune',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        children: [
          QuickStatsWidget(
            pendingReviews: _pendingReviews,
            approvedProjects: _approvedProjects,
            totalCreditsMinted: _totalCreditsMinted,
          ),
          FilterChipsWidget(
            filters: _filterOptions,
            selectedFilter: _selectedFilter,
            onFilterSelected: (filter) =>
                setState(() => _selectedFilter = filter),
          ),
          SearchSortWidget(
            searchController: _searchController,
            selectedSort: _selectedSort,
            sortOptions: _sortOptions,
            onSortChanged: (sort) => setState(() => _selectedSort = sort),
            onSearchChanged: _onSearchChanged,
          ),
          BulkActionsWidget(
            selectedCount: _selectedProjects.length,
            onBulkApprove: () => _showBulkActionDialog('Approve'),
            onBulkReject: () => _showBulkActionDialog('Reject'),
            onClearSelection: () => setState(() => _selectedProjects.clear()),
          ),
          Expanded(
            child: _isRefreshing
                ? Center(child: CircularProgressIndicator())
                : _filteredProjects.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'search_off',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No projects found',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Try adjusting your filters or search terms',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredProjects.length,
                        itemBuilder: (context, index) {
                          final project = _filteredProjects[index];
                          final projectId = project['id'] as String;

                          return ProjectCardWidget(
                            project: project,
                            isSelected: _selectedProjects.contains(projectId),
                            onLongPress: () => _onProjectLongPress(projectId),
                            onApprove: () =>
                                _showActionDialog('Approve', project),
                            onReject: () =>
                                _showActionDialog('Reject', project),
                            onViewDetails: () => Navigator.pushNamed(
                                context, '/project-detail-screen'),
                            onAssignReviewer: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Assign reviewer functionality')),
                              );
                            },
                            onSetPriority: () {
                              setState(() {
                                project['isPriority'] =
                                    !(project['isPriority'] as bool);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(project['isPriority'] as bool
                                      ? 'Project marked as priority'
                                      : 'Priority removed from project'),
                                ),
                              );
                            },
                            onRequestMoreInfo: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Request more info sent to NGO')),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Analytics Dashboard',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Charts and analytics would be displayed here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Configuration Panel',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Admin configuration options would be displayed here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'account_circle',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Admin Profile',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Profile settings and information would be displayed here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/profile-settings-screen'),
            child: Text('Go to Profile Settings'),
          ),
        ],
      ),
    );
  }
}
