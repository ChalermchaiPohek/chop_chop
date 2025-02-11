import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Slidable(
                key: ValueKey(index),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (ctx) {},
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('Subtitle for item ${index + 1}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  // onTap: () {},
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Theme.of(context).primaryColorDark,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text("Subtotal")),
                    Text("1,234.55"),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text("Promotion discount")),
                    Text("-999.99", style: TextStyle(color: Colors.red),),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text("1,212.3")),
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
}
