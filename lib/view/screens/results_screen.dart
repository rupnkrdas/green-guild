// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:carbon_tracker/models/result_provider.dart';
import 'package:carbon_tracker/view/screens/home_screen.dart';

import '../../services/utilities/API_services.dart';

class ResultsPage extends StatefulWidget {
  static String routeName = 'ResultsPageRoute';
  final double commuteFootprint;
  final double householdFootprint;
  final double foodFootprint;
  final Scores scores;
  const ResultsPage({
    Key? key,
    required this.commuteFootprint,
    required this.householdFootprint,
    required this.foodFootprint,
    required this.scores,
  }) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(category: 'Commute Footprint', carbonFootprint: widget.commuteFootprint, color: Colors.teal.shade300),
      ChartData(category: 'Household Footprint', carbonFootprint: widget.householdFootprint, color: Colors.teal.shade500),
      ChartData(category: 'Food Footprint', carbonFootprint: widget.foodFootprint, color: Colors.teal.shade700),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0).copyWith(top: MediaQuery.of(context).viewPadding.top),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Carbon Footprint',
              style: GoogleFonts.poppins(
                fontSize: 40,
                height: 1,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade700,
              ),
            ),

            // pie chart
            SfCircularChart(
              legend: Legend(
                isResponsive: true,
                isVisible: true,
                position: LegendPosition.auto,
                orientation: LegendItemOrientation.horizontal,
                overflowMode: LegendItemOverflowMode.wrap,
                textStyle: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              tooltipBehavior: _tooltipBehavior,
              series: <CircularSeries>[
                // Render pie chart
                DoughnutSeries<ChartData, String>(
                  radius: '80',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.carbonFootprint,
                  pointColorMapper: (caseType, index) => caseType.color,
                  explode: true,
                  // explodeOffset: '5%',
                  strokeColor: Colors.white,
                  // strokeWidth: 5,
                  enableTooltip: true,
                  dataLabelSettings: const DataLabelSettings(
                    color: Colors.white,
                    opacity: 0.8,
                    alignment: ChartAlignment.center,
                    isVisible: true,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),

            // result cards
            Expanded(
              child: ListView(children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ResultsCard(title: 'Commute sustainability score', subtitle: widget.scores.commuteScore.toString()),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ResultsCard(title: 'Household sustainability score', subtitle: widget.scores.householdScore.toString()),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ResultsCard(title: 'Food sustainability score', subtitle: widget.scores.foodScore.toString()),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ResultsCard(title: 'Total sustainability score', subtitle: widget.scores.totalScore.toString()),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const ResultsCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String category;
  final double carbonFootprint;
  final Color color;

  ChartData({
    required this.category,
    required this.carbonFootprint,
    required this.color,
  });
}
