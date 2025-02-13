import 'package:chop_chop/model/product_respond.dart';
import 'package:get/get.dart';

class CartController extends GetxController {

  late RxMap<Item, int> selectedProduct = <Item, int>{}.obs;

  void updateItemInCart(int amount, Item item) {
    if (amount == 0) {
      selectedProduct.remove(item);
    } else {
      selectedProduct[item] = amount;
    }
  }
}