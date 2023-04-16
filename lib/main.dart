import 'package:carbon_tracker/constants/app_theme.dart';
import 'package:carbon_tracker/models/user.dart';
import 'package:carbon_tracker/providers/questions_map_provider.dart';
import 'package:carbon_tracker/view/screens/home_screen.dart';
import 'package:carbon_tracker/view/screens/login_screen.dart';
import 'package:carbon_tracker/view/screens/category_details.dart';
import 'package:carbon_tracker/view/screens/register_screen.dart';
import 'package:carbon_tracker/view/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/result_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuestionsMapProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ResultProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Green Guild',
        theme: ThemeData(scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor, useMaterial3: true),
        initialRoute: LoginPage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          CategoryDetailsPage.routeName: (context) => CategoryDetailsPage(categoryName: 'Commute', totalQuestions: 5),
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          ResultsPage.routeName: (context) => ResultsPage(commuteFootprint: 1, foodFootprint: 1, householdFootprint: 1, scores: Scores(commuteScore: 1, foodScore: 1, householdScore: 1)),
        },
      ),
    );
  }
}
