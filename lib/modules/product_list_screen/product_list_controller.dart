import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/services/products/services.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {

  /// TODO: make a getter.
  int get productCount => _productCount.value;
  final _productCount = 0.obs;

  var _cursor = "";

  late final RxMap<Item, int> selectedProduct = <Item, int>{}.obs;

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

  void updateItemInCart(int amount, Item item) {
    if (amount == 0) {
      selectedProduct.remove(item);
    } else {
      selectedProduct[item] = amount;
    }
  }
}