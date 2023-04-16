import 'dart:convert';
import 'dart:developer';

import 'package:carbon_tracker/constants/app_theme.dart';
import 'package:carbon_tracker/constants/app_urls.dart';
import 'package:carbon_tracker/view/screens/home_screen.dart';
import 'package:carbon_tracker/view/screens/register_screen.dart';
import 'package:carbon_tracker/view/screens/widgets/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/user.dart';

class LoginPage extends StatefulWidget {
  static String routeName = 'loginPageRoute';

  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // // Returns true if email address is in use.
  // Future<bool> checkIfEmailInUse(String emailAddress) async {
  //   try {
  //     // Fetch sign-in methods for the email address
  //     final list =
  //         await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

  //     // In case list is not empty
  //     if (list.isNotEmpty) {
  //       // Return true because there is an existing
  //       // user using the email address
  //       return true;
  //     } else {
  //       // Return false because email adress is not in use
  //       return false;
  //     }
  //   } catch (error) {
  //     // Handle error
  //     // ...
  //     return true;
  //   }
  // }

  // Future signIn() async {
  //   HapticFeedback.heavyImpact();

  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim());
  //   } on FirebaseAuthException catch (e) {
  //     showDialog(
  //         context: context,
  //         builder: ((context) {
  //           return AlertDialog(
  //             backgroundColor: Colors.grey[800],
  //             content: Text(
  //               // 'This email is not yet registered, Kindly Register first!',
  //               e.message.toString(),
  //               style: TextStyle(color: Colors.grey.shade200),
  //               textAlign: TextAlign.center,
  //             ),
  //           );
  //         }));
  //   }
  // }

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
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,

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
                    'Stay on track with your\ncarbon neutral journey!',
                    style: TextStyle(
                      fontSize: 20,
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

                  // sign-in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(AppURL.checkAuthURL);
                        final response = await http.post(url, body: {
                          'username': _usernameController.text,
                          'password': _passwordController.text,
                        });
                        // log(response.body);

                        var data = jsonDecode(response.body);
                        userProvider.setAllValues(username: data['username'], carbonCount: data['carbon_count']);

                        if (data['status_code'] == 202) {
                          log('Login Successful');
                          Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
                        } else {
                          log(data);
                          log('Login Failed');
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Authentication Failed'),
                              content: Text('User not found!'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RegisterPage()), (route) => false);
                                    },
                                    child: Text('Register'))
                              ],
                            ),
                          );
                        }
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
                            'Sign In',
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

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            RegisterPage.routeName,
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Register now',
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
