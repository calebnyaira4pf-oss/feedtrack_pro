import 'package:flutter/material.dart';

import '../services/analytics_service.dart';
import 'inventory_screen.dart';
import 'orders_screen.dart';
import 'reports_screen.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int currentIndex = 0;

  final screens = [
    const DashboardHome(),
    const InventoryScreen(),
    const OrdersScreen(),
    const ReportsScreen(),
    const AlertsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "Inventory",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Orders",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}
class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final analytics = AnalyticsService();

  double inventoryValue = 0;
  int feedCount = 0;
  int pendingOrders = 0;
  double monthlySpend = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future loadDashboard() async {
    inventoryValue = await analytics.getInventoryValue();
    feedCount = await analytics.getFeedCount();
    pendingOrders = await analytics.getPendingOrders();
    monthlySpend = await analytics.getMonthlySpend();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "FeedTrack Pro",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text("Welcome Farmer"),
                subtitle:
                    const Text("Manage your feed inventory efficiently"),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: buildCard(
                    "Inventory Value",
                    "KES ${inventoryValue.toStringAsFixed(0)}",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildCard(
                    "Feed Types",
                    "$feedCount",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: buildCard(
                    "Pending Orders",
                    "$pendingOrders",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildCard(
                    "Monthly Spend",
                    "KES ${monthlySpend.toStringAsFixed(0)}",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.red.shade100,
              child: const ListTile(
                leading: Icon(Icons.warning),
                title: Text(
                  "Dairy Meal stock low",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard(
    String title,
    String value,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}