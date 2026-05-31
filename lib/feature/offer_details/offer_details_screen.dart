import 'package:flutter/material.dart';
import 'package:flutter_challenge/feature/offer_details/offer_details_screen_controller.dart';
import 'package:flutter_challenge/feature/shared_widget/the_button.dart';
import 'package:flutter_challenge/feature/shared_widget/the_network_image.dart';
import 'package:flutter_challenge/util/constants/app_colors.dart';
import 'package:flutter_challenge/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// INTENTIONAL GAP (Task A2): Screen is a stub — candidate implements full UI + controller.
class OfferDetailsScreen extends GetView<OfferDetailsScreenController> {
  const OfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('offer_details'.tr, style: Styles.boldText18())),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hasError.value || controller.offer.value == null) {
          return Center(
            child: Text('error_generic'.tr, style: Styles.regularText14()),
          );
        }
        final offer = controller.offer.value!;
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TheNetworkImage(imageUrl: offer.imageUrl, height: 240.h),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & store
                          Text(offer.title, style: Styles.boldText18()),
                          SizedBox(height: 4.h),
                          Text(offer.storeName, style: Styles.regularText14()),
                          SizedBox(height: 12.h),

                          // Pricing row
                          Row(
                            children: [
                              Text(
                                '฿${offer.discountedPrice}',
                                style: Styles.boldText18(color: AppColors.primary),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '฿${offer.originalPrice}',
                                style: Styles.regularText14().copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeDiscount,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  '-${offer.discountPercent}%',
                                  style: Styles.sBoldText12(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Details
                          _detailRow(Icons.access_time, offer.pickupWindow),
                          SizedBox(height: 8.h),
                          _detailRow(
                            Icons.shopping_bag_outlined,
                            '${offer.quantityLeft} left',
                          ),
                          SizedBox(height: 8.h),
                          _detailRow(
                            Icons.eco_outlined,
                            '${'co2_saved'.tr}: ${offer.co2Kg} kg',
                          ),
                          SizedBox(height: 24.h),

                          // Quantity stepper
                          Text('quantity'.tr, style: Styles.mediumText16()),
                          SizedBox(height: 8.h),
                          Obx(
                            () => Row(
                              children: [
                                IconButton(
                                  onPressed: controller.decrement,
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: AppColors.primary,
                                ),
                                Text(
                                  '${controller.quantity.value}',
                                  style: Styles.boldText18(),
                                ),
                                IconButton(
                                  onPressed: controller.increment,
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add to bag button
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: TheButton(
                label: 'add_to_bag'.tr,
                onPressed: controller.addToBag,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.textSecondary),
        SizedBox(width: 8.w),
        Expanded(child: Text(text, style: Styles.regularText14())),
      ],
    );
  }
}
