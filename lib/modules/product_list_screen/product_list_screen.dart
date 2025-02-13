import 'package:cart_stepper/cart_stepper.dart';
import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/modules/product_list_screen/product_list_controller.dart';
import 'package:chop_chop/router/route_path.dart';
import 'package:chop_chop/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductListController _controller = Get.put(ProductListController());
  final NumberFormat _formater = NumberFormat("#,###.##");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              /// TODO: Use a proper data!
              Get.toNamed(
                  RoutePath.cartPath,
                  arguments: {
                    "":"",
                  }
              );
            },
            child: Row(
              children: [
                Icon(Icons.shopping_cart_rounded),
                const VerticalDivider(color: Colors.transparent,),
                Text("amount of selected product") /// TODO: add the real data.
              ],
            ),
          )
        ],
      ),
      body: SafeArea(child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIConst.hDivider,
          Text("Recommend Products", style: Theme.of(context).textTheme.titleLarge,),
          UIConst.hDivider,
          FutureBuilder<List<Item>>(
            future: _controller.fetchRecommendedProduct(),
            builder: (_, snapshot) {
              /// TODO: handling error
              final bool isLoading = snapshot.connectionState == ConnectionState.waiting;
              final List<Item> data = snapshot.data ?? [];

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                    itemCount: isLoading ? 5 : data.length,
                    itemBuilder: (context, index) {
                      /// MARK: - Possibly has a better solution.
                      if (isLoading) {
                        return ListTile(
                          // key: ValueKey(item.id),
                          leading: SizedBox.square(
                            dimension: 30,
                            child: Container(
                              /// TODO: add a photo
                            ),
                          ),
                          title: Text("item.name"),
                          subtitle: Text("item.price"),
                        );
                      } else {
                        final item = data.elementAt(index);
                        return ListTile(
                          leading: const SizedBox(),
                          title: Text(item.name),
                          subtitle: Text(_formater.format(item.price)),
                          trailing: Obx(() {

                            final bool isAlreadyIn = _controller.selectedProduct.containsKey(item);
                            if (isAlreadyIn) {
                              return CartStepper(
                                alwaysExpanded: true,
                                stepper: 1,
                                value: _controller.selectedProduct[item],
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
                      }
                    },
                  ),
                ),
              );
            },
          ),
          UIConst.hDivider,
          Text("Latest Products", style: Theme.of(context).textTheme.titleMedium,),
          UIConst.hDivider,
          FutureBuilder<List<Item>>(
            future: _controller.fetchLatestProduct(),
            builder: (_, snapshot) {
              /// TODO: handling error
              final bool isLoading = snapshot.connectionState == ConnectionState.waiting;
              final List<Item> data = snapshot.data ?? [];

              return Expanded(
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isLoading ? 5 : data.length,
                    itemBuilder: (context, index) {
                      /// MARK: - Possibly has a better solution.
                      if (isLoading) {
                        return ListTile(
                          // key: ValueKey(item.id),
                          leading: SizedBox.square(
                            dimension: 30,
                            child: Container(
                              /// TODO: add a photo
                            ),
                          ),
                          title: Text("item.name"),
                          subtitle: Text("item.price"),
                        );
                      } else {
                        final item = data.elementAt(index);
                        return ListTile(
                          leading: const SizedBox(),
                          title: Text(item.name),
                          subtitle: Text(_formater.format(item.price)),
                          trailing: Obx(() {

                            final bool isAlreadyIn = _controller.selectedProduct.containsKey(item);
                            if (isAlreadyIn) {
                              return CartStepper(
                                alwaysExpanded: true,
                                stepper: 1,
                                value: _controller.selectedProduct[item],
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
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
