# FindIt

**Turn an inspiring social post into a shortlist of products you can explore
and save.**

FindIt is a mobile product-discovery prototype. The Flutter app presents a feed
of analyzed posts, visually similar products, product details, and a saved-items
collection. A small FastAPI service supplies the discovery results and exposes
the contract for a future ingestion pipeline.

## Product experience

- Browse discovery results grouped around the object found in an image.
- Compare product matches by retailer, price, and similarity score.
- Open a product detail view and save or remove items from a wishlist.
- Move between discovery, saved items, and profile views in a Material 3 mobile
  interface.
- Exercise the client against a documented HTTP API without external accounts.

## How it works

```text
Flutter app  ── HTTP ──>  FastAPI service  ──>  mock discovery catalogue
```

The app uses `go_router` for navigation and a typed model/service layer for API
responses. The API defines webhook, results, product, wishlist, and health
routes with Pydantic response models.

## Run locally

Start the API:

```sh
cd findit_backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

Then run the Flutter client in another terminal:

```sh
cd findit_app
flutter pub get
flutter run
```

The client currently targets `10.0.2.2:8000` for an Android emulator. Update
`findit_app/lib/services/api_service.dart` when using another simulator or a
physical device.

## Verify the project

```sh
cd findit_app
flutter analyze
flutter test
```

The backend can be syntax-checked with:

```sh
python3 -m compileall -q findit_backend
```

## Product boundaries

FindIt currently demonstrates the product flow with mock catalogue data. The
webhook does not validate an Instagram signature or run computer vision, saved
items are not persisted, and the client uses a fixed mock user. Retailer links
and similarity values are illustrative. These boundaries keep the repository
focused on the experience and API contract without presenting placeholder data
as a live discovery system.
