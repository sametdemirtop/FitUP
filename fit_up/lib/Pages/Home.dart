import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_up/Pages/LandingPage.dart';
import 'package:fit_up/Pages/RegisterPage1.dart';
import 'package:fit_up/Pages/progress.dart';
import 'package:fit_up/models/Kullanici.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String? kullanici;

  Home({this.kullanici});

  @override
  _HomeState createState() => _HomeState(kullanici: kullanici);
}

class _HomeState extends State<Home> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? kullanici;

  _HomeState({this.kullanici});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 250.0,
                width: 250.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo3.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 500,
                  width: MediaQuery.of(context).size.width - 25,
                  child: FutureBuilder<DocumentSnapshot>(
                      future: kullaniciRef.doc(kullanici).get(),
                      builder: (context, ds) {
                        if (!ds.hasData) {
                          return circularProgress();
                        } else {
                          Kullanici account = Kullanici.fromDocument(ds.data!);
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black87, BlendMode.darken),
                                  image:
                                      AssetImage('assets/images/dumbell2.jpg'),
                                  fit: BoxFit.cover,
                                )),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: account.fromWhere == "mail"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              child: Image.network(
                                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Gmail_icon_%282020%29.svg/1024px-Gmail_icon_%282020%29.svg.png'),
                                              height: 75,
                                              width: 75,
                                            ),
                                          )
                                        : account.fromWhere == "facebook"
                                            ? Icon(
                                                Icons.facebook,
                                                size: 70,
                                                color: Colors.blueAccent,
                                              )
                                            : account.fromWhere == "google"
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                      child: Image.network(
                                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png'),
                                                      height: 75,
                                                      width: 75,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Icon(
                                                      Icons.person_pin,
                                                      size: 70,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        "from" +
                                            " " +
                                            account.fromWhere!.toUpperCase(),
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                      child: Column(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          account.profileName!.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(account.email!,
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              account.gender == "Male"
                                                  ? Icon(
                                                      Icons.male,
                                                      color: Colors.white,
                                                      size: 40,
                                                    )
                                                  : Icon(Icons.female,
                                                      color: Colors.white),
                                              Text(" : ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(account.gender!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.date_range,
                                                  color: Colors.white),
                                              Text(" : ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(account.age.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.height,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                              Text(": ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  account.length.toString() +
                                                      " cm ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.monitor_weight,
                                                  color: Colors.white),
                                              Text(" : ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  account.weight.toString() +
                                                      " kg ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 30, top: 50),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: kullaniciRef.doc(kullanici).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return circularProgress();
                        } else {
                          return TextButton(
                            onPressed: () async {
                              if (snapshot.data!.get("fromWhere") == "google") {
                                await googlegiris!.signOut();
                                setState(() {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LandingPage()));
                                });
                              } else if (snapshot.data!.get("fromWhere") ==
                                  "withoutsigningup") {
                                if (snapshot.data!.exists) {
                                  await snapshot.requireData.reference
                                      .delete()
                                      .then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LandingPage()));
                                  });
                                }
                              } else {
                                await _firebaseAuth.signOut().then((value) {
                                  setState(() {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LandingPage()));
                                  });
                                });
                              }
                            },
                            child: Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.indigoAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign out",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
