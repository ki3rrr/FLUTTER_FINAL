import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_books.dart';
import '../models/book.dart';

class BookStorage {
  BookStorage._();

  static const _storageKey = 'book_library_management_system.books.v1';

  static Future<List<Book>> loadBooks() async {
    final preferences = await SharedPreferences.getInstance();
    final storedBooks = preferences.getString(_storageKey);

    if (storedBooks == null) {
      final starterBooks = List<Book>.of(sampleBooks);
      await saveBooks(starterBooks);
      return starterBooks;
    }

    final decoded = jsonDecode(storedBooks);
    if (decoded is! List) {
      throw const FormatException('Saved library data is not a list.');
    }

    return decoded.map((entry) {
      if (entry is! Map) {
        throw const FormatException('A saved book entry is invalid.');
      }
      return Book.fromJson(Map<String, dynamic>.from(entry));
    }).toList();
  }

  static Future<void> saveBooks(List<Book> books) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _storageKey,
      jsonEncode(books.map((book) => book.toJson()).toList()),
    );

    if (!saved) {
      throw StateError('The library could not be saved on this device.');
    }
  }
}
