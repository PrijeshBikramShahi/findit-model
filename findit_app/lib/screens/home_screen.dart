import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Result>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _resultsFuture = ApiService.getResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FindIt'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.alternate_email_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('findit.app', style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Result>>(
        future: _resultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmer();
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          final results = snapshot.data!;
          if (results.isEmpty) {
            return _buildEmpty();
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _resultsFuture = ApiService.getResults());
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (ctx, i) => _ResultCard(result: results[i]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (_, __) => Container(
          height: 380,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('Could not connect to server', style: TextStyle(fontFamily: 'Syne', fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Make sure the backend is running', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() => _resultsFuture = ApiService.getResults()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: Text('🔍', style: TextStyle(fontSize: 36))),
          ),
          const SizedBox(height: 20),
          const Text('No results yet', style: TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Tag @findit.app on Instagram\nto find products you love', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Result result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final topMatch = result.matches.isNotEmpty ? result.matches.first : null;

    return GestureDetector(
      onTap: () => context.push('/product/${result.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Instagram image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: result.originalImageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(height: 220, color: Colors.grey[100]),
                  ),
                  // Detected class badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A).withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: Color(0xFFD4A853), size: 12),
                          const SizedBox(width: 4),
                          Text(
                            result.detectedClass.toUpperCase(),
                            style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Match count badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A853),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${result.matches.length} matches',
                        style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0A0A0A)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top match preview
            if (topMatch != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: topMatch.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(width: 64, height: 64, color: Colors.grey[100]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Best match',
                            style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey[500], letterSpacing: 0.3),
                          ),
                          const SizedBox(height: 2),
                          Text(topMatch.title, style: const TextStyle(fontFamily: 'DM Sans', fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(topMatch.retailer, style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${topMatch.price.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(topMatch.similarityScore * 100).toStringAsFixed(0)}% match',
                            style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    _timeAgo(result.processedAt),
                    style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: Colors.grey[400]),
                  ),
                  const Spacer(),
                  const Text(
                    'See all matches →',
                    style: TextStyle(fontFamily: 'Syne', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0A0A0A)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
