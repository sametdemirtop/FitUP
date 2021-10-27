import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_up/Pages/RegisterPage1.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'Home.dart';

class RegisterPage2 extends StatefulWidget {
  final String userID;
  RegisterPage2({required this.userID});

  @override
  _RegisterPage2State createState() => _RegisterPage2State(userID: userID);
}

class _RegisterPage2State extends State<RegisterPage2> {
  int? activeIndex = 0;
  int _currentAge = 0;
  int _currentLength = 100;
  int _currentWeigth = 30;
  String gender = "";
  PageController pageController = PageController(initialPage: 0);
  bool isFemale = false;
  bool isMale = false;
  String? userID;

  _RegisterPage2State({this.userID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            padding: EdgeInsets.only(top: 15),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () async {
              if (pageController.page!.toInt() != 0) {
                pageController.animateToPage(
                  pageController.page!.toInt() - 1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                DocumentSnapshot ds = await kullaniciRef.doc(userID).get();
                if (ds.exists) {
                  ds.reference.delete();
                }
                Navigator.pop(context);
              }
            },
          ),
          title: Padding(
            padding: EdgeInsets.only(
              left: 75,
              top: 20,
            ),
            child: Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo3.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            activeIndex = index;
          });
        },
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                image: AssetImage('assets/images/dumbell.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What is your Gender ?",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMale = true;
                            isFemale = false;
                            gender = "Male";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          height: 160,
                          width: 160,
                          child: Icon(
                            Icons.male,
                            size: 60,
                            color: isMale == true ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFemale = true;
                            isMale = false;
                            gender = "Female";
                          });
                        },
                        child: Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.female,
                            size: 60,
                            color: isFemale == true ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                image: AssetImage('assets/images/dumbell.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "What is your Age ?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                NumberPicker(
                  value: _currentAge,
                  itemWidth: 350,
                  haptics: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 25),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 2.0,
                        color: Colors.white70,
                      ),
                      bottom: BorderSide(width: 2.0, color: Colors.white70),
                    ),
                  ),
                  selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                  minValue: 0,
                  maxValue: 100,
                  onChanged: (value) => setState(() => _currentAge = value),
                ),
                Text('Age: ${_currentAge.toString()}'),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                image: AssetImage('assets/images/dumbell.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "How much is your Length?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                NumberPicker(
                  selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                  value: _currentLength,
                  itemWidth: 350,
                  textStyle: TextStyle(color: Colors.white, fontSize: 25),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 2.0,
                        color: Colors.white70,
                      ),
                      bottom: BorderSide(width: 2.0, color: Colors.white70),
                    ),
                  ),
                  minValue: 0,
                  maxValue: 300,
                  onChanged: (value) => setState(() => _currentLength = value),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                image: AssetImage('assets/images/dumbell.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "How much is your Weight?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                NumberPicker(
                  selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                  value: _currentWeigth,
                  itemWidth: 350,
                  haptics: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 25),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 2.0,
                        color: Colors.white70,
                      ),
                      bottom: BorderSide(width: 2.0, color: Colors.white70),
                    ),
                  ),
                  minValue: 0,
                  maxValue: 300,
                  onChanged: (value) => setState(() => _currentWeigth = value),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 125,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                pageController.animateToPage(
                  pageController.page!.toInt() + 1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
                if (pageController.page!.toInt() == 3) {
                  if (_currentAge == 0 &&
                      _currentLength == 100 &&
                      _currentWeigth == 30 &&
                      gender == "") {
                    SnackBar snackbar = SnackBar(
                        content: Text(
                            "You cannot leave personal information blank."));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else {
                    kullaniciRef.doc(userID).update({
                      "age": _currentAge,
                      "length": _currentLength,
                      "weight": _currentWeigth,
                      "gender": gender,
                    }).then((value) => {
                          kullaniciRef.doc(userID).get().then((value) {
                            if (value.get("fromWhere") == "signup") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage1(
                                            isToogle: true,
                                          )));
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home(kullanici: userID)));
                            }
                          }),
                        });
                  }
                }
              },
              child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            buildSmooth()
          ],
        ),
      ),
    );
  }

  Widget buildSmooth() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex!,
      count: 4,
      effect: JumpingDotEffect(
          dotWidth: 7,
          dotHeight: 7,
          activeDotColor: Colors.indigoAccent,
          dotColor: Colors.grey),
    );
  }
}
