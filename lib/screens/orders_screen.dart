import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

class OrdersScreen extends StatefulWidget {

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() =>
      _OrdersScreenState();
}

class _OrdersScreenState
    extends State<OrdersScreen> {

  List<OrderModel> orders = [];

  final service =
  OrderService();

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {

    orders =
    await service.getOrders();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text("Orders"),
      ),

      body: orders.isEmpty
          ? const Center(
              child: Text(
                "No Orders Available",
              ),
            )
          : ListView.builder(
              itemCount: orders.length,

              itemBuilder: (context, index) {

                final order = orders[index];

                return Card(
                  child: ListTile(

                    title: Text(order.feedName),

                    subtitle: Text(
                      "${order.quantity} kg\n${order.status}",
                    ),

                    trailing: Text(
                      "KES ${order.total}",
                    ),
                  ),
                );
              },
            ),

      floatingActionButton:
      FloatingActionButton(

        onPressed: addOrder,

        child:
        const Icon(Icons.add),
      ),
    );
  }

  void addOrder() {

    final feed =
    TextEditingController();

    final quantity =
    TextEditingController();

    final supplier =
    TextEditingController();

    final total =
    TextEditingController();

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(

          title:
          const Text(
              "Place Order"),

          content:
          SingleChildScrollView(

            child: Column(
              children: [

                TextField(
                  controller: feed,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Feed Name",
                  ),
                ),

                TextField(
                  controller:
                  quantity,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Quantity",
                  ),
                ),

                TextField(
                  controller:
                  supplier,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Supplier",
                  ),
                ),

                TextField(
                  controller:
                  total,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Total Cost",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            ElevatedButton(

              onPressed:
                  () async {

                if (feed.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter feed name')),
                  );
                  return;
                }

                final q = int.tryParse(quantity.text);
                if (q == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter valid quantity')),
                  );
                  return;
                }

                final t = double.tryParse(total.text);
                if (t == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter valid total cost')),
                  );
                  return;
                }

                await service.insertOrder(
                  OrderModel(
                    feedName: feed.text,
                    quantity: q,
                    supplier: supplier.text,
                    total: t,
                    orderDate: DateTime.now().toString(),
                    status: "Pending",
                  ),
                );

                if (!mounted) return;

                Navigator.pop(context);

                loadOrders();
              },

              child:
              const Text(
                "Submit",
              ),
            )
          ],
        );
      },
    );
  }
}