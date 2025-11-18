import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import '../model/produk.dart';

class ApiService {
  // Choose an appropriate base URL depending on the platform.
  // - On Android emulator use 10.0.2.2 to reach host machine.
  // - On web and desktop, localhost is fine.
  static String get baseUrl {
    if (kIsWeb) return "http://localhost/toko-api/public";
    if (defaultTargetPlatform == TargetPlatform.android)
      return "http://10.0.2.2/toko-api/public";
    return "http://localhost/toko-api/public";
  }

  // GET semua produk
  static Future<List<Produk>> getProduk() async {
    final response = await http.get(Uri.parse("$baseUrl/produk"));
    final jsonData = jsonDecode(response.body);

    List list = jsonData['data'];
    return list.map((e) => Produk.fromJson(e)).toList();
  }

  // POST tambah produk
  static Future<bool> tambahProduk(Produk p) async {
    try {
      // Coba kirim sebagai JSON (banyak API modern menerima JSON)
      final jsonBody = jsonEncode({
        "kode_produk": p.kodeProduk,
        "nama_produk": p.namaProduk,
        "harga": p.hargaProduk.toString(),
      });

      final response = await http.post(
        Uri.parse("$baseUrl/produk"),
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );

      // Debug output untuk membantu diagnosis
      print('tambahProduk -> status: ${response.statusCode}');
      print('tambahProduk -> body: ${response.body}');

      // Be tolerant terhadap 200 atau 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // Jika server tidak menerima JSON, coba fallback ke form-encoded
      final fallback = await http.post(
        Uri.parse("$baseUrl/produk"),
        body: {
          "kode_produk": p.kodeProduk,
          "nama_produk": p.namaProduk,
          "harga": p.hargaProduk.toString(),
        },
      );

      print('tambahProduk fallback -> status: ${fallback.statusCode}');
      print('tambahProduk fallback -> body: ${fallback.body}');

      return fallback.statusCode == 200 || fallback.statusCode == 201;
    } catch (e) {
      print('tambahProduk error: $e');
      return false;
    }
  }

  // PUT update produk
  static Future<bool> updateProduk(Produk p) async {
    try {
      // Coba kirim sebagai JSON
      final jsonBody = jsonEncode({
        "kode_produk": p.kodeProduk,
        "nama_produk": p.namaProduk,
        "harga": p.hargaProduk.toString(),
      });

      final response = await http.put(
        Uri.parse("$baseUrl/produk/${p.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );

      print('updateProduk -> status: ${response.statusCode}');
      print('updateProduk -> body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // Fallback ke form-encoded
      final fallback = await http.put(
        Uri.parse("$baseUrl/produk/${p.id}"),
        body: {
          "kode_produk": p.kodeProduk,
          "nama_produk": p.namaProduk,
          "harga": p.hargaProduk.toString(),
        },
      );

      print('updateProduk fallback -> status: ${fallback.statusCode}');
      print('updateProduk fallback -> body: ${fallback.body}');

      return fallback.statusCode == 200 || fallback.statusCode == 201;
    } catch (e) {
      print('updateProduk error: $e');
      return false;
    }
  }

  // DELETE produk
  static Future<bool> deleteProduk(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/produk/$id"));
      print('deleteProduk -> status: ${response.statusCode}');
      print('deleteProduk -> body: ${response.body}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('deleteProduk error: $e');
      return false;
    }
  }
}
