import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/capture_preview_widget.dart';
import './widgets/gps_overlay_widget.dart';
import './widgets/manual_coordinates_widget.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({Key? key}) : super(key: key);

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen>
    with WidgetsBindingObserver {
  // Camera related
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  FlashMode _flashMode = FlashMode.auto;
  bool _showGrid = false;
  bool _isPhotoMode = true;
  bool _isRecording = false;

  // GPS related
  double? _latitude;
  double? _longitude;
  double? _accuracy;
  bool _isLoadingLocation = false;

  // Capture related
  XFile? _capturedImage;
  bool _isProcessing = false;
  String? _lastImagePath;
  final ImagePicker _imagePicker = ImagePicker();

  // Mock data for captured images with GPS coordinates
  final List<Map<String, dynamic>> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      if (!await _requestCameraPermission()) {
        _showPermissionDialog();
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showErrorSnackBar('No cameras available on this device');
        return;
      }

      // Select appropriate camera
      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      // Initialize camera controller
      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: !_isPhotoMode,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to initialize camera: ${e.toString()}');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(_flashMode);
      }
    } catch (e) {
      // Silently handle unsupported features
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      if (!kIsWeb) {
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _accuracy = position.accuracy;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      HapticFeedback.mediumImpact();
      final XFile photo = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = photo;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to capture photo: ${e.toString()}');
    }
  }

  Future<void> _startStopRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (_isRecording) {
        final XFile video = await _cameraController!.stopVideoRecording();
        setState(() {
          _isRecording = false;
          _capturedImage = video;
        });
        HapticFeedback.mediumImpact();
      } else {
        await _cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to record video: ${e.toString()}');
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select image from gallery');
    }
  }

  void _toggleFlash() {
    if (kIsWeb) return;

    setState(() {
      switch (_flashMode) {
        case FlashMode.auto:
          _flashMode = FlashMode.always;
          break;
        case FlashMode.always:
          _flashMode = FlashMode.off;
          break;
        case FlashMode.off:
          _flashMode = FlashMode.auto;
          break;
        case FlashMode.torch:
          _flashMode = FlashMode.auto;
          break;
      }
    });

    _cameraController?.setFlashMode(_flashMode);
    HapticFeedback.selectionClick();
  }

  void _switchMode() {
    setState(() {
      _isPhotoMode = !_isPhotoMode;
    });
    HapticFeedback.selectionClick();
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _isProcessing = false;
    });
  }

  Future<void> _acceptPhoto() async {
    if (_capturedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate image processing and compression
      await Future.delayed(Duration(seconds: 2));

      // Create captured image data with GPS coordinates
      final imageData = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'path': _capturedImage!.path,
        'latitude': _latitude,
        'longitude': _longitude,
        'accuracy': _accuracy,
        'timestamp': DateTime.now(),
        'type': _isPhotoMode ? 'photo' : 'video',
        'status': 'pending_upload',
      };

      _capturedImages.add(imageData);

      setState(() {
        _lastImagePath = _capturedImage!.path;
        _capturedImage = null;
        _isProcessing = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image captured and saved locally'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to project submission with captured images
      Navigator.pop(context, _capturedImages);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorSnackBar('Failed to process image');
    }
  }

  void _showManualCoordinatesDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ManualCoordinatesWidget(
          initialLatitude: _latitude,
          initialLongitude: _longitude,
          onCoordinatesChanged: (lat, lng) {
            setState(() {
              _latitude = lat;
              _longitude = lng;
              _accuracy = null; // Manual entry has no accuracy
            });
          },
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text(
          'This app needs camera access to capture photos for project documentation. Please grant camera permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview or captured image preview
            if (_capturedImage != null)
              CapturePreviewWidget(
                capturedImage: _capturedImage!,
                onRetake: _retakePhoto,
                onAccept: _acceptPhoto,
                isProcessing: _isProcessing,
              )
            else
              CameraPreviewWidget(
                cameraController: _cameraController,
                isInitialized: _isCameraInitialized,
                showGrid: _showGrid,
              ),

            // GPS overlay (only show when not in preview mode)
            if (_capturedImage == null)
              GpsOverlayWidget(
                latitude: _latitude,
                longitude: _longitude,
                accuracy: _accuracy,
                isLoading: _isLoadingLocation,
                onRefresh: _getCurrentLocation,
              ),

            // Camera controls (only show when not in preview mode)
            if (_capturedImage == null)
              CameraControlsWidget(
                onCapture: _isPhotoMode ? _capturePhoto : _startStopRecording,
                onGallery: _selectFromGallery,
                onFlashToggle: _toggleFlash,
                onModeSwitch: _switchMode,
                lastImagePath: _lastImagePath,
                flashMode: _flashMode,
                isPhotoMode: _isPhotoMode,
                isRecording: _isRecording,
              ),

            // Top action bar (only show when not in preview mode)
            if (_capturedImage == null)
              Positioned(
                top: 2.h,
                left: 4.w,
                right: 4.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Action buttons
                    Row(
                      children: [
                        // Grid toggle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showGrid = !_showGrid;
                            });
                            HapticFeedback.selectionClick();
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'grid_on',
                              color: _showGrid
                                  ? AppTheme.lightTheme.primaryColor
                                  : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        SizedBox(width: 2.w),

                        // Manual coordinates
                        GestureDetector(
                          onTap: _showManualCoordinatesDialog,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'edit_location',
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Offline indicator
            Positioned(
              top: 12.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'cloud_off',
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Offline',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Storage indicator
            if (_capturedImages.isNotEmpty)
              Positioned(
                top: 15.h,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'photo_library',
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${_capturedImages.length} saved',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
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
