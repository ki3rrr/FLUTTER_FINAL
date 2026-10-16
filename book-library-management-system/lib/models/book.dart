enum BookCoverSource { localAsset, network }

class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.coverSource,
    required this.coverLocation,
    required this.isAvailable,
    required this.rating,
    required this.year,
  });

  final String id;
  final String title;
  final String author;
  final String category;
  final BookCoverSource coverSource;
  final String coverLocation;
  final bool isAvailable;
  final double rating;
  final int year;

  Book copyWith({
    String? title,
    String? author,
    String? category,
    BookCoverSource? coverSource,
    String? coverLocation,
    bool? isAvailable,
    double? rating,
    int? year,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      coverSource: coverSource ?? this.coverSource,
      coverLocation: coverLocation ?? this.coverLocation,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      year: year ?? this.year,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'coverSource': coverSource.name,
      'coverLocation': coverLocation,
      'isAvailable': isAvailable,
      'rating': rating,
      'year': year,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final coverSource = json['coverSource'] == BookCoverSource.network.name
        ? BookCoverSource.network
        : BookCoverSource.localAsset;

    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      coverSource: coverSource,
      coverLocation: json['coverLocation'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      year: (json['year'] as num?)?.toInt() ?? DateTime.now().year,
    );
  }
}
