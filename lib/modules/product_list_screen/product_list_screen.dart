import 'package:cart_stepper/cart_stepper.dart';
import 'package:chop_chop/model/product_respond.dart';
import 'package:chop_chop/modules/product_list_screen/product_list_controller.dart';
import 'package:chop_chop/router/route_path.dart';
import 'package:chop_chop/util/constants.dart';
import 'package:flutter/cupertino.dart';
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
  final ProductListController _controller = Get.find<ProductListController>();
  final NumberFormat _formater = NumberFormat("#,###.##");
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      if (!_controller.isLoadingProduct) {
        _controller.fetchLatestProduct();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Get.toNamed(
                      RoutePath.cartPath,
                      arguments: {
                        "products": _controller.selectedProduct,
                      }
                  );
                },
                icon: Badge.count(
                  count: _controller.totalProduct,
                  child: Icon(Icons.shopping_cart_rounded),
                ),
              );
            },),
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
          FutureBuilder(
            future: _controller.fetchRecommendedProduct(),
            builder: (_, snapshot) {
              final bool isLoading = snapshot.connectionState == ConnectionState.waiting;

              /// MARK: - not perform a proper test.
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.xmark_circle,
                        color: CupertinoColors.destructiveRed,
                        size: 50,
                      ),
                      Text("Something went wrong"),
                      FilledButton(
                        onPressed: () async {
                          if (!_controller.isLoadingRecProduct) {
                            await _controller.fetchRecommendedProduct();
                          }
                        },
                        child: Text("Refresh"),
                      )
                    ],
                  ),
                );
              }

              final List<Item> data = _controller.recommendedProducts;
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Skeletonizer(
                  enabled: isLoading || data.isEmpty,
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
          FutureBuilder(
            future: _controller.fetchLatestProduct(),
            builder: (_, snapshot) {
              final bool isLoading = snapshot.connectionState == ConnectionState.waiting;

              /// MARK: - not perform a proper test.
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.xmark_circle,
                        color: CupertinoColors.destructiveRed,
                        size: 50,
                      ),
                      Text("Something went wrong"),
                      FilledButton(
                        onPressed: () {
                          if (!_controller.isLoadingRecProduct) {
                            _controller.fetchLatestProduct();
                          }
                        },
                        child: Text("Refresh"),
                      )
                    ],
                  ),
                );
              }

              final List<Item> products = _controller.products;
              return Expanded(
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: isLoading ? 5 : products.length,
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
                        final item = products.elementAt(index);
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
