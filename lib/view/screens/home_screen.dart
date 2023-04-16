import 'dart:convert';
import 'dart:developer';

import 'package:carbon_tracker/view/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:carbon_tracker/constants/app_theme.dart';
import 'package:carbon_tracker/constants/app_urls.dart';
import 'package:carbon_tracker/models/user.dart';
import 'package:carbon_tracker/services/utilities/api_services.dart';
import 'package:carbon_tracker/view/screens/category_details.dart';

import '../../models/result_provider.dart';
import '../../providers/questions_map_provider.dart';

class HomePage extends StatefulWidget {
  static String routeName = 'HomeScreenRoute';
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsMapProvider>(
      builder: (context, questionsMapProvider, child) => Scaffold(
        body: FutureBuilder(
          future: APIServices.fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List categoriesList = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),

                  // Welcome card
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) => WelcomeCard(
                      userName: userProvider.username!,
                      carbonCount: userProvider.carbonCount!,
                    ),
                  ),

                  // track cards
                  Expanded(
                    child: ListView.builder(
                      itemCount: categoriesList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                        child: CategoryCard(
                          title: categoriesList[index],
                          subtitle: (categoriesList[index] == 'Commute')
                              ? 'Carbon footprint from transportation'
                              : (categoriesList[index] == 'Household')
                                  ? 'Carbon footprint from household energy use and waste management'
                                  : 'Carbon footprint from food consumption',
                        ),
                      ),
                    ),
                  ),

                  // submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Consumer2<UserProvider, ResultProvider>(
                      builder: (context, userProvider, result, child) => InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () async {
                          var jsonData = jsonEncode(questionsMapProvider.questionsMap);
                          // log(jsonData);

                          final url = Uri.parse("${AppURL.baseURL}/submit");
                          final response = await http.post(url, body: {'jsondata': jsonData, 'username': userProvider.username});
                          log(response.body);

                          var data = response.body;
                          // log(data);
                          Map<String, dynamic> parsedData = json.decode(data);

                          result = ResultProvider.fromJson(parsedData);
                          log(result.totalCarbonCount.toString());
                          log(result.categories!.commute.toString());

                          if (result.scores!.totalScore! > 32) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text("Your sustainability score is above average,\nplease take action to reduce your environmental impact."),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text("Your sustainability score is below average,\nkeep up the good work."),
                              ),
                            );
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResultsPage(
                                commuteFootprint: result.categories!.commute!,
                                householdFootprint: result.categories!.household!,
                                foodFootprint: result.categories!.food!,
                                scores: result.scores!,
                              ),
                            ),
                          );
                        },
                        child: Ink(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.buttonBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'SUBMIT',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryDetailsPage(categoryName: title, totalQuestions: 5),
        ));
      },
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.teal.shade900,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  final String userName;
  double carbonCount;
  WelcomeCard({
    Key? key,
    required this.userName,
    required this.carbonCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, user, child) => Container(
        decoration: BoxDecoration(
          color: Color(0xFFF0EBEB),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 50),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        width: double.maxFinite,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hi, $userName',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You\'re doing well!',
                style: GoogleFonts.poppins(
                  height: 0.8,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/circular-avatar.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$carbonCount kg ',
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'CO2eq',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'in the last 7 days',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
