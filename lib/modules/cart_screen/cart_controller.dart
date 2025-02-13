import 'package:chop_chop/model/product_respond.dart';
import 'package:get/get.dart';

class CartController extends GetxController {

  late RxMap<Item, int> selectedProduct = <Item, int>{}.obs;
  double get totalPrice => _totalPrice.value;
  final RxDouble _totalPrice = 0.0.obs;

  double get discountPrice => _discountPrice.value;
  final RxDouble _discountPrice = 0.0.obs;


  @override
  void onReady() {
    super.onReady();
    _calculatePrice();
  }

  void updateItemInCart(int amount, Item item) {
    if (amount == 0) {
      selectedProduct.remove(item);
    } else {
      selectedProduct[item] = amount;
    }
    _calculatePrice();
  }

  void _calculatePrice() {
    const double discountRate = 0.05;
    _totalPrice.value = 0.0;
    _discountPrice.value = 0.0;

    for (var product in selectedProduct.entries) {
      final int unitPrice = product.key.price;
      final int quantity = product.value;
      final int pairs = quantity ~/ 2;
      final int remaining = quantity % 2;

      final int totalForPairs = pairs * (unitPrice * 2);
      final double discount = totalForPairs * discountRate;
      _discountPrice.value += discount;

      final double totalAfterDiscount = (totalForPairs - discount);
      int totalForRemaining = remaining * unitPrice;
      double totalForProduct = totalAfterDiscount + totalForRemaining;

      _totalPrice.value += totalForProduct;
    }
  }
}