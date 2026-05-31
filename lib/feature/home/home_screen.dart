import 'package:flutter/material.dart';
import 'package:flutter_challenge/feature/home/home_screen_controller.dart';
import 'package:flutter_challenge/feature/shared_widget/main_shell.dart';
import 'package:flutter_challenge/feature/shared_widget/offer_card.dart';
import 'package:flutter_challenge/util/constants/app_colors.dart';
import 'package:flutter_challenge/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;
  final HomeScreenController controller = Get.find<HomeScreenController>();

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _shimmerAnimation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainShell(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('home_title'.tr, style: Styles.boldText18()),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 12.h),
              _buildFilterChips(),
              SizedBox(height: 12.h),
              Expanded(child: _buildOfferList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: controller.setSearchQuery,
      decoration: InputDecoration(
        hintText: 'search_hint'.tr,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: Colors.white,
      ),
      // INTENTIONAL GAP (Task A1): onChanged not connected to controller.setSearchQuery.
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip('filter_all'.tr, OfferFilter.all),
            _filterChip('filter_bakery'.tr, OfferFilter.bakery),
            _filterChip('filter_cafe'.tr, OfferFilter.cafe),
            _filterChip('filter_market'.tr, OfferFilter.market),
            _filterChip('filter_favorites'.tr, OfferFilter.favorites),
          ],
        ),
      );
    });
  }

  Widget _filterChip(String label, OfferFilter filter) {
    final isSelected = controller.activeFilter == filter;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => controller.setFilter(filter),
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildOfferList() {
    return Obx(() {
      if (controller.isLoading) {
        return _buildShimmerList();
      }
      if (controller.hasError) {
        return Center(
          child: Text('error_generic'.tr, style: Styles.regularText14()),
        );
      }

      final offers = controller.visibleOffers;
      // INTENTIONAL GAP (Task A4): no empty state widget when offers.isEmpty.
      if (offers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront_outlined, size: 64.sp, color: AppColors.textSecondary),
              SizedBox(height: 16.h),
              Text('empty_offers'.tr, style: Styles.regularText14(), textAlign: TextAlign.center),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.onRefresh,
        color: AppColors.primary,
        child: ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            return OfferCard(
              offer: offer,
              onFavoriteTap: () => controller.toggleFavorite(offer.id),
            );
          },
        ),
      );
    });
  }

  Widget _buildShimmerList() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, _) {
        final color = Color.lerp(
          const Color(0xFFE0E0E0),
          const Color(0xFFF5F5F5),
          _shimmerAnimation.value,
        )!;
        return ListView.builder(
          itemCount: 4,
          itemBuilder: (_, __) => _buildShimmerCard(color),
        );
      },
    );
  }

  Widget _buildShimmerCard(Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 140.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                Container(
                  height: 16.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                // Store name placeholder
                Container(
                  height: 12.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 12.h),
                // Price placeholder
                Container(
                  height: 16.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
