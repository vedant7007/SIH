import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/credit_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/marketplace_header_widget.dart';
import './widgets/quick_actions_dialog_widget.dart';
import './widgets/sort_dropdown_widget.dart';

class CarbonCreditMarketplaceScreen extends StatefulWidget {
  const CarbonCreditMarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<CarbonCreditMarketplaceScreen> createState() =>
      _CarbonCreditMarketplaceScreenState();
}

class _CarbonCreditMarketplaceScreenState
    extends State<CarbonCreditMarketplaceScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _selectedSort = 'Most Popular';
  int _cartItemCount = 3;
  List<Map<String, dynamic>> _filteredCredits = [];
  bool _isLoading = false;

  // Mock data for carbon credits - REMOVED ALL DEMO PROJECTS
  final List<Map<String, dynamic>> _creditData = [];

  final List<String> _filterOptions = [
    'All',
    'Reforestation',
    'Renewable Energy',
    'Waste Management'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredCredits = List.from(_creditData);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterCredits();
  }

  void _filterCredits() {
    setState(() {
      _filteredCredits = _creditData.where((credit) {
        final matchesSearch = _searchController.text.isEmpty ||
            (credit["projectName"] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            (credit["location"] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            (credit["projectType"] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesFilter = _selectedFilter == 'All' ||
            (credit["projectType"] as String) == _selectedFilter;

        return matchesSearch && matchesFilter;
      }).toList();

      _sortCredits();
    });
  }

  void _sortCredits() {
    switch (_selectedSort) {
      case 'Price Low-High':
        _filteredCredits.sort((a, b) => (a["pricePerCredit"] as double)
            .compareTo(b["pricePerCredit"] as double));
        break;
      case 'Price High-Low':
        _filteredCredits.sort((a, b) => (b["pricePerCredit"] as double)
            .compareTo(a["pricePerCredit"] as double));
        break;
      case 'Newest':
        _filteredCredits
            .sort((a, b) => (b["id"] as int).compareTo(a["id"] as int));
        break;
      case 'Most Popular':
        _filteredCredits.sort((a, b) => (b["remainingCredits"] as int)
            .compareTo(a["remainingCredits"] as int));
        break;
      case 'Location':
        _filteredCredits.sort((a, b) =>
            (a["location"] as String).compareTo(b["location"] as String));
        break;
    }
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterCredits();
  }

  void _onSortChanged(String sort) {
    setState(() {
      _selectedSort = sort;
    });
    _filterCredits();
  }

  void _onAddToCart(Map<String, dynamic> credit) {
    setState(() {
      _cartItemCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${credit["projectName"]} added to cart",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.onPrimaryLight,
          ),
        ),
        backgroundColor: AppTheme.successLight,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _onCreditTap(Map<String, dynamic> credit) {
    Navigator.pushNamed(context, '/project-detail-screen');
  }

  void _onCreditLongPress(Map<String, dynamic> credit) {
    showDialog(
      context: context,
      builder: (context) => QuickActionsDialogWidget(
        creditData: credit,
        onAddToWishlist: () => _onAddToWishlist(credit),
        onShare: () => _onShare(credit),
        onCompare: () => _onCompare(credit),
      ),
    );
  }

  void _onAddToWishlist(Map<String, dynamic> credit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added to wishlist"),
        backgroundColor: AppTheme.primaryLight,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onShare(Map<String, dynamic> credit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sharing ${credit["projectName"]}"),
        backgroundColor: AppTheme.primaryLight,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onCompare(Map<String, dynamic> credit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added to comparison"),
        backgroundColor: AppTheme.primaryLight,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onCartTap() {
    _tabController.animateTo(1); // Navigate to Cart tab
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredCredits = List.from(_creditData);
    });

    _filterCredits();
  }

  void _onFloatingActionButtonTap() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Saved Items',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to saved items
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'compare_arrows',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Compare Credits',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to comparison tool
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Carbon Credits',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Marketplace'),
            Tab(text: 'Cart'),
            Tab(text: 'Orders'),
            Tab(text: 'Profile'),
          ],
          labelColor: AppTheme.primaryLight,
          unselectedLabelColor: AppTheme.textSecondaryLight,
          indicatorColor: AppTheme.primaryLight,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Marketplace Tab
          Column(
            children: [
              // Header with search and cart
              MarketplaceHeaderWidget(
                searchController: _searchController,
                cartItemCount: _cartItemCount,
                onCartTap: _onCartTap,
                onSearchChanged: (value) => _onSearchChanged(),
              ),

              // Filter chips
              Container(
                height: 8.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final filter = _filterOptions[index];
                    return FilterChipWidget(
                      label: filter,
                      isSelected: _selectedFilter == filter,
                      onTap: () => _onFilterSelected(filter),
                    );
                  },
                ),
              ),

              // Sort dropdown
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_filteredCredits.length} credits available",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SortDropdownWidget(
                      selectedSort: _selectedSort,
                      onSortChanged: _onSortChanged,
                    ),
                  ],
                ),
              ),

              // Credits grid
              Expanded(
                child: _filteredCredits.isEmpty
                    ? EmptyStateWidget(
                        title: "No Credits Found",
                        subtitle:
                            "Try adjusting your search or filter criteria to find carbon credits.",
                        actionText: "Clear Filters",
                        onActionTap: () {
                          setState(() {
                            _selectedFilter = 'All';
                            _searchController.clear();
                          });
                          _filterCredits();
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppTheme.primaryLight,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          itemCount: _filteredCredits.length,
                          itemBuilder: (context, index) {
                            final credit = _filteredCredits[index];
                            return CreditCardWidget(
                              creditData: credit,
                              onAddToCart: () => _onAddToCart(credit),
                              onTap: () => _onCreditTap(credit),
                              onLongPress: () => _onCreditLongPress(credit),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),

          // Cart Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: AppTheme.primaryLight,
                  size: 60,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Cart',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '$_cartItemCount items in cart',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Orders Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'receipt_long',
                  color: AppTheme.primaryLight,
                  size: 60,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Orders',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Your purchase history',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Profile Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.primaryLight,
                  size: 60,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Profile',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Account settings and preferences',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _onFloatingActionButtonTap,
              backgroundColor: AppTheme.primaryLight,
              child: CustomIconWidget(
                iconName: 'bookmark',
                color: AppTheme.onPrimaryLight,
                size: 24,
              ),
            )
          : null,
    );
  }
}
