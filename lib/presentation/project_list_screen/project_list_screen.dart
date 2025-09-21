import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './widgets/filter_sort_widget.dart';

import '../../core/app_export.dart';
import './widgets/project_card_widget.dart';
import './widgets/filter_sort_widget.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<Map<String, dynamic>> _allProjects = [];
  List<Map<String, dynamic>> _filteredProjects = [];

  String _searchQuery = "";
  String? _selectedStatus;
  String? _selectedSort;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  // 🔥 Load from backend instead of static mock
  void _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await dio.get(
        '/projects',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      dynamic payload = response.data;
      List<dynamic> serverProjects = [];

      // Flexible handling depending on backend shape
      if (payload is Map && payload.containsKey('projects')) {
        serverProjects = payload['projects'] as List<dynamic>;
      } else if (payload is List) {
        serverProjects = payload;
      } else if (payload is Map && payload.containsKey('project')) {
        serverProjects = [payload['project']];
      }

      List<Map<String, dynamic>> uiProjects = [];
      for (int i = 0; i < serverProjects.length; i++) {
        final sp = serverProjects[i] as Map<String, dynamic>;

        final remoteId = sp['id']?.toString() ??
            sp['_id']?.toString() ??
            '${DateTime.now().millisecondsSinceEpoch}_$i';

        final Map<String, dynamic> ui = {
          'id': i, // local UI id
          'remoteId': remoteId, // backend id
          'title': sp['title'] ?? sp['name'] ?? 'Untitled project',
          'description': sp['description'] ?? sp['desc'] ?? '',
          'area': sp['area'],
          'species': sp['species'] ?? '',
          'saplings': sp['saplings'] ?? sp['tokens'] ?? 0,
          'lat': sp['lat'] ?? sp['latitude'] ?? null,
          'lng': sp['lng'] ?? sp['longitude'] ?? null,
          'status': (sp['status'] ?? 'DRAFT').toString(),
          'cid': sp['cid'],
          'tokenId': sp['tokenId'],
          'createdAt': sp['createdAt'],
          'raw': sp,
        };

        uiProjects.add(ui);
      }

      setState(() {
        _allProjects = List.from(uiProjects);
        _filteredProjects = List.from(_allProjects);
        _isLoading = false;
      });

      _applyFiltersAndSort();
    } catch (e, st) {
      print("❌ Error loading projects: $e\n$st");
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Failed to load projects");
    }
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = _allProjects.where((p) {
      final matchesSearch = p['title']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _selectedStatus == "All" || p['status'] == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    if (_selectedSort == "Newest") {
      filtered.sort((a, b) =>
          (b['createdAt'] ?? '').toString().compareTo(a['createdAt'] ?? ''));
    } else if (_selectedSort == "Oldest") {
      filtered.sort((a, b) =>
          (a['createdAt'] ?? '').toString().compareTo(b['createdAt'] ?? ''));
    }

    setState(() {
      _filteredProjects = filtered;
    });
  }

  void _deleteProject(int projectId) {
    setState(() {
      _allProjects.removeWhere((p) => p['id'] == projectId);
      _filteredProjects.removeWhere((p) => p['id'] == projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search + Filters
            FilterSortWidget(
              searchQuery: _searchQuery,
              selectedStatus: _selectedStatus,
              selectedSort: _selectedSort,
              onSearchChanged: (val) {
                setState(() => _searchQuery = val);
                _applyFiltersAndSort();
              },
              onStatusChanged: (val) {
                setState(() => _selectedStatus = val);
                _applyFiltersAndSort();
              },
              onSortChanged: (val) {
                setState(() => _selectedSort = val);
                _applyFiltersAndSort();
              },
            ),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredProjects.isEmpty
                      ? Center(
                          child: Text(
                            "No projects found",
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            left: 4.w,
                            right: 4.w,
                            top: 2.h,
                            bottom: MediaQuery.of(context).viewInsets.bottom +
                                12.h, // ✅ fixes overflow
                          ),
                          itemCount: _filteredProjects.length,
                          itemBuilder: (context, index) {
                            final project = _filteredProjects[index];
                            return ProjectCardWidget(
                              project: project,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.projectDetails,
                                  arguments: project,
                                );
                              },
                              onDelete: () => _deleteProject(project['id']),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
