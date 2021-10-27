import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_up/Pages/LandingPage.dart';
import 'package:fit_up/models/Kullanici.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Home.dart';
import 'RegisterPage3.dart';
import 'ResetPassword.dart';

final kullaniciRef = FirebaseFirestore.instance.collection("Kullanicilar");
final FirebaseAuth _auth = FirebaseAuth.instance;
final DateTime timestamp = DateTime.now();

Kullanici? anlikKullanici;

class RegisterPage1 extends StatefulWidget {
  final bool isToogle;
  RegisterPage1({required this.isToogle});
  final _RegisterPage1State child = _RegisterPage1State(isToogle: false);
  @override
  _RegisterPage1State createState() {
    _RegisterPage1State(
      isToogle: this.isToogle,
    );
    return child;
  }
}

class _RegisterPage1State extends State<RegisterPage1> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();
  List<bool>? isSelected;
  final formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> _initFirebaseSdk = Firebase.initializeApp();
  bool isToogle = false;
  bool obscure = true;

  bool kullaniciOnline = false;

  _RegisterPage1State({
    required this.isToogle,
  });

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    isSelected = [false, true];
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage()));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 100),
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
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigoAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ToggleButtons(
                    color: Colors.white,
                    borderColor: Colors.blue[200],
                    fillColor: Colors.white,
                    selectedBorderColor: Colors.blue[200],
                    borderWidth: 3,
                    renderBorder: false,
                    selectedColor: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, right: 60),
                        child: Text(
                          "Sign up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, right: 60),
                        child: Text(
                          "Sign in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        toggleScreen();
                        for (int i = 0; i < isSelected!.length; i++) {
                          isSelected![i] = i == index;
                        }
                      });
                    },
                    isSelected: isSelected!,
                  ),
                ),
              ),
              kayitEkrani(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding Register() {
    return Padding(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Create account to continue",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "E-mail",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : "Please enter a mail address",
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepOrange.shade200, width: 6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Create Password",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (val) =>
                          val!.length < 6 ? "Enter more than 6 char " : null,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (obscure == true) {
                                  setState(() {
                                    obscure = false;
                                  });
                                } else {
                                  setState(() {
                                    obscure = true;
                                  });
                                }
                              });
                            },
                            icon: obscure == true
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Re-write Password",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _rePasswordController,
                      validator: (val) =>
                          val!.length < 6 ? "Enter more than 6 char " : null,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (obscure == true) {
                                  setState(() {
                                    obscure = false;
                                  });
                                } else {
                                  setState(() {
                                    obscure = true;
                                  });
                                }
                              });
                            },
                            icon: obscure == true
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                privacyPolicyLinkAndTermsOfService(),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      debugPrint("Email= " + _emailController.text);
                      debugPrint("pass= " + _passwordController.text);
                      createPerson(
                        _emailController.text,
                        _passwordController.text,
                      ).then((value) {
                        setState(() {
                          isToogle = false;
                        });
                      });
                    }
                  },
                  child: Container(
                    width: 400,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
          child: Column(
        children: [
          Text(
            'By continuing, you agree to our ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = termsOfServices),
                TextSpan(
                    text: ' and ',
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = privacyPolicy),
                    ])
              ],
            ),
          ),
        ],
      )),
    );
  }

  termsOfServices() async {
    final url =
        'https://www.google.com/intl/en_ZZ/policies/terms/archive/20070416/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  privacyPolicy() async {
    final url =
        'https://www.freeprivacypolicy.com/live/21f92ffd-a356-419b-9d7a-233af32b533a';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<User?> createPerson(String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await kullaniciRef.doc(user.user!.uid).get();
    if (!documentSnapshot.exists) {
      kullaniciRef.doc(user.user!.uid).set({
        "id": user.user!.uid,
        "profileName": "",
        "email": user.user!.email,
        "timestamp": timestamp,
        "gender": "",
        "age": "",
        "length": "",
        "weight": "",
        "fromWhere": "mail",
      }).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterPage3(userID: user.user!.uid)));
      });
      documentSnapshot = await kullaniciRef.doc(user.user!.uid).get();
    }
    anlikKullanici = Kullanici.fromDocument(documentSnapshot);

    return user.user;
  }

  Padding Login() {
    return Padding(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 15, left: 15, bottom: 15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Sign in to continue",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "E-mail",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : "Please enter a mail address",
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (val) =>
                          val!.length < 6 ? "Enter more than 6 char " : null,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (obscure == true) {
                                  setState(() {
                                    obscure = false;
                                  });
                                } else {
                                  setState(() {
                                    obscure = true;
                                  });
                                }
                              });
                            },
                            icon: obscure == true
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      debugPrint("Email= " + _emailController.text);
                      debugPrint("pass= " + _passwordController.text);
                      signIn(_emailController.text, _passwordController.text)
                          .then((value) async {
                        setState(() {
                          SnackBar snackbar = SnackBar(
                              content: Text(
                                  "Welcome ${anlikKullanici!.profileName}"));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          Timer(Duration(seconds: 3), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          kullanici: anlikKullanici!.id,
                                        )));
                          });
                        });
                      });
                    }
                  },
                  child: Container(
                    width: 400,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding toggle() {
    if (isToogle) {
      return Register();
    } else {
      return Login();
    }
  }

  Container kayitEkrani() {
    return Container(
      color: Colors.white,
      child: toggle(),
    );
  }

  void toggleScreen() {
    setState(() {
      isToogle = !isToogle;
    });
  }

  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await kullaniciRef.doc(user.user!.uid).get();
    if (!documentSnapshot.exists) {
      documentSnapshot = await kullaniciRef.doc(user.user!.uid).get();
    }
    anlikKullanici = Kullanici.fromDocument(documentSnapshot);
    return user.user;
  }

  signOut() async {
    return await _auth.signOut();
  }
}
