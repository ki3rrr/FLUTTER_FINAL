# Book Library Management System

A small Flutter app for learning common Flutter UI patterns while managing a book collection.

## Run the app

1. Install the Flutter SDK and make sure `flutter doctor` completes for your target device.
2. Open a terminal in this folder.
3. Generate the platform runner folders and fetch the Flutter packages:

   ```sh
   flutter create --project-name book_library_management_system --platforms android,ios,web .
   flutter pub get
   ```

4. Launch the app:

   ```sh
   flutter run
   ```

   To target one device, run `flutter devices` and use `flutter run -d <device-id>`.

## Project map

```text
lib/
  data/sample_books.dart       20 starter books stored as a typed Dart list
  models/book.dart             Custom Book class, JSON conversion, and copyWith
  screens/library_screen.dart  Stateful library with search, filters, and CRUD
  services/book_storage.dart   Local persistent storage with shared_preferences
  theme/app_colors.dart        Reusable color palette
  widgets/book_card.dart       Extracted book card and local/network cover
  widgets/stat_card.dart       Extracted collection statistic card
assets/images/
  local_book_cover.png         Bundled local cover image
```

## Flutter concepts demonstrated

- `MaterialApp`, `ThemeData`, `AppBar`, and `Scaffold`
- A deliberate color palette and serif/sans-serif font styling
- Local image loading with `Image.asset` and remote image loading with `Image.network`
- `Container`, `Padding`, `Row`, `Column`, and `Expanded`
- Stateless reusable widgets (`BookCard`, `StatCard`, `BookCover`)
- A stateful screen that manages a custom-class `List<Book>`
- `ListView.builder` for rendering the collection as book cards
- Create, read, edit, and delete books; confirm deletion and undo it
- Search, category filtering, and availability changes
- Local persistence: added, edited, deleted, and availability changes remain after restart
- Twenty starter titles across multiple categories
- Responsive layout: compact list on phones and a multi-column grid on wide screens
- CRUD changes are persisted locally with SharedPreferences, so they remain after restarting the app

The starter collection is saved to the device the first time the app opens. After that, the saved collection is loaded on startup.
