import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_storage.dart';
import '../theme/app_colors.dart';
import '../widgets/book_card.dart';
import '../widgets/stat_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _searchController = TextEditingController();
  List<Book> _books = [];
  String _selectedCategory = 'All books';
  String _searchText = '';
  bool _isLoading = true;
  bool _isSaving = false;
  Object? _loadError;

  List<String> get _categories => [
        'All books',
        ...{for (final book in _books) book.category},
      ];

  List<Book> get _visibleBooks {
    final query = _searchText.trim().toLowerCase();
    return _books.where((book) {
      final matchesCategory = _selectedCategory == 'All books' ||
          book.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }
    try {
      final books = await BookStorage.loadBooks();
      if (!mounted) return;
      setState(() => _books = books);
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCount = _books.where((book) => book.isAvailable).length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_library_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE READING ROOM',
                  style: TextStyle(
                    fontFamily: 'sans-serif',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Library desk',
                  style: TextStyle(
                    color: AppColors.mutedInk,
                    fontFamily: 'sans-serif',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Add a book',
            onPressed: _isLoading || _isSaving ? null : () => _showBookForm(),
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: AppColors.forest,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading || _isSaving ? null : () => _showBookForm(),
        backgroundColor: AppColors.forest,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add a book',
          style: TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.forest),
            )
          : _loadError != null
              ? _LoadErrorMessage(onRetry: () => _loadBooks())
              : SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isSaving)
                        const LinearProgressIndicator(
                          minHeight: 2,
                          color: AppColors.forest,
                          backgroundColor: AppColors.forestLight,
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A good book is',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: MediaQuery.sizeOf(context).width < 380
                                    ? 25
                                    : 29,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'always in season.',
                              style: TextStyle(
                                color: AppColors.forest,
                                fontSize: MediaQuery.sizeOf(context).width < 380
                                    ? 25
                                    : 29,
                                fontStyle: FontStyle.italic,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Keep your shelves in order and your next read close.',
                              style: TextStyle(
                                color: AppColors.mutedInk,
                                fontFamily: 'sans-serif',
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    label: 'Books in library',
                                    value: '${_books.length}',
                                    icon: Icons.auto_stories_rounded,
                                    tint: AppColors.forestLight,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: StatCard(
                                    label: 'On the shelf',
                                    value: '$availableCount',
                                    icon: Icons.bookmark_added_rounded,
                                    tint: const Color(0xFFF5EBD9),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.paper,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.line),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) =>
                                    setState(() => _searchText = value),
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontFamily: 'sans-serif',
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search title or author',
                                  hintStyle: const TextStyle(
                                    color: AppColors.mutedInk,
                                    fontFamily: 'sans-serif',
                                    fontSize: 13,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: AppColors.forest,
                                  ),
                                  suffixIcon: _searchText.isEmpty
                                      ? null
                                      : IconButton(
                                          tooltip: 'Clear search',
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() => _searchText = '');
                                          },
                                          icon: const Icon(Icons.close_rounded),
                                        ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your collection',
                                  style: TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${_visibleBooks.length} TITLES',
                                  style: const TextStyle(
                                    color: AppColors.mutedInk,
                                    fontFamily: 'sans-serif',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 34,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final category = _categories[index];
                                  final isSelected =
                                      category == _selectedCategory;
                                  return ChoiceChip(
                                    label: Text(category),
                                    selected: isSelected,
                                    onSelected: (_) => setState(
                                      () => _selectedCategory = category,
                                    ),
                                    showCheckmark: false,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.ink,
                                      fontFamily: 'sans-serif',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    backgroundColor: AppColors.paper,
                                    selectedColor: AppColors.forest,
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppColors.forest
                                          : AppColors.line,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _visibleBooks.isEmpty
                            ? const _EmptyLibraryMessage()
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  // Keep a comfortable list on phones and use a
                                  // responsive grid on tablets and desktop screens.
                                  final isWide = constraints.maxWidth >= 760;
                                  final horizontalPadding =
                                      isWide ? 28.0 : 20.0;
                                  if (isWide) {
                                    final columns = (constraints.maxWidth / 390)
                                        .floor()
                                        .clamp(2, 4);
                                    return GridView.builder(
                                      padding: EdgeInsets.fromLTRB(
                                        horizontalPadding,
                                        0,
                                        horizontalPadding,
                                        90,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: columns,
                                        crossAxisSpacing: 14,
                                        mainAxisSpacing: 0,
                                        mainAxisExtent: 210,
                                      ),
                                      itemCount: _visibleBooks.length,
                                      itemBuilder: (context, index) {
                                        final book = _visibleBooks[index];
                                        return BookCard(
                                          key: ValueKey(book.id),
                                          book: book,
                                          onEdit: () =>
                                              _showBookForm(book: book),
                                          onAvailabilityChanged:
                                              (isAvailable) =>
                                                  _changeAvailability(
                                                      book, isAvailable),
                                          onRemove: () => _removeBook(book),
                                        );
                                      },
                                    );
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.fromLTRB(
                                      horizontalPadding,
                                      0,
                                      horizontalPadding,
                                      90,
                                    ),
                                    itemCount: _visibleBooks.length,
                                    itemBuilder: (context, index) {
                                      final book = _visibleBooks[index];
                                      return BookCard(
                                        key: ValueKey(book.id),
                                        book: book,
                                        onEdit: () => _showBookForm(book: book),
                                        onAvailabilityChanged: (isAvailable) =>
                                            _changeAvailability(
                                                book, isAvailable),
                                        onRemove: () => _removeBook(book),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> _showBookForm({Book? book}) async {
    if (_isSaving) return;
    final isEditing = book != null;

    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController = TextEditingController(text: book?.author ?? '');
    final categoryController = TextEditingController(
      text: book?.category ?? 'Fiction',
    );

    Book? editedBook;
    try {
      editedBook = await showDialog<Book>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            scrollable: true,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            backgroundColor: AppColors.paper,
            title: Text(
              isEditing ? 'Edit book details' : 'Add a book',
              style: const TextStyle(color: AppColors.ink, fontSize: 21),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BookTextField(
                    controller: titleController,
                    label: 'Book title',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _BookTextField(
                    controller: authorController,
                    label: 'Author',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _BookTextField(
                    controller: categoryController,
                    label: 'Category',
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.forest,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  final updated = book == null
                      ? Book(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          title: titleController.text.trim(),
                          author: authorController.text.trim(),
                          category: categoryController.text.trim(),
                          coverSource: BookCoverSource.localAsset,
                          coverLocation: 'assets/images/local_book_cover.png',
                          isAvailable: true,
                          rating: 5.0,
                          year: DateTime.now().year,
                        )
                      : book.copyWith(
                          title: titleController.text.trim(),
                          author: authorController.text.trim(),
                          category: categoryController.text.trim(),
                        );
                  Navigator.pop(dialogContext, updated);
                },
                child: Text(isEditing ? 'Save changes' : 'Add book'),
              ),
            ],
          );
        },
      );
    } finally {
      titleController.dispose();
      authorController.dispose();
      categoryController.dispose();
    }

    if (editedBook == null || !mounted) return;

    final updatedBooks = List<Book>.of(_books);
    final existingBook = book;
    if (existingBook != null) {
      final index = updatedBooks.indexWhere(
        (item) => item.id == existingBook.id,
      );
      if (index == -1) return;
      updatedBooks[index] = editedBook;
    } else {
      updatedBooks.insert(0, editedBook);
    }

    final saved = await _saveCollection(updatedBooks, resetFilters: true);
    if (!saved || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? '“${editedBook.title}” already edited successfully.'
              : '“${editedBook.title}” already added successfully.',
        ),
      ),
    );
  }

  Future<void> _changeAvailability(Book book, bool isAvailable) async {
    final index = _books.indexWhere((item) => item.id == book.id);
    if (index == -1) return;
    final updatedBooks = List<Book>.of(_books);
    updatedBooks[index] = updatedBooks[index].copyWith(
      isAvailable: isAvailable,
    );
    await _saveCollection(updatedBooks);
  }

  Future<void> _removeBook(Book book) async {
    final index = _books.indexWhere((item) => item.id == book.id);
    if (index == -1) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.paper,
        title: const Text('Delete this book?'),
        content: Text('Remove “${book.title}” from your library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.rose,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) return;

    final updatedBooks = List<Book>.of(_books)..removeAt(index);
    final saved = await _saveCollection(updatedBooks);
    if (!saved || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('“${book.title}” already deleted successfully.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            if (!mounted) return;
            final restoredBooks = List<Book>.of(_books)
              ..insert(index.clamp(0, _books.length).toInt(), book);
            await _saveCollection(restoredBooks);
          },
        ),
      ),
    );
  }

  Future<bool> _saveCollection(
    List<Book> updatedBooks, {
    bool resetFilters = false,
  }) async {
    if (_isSaving) return false;
    setState(() => _isSaving = true);
    try {
      await BookStorage.saveBooks(updatedBooks);
      if (!mounted) return false;
      setState(() {
        _books = updatedBooks;
        if (resetFilters) {
          _selectedCategory = 'All books';
          _searchController.clear();
          _searchText = '';
        } else if (_selectedCategory != 'All books' &&
            !_books.any((book) => book.category == _selectedCategory)) {
          _selectedCategory = 'All books';
        }
      });
      return true;
    } catch (_) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your library. Please try again.'),
        ),
      );
      return false;
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _BookTextField extends StatelessWidget {
  const _BookTextField({
    required this.controller,
    required this.label,
    required this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'sans-serif', fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter ${label.toLowerCase()}.';
        }
        return null;
      },
    );
  }
}

class _LoadErrorMessage extends StatelessWidget {
  const _LoadErrorMessage({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sync_problem_rounded,
              color: AppColors.rose,
              size: 38,
            ),
            const SizedBox(height: 12),
            const Text(
              'Could not load your library',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLibraryMessage extends StatelessWidget {
  const _EmptyLibraryMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              color: AppColors.forest,
              size: 38,
            ),
            const SizedBox(height: 12),
            const Text(
              'No books found',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Try another search or add a title to your collection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mutedInk,
                fontFamily: 'sans-serif',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
