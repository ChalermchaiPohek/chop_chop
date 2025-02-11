import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/services/products/services.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {

  var isLoading = true.obs;
  var productList = Rxn<ProductRespond>();

  @override
  void onInit() {
    super.onInit();
    fetchLatestProduct();
  }

  Future<ProductRespond?> fetchLatestProduct() async {
    try {
      isLoading(true);
      final x = await ProductService().getLatestProduct();
      productList.value = x;
      print(x);
      return x;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users");
    } finally {
      isLoading(false);
    }
    return null;
  }
}