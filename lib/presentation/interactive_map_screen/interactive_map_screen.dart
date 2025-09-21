import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/app_export.dart';
import './widgets/map_filter_panel.dart';
import './widgets/map_overlay_controls.dart';
import './widgets/project_bottom_sheet.dart';
import './widgets/project_preview_card.dart';

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({Key? key}) : super(key: key);

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  bool _isFilterPanelVisible = false;
  bool _isLocationLoading = false;
  bool _isHeatMapEnabled = false;
  String _currentMapType = 'Standard';
  Map<String, dynamic>? _selectedProject;
  bool _showPreviewCard = false;
  bool _showBottomSheet = false;

  // Current location
  LatLng _currentLocation =
      const LatLng(20.5937, 78.9629); // Default to India center

  // Mock project data - REMOVED ALL DEMO PROJECTS
  final List<Map<String, dynamic>> _projectsData = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    _createMarkers();
    _createGeofencingPolygons();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Handle error silently
    }
  }

  void _createMarkers() {
    final Set<Marker> markers = {};

    for (final project in _projectsData) {
      final coordinates = project['coordinates'] as Map<String, dynamic>;
      final lat = (coordinates['lat'] as num).toDouble();
      final lng = (coordinates['lng'] as num).toDouble();
      final status = project['status'] as String;

      markers.add(
        Marker(
          markerId: MarkerId(project['id'].toString()),
          position: LatLng(lat, lng),
          icon: _getMarkerIcon(status),
          onTap: () => _onMarkerTapped(project),
          infoWindow: InfoWindow(
            title: project['title'] as String,
            snippet: '${project['credits']} CO₂ tons',
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  BitmapDescriptor _getMarkerIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'pending':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      case 'rejected':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _createGeofencingPolygons() {
    final Set<Polygon> polygons = {};

    // Sample geofencing polygon for demonstration
    polygons.add(
      Polygon(
        polygonId: const PolygonId('geofence_1'),
        points: [
          const LatLng(21.8, 88.8),
          const LatLng(22.1, 88.8),
          const LatLng(22.1, 89.1),
          const LatLng(21.8, 89.1),
        ],
        strokeColor: AppTheme.primaryLight,
        strokeWidth: 2,
        fillColor: AppTheme.primaryLight.withValues(alpha: 0.2),
      ),
    );

    setState(() {
      _polygons = polygons;
    });
  }

  void _onMarkerTapped(Map<String, dynamic> project) {
    setState(() {
      _selectedProject = project;
      _showPreviewCard = true;
      _showBottomSheet = false;
    });
  }

  void _onSearchTap() {
    // Implement search functionality
    showSearch(
      context: context,
      delegate: ProjectSearchDelegate(_projectsData),
    );
  }

  void _onFilterTap() {
    setState(() {
      _isFilterPanelVisible = !_isFilterPanelVisible;
    });
  }

  Future<void> _onLocationTap() async {
    setState(() {
      _isLocationLoading = true;
    });

    await _getCurrentLocation();

    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
      );
    }

    setState(() {
      _isLocationLoading = false;
    });
  }

  void _onLayerToggle() {
    final mapTypes = ['Standard', 'Satellite', 'Terrain'];
    final currentIndex = mapTypes.indexOf(_currentMapType);
    final nextIndex = (currentIndex + 1) % mapTypes.length;

    setState(() {
      _currentMapType = mapTypes[nextIndex];
    });
  }

  MapType _getMapType() {
    switch (_currentMapType) {
      case 'Satellite':
        return MapType.satellite;
      case 'Terrain':
        return MapType.terrain;
      default:
        return MapType.normal;
    }
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    // Apply filters to markers
    _createMarkers();
  }

  void _closePreviewCard() {
    setState(() {
      _showPreviewCard = false;
      _selectedProject = null;
    });
  }

  void _showProjectBottomSheet() {
    setState(() {
      _showPreviewCard = false;
      _showBottomSheet = true;
    });
  }

  void _closeBottomSheet() {
    setState(() {
      _showBottomSheet = false;
      _selectedProject = null;
    });
  }

  void _viewFullDetails() {
    Navigator.pushNamed(context, '/project-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 6.0,
            ),
            mapType: _getMapType(),
            markers: _markers,
            polygons: _polygons,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onTap: (LatLng position) {
              if (_showPreviewCard) {
                _closePreviewCard();
              }
            },
            gestureRecognizers: {},
          ),

          // Map Overlay Controls
          MapOverlayControls(
            onSearchTap: _onSearchTap,
            onFilterTap: _onFilterTap,
            onLocationTap: _onLocationTap,
            onLayerToggle: _onLayerToggle,
            currentLayer: _currentMapType,
            isLocationLoading: _isLocationLoading,
          ),

          // Filter Panel
          if (_isFilterPanelVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFilterPanelVisible = false;
                  });
                },
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),

          MapFilterPanel(
            isVisible: _isFilterPanelVisible,
            onClose: () {
              setState(() {
                _isFilterPanelVisible = false;
              });
            },
            onFiltersChanged: _onFiltersChanged,
          ),

          // Project Preview Card
          if (_showPreviewCard && _selectedProject != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ProjectPreviewCard(
                project: _selectedProject!,
                onViewDetails: _showProjectBottomSheet,
                onClose: _closePreviewCard,
              ),
            ),

          // Project Bottom Sheet
          if (_showBottomSheet && _selectedProject != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ProjectBottomSheet(
                project: _selectedProject!,
                onClose: _closeBottomSheet,
                onViewFullDetails: _viewFullDetails,
              ),
            ),
        ],
      ),
    );
  }
}

class ProjectSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> projects;

  ProjectSearchDelegate(this.projects);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: CustomIconWidget(
          iconName: 'clear',
          color: AppTheme.textPrimaryLight,
          size: 24,
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: AppTheme.textPrimaryLight,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = projects.where((project) {
      final title = (project['title'] as String).toLowerCase();
      final location = (project['location'] as String).toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery) || location.contains(searchQuery);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final project = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getStatusColor(project['status'] as String),
            child: CustomIconWidget(
              iconName: 'eco',
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Text(
            project['title'] as String,
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          subtitle: Text(
            project['location'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          onTap: () {
            close(context, project['title'] as String);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = projects.where((project) {
      final title = (project['title'] as String).toLowerCase();
      final location = (project['location'] as String).toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery) || location.contains(searchQuery);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final project = suggestions[index];
        return ListTile(
          leading: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.textSecondaryLight,
            size: 20,
          ),
          title: Text(
            project['title'] as String,
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          subtitle: Text(
            project['location'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          onTap: () {
            query = project['title'] as String;
            showResults(context);
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'rejected':
        return AppTheme.errorLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
