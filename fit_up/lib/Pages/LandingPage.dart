import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_up/models/Kullanici.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import 'Home.dart';
import 'RegisterPage1.dart';
import 'RegisterPage2.dart';
import 'RegisterPage3.dart';

final GoogleSignIn? googlegiris = GoogleSignIn();
final FacebookLogin fb = FacebookLogin();

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String id = Uuid().v4();
  @override
  void initState() {
    super.initState();
    googlegiris!.onCurrentUserChanged.listen((googleHesap) {
      setState(() {
        kullaniciKontrol(googleHesap!);
      });
    }, onError: (gHata) {
      print("Hata Mesaj: " + gHata.toString());
    });

    googlegiris!.isSignedIn().then((isSignedIn) async {
      if (isSignedIn == true) {
        googlegiris!.signInSilently(suppressErrors: false).then((googleHesap2) {
          setState(() {
            kullaniciKontrol(googleHesap2!);
          });
        }).catchError((gHata) {
          print("Hata Mesaj 2: " + gHata.toString());
        });
      }
    });
  }

  Future<User?> _logInWithFacebook() async {
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in
        // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;
        print('Access token: ${accessToken!.token}');
        final facebookAuthWithCredential =
            FacebookAuthProvider.credential(accessToken.token);
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthWithCredential);

        // Get profile data
        final profile = await fb.getUserProfile();
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');
        print('Hello, ${profile!.name}! You ID: ${profile.userId}');
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await kullaniciRef
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
        if (!documentSnapshot.exists) {
          kullaniciRef.doc(FirebaseAuth.instance.currentUser!.uid).set({
            "id": FirebaseAuth.instance.currentUser!.uid,
            "profileName": profile.name,
            "email": email,
            "timestamp": timestamp,
            "gender": "",
            "age": "",
            "length": "",
            "weight": "",
            "fromWhere": "facebook",
          }).then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterPage2(
                        userID: FirebaseAuth.instance.currentUser!.uid)));
          });
          documentSnapshot = await kullaniciRef
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Home(kullanici: FirebaseAuth.instance.currentUser!.uid)));
        }
        anlikKullanici = Kullanici.fromDocument(documentSnapshot);
        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  withOutSignIn() {
    kullaniciRef.doc(id).set({
      "id": id,
      "profileName": "",
      "email": id,
      "timestamp": timestamp,
      "gender": "",
      "age": "",
      "length": "",
      "weight": "",
      "fromWhere": "withoutsigningup",
    }).then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegisterPage3(userID: id)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gym.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 185.0,
              width: 185.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/gym3.jpeg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: Text(
                "CREATE AN ACCOUNT TO",
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        offset: Offset(15, 15),
                        blurRadius: 15),
                  ],
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            Center(
              child: Text(
                "START",
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        offset: Offset(15, 15),
                        blurRadius: 15),
                  ],
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SignInButton(
                Buttons.Email,
                elevation: 5,
                text: "Sign up with Mail",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterPage1(
                                isToogle: true,
                              )));
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SignInButton(
                Buttons.Google,
                elevation: 5,
                text: "Sign up with Google",
                onPressed: () {
                  kullaniciGiris();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SignInButton(
                Buttons.FacebookNew,
                text: "Sign up with Facebook",
                elevation: 5,
                onPressed: () async {
                  _logInWithFacebook();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: Center(
                  child: Text(
                "OR",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
            ),
            GestureDetector(
              onTap: () {
                withOutSignIn();
              },
              child: Text(
                "Continue without signing up",
                style: TextStyle(
                    color: Colors.white, decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      ),
    );
  }

  kullaniciGiris() {
    setState(() {
      googlegiris!.signIn();
    });
  }

  kullaniciKontrol(GoogleSignInAccount? girisHesap) async {
    if (girisHesap != null) {
      DocumentSnapshot ds = await kullaniciRef.doc(girisHesap.id).get();
      if (ds.exists) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      kullanici: girisHesap.id,
                    )));
      } else {
        return await kullaniciFireStoreKayit();
      }
    }
  }

  kullaniciFireStoreKayit() async {
    final GoogleSignInAccount? gAnlikKullanici = googlegiris!.currentUser;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await kullaniciRef.doc(gAnlikKullanici!.id).get();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await gAnlikKullanici.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (!documentSnapshot.exists) {
      kullaniciRef.doc(gAnlikKullanici.id).set({
        "id": gAnlikKullanici.id,
        "profileName": gAnlikKullanici.displayName,
        "email": gAnlikKullanici.email,
        "timestamp": timestamp,
        "gender": "",
        "age": "",
        "length": "",
        "weight": "",
        "fromWhere": "google",
      }).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RegisterPage2(userID: gAnlikKullanici.id)));
      });

      documentSnapshot = await kullaniciRef.doc(anlikKullanici!.id).get();
    }
    anlikKullanici = Kullanici.fromDocument(documentSnapshot);
  }
}
