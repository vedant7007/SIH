import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/beneficiary_count_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/location_section_widget.dart';
import './widgets/photo_gallery_widget.dart';
import './widgets/project_description_field_widget.dart';
import './widgets/project_form_header_widget.dart';
import './widgets/project_title_field_widget.dart';
import './widgets/project_type_picker_widget.dart';
import './widgets/submit_button_widget.dart';

class ProjectSubmissionScreen extends StatefulWidget {
  @override
  State<ProjectSubmissionScreen> createState() =>
      _ProjectSubmissionScreenState();
}

class _ProjectSubmissionScreenState extends State<ProjectSubmissionScreen> {
  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _addressController = TextEditingController();
  final _beneficiaryController = TextEditingController();

  // State
  bool _isSubmitting = false;
  bool _isDraftSaving = false;
  bool _isGpsEnabled = false;
  bool _isLoadingLocation = false;
  bool _isPhotoLoading = false;
  bool _isOffline = false;

  List<String> _projectPhotos = [];
  String? _selectedProjectType;
  DateTime? _startDate;
  DateTime? _completionDate;
  Timer? _draftSaveTimer;

  // Validation
  String? _titleError;
  String? _descriptionError;
  String? _locationError;
  String? _projectTypeError;
  String? _startDateError;
  String? _beneficiaryError;

  final List<String> _projectTypes = [
    'Tree Plantation',
    'Mangrove Restoration',
    'Forest Conservation',
    'Agroforestry',
    'Wetland Restoration',
    'Grassland Restoration',
    'Bamboo Cultivation',
    'Carbon Sequestration',
    'Soil Carbon Enhancement',
    'Community Reforestation',
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _draftSaveTimer =
        Timer.periodic(Duration(seconds: 30), (_) => _saveDraft());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _addressController.dispose();
    _beneficiaryController.dispose();
    _draftSaveTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;

    if (!status.isGranted) {
      final result = await Permission.location.request();
      setState(() {
        _isGpsEnabled = result.isGranted;
      });
    } else {
      setState(() {
        _isGpsEnabled = true;
      });
    }
  }

  // 📌 Helpers
  void _saveDraft() {
    print("💾 Draft auto-saved (mock)");
  }

  void _showSuccessDialog(String projectId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("✅ Success"),
        content: Text("Project $projectId submitted successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pushReplacementNamed(
                  context, AppRoutes.projectList); // 👈 navigate to list
            },
            child: Text("View Projects"),
          ),
        ],
      ),
    );
  }

  void _toggleManualLocationEntry() {
    setState(() {
      _latitudeController.text = "10.000";
      _longitudeController.text = "77.000";
    });
  }

  Future<void> _addPhoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _projectPhotos.add(img.path);
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _projectPhotos.removeAt(index);
    });
  }

  void _reorderPhotos(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _projectPhotos.removeAt(oldIndex);
      _projectPhotos.insert(newIndex, item);
    });
  }

  // 📌 Validation
  bool _validateForm() {
    if (_titleController.text.isEmpty) {
      _titleError = "Title required";
      setState(() {});
      return false;
    }
    return true;
  }

  double _calculateProgress() {
    int done = 0;
    if (_titleController.text.isNotEmpty) done++;
    if (_descriptionController.text.isNotEmpty) done++;
    if (_latitudeController.text.isNotEmpty) done++;
    if (_longitudeController.text.isNotEmpty) done++;
    if (_selectedProjectType != null) done++;
    if (_startDate != null) done++;
    if (_beneficiaryController.text.isNotEmpty) done++;
    return done / 7;
  }

  // 📌 Submit (create -> upload photos -> submit for review)
  Future<void> _submitProject() async {
    if (!_validateForm()) return;

    setState(() => _isSubmitting = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

      // 1) Create project (server defaults to DRAFT)
      final createRes = await dio.post(
        "/projects",
        data: {
          "title": _titleController.text,
          "description": _descriptionController.text,
          "lat": double.tryParse(_latitudeController.text) ?? 0.0,
          "lng": double.tryParse(_longitudeController.text) ?? 0.0,
          "species": _selectedProjectType ?? "Tree Plantation",
          "saplings": int.tryParse(_beneficiaryController.text) ?? 0,
          "language": "en",
          "area": 1.0, // mock value (can be from form later)
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final created = createRes.data["project"] as Map<String, dynamic>?;
      final projectId = created?["id"]?.toString();
      if (projectId == null) {
        throw Exception("Project ID missing from create response");
      }

      // 2) Upload photos (if any)
      for (final path in _projectPhotos) {
        try {
          final fileName = path.split('/').last;
          final formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(path, filename: fileName),
          });

          await dio.post(
            "/projects/$projectId/upload",
            data: formData,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
              contentType: "multipart/form-data",
            ),
          );
        } catch (e) {
          // Continue uploading remaining files, but notify failure for this one
          print("⚠️ Photo upload failed for $path: $e");
        }
      }

      // 3) Submit project for review (triggers AI mock, audit log, etc.)
      await dio.post(
        "/projects/$projectId/submit",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // Success
      _showSuccessDialog(projectId);
    } catch (e) {
      print("❌ Error submitting project: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit project. Try again.")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // 📌 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ProjectFormHeaderWidget(
            progress: _calculateProgress(),
            onBackPressed: () => Navigator.pop(context),
            onSaveDraft: _saveDraft,
            isDraftSaving: _isDraftSaving,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ProjectTitleFieldWidget(
                    controller: _titleController,
                    errorText: _titleError,
                    onChanged: (_) => setState(() => _titleError = null),
                  ),
                  ProjectDescriptionFieldWidget(
                    controller: _descriptionController,
                    errorText: _descriptionError,
                    onChanged: (_) => setState(() => _descriptionError = null),
                  ),
                  LocationSectionWidget(
                    latitudeController: _latitudeController,
                    longitudeController: _longitudeController,
                    addressController: _addressController,
                    isGpsEnabled: _isGpsEnabled,
                    isLoadingLocation: _isLoadingLocation,
                    onGetCurrentLocation: () {},
                    onToggleManualEntry: _toggleManualLocationEntry,
                    onLatitudeChanged: (_) {},
                    onLongitudeChanged: (_) {},
                    onAddressChanged: (_) {},
                  ),
                  PhotoGalleryWidget(
                    photos: _projectPhotos,
                    onAddPhoto: _addPhoto,
                    onRemovePhoto: _removePhoto,
                    onReorderPhotos: _reorderPhotos,
                    isLoading: _isPhotoLoading,
                  ),
                  ProjectTypePickerWidget(
                    projectTypes: _projectTypes,
                    selectedType: _selectedProjectType,
                    onTypeSelected: (t) => setState(() {
                      _selectedProjectType = t;
                    }),
                  ),
                  DatePickerWidget(
                    label: "Start Date",
                    selectedDate: _startDate,
                    onDateSelected: (d) => setState(() => _startDate = d),
                    isRequired: true,
                  ),
                  BeneficiaryCountWidget(
                    controller: _beneficiaryController,
                    errorText: _beneficiaryError,
                    onChanged: (_) => setState(() => _beneficiaryError = null),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SubmitButtonWidget(
        isEnabled: _calculateProgress() == 1.0,
        isSubmitting: _isSubmitting,
        isOffline: _isOffline,
        onSubmit: _submitProject,
      ),
    );
  }
}
