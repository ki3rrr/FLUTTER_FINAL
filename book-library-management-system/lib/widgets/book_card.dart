import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/app_colors.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onAvailabilityChanged,
    required this.onRemove,
  });

  final Book book;
  final VoidCallback onEdit;
  final ValueChanged<bool> onAvailabilityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.paper,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BookCover(book: book),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.forestLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      book.category.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontFamily: 'sans-serif',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${book.author}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.mutedInk,
                      fontFamily: 'sans-serif',
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.ochre,
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        book.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontFamily: 'sans-serif',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${book.year}',
                        style: const TextStyle(
                          color: AppColors.mutedInk,
                          fontFamily: 'sans-serif',
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              onAvailabilityChanged(!book.isAvailable),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: book.isAvailable
                                ? AppColors.forest
                                : AppColors.rose,
                            side: BorderSide(
                              color: book.isAvailable
                                  ? AppColors.forest.withOpacity(0.35)
                                  : AppColors.rose.withOpacity(0.35),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: const Size(0, 34),
                            textStyle: const TextStyle(
                              fontFamily: 'sans-serif',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: Text(
                            book.isAvailable ? 'Available' : 'Checked out',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit ${book.title}',
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                        color: AppColors.forest,
                        iconSize: 19,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        tooltip: 'Remove ${book.title}',
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline_rounded),
                        color: AppColors.mutedInk,
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final image = book.coverSource == BookCoverSource.localAsset
        ? Image.asset(
            book.coverLocation,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _CoverFallback(),
          )
        : Image.network(
            book.coverLocation,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const _CoverFallback(showSpinner: true);
            },
            errorBuilder: (_, __, ___) => const _CoverFallback(),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(width: 82, height: 120, child: image),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({this.showSpinner = false});

  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forestLight,
      alignment: Alignment.center,
      child: showSpinner
          ? const SizedBox(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.forest,
              ),
            )
          : const Icon(
              Icons.menu_book_rounded,
              color: AppColors.forest,
              size: 30,
            ),
    );
  }
}
