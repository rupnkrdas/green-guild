import 'dart:convert';
import 'dart:developer';

import 'package:carbon_tracker/constants/app_theme.dart';
import 'package:carbon_tracker/constants/app_urls.dart';
import 'package:carbon_tracker/models/user.dart';
import 'package:carbon_tracker/view/screens/login_screen.dart';
import 'package:carbon_tracker/view/screens/widgets/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'home_screen.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = 'registerPageRoute';

  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    ' Green Guild',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 60,
                      color: Colors.teal,
                    ),
                  ),

                  Text(
                    'Track your carbon footprint, \nand take action for a sustainable future!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  // username textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: LoginTextField(
                      textFieldController: _usernameController,
                      hintText: ' Username',
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // email text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: LoginTextField(
                      textFieldController: _emailController,
                      hintText: ' Email',
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // password text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: LoginTextField(
                      textFieldController: _passwordController,
                      hintText: ' Password',
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  const SizedBox(height: 25),

                  // register button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(AppURL.registerURL);
                        final response = await http.post(url, body: {
                          'username': _usernameController.text,
                          'password': _passwordController.text,
                          'email': _emailController.text,
                        });

                        var data = jsonDecode(response.body);

                        if (data['status_code'] == 202) {
                          log('Login Successful');
                          print(data);
                          userProvider.setAllValues(
                            username: data['username'],
                            carbonCount: 0,
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
                        } else {
                          log('Registration Failed');
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Registration Failed'),
                              content: Text('Username already exists!'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RegisterPage()), (route) => false);
                                  },
                                  child: Text('Try Again'),
                                )
                              ],
                            ),
                          );
                        }

                        // log(response.body);
                        // final responseData = json.decode(response.body);
                        // Do something with the response data, such as checking if the authentication was successful.
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.buttonBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
                        },
                        child: Text(
                          'Login now',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
