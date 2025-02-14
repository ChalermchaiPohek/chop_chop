import 'dart:convert';
import 'dart:io';

import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/util/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductService extends GetxService {


  Future<ProductRespond> getLatestProduct({int limit = 20, String? cursor}) async {
    try {
      String apiPath = "products?limit=$limit";
      if (cursor != null && cursor.trim().isNotEmpty) {
        apiPath += "&cursor=$cursor";
      }

      final bool isAndroid = Platform.isAndroid;

      final response = await http.get(
        Uri.parse(
          "${isAndroid ? AppConst.baseUrlAndroidEmu : AppConst.baseUrl}/$apiPath",
        ),
      );
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

  Future<List<Item>> getRecommendedProduct() async {
    try {
      final bool isAndroid = Platform.isAndroid;
      final response = await http.get(Uri.parse("${isAndroid ? AppConst.baseUrlAndroidEmu : AppConst.baseUrl}/recommended-products"));
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