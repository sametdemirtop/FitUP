import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_up/Pages/LandingPage.dart';
import 'package:flutter/material.dart';

import 'RegisterPage1.dart';
import 'RegisterPage2.dart';

class RegisterPage3 extends StatefulWidget {
  final String userID;
  RegisterPage3({required this.userID});

  @override
  _RegisterPage3State createState() => _RegisterPage3State(userID: userID);
}

class _RegisterPage3State extends State<RegisterPage3> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String? userID;

  _RegisterPage3State({this.userID});

  createName() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      kullaniciRef.doc(userID).update({
        "profileName": name,
      }).then((value) => {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterPage2(userID: userID!))),
          });
    } else {
      SnackBar snackbar = SnackBar(content: Text("It did not validate."));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                DocumentSnapshot ds = await kullaniciRef.doc(userID).get();
                if (ds.exists) {
                  ds.reference.delete().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LandingPage()));
                  });
                }
              }),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            image: AssetImage('assets/images/new.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(0.8),
              ),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Your Name ?",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            name = text;
                          });
                        },
                        validator: (val) {
                          if (val!.trim().length <= 3 || val.isEmpty) {
                            return "Enter 3 char or more than 3 char ";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.deepOrange, width: 6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Text('Name: $name'),
            TextButton(
              onPressed: createName,
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
            )
          ],
        ),
      ),
    );
  }
}
