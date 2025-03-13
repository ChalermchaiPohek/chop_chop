import 'package:cart_stepper/cart_stepper.dart';
import 'package:chop_chop/modules/cart_screen/cart_controller.dart';
import 'package:chop_chop/util/constants.dart';
import 'package:chop_chop/util/food_enum.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _controller = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _controller.orderedFood(Get.arguments["products"] as List<Food>? ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final List<Widget> successOrder = [
      Text(
        "Your order has been processed.",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      UIConst.hDivider,
      Text("Thank you!"),
      UIConst.hDivider,
      FilledButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Order again"),
      )
    ];
    final List<Widget> emptyCart = [
      Text("Not order yet?"),
      UIConst.hDivider,
      FilledButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Go to order screen"),
      )
    ];

    return Obx(() {
      final products = _controller.orderedFood;
      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _controller.placeOrderSucceed ? successOrder : emptyCart,
          ),
        );
      } else {
        return Column(
          children: [
            Expanded(
              flex: 8,
              child: Obx(() {
                final foodGroupOrder = products.groupListsBy((element) => element,);
                final List<Widget> productItems = foodGroupOrder.entries.map((e) {
                  return Slidable(
                    key: UniqueKey(),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (ctx) {
                            _controller.updateItemInCart(0, e.key);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: e.key.colour,),
                      title: Text(e.key.name),
                      subtitle: Text("${e.key.price.toStringAsFixed(2)} / unit"),
                      trailing: CartStepper(
                        alwaysExpanded: true,
                        stepper: 1,
                        value: e.value.length,
                        didChangeCount: (value) {
                          _controller.updateItemInCart(value, e.key);
                        },
                      ),
                      onTap: () {},
                    ),
                  );
                },).toList();
                return ListView(
                  shrinkWrap: true,
                  children: productItems,
                );
              },),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).focusColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("Member card")),
                        Obx(() {
                          return Checkbox(value: _controller.isMembership, onChanged: (_) {
                            _controller.toggleMembership();
                          });
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Total")),
                        Obx(() {
                          return Text(_controller.totalPrice.toStringAsFixed(2));
                        },),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }
    },);

  }
}
