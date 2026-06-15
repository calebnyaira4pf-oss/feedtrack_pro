import 'package:flutter/material.dart';

import '../models/feed_model.dart';
import '../services/alert_service.dart';

class AlertsScreen
    extends StatefulWidget {

  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() =>
      _AlertsScreenState();
}

class _AlertsScreenState
    extends State<AlertsScreen> {

  List<FeedModel> alerts = [];

  @override
  void initState() {
    super.initState();
    loadAlerts();
  }

  Future<void> loadAlerts() async {

    alerts = await AlertService()
        .getLowStockFeeds();

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Low Stock Alerts"),
      ),
      body: alerts.isEmpty
          ? const Center(
              child: Text("No Low Stock Alerts"),
            )
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final feed = alerts[index];

                return Card(
                  color: Colors.red.shade100,
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    title: Text(feed.name),
                    subtitle: Text("Remaining: ${feed.quantity} kg"),
                  ),
                );
              },
            ),
    );
  }
}