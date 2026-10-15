import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String resultId;
  const ProductDetailScreen({super.key, required this.resultId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Result> _resultFuture;
  final Set<String> _saved = {};

  @override
  void initState() {
    super.initState();
    _resultFuture = ApiService.getResult(widget.resultId);
  }

  Future<void> _toggleSave(String productId) async {
    setState(() {
      if (_saved.contains(productId)) {
        _saved.remove(productId);
        ApiService.unsaveProduct(productId);
      } else {
        _saved.add(productId);
        ApiService.saveProduct(productId);
      }
    });
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result>(
      future: _resultFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        }
        final result = snapshot.data!;
        return _buildContent(result);
      },
    );
  }

  Widget _buildContent(Result result) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with original image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFFFAF9F7),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: result.originalImageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[200]),
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Color(0xFF0A0A0A)),
              ),
            ),
          ),

          // Detected class header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A853).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      result.detectedClass.toUpperCase(),
                      style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD4A853),
                          letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${result.matches.length} matches found',
                      style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 13,
                          color: Colors.grey[500])),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text('Similar Products',
                  style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
            ),
          ),

          // Product matches list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _ProductTile(
                product: result.matches[i],
                rank: i + 1,
                isSaved: _saved.contains(result.matches[i].id),
                onSave: () => _toggleSave(result.matches[i].id),
                onShop: () => _openLink(result.matches[i].affiliateUrl),
              ),
              childCount: result.matches.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final int rank;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onShop;

  const _ProductTile({
    required this.product,
    required this.rank,
    required this.isSaved,
    required this.onSave,
    required this.onShop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 24,
            child: Text('$rank',
                style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[400])),
          ),

          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(width: 72, height: 72, color: Colors.grey[100]),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title,
                    style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(product.retailer,
                    style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 12,
                        color: Colors.grey[500])),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                          '${(product.similarityScore * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              GestureDetector(
                onTap: onSave,
                child: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isSaved ? const Color(0xFFD4A853) : Colors.grey[400],
                  size: 22,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onShop,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Shop',
                      style: TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
