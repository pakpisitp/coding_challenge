import 'package:flutter_challenge/model/offer_model.dart';
import 'package:flutter_challenge/repository/offer_repo.dart';
import 'package:flutter_challenge/service/cart_service.dart';
import 'package:get/get.dart';

class OfferDetailsScreenController extends GetxController {
  final OfferRepo _offerRepo = Get.find<OfferRepo>();
  final CartService _cartService = Get.find<CartService>();

  final Rx<OfferModel?> offer = Rx(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxInt quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['id'] ?? '';
    _loadOffer(id);
  }

  Future<void> _loadOffer(String id) async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final result = await _offerRepo.fetchOfferById(id);
      if (result == null) {
        hasError.value = true;
      } else {
        offer.value = result;
      }
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void increment() {
    final max = offer.value?.quantityLeft ?? 1;
    if (quantity.value < max) quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  Future<void> addToBag() async {
    final current = offer.value;
    if (current == null) return;
    await _cartService.addOffer(current, quantity: quantity.value);
    Get.snackbar(
      'add_to_bag'.tr,
      '${current.title} x${quantity.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
