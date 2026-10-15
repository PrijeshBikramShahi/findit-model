import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // Change this to your local IP when testing on a real device
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
  static const String baseUrl = 'http://10.0.2.2:8000';

  static const String _userId = 'user_mock_001'; // replace with real auth later

  // ── Results ──────────────────────────────────────────────────────────────

  static Future<List<Result>> getResults() async {
    final response = await http.get(Uri.parse('$baseUrl/results/$_userId'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((j) => Result.fromJson(j)).toList();
    }
    throw Exception('Failed to load results');
  }

  static Future<Result> getResult(String resultId) async {
    final response = await http.get(Uri.parse('$baseUrl/result/$resultId'));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load result');
  }

  // ── Products ─────────────────────────────────────────────────────────────

  static Future<Product> getProduct(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/$productId'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load product');
  }

  // ── Saved / Wishlist ──────────────────────────────────────────────────────

  static Future<List<SavedItem>> getSaved() async {
    final response = await http.get(Uri.parse('$baseUrl/saved/$_userId'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((j) => SavedItem.fromJson(j)).toList();
    }
    throw Exception('Failed to load saved items');
  }

  static Future<void> saveProduct(String productId) async {
    await http.post(Uri.parse('$baseUrl/save/$_userId/$productId'));
  }

  static Future<void> unsaveProduct(String productId) async {
    await http.delete(Uri.parse('$baseUrl/save/$_userId/$productId'));
  }
}
