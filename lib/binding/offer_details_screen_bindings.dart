import 'package:flutter_challenge/feature/offer_details/offer_details_screen_controller.dart';
import 'package:get/get.dart';

class OfferDetailsScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfferDetailsScreenController>(
      () => OfferDetailsScreenController(),
    );
  }
}
