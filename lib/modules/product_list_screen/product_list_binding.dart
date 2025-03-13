import 'package:chop_chop/modules/product_list_screen/product_list_controller.dart';
import 'package:get/get.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ProductListController.new);
  }

}