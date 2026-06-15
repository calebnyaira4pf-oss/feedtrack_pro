import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrderReport
    extends StatelessWidget {

  const OrderReport(
      {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
                "Order Analytics"),
      ),

      body: BarChart(

        BarChartData(

          barGroups: [

            BarChartGroupData(
              x: 1,

              barRods: [
                BarChartRodData(
                  toY: 20,
                )
              ],
            ),

            BarChartGroupData(
              x: 2,

              barRods: [
                BarChartRodData(
                  toY: 30,
                )
              ],
            ),

            BarChartGroupData(
              x: 3,

              barRods: [
                BarChartRodData(
                  toY: 15,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}