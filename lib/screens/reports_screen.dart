import 'package:flutter/material.dart';
import 'inventory_report.dart';
import 'order_report.dart';

class ReportsScreen
    extends StatelessWidget {

  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Reports"),
      ),

      body: ListView(

        children: [

          ListTile(
            leading:
                const Icon(Icons.inventory),

            title:
                const Text(
                    "Inventory Report"),

            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const InventoryReport(),
                ),
              );
            },
          ),

          ListTile(
            leading:
                const Icon(
                    Icons.shopping_cart),

            title:
                const Text(
                    "Order Report"),

            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const OrderReport(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}