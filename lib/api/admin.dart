import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/session_manager.dart';
import '../models/product.dart';

class AdminApi {
  static Future<Map<String, dynamic>> login(
    String login,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/login'),
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

  static Future<void> logout() async {
    final token = await SessionManager.getToken();
    await http.post(
      Uri.parse('$baseUrl/admin/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    await SessionManager.clearToken();
  }

  static Future<List<Product>> getProducts() async {
    final token = await SessionManager.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/admin/products'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil produk');
    }
  }

  static Future<bool> saveProduct(
    Product product, {
    int? id,
    Uint8List? webImageBytes,
  }) async {
    final token = await SessionManager.getToken();
    final uri = Uri.parse(
      id == null ? '$baseUrl/admin/products' : '$baseUrl/admin/products/$id',
    );

    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..headers['Accept'] = 'application/json'
          ..fields.addAll(product.toMap());

    if (id != null) {
      request.fields['_method'] = 'PUT';
    }

    if (kIsWeb && webImageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          webImageBytes,
          filename: 'upload.png',
        ),
      );
    } else if (product.imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', product.imageFile!.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> deleteProduct(int id) async {
    final token = await SessionManager.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/products/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }
}
