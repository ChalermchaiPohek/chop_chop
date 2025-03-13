import 'package:chop_chop/util/food_enum.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  late final RxList<Food> orderedFood = <Food>[].obs;
  int get totalProduct => orderedFood.isEmpty
      ? 0
      : orderedFood.length;

  void updateItemInCart(int amount, Food food) {
    final List<Food> groupFood = orderedFood.where((p0) => p0.name == food.name,).toList();

    if (amount > groupFood.length) {
      orderedFood.add(food);
    } else {
      orderedFood.remove(food);
    }
  }

  void clearCart() {
    orderedFood.clear();
  }
}