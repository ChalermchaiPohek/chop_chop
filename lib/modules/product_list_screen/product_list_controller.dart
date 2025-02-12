import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/services/products/services.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {

  /// TODO: make a getter.
  // final isLoadingProducts = true.obs;
  final productCount = 0.obs;
  var _cursor = "";
  // final productList = Rxn<ProductRespond>();
  // final recommendedProducts = RxList<Item>();

  // bool get loadingRecommended => _isLoadingRecommended.value;
  // final _isLoadingRecommended = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // fetchLatestProduct();
    // await fetchRecommendedProduct();
  }

  Future<List<Item>> fetchLatestProduct() async {
    try {
      final resp = await ProductService().getLatestProduct();
      _cursor = resp.nextCursor;
      return resp.items;
    } catch (e, s) {
      print(e);
      return Future.error(e);
    }
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