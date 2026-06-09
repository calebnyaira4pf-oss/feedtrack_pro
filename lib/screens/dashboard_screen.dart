import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),

        children: const [

          Card(
            child: Center(
              child: Text("Inventory"),
            ),
          ),

          Card(
            child: Center(
              child: Text("Orders"),
            ),
          ),

          Card(
            child: Center(
              child: Text("Reports"),
            ),
          ),

          Card(
            child: Center(
              child: Text("Profile"),
            ),
          ),
        ],
      ),
    );
  }
}