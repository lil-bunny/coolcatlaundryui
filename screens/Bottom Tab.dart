import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/screens/Dashboard.dart';
import 'package:ishtri_db/screens/My%20Rate.dart';
import 'package:ishtri_db/screens/MySchedule.dart';
import 'package:ishtri_db/screens/Orders.dart';
import 'package:ishtri_db/screens/View%20My%20Rate.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  void submit() {
    showAlertDialog(context);
  }

  bool isChecked = true;
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    Widget remindButton = TextButton(
      child: const Text("Remind me later"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [cancelButton, continueButton, remindButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    void cancel() {
      Navigator.pop(context, false);
    }
  }

  var _data = null;
  var page = 1;
  List _users = [];
  late ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // print("Hello");
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _firstLoad();
        print(_controller.position.pixels);
      }
    });

    setState(() {
      page++;
    });
    // _controller = ScrollController()..addListener(_fetchData());
    _firstLoad();
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  final List<String> names = <String>[
    'Aby',
    'Aish',
    'Ayan',
    'Ben',
    'Bob',
    'Charlie',
    'Cook',
    'Carline'
  ];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
  bool isSelect = false;
  // void apicall() {
  Future<List> _firstLoad() async {
    var url = Uri.parse(
        'https://reqres.in/api/users?page=${_users.length > 0 ? page : 1}');
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var res = json.decode(response.body);
      _users = [..._users, ...res['data']];
      print('response >>>>>>>>>>>>>${_users}');
      // return json.decode(response.body);
      // return jsonResponse.map((data) => Data.fromJson(data)).toList();
      return _users;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<dynamic>> _fetchData() async {
    var url = Uri.parse('https://reqres.in/api/users?page=${page}');
    print(url);
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      // _users.insertAll(0, json.decode(response.body));
      // return json.decode(response.body);
      var res = json.decode(response.body);
      _users = [..._users, ...res['data']];
      // return jsonResponse.map((data) => Data.fromJson(data)).toList();
      return _users;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  void dialog() {
    Get.defaultDialog(
      title: "Hi i test dialog",
      middleText:
          "FlutterDevs is a protruding flutter app development company with "
          "an extensive in-house team of 30+ seasoned professionals who know "
          "exactly what you need to strengthen your business across various dimensions",
      backgroundColor: Colors.teal,
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white),
      actions: [
        TextButton(onPressed: () => {Get.back()}, child: const Text("Close"))
      ],
    );
  }

  // }
  static const List<String> _widgetOptions = <String>[
    '/screens/BottomTab',
    '/screens/Orders'
    // BottomTab(),
    // Orders(),
    // MySchedule(),
    // MyRate()
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    print(index);
    // Get.toNamed(_widgetOptions.elementAt(index).toString());
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/images/Home.png"),
                color: Colors.grey,
              ),
              label: 'Home',
              activeIcon: Image(
                image: AssetImage(
                  "assets/images/Home.png",
                ),
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/images/Document.png"),
                height: 25,
                color: Colors.grey,
              ),
              activeIcon: Image(
                image: AssetImage(
                  "assets/images/Document.png",
                ),
                color: Colors.black,
                height: 25,
              ),
              label: 'My Orders',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/images/Schedule.png"),
                color: Colors.grey,
                height: 25,
              ),
              activeIcon: Image(
                image: AssetImage(
                  "assets/images/Schedule.png",
                ),
                color: Colors.black,
                height: 27,
              ),
              label: 'My Schedule',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/images/To_Do.png"),
                height: 25,
                color: Colors.grey,
              ),
              activeIcon: Image(
                image: AssetImage(
                  "assets/images/To_Do.png",
                ),
                height: 25,
                color: Colors.black,
              ),
              label: 'My Rates',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5,
        ),
        body: _selectedIndex == 0
            ? Dashboard()
            : _selectedIndex == 1
                ? Orders()
                : _selectedIndex == 2
                    ? MySchedule()
                    : ViewMyRate());
  }
}
