import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_clinet/API/authentication.dart';
import 'package:qutub_clinet/FCM/fcmConfig.dart';
import 'package:qutub_clinet/Providers/userProvider.dart';
import 'package:qutub_clinet/ui/Login/login.dart';
import 'package:qutub_clinet/ui/widgets/snackBarAndDialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Home/home.dart';
import 'colors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
     //   _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
       // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
    //    _navigateToItemDetail(message);
      },
    );
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 4), onDoneLoading);
  }

  onDoneLoading() async {
    setState(() {
      loginStatus = true;
    });
    await checkUserLoggedIn().then((value) {
      if (value == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => Login()));
      } else {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(value);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => MainHome()));
      }
    }).catchError((e) {
      setState(() {
        loginStatus = false;
      });
      showSnackbarError(
          msg: 'حدث خطأ في الأتصال.حاول مرة اخرى', scaffoldKey: splashKey);
    });
  }

  var splashKey = GlobalKey<ScaffoldState>();
  var loginStatus;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: splashKey,
      backgroundColor: MyColor.customColor,
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            scale: 8,
          ),
          SizedBox(
            height: 30,
          ),
          (loginStatus == true)
              ? CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(MyColor.whiteColor),
                )
              : (loginStatus == false)
                  ? InkWell(
                      onTap: () {
                        onDoneLoading();
                      },
                      child: Icon(
                        Icons.refresh,
                        color: MyColor.whiteColor,
                        size: 25,
                      ),
                    )
                  : Container()
        ],
      )),
    );
  }
}
