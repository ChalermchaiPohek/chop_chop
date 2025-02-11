import 'dart:convert';

import 'package:chop_chop/model/product_respond.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductService extends GetxService {
  final String baseUrl = "http://localhost:8080";

  Future<ProductRespond> getLatestProduct() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/products"));
      if (response.statusCode == 200) {
        return ProductRespond.fromJson(json.decode(response.body));
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error, s) {
      printError(info: s.toString());
      rethrow;
    }
  }

  Future<ProductRespond> getRecommendedProduct() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/recommended-products"));
      if (response.statusCode == 200) {
        /// TODO: change to List<Item>
        return ProductRespond.fromJson(json.decode(response.body));
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error, s) {
      printError(info: s.toString());
      rethrow;
    }
  }
}