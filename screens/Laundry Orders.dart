import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LaundryOrders extends StatefulWidget {
  const LaundryOrders({super.key});

  @override
  State<LaundryOrders> createState() => _LaundryOrdersState();
}

class _LaundryOrdersState extends State<LaundryOrders> {
  void submit() {
    showAlertDialog(context);
  }

  bool isChecked = true;
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {},
    );
    Widget remindButton = TextButton(
      child: const Text("Remind me later"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
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

  List<Map<String, dynamic>> delivery = [
    {"item": "Jain Enterprises", "Holiday": 'Sunday'},
    {"item": "Dogra Ventures", "Holiday": 'Sunday'},
    {"item": "Sarmila K (Self)", "Holiday": 'Thursday'},
    {"item": "Veena K Ent.", "Holiday": 'Saturday'},
    {"item": "Sanil ent", "Holiday": 'Sunday, Monday'},
    {"item": "Demo service", "Holiday": 'Sunday, Monday'},
  ];
  List<String> usersorde = [
    'Sarmila K',
    'L Menchu',
    'Sunil K',
    'N Kataria',
    'L Menchu',
    'Sarmila K',
  ];
  List<String> category = [
    'In Hand',
    'In Laundry',
    'Delivered',
  ];
  int currentSelectedIndex = 0; //For Horizontal Date
  int currentCateSelectedIndex = 0;
  ScrollController scrollController = ScrollController();
  void dialog() {
    Get.defaultDialog(
      title: "Hi i test dialog",
      middleText:
          "FlutterDevs is a protruding flutter app development company with "
          "an extensive in-house team of 30+ seasoned professionals who know "
          "exactly what you need to strengthen your business across various dimensions",
      backgroundColor: Colors.teal,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      actions: [
        TextButton(onPressed: () => {Get.back()}, child: Text("Close"))
      ],
    );
  }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Laundry Orders',
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/Hover.png"),
          ),
          onPressed: () {
            Get.toNamed("/screens/DeliveryBoyProfile");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(18.0, 0, 18, 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Laundry*",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () => {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Jain Enterprises",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Image(
                              height: 25,
                              width: 25,
                              image: AssetImage("assets/images/Sort Down.png"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 52,
                  // width: MediaQuery.of(context).size.width - 22,
                  decoration: BoxDecoration(
                    color: const Color(0xff1C2941),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => {
                          setState(() {
                            isChecked = true;
                          }),
                        },
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: !isChecked
                                ? const Color.fromRGBO(28, 41, 65, 1)
                                : const Color.fromRGBO(92, 136, 218, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 22,
                          child: Center(
                            child: Text(
                              "Active",
                              style: TextStyle(
                                color: !isChecked
                                    ? Color.fromRGBO(92, 136, 218, 1)
                                    : Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          setState(() {
                            isChecked = false;
                          }),
                        },
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: isChecked
                                ? const Color(0xff1C2941)
                                : Color.fromRGBO(92, 136, 218, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 22,
                          child: Center(
                            child: Text(
                              "Inactive",
                              style: TextStyle(
                                color: isChecked
                                    ? Color.fromRGBO(92, 136, 218, 1)
                                    : Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Laundry Name",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Holiday",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.grey,
                    )
                  ],
                ),
                Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 33);
                    },
                    itemCount: category.length,
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          color: Color.fromRGBO(190, 58, 58, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              // offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                              width: MediaQuery.of(context).size.width - 30,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    // offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                "Pickup:05 Dec. 2022 | 12-02PM",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "CS12345678",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 9, 0, 0),
                                                    child: Text(
                                                      "Rahul Sethi",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(0, 4, 0, 0),
                                                    child: const Text(
                                                      "18 Cloths",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0.0, 18, 0, 0),
                                                child: Container(
                                                  width: 130,
                                                  height: 33,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        237, 82, 16, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/screens/PickupOrder");
                                                    },
                                                    child: Text(
                                                      "pickup for Delivery"
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
