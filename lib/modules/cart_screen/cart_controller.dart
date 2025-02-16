import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/services/order/services.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final OrderService _orderService = Get.find();

  late RxMap<Item, int> selectedProduct = <Item, int>{}.obs;
  double get totalPrice => _totalPrice.value;
  final RxDouble _totalPrice = 0.0.obs;

  double get discountPrice => _discountPrice.value;
  final RxDouble _discountPrice = 0.0.obs;

  bool get placeOrderStatus => _placeOrderSucceed.value;
  final _placeOrderSucceed = false.obs;

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
      final int pairs = quantity ~/ 2; /// MARK: - หารไม่เอาค่าทศนิยม e.g int result1 = 7 ~/ 2;  // 3 (instead of 3.5)
      final int remaining = quantity % 2;

      final int totalForPairs = pairs * (unitPrice * 2); /// MARK: - calculate all pairs' price.
      final double discount = totalForPairs * discountRate;
      _discountPrice.value += discount;

      final double totalAfterDiscount = (totalForPairs - discount);
      int totalForRemaining = remaining * unitPrice;
      double totalForProduct = totalAfterDiscount + totalForRemaining;

      _totalPrice.value += totalForProduct;
    }
  }

  Future placeOrder() async {
    try {
      final List<int> productIds = selectedProduct.keys.map((e) => e.id,).toList();
      return _orderService.checkout(productIds).then((value) {
        if (value > 200 && value < 300) {
          _placeOrderSucceed.value = true;
          selectedProduct.clear();
          return ;
        } else {
          _placeOrderSucceed.value = false;
          throw Exception(value);
        }
      },);
    } catch (error, s) {
      _placeOrderSucceed.value = false;
      return Future.error(error, s);
    }
  }
}