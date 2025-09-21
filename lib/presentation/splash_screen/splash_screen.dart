import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _showRetryButton = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading indicator animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchEssentialConfiguration(),
        _prepareCachedData(),
        _detectSystemTheme(),
        Future.delayed(
            const Duration(milliseconds: 2500)), // Minimum splash time
      ]);

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _showRetryButton = true;
        });

        // Show retry option after 5 seconds if network timeout
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _showRetryButton) {
            setState(() {
              _showRetryButton = true;
            });
          }
        });
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate checking authentication tokens
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _fetchEssentialConfiguration() async {
    // Simulate fetching essential configuration
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached offline data
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _detectSystemTheme() async {
    // Simulate detecting system theme preference
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    String nextRoute;
    if (token != null && token.isNotEmpty) {
      switch (role) {
        case 'NGO':
          nextRoute = AppRoutes.ngoHome;
          break;
        case 'ADMIN':
          nextRoute = AppRoutes.adminDashboard;
          break;
        case 'COMPANY':
          nextRoute = AppRoutes.carbonCreditMarketplace;
          break;
        default:
          nextRoute = AppRoutes.ngoHome;
      }
    } else {
      nextRoute = AppRoutes.authentication;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _retryInitialization() {
    setState(() {
      _showRetryButton = false;
      _isInitializing = true;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to match brand colors
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.primaryLight,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.primaryLight,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryLight,
                AppTheme.primaryLight.withValues(alpha: 0.8),
                AppTheme.primaryVariantLight.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Animated Logo Section
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: _buildLogo(),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),

              // Loading Section
              _buildLoadingSection(),

              // Spacer to balance layout
              const Spacer(flex: 3),

              // App Version and Copyright
              _buildFooterInfo(),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Logo Container with shadow
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'eco',
                  color: AppTheme.primaryLight,
                  size: 12.w,
                ),
                SizedBox(height: 1.h),
                Text(
                  'V',
                  style: TextStyle(
                    fontSize: 8.w,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App Name
        Text(
          'Vsmart',
          style: TextStyle(
            fontSize: 8.w,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),

        SizedBox(height: 1.h),

        // App Tagline
        Text(
          'Carbon Credit Verification',
          style: TextStyle(
            fontSize: 3.5.w,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    if (_showRetryButton) {
      return Column(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: Colors.white.withValues(alpha: 0.8),
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Connection timeout',
            style: TextStyle(
              fontSize: 4.w,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _retryInitialization,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryLight,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Retry',
              style: TextStyle(
                fontSize: 4.w,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    if (_isInitializing) {
      return Column(
        children: [
          // Custom loading indicator
          AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingAnimation.value * 2 * 3.14159,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: CustomPaint(
                    painter: LoadingPainter(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          Text(
            'Initializing...',
            style: TextStyle(
              fontSize: 3.5.w,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFooterInfo() {
    return Column(
      children: [
        Text(
          'Version 1.0.0',
          style: TextStyle(
            fontSize: 3.w,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          '© 2024 Vsmart Technologies',
          style: TextStyle(
            fontSize: 2.8.w,
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

// Custom painter for loading indicator
class LoadingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  LoadingPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      3.14159, // Half circle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
