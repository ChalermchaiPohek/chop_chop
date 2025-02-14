import 'dart:convert';

import 'package:chop_chop/util/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderService extends GetxService {


  Future<int> checkout(List<int> productIds) async {
    try {
      if (productIds.isEmpty) {
        return 0;
      }
      final response = await http.post(
        Uri.parse("${AppConst.baseUrl}/orders/checkout"),
        headers: {
          "Content-Type":"application/json",
        },
        body: jsonEncode({
          "products": productIds,
        })
      );

      return response.statusCode;
    } catch (error, s) {
      printError(info: s.toString());
      rethrow;
    }
  }

}