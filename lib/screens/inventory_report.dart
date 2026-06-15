import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InventoryReport
    extends StatelessWidget {

  const InventoryReport(
      {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
                "Inventory Analytics"),
      ),

      body: PieChart(

        PieChartData(

          sections: [

            PieChartSectionData(
              value: 40,
              title: "Dairy",
            ),

            PieChartSectionData(
              value: 30,
              title: "Poultry",
            ),

            PieChartSectionData(
              value: 30,
              title: "Pig",
            ),
          ],
        ),
      ),
    );
  }
}