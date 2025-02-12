import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/services/products/services.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {

  /// TODO: make a getter.
  // final isLoadingProducts = true.obs;
  final productCount = 0.obs;
  // final productList = Rxn<ProductRespond>();
  // final recommendedProducts = RxList<Item>();

  // bool get loadingRecommended => _isLoadingRecommended.value;
  // final _isLoadingRecommended = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchLatestProduct();
    // await fetchRecommendedProduct();
  }

  Future<ProductRespond?> fetchLatestProduct() async {
    // try {
    //   isLoadingProducts(true);
    //   final x = await ProductService().getLatestProduct();
    //   productList.value = x;
    //   print(x);
    //   return x;
    // } catch (e, s) {
    //   print(e);
    //   return null;
    //   // Get.snackbar("Error", "Failed to fetch users");
    // }
  }

  Future<List<Item>> fetchRecommendedProduct() async {
    try {
      return ProductService().getRecommendedProduct()
          .then((value) async {
            await Future.delayed(const Duration(seconds: 3));
        return value;
      },);
    } catch (error, s) {
      printError(info: error.toString());
      return Future.error(error);
    }
  }
}