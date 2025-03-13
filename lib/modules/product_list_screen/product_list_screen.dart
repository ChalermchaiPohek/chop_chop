import 'package:cart_stepper/cart_stepper.dart';
import 'package:chop_chop/modules/product_list_screen/product_list_controller.dart';
import 'package:chop_chop/router/route_path.dart';
import 'package:chop_chop/util/constants.dart';
import 'package:chop_chop/util/food_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductListController _controller = Get.find<ProductListController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Obx(() {
              return Visibility(
                visible: _controller.totalProduct > 0,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Get.toNamed(
                        RoutePath.cartPath,
                        arguments: {
                          "products": _controller.orderedFood,
                        }
                    );
                  },
                  icon: Badge.count(
                    count: _controller.totalProduct,
                    child: Icon(Icons.shopping_cart_rounded),
                  ),
                ),
              );
            },
            ),
          ),
          Obx(() {
            return Visibility(
              visible: _controller.totalProduct > 0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    _controller.clearCart();
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
            );
          },
          ),

        ],
      ),
      body: SafeArea(child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIConst.hDivider,
            Text("Food menu", style: Theme.of(context).textTheme.titleLarge,),
            UIConst.hDivider,
            ListView.builder(
              shrinkWrap: true,
              itemCount: Food.values.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = Food.values.elementAt(index);
                return ListTile(
                  leading: CircleAvatar(backgroundColor: item.colour,),
                  title: Text(item.name),
                  subtitle: Text(item.price.toStringAsFixed(2)),
                  trailing: Obx(() {
                    final Iterable<Food> foodByName = _controller.orderedFood.where((p0) => p0.name == item.name,);
                    final bool isAlreadyIn = foodByName.isNotEmpty;
                    final int foodAmount = foodByName.length;
                    if (isAlreadyIn) {
                      return CartStepper(
                        alwaysExpanded: true,
                        stepper: 1,
                        value: foodAmount,
                        didChangeCount: (value) {
                          _controller.updateItemInCart(value, item);
                        },
                      );
                    } else {
                      return FilledButton(
                        onPressed: () {
                          _controller.updateItemInCart(1, item);
                        },
                        child: Text("Add to cart"),
                      );
                    }
                  },),
                  onTap: null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
