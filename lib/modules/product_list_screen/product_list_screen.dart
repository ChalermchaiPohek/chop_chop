import 'package:chop_chop/modules/product_list_screen/product_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductListController _controller = Get.put(ProductListController());

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
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Text("Recommend Products"),
        Obx(() {
          _controller.isLoading;
          _controller.productList.value;
          return Text("Test");
        },),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const SizedBox(),
                title: Skeletonizer(child: Text('Item ${index + 1}')),
                subtitle: Skeletonizer(child: Text('Subtitle for item ${index + 1}')),
                trailing: FilledButton(
                    onPressed: () {
                      /// TODO: add logic to change to + & -
                    },
                    child: Text("Add to cart"),
                ),
                onTap: null,
              );
            },
          ),
        ),
        Text("Latest Products"),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Item ${index + 1}'),
                subtitle: Text('Subtitle for item ${index + 1}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
