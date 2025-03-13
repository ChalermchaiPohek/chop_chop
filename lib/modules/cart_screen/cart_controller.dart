import 'package:chop_chop/util/constants.dart';
import 'package:chop_chop/util/food_enum.dart';
import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class CartController extends GetxController {

  late RxList<Food> orderedFood = <Food>[].obs;

  final Rx<Decimal> _totalPrice = Rx(Decimal.zero);
  Decimal get totalPrice => _totalPrice.value;

  // final RxDouble _discountPrice = 0.0.obs;
  // double get discountPrice => _discountPrice.value;

  final _placeOrderSucceed = false.obs;
  bool get placeOrderSucceed => _placeOrderSucceed.value;

  // Rx<Decimal> x = Rx(Decimal.zero);

  final _isMember = false.obs;
  bool get isMembership => _isMember.value;
  void toggleMembership() {
    final bool currentValue = _isMember.value;
    _isMember.value = !currentValue;
    _calculatePrice();
  }

  @override
  void onReady() {
    super.onReady();
    _calculatePrice();
  }

  void updateItemInCart(int amount, Food food) {
    final Iterable<Food> groupFood = orderedFood.where((p0) => p0.name == food.name,);

    if (amount > groupFood.length) {
      orderedFood.add(food);
    } else {
      orderedFood.remove(food);
    }
    _calculatePrice();
  }

  void _calculatePrice() {
    _totalPrice.value = Decimal.zero;
    final foodGroupOrder = orderedFood.groupListsBy((element) => element,);

    for (var element in foodGroupOrder.entries) {
      final int orderQueue = element.value.length;
      if (Food.pairFoodPromotion.contains(element.key)) {

        if (orderQueue > 1) {
          final int pairs = (element.value.length / 2).truncate();
          Decimal pricePerPair = (element.key.price * Decimal.fromInt(2)) * AppConst.pairDiscount;
          if (_isMember.value) {
            pricePerPair *= AppConst.memberDiscount;
          }

          final Decimal subPairPrice = pricePerPair * Decimal.fromInt(pairs);
          _totalPrice.value += subPairPrice;

          if (orderQueue.isOdd) {
            if (_isMember.value) {
              _totalPrice.value += element.key.price * AppConst.memberDiscount;
            } else {
              _totalPrice.value += element.key.price;
            }
          }
        } else {
          _conditionCalculate(_isMember.value, element.key.price, Decimal.fromInt(orderQueue));
        }
      } else {
        _conditionCalculate(_isMember.value, element.key.price, Decimal.fromInt(orderQueue));
      }
    }
  }

  void _conditionCalculate(bool isMember, Decimal pricePerUnit, Decimal amount) {
    if (isMember) {
      /// MARK: discount 10%
      final subTotal = pricePerUnit * amount;
      _totalPrice.value += subTotal * AppConst.memberDiscount;
    } else {
      /// MARK: normal calculate
      _totalPrice.value += pricePerUnit * amount;
    }
  }
}