# Solution — [Pakpisit Pakhakorntanatorn]

## Time spent
~4 hours

## Tasks completed

- A1: Fixed `visibleOffers` getter to filter by category and search query. Wired `onChanged: controller.setSearchQuery` to the search `TextField`.
- A2: Created `OfferDetailsScreenController` (loads offer by id, manages quantity stepper, calls `CartService.addOffer`), `OfferDetailsScreenBindings`, and implemented full details screen UI (image, pricing, discount badge, pickup window, quantity left, CO₂ badge, quantity stepper, Add to bag button). Added binding to the route in `routes.dart`.
- A3: Wrapped `ListView.builder` with `RefreshIndicator` wired to `controller.onRefresh` in `home_screen.dart`.
- A4: Replaced `SizedBox.shrink()` with a centered empty state (icon + `'empty_offers'.tr`) when `visibleOffers` is empty.

## Bugs fixed

- B1: `OfferModel.fromJson` read `data['co2_saved_kg']` which does not exist in the mock data — changed to `data['co2_kg']` to match the actual JSON key.
- B2: `toggleFavorite` in `HomeScreenController` saved to prefs but never updated `_offers`. Fixed by finding the offer by id in `_offers` and replacing it with `copyWith(isFavorite: !current)`, triggering a reactive rebuild. Added `favorite_saved`/`favorite_removed` snackbar feedback.
- B3: `CartService.cartTotal` multiplied `item.offer.originalPrice` instead of `item.offer.discountedPrice`. Changed to use `discountedPrice`.

## Stretch goals completed

- S1: Test 'test/cart_service_test.dart' -> All tests passed.
- S2: Added `favorites` case to `OfferFilter` enum. Updated `visibleOffers` to filter by `isFavorite` when active. Added "Favorites only" chip to the filter row. Persisted selected filter across restarts via `SharedPreferences`.
- S3: Replaced `CircularProgressIndicator` with shimmer placeholder cards during loading. Implemented using `AnimationController` (no new dependencies) — 4 skeleton cards pulse between two grey shades matching the real `OfferCard` layout.

## AI tools used

I used Claude as an AI tool. For example promtps; I used Claude to assist me in critical pinpoint the problems, plan out before implement or change the code structure, and lastly I will check out that the plan or outcome is really in line with the objective if not then I will make some edit or correct it.

## If I had more time

Maybe I would try to make a proper navigate between pages (Home, Bag, Profile), and more detail profile page.
