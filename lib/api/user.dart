import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/session_manager.dart';
import '../models/product.dart';

class UserApi {
  static Future<void> logout() async {
    final token = await SessionManager.getToken();
    await http.post(
      Uri.parse('$baseUrl/user/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    await SessionManager.clearToken();
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
      },
    );

    if (response.statusCode == 201) {
      return {'success': true};
    } else {
      final data = jsonDecode(response.body);
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal registrasi',
      };
    }
  }

  static Future<Map<String, dynamic>> login(
    String login,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Accept': 'application/json'},
      body: {'login': login, 'password': password},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await SessionManager.saveToken(data['access_token']);
      return {
        'success': true,
        'access_token': data['access_token'],
        'user': data['user'] ?? {},
      };
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    }
  }

  static Future<List<Product>> getProducts() async {
    final token = await SessionManager.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/user/products'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  static Future<Product> getProductDetail(int id) async {
    final token = await SessionManager.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/user/products/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Produk tidak ditemukan');
    }
  }
}
