import 'dart:async';
import 'dart:developer';

import 'package:carbon_tracker/models/question/questions_list.dart';
import 'package:carbon_tracker/providers/questions_map_provider.dart';
import 'package:carbon_tracker/services/utilities/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryDetailsPage extends StatefulWidget {
  String categoryName;
  final int totalQuestions;
  static String routeName = 'TrackDetailsRoute';

  CategoryDetailsPage({
    Key? key,
    required this.categoryName,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final TextEditingController _controller = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);
  int _pageViewIndex = 0;

  bool isKeyboardOpen = false;

  String action = "START";
  Timer? timer;
  int _selectedAmount = 5;

  void decrementSelectedAmount() {
    setState(() {
      _selectedAmount--;
      if (_selectedAmount <= 0) {
        _selectedAmount = 0;
      }

      _controller.text = _selectedAmount.toString();
    });
  }

  @override
  void initState() {
    _controller.text = _selectedAmount.toString();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: FutureBuilder(
          future: APIServices.fetchQuestions(widget.categoryName),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuestionsList questionsList = snapshot.data!;
              return PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: questionsList.questions!.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        widget.categoryName.toUpperCase(),
                        style: GoogleFonts.dmMono(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.teal[400],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                          child: Text(
                            questionsList.questions![index].question!,
                            style: GoogleFonts.poppins(
                              height: 1.2,
                              fontSize: (isKeyboardOpen) ? 20 : 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal[900],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextField(
                            onTap: () {
                              isKeyboardOpen = true;
                              setState(() {});
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _selectedAmount = 0;
                              } else {
                                _selectedAmount = int.parse(value);
                              }
                            },
                            textAlign: TextAlign.center,
                            controller: _controller,
                            style: GoogleFonts.poppins(
                              fontSize: 100,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal.shade900,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  decrementSelectedAmount();
                                }),
                                onLongPress: () => setState(() {
                                  timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
                                    setState(() {
                                      action = "Longpress started";
                                      decrementSelectedAmount();
                                    });
                                  });
                                }),
                                onLongPressEnd: (_) => setState(() {
                                  action = "LongPress stopped";
                                  timer?.cancel();
                                }),
                                child: Text(
                                  '-',
                                  style: GoogleFonts.dmMono(
                                    // height: -1,
                                    fontSize: 100,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAmount++;
                                    _controller.text = _selectedAmount.toString();
                                  });
                                },
                                onLongPress: () => setState(() {
                                  timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
                                    setState(() {
                                      action = "Longpress started";
                                      _selectedAmount++;
                                      _controller.text = _selectedAmount.toString();
                                    });
                                  });
                                }),
                                onLongPressEnd: (_) => setState(() {
                                  action = "LongPress stopped";
                                  timer?.cancel();
                                }),
                                child: Text(
                                  '+',
                                  style: GoogleFonts.dmMono(
                                    // height: -1,
                                    fontSize: 100,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: 2,
                        color: Colors.teal[700],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<QuestionsMapProvider>(
                            builder: (context, questionsMapProvider, child) => GestureDetector(
                              onTap: () {
                                // add to the map the corresponding question and answer
                                // _map.putIfAbsent(questionsList.questions![_pageViewIndex].id, () => _selectedAmount);
                                // _pageViewIndex++;
                                // if (_pageViewIndex == questionsList.questions!.length) {
                                //   Navigator.of(context).pop(_map);
                                // }
                                // print(_map);

                                questionsMapProvider.addQuestion(questionsList.questions![_pageViewIndex].id!.toString(), _selectedAmount.toString());
                                _pageViewIndex++;
                                if (_pageViewIndex == questionsList.questions!.length) {
                                  Navigator.of(context).pop();
                                }
                                // _pageViewIndex++;
                                log(questionsMapProvider.questionsMap.toString());

                                // _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                // _pageController.animateTo(offset, duration: duration, curve: curve)
                                // _pageController.nextPage(duration: duration, curve: curve)
                                _pageController.animateToPage(_pageViewIndex, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                              },
                              child: Text(
                                (_pageViewIndex <= questionsList.questions!.length - 2) ? 'NEXT' : 'DONE',
                                style: GoogleFonts.dmMono(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                },
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
