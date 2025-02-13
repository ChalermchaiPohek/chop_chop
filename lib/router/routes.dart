import 'package:chop_chop/modules/cart_screen/cart_binding.dart';
import 'package:chop_chop/modules/cart_screen/cart_screen.dart';
import 'package:chop_chop/modules/product_list_screen/product_list_binding.dart';
import 'package:chop_chop/modules/product_list_screen/product_list_screen.dart';
import 'package:chop_chop/router/route_path.dart';
import 'package:get/get.dart';

abstract class Routes {
  static List<GetPage> routers = [
    GetPage(
      name: RoutePath.productListPath,
      page: ProductListScreen.new,
      transition: Transition.native,
      binding: ProductListBinding()
    ),
    GetPage(
      name: RoutePath.cartPath,
      page: CartScreen.new,
      transition: Transition.native,
      binding: CartBinding()
    ),
  ];
}