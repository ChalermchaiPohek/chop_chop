import 'dart:convert';

import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/util/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductService extends GetxService {


  Future<ProductRespond> getLatestProduct() async {
    try {
      final response = await http.get(Uri.parse("${AppConst.baseUrl}/products"));
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

  /// TODO: Not test yet.
  Future<List<Item>> getRecommendedProduct() async {
    try {
      final response = await http.get(Uri.parse("${AppConst.baseUrl}/recommended-products"));
      if (response.statusCode == 200) {
        final List jsonResp = json.decode(response.body);
        return jsonResp.map((e) => Item.fromJson(e),).toList();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error, s) {
      printError(info: s.toString());
      rethrow;
    }
  }
}