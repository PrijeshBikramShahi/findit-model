// lib/models/product.dart

class Product {
  final String id;
  final String imageUrl;
  final String title;
  final String retailer;
  final double price;
  final String affiliateUrl;
  final double similarityScore;

  const Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.retailer,
    required this.price,
    required this.affiliateUrl,
    required this.similarityScore,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        imageUrl: json['image_url'],
        title: json['title'],
        retailer: json['retailer'],
        price: (json['price'] as num).toDouble(),
        affiliateUrl: json['affiliate_url'],
        similarityScore: (json['similarity_score'] as num).toDouble(),
      );
}

// lib/models/result.dart

class Result {
  final String id;
  final String instagramPostUrl;
  final String originalImageUrl;
  final String detectedClass;
  final List<Product> matches;
  final DateTime processedAt;

  const Result({
    required this.id,
    required this.instagramPostUrl,
    required this.originalImageUrl,
    required this.detectedClass,
    required this.matches,
    required this.processedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'],
        instagramPostUrl: json['instagram_post_url'],
        originalImageUrl: json['original_image_url'],
        detectedClass: json['detected_class'],
        matches: (json['matches'] as List).map((m) => Product.fromJson(m)).toList(),
        processedAt: DateTime.parse(json['processed_at']),
      );
}

// lib/models/saved_item.dart

class SavedItem {
  final String id;
  final Product product;
  final DateTime savedAt;

  const SavedItem({
    required this.id,
    required this.product,
    required this.savedAt,
  });

  factory SavedItem.fromJson(Map<String, dynamic> json) => SavedItem(
        id: json['id'],
        product: Product.fromJson(json['product']),
        savedAt: DateTime.parse(json['saved_at']),
      );
}
