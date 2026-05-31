import 'package:flutter_challenge/model/offer_model.dart';
import 'package:flutter_challenge/repository/offer_repo.dart';
import 'package:flutter_challenge/service/the_exceptions.dart';
import 'package:flutter_challenge/util/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OfferFilter { all, bakery, cafe, market, favorites }

class HomeScreenController extends GetxController {
  final OfferRepo _offerRepo = Get.find<OfferRepo>();

  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxList<OfferModel> _offers = <OfferModel>[].obs;
  final Rx<OfferFilter> _activeFilter = OfferFilter.all.obs;
  final RxString _searchQuery = ''.obs;

  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  List<OfferModel> get offers => _offers;
  OfferFilter get activeFilter => _activeFilter.value;
  String get searchQuery => _searchQuery.value;

  /// INTENTIONAL GAP (Task A1): filter + search not applied — returns all offers.
  List<OfferModel> get visibleOffers {
    final query = _searchQuery.value.toLowerCase();
    final filter = _activeFilter.value;

    return _offers.where((offer) {
      final matchesCategory = filter == OfferFilter.all ||
          (filter == OfferFilter.favorites
              ? offer.isFavorite
              : offer.category == filter.name);
      final matchesSearch = query.isEmpty ||
          offer.title.toLowerCase().contains(query) ||
          offer.storeName.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadPersistedFilter();
    fetchOffers();
  }

  void _loadPersistedFilter() {
    final prefs = Get.find<SharedPreferences>();
    final saved = prefs.getString(AppConstants.ACTIVE_FILTER_PREF_KEY);
    if (saved != null) {
      _activeFilter.value = OfferFilter.values.firstWhere(
        (f) => f.name == saved,
        orElse: () => OfferFilter.all,
      );
    }
  }

  Future<void> fetchOffers() async {
    _isLoading.value = true;
    _hasError.value = false;
    try {
      final data = await _offerRepo.fetchOffers();
      _offers.assignAll(data);
    } on TheException catch (e) {
      _hasError.value = true;
      Get.snackbar('error_generic'.tr, e.displayError());
    } finally {
      _isLoading.value = false;
    }
  }

  void setFilter(OfferFilter filter) {
    _activeFilter.value = filter;
    // INTENTIONAL GAP (Task A1): candidate should refresh visibleOffers.
    Get.find<SharedPreferences>().setString(
      AppConstants.ACTIVE_FILTER_PREF_KEY,
      filter.name,
    );
  }

  void setSearchQuery(String value) {
    _searchQuery.value = value;
    // INTENTIONAL GAP (Task A1): candidate should refresh visibleOffers.
  }

  Future<void> toggleFavorite(String offerId) async {
    await _offerRepo.toggleFavorite(offerId);
    // INTENTIONAL GAP (Task B2): list does not update after toggle.
    final index = _offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      final nowFavorite = !_offers[index].isFavorite;
      _offers[index] = _offers[index].copyWith(isFavorite: nowFavorite);
      Get.snackbar(
        nowFavorite ? 'favorite_saved'.tr : 'favorite_removed'.tr,
        '',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// INTENTIONAL GAP (Task A3): pull-to-refresh not wired in UI — candidate connects this.
  Future<void> onRefresh() => fetchOffers();
}
