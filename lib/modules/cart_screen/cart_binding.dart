import 'package:chop_chop/modules/cart_screen/cart_controller.dart';
import 'package:get/get.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(CartController.new);
  }

}