import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/main.dart';
import 'package:ishtri_db/screens/Welcome.dart';
import 'package:ishtri_db/screens/auth/WelcomeSignup.dart';
import 'package:ishtri_db/services/Constent.dart';
import 'package:flutter/material.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

const String API_TOKEN_KEY = 'api_token';
const String USER_LOGIN_KEY = 'user_login_det';
const String IS_NEW_USER_FLAG = 'is_new_user';
dynamic subscription;
BuildContext? _context;
//show loader by context
void showLoader(context) {
  MyApp.showLoader(context, true, '');
  _context = context;
  //DialogHelper.showLoading('Please Wait...');
}

//hide loader by context
void hideLoader(context) {
  try {
    MyApp.showLoader(context, false, '');
    //DialogHelper.hideLoading();
  } catch (ex) {}
}

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<String?> getFirebaseToken() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  String? token = await messaging.getToken();
  print("Device Token: $token");
  return token;
}

void registerNotification() async {
  late final FirebaseMessaging _messaging;
  // 1. Initialize the Firebase app
  await Firebase.initializeApp();

  // 2. Instantiate Firebase Messaging
  _messaging = FirebaseMessaging.instance;

  // 3. On iOS, this helps to take the user permissions
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // TODO: handle the received notifications
  } else {
    print('User declined or has not accepted permission');
  }
}

var _intLoad;
showInternetLoading(msg) {
  _intLoad = showSimpleNotification(
    Center(child: Text(msg)),
    background: Colors.red,
    autoDismiss: false,
    position: NotificationPosition.top,
    contentPadding: EdgeInsets.only(top: 0),
  );
  // EasyLoading.show(status: '');
  isInternetConnected = false;
  // DialogHelper.showLoading(msg);
  //_entry.dismiss();
}

//hide loader using getX dialog helper
var _firstLoad = true;
hideInternetLoading(msg) {
  isInternetConnected = true;
  if (_intLoad != null) {
    _intLoad.dismiss();
    if (!_firstLoad) {
      showSimpleNotification(Center(child: Text(msg)),
          background: Colors.green,
          duration: Duration(milliseconds: 3000),
          contentPadding: EdgeInsets.all(0));
    } else {
      _firstLoad = false;
    }

    //DialogHelper.hideLoading();
    // EasyLoading.dismiss();
  }
}

//Set  User api token for future purpose
Future<String> setApiToken(String token) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(API_TOKEN_KEY, token);
  print('token set ${token}');
  return token;
}

//Get  User api token form local
Future<String> getApiToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String token = _prefs.getString(API_TOKEN_KEY) ?? "";
  return token;
}

String capitalizeEachWord(String text) {
  String capText = '';
  String temp = '';
  List<dynamic> words = text.split(' ');

  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      capText = words[i][0].toUpperCase() + words[i].substring(1);
    }
    temp = temp + ' ' + capText;
  }
  return words.join(' ');
}

checkInternetStatus() async {
  bool isNetwork;
  subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      log('no int Stat@@@ $result');
      showInternetLoading('You are offline');
      isNetwork = false;
    } else {
      //if (!firstLoad){
      log('active int@@@ $result');
      hideInternetLoading("Back to online");
      isNetwork = true;
      // }
    }
    print('connect status result :: ${result}');
  });
}

toast(String name) {
  return Fluttertoast.showToast(
    msg: name,
    // toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}

Future<void> logout() async {
  Navigator.of(_context!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeSignup()),
      (Route route) => false);

  await Provider.of<SignupDataProvider>(_context!, listen: false).logout();
}

Future<bool?> showConfirmPopup(
    context, heading, title, textOK, textCancel) async {
  Widget okButton = InkWell(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: themeBlueColor),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 7.0),
        child: Text(
          textOK,
          style: TextStyle(color: themeBlueColor, fontSize: 18.0),
        ),
      ),
    ),
    onTap: () {
      Navigator.of(context).pop(true);
      // true here means you clicked ok
    },
  );
  Widget cancelButton = InkWell(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: redColor,
        ),
        color: redColor,
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 35.0, right: 35.0, top: 8.0, bottom: 7.0),
        child: Container(
          child: Text(
            textCancel,
            style: TextStyle(color: whiteColor, fontSize: 18.0),
          ),
        ),
      ),
    ),
    onTap: () {
      Navigator.of(context).pop(false);
      // false here means you clicked cancel
    },
  );

  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        elevation: 5,
        actionsAlignment: MainAxisAlignment.center,
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(heading),
        content: Text(title),
        actions: [
          okButton,
          cancelButton,
        ],
      );
    },
  );
}

Future<bool?> showErrorPopup(context, heading, title) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
     
// Widget okButton = InkWell(
//     child: Text("OK"),
//     onTap: () {
// Navigator.pop(context);

//      },
//   );


      return AlertDialog(
        backgroundColor: whiteColor,
        elevation: 5,
        actionsAlignment: MainAxisAlignment.center,
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Center(child: Text(heading)),
        content: Center(
            child: Text(
          title,
          textAlign: TextAlign.center,
        )),

    //     actions: [
    //   okButton,
    // ],
      );
    },
  );
}
