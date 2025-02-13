import 'package:cart_stepper/cart_stepper.dart';
import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/modules/cart_screen/cart_controller.dart';
import 'package:chop_chop/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _controller = Get.find<CartController>();
  final NumberFormat _formater = NumberFormat("#,###.##");

  @override
  void initState() {
    super.initState();
    _controller.selectedProduct(Get.arguments["products"] as Map<Item, int>);
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
    return Obx(() {
      final products = _controller.selectedProduct;
      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Empty Cart"),
              UIConst.hDivider,
              FilledButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Go to shopping"),
              )
            ],
          ),
        );
      } else {
        return Column(
          children: [
            Expanded(
              flex: 8,
              child: Obx(() {
                final List<Widget> productItems = products.entries.map((e) {
                  return Slidable(
                    key: ValueKey(e.key.id),
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
                      leading: const SizedBox(),
                      title: Text(e.key.name),
                      subtitle: Text("${_formater.format(e.key.price)} / unit"),
                      trailing: CartStepper(
                        alwaysExpanded: true,
                        stepper: 1,
                        value: e.value,
                        didChangeCount: (value) {
                          _controller.updateItemInCart(value, e.key);
                        },
                      ),
                      // onTap: () {},
                    ),
                  );
                },).toList();
                return ListView(
                  // itemCount: products.length,
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
                        Expanded(child: Text("Subtotal")),
                        Obx(() {
                          final subTotal = _controller.totalPrice;
                          return Text(_formater.format(subTotal));
                        },),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Promotion discount")),
                        Obx(() {
                          final discount = _controller.discountPrice;
                          return Text("-${_formater.format(discount)}", style: TextStyle(color: Colors.red),);
                        },),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                            child: Obx(() {
                              final subTotal = _controller.totalPrice;
                              final discount = _controller.discountPrice;
                              return Text(_formater.format(subTotal - discount), style: Theme.of(context).textTheme.titleLarge,);
                            },),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () {
                            /// TODO: fire an api then show success or faile checkout.
                          },
                          child: Text("Checkout"),
                        )
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
