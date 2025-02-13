import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/services/products/services.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  List<Item> get products => _product;
  final RxList<Item> _product = RxList<Item>();

  List<Item> get recommendedProducts => _rProduct;
  final RxList<Item> _rProduct = RxList<Item>();

  String? _cursor;
  bool isLoadingProduct = false;
  bool isLoadingRecProduct = false;

  late final RxMap<Item, int> selectedProduct = <Item, int>{}.obs;
  int get totalProduct => selectedProduct.values.isEmpty
      ? 0
      : selectedProduct.values.reduce((value, element) => value + element,);

  // @override
  // Future<void> onInit() async {
  //   super.onInit();
  //   // fetchLatestProduct();
  //   // await fetchRecommendedProduct();
  // }

  Future fetchLatestProduct() async {
    try {
      isLoadingProduct = true;
      await Future.delayed(const Duration(seconds: 3));
      final resp = await ProductService().getLatestProduct(cursor: _cursor);
      isLoadingProduct = false;
      _cursor = resp.nextCursor;
      _product.addAll(resp.items);
    } catch (e, s) {
      print(e);
      isLoadingProduct = false;
      return Future.error(e);
    }
  }

  Future fetchRecommendedProduct() async {
    try {
      isLoadingRecProduct = true;
      return ProductService().getRecommendedProduct()
          .then((value) async {
        await Future.delayed(const Duration(seconds: 3));
          _rProduct.addAll(value);
        isLoadingRecProduct = false;
        return;
      },);
    } catch (error, s) {
      isLoadingRecProduct = false;
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