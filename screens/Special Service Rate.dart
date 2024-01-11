import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/LaundryDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SpecialServiceRate extends StatefulWidget {
  const SpecialServiceRate({super.key});

  @override
  State<SpecialServiceRate> createState() => _SpecialServiceRateState();
}

class _SpecialServiceRateState extends State<SpecialServiceRate> {
  bool isChecked = false;
  dynamic delivery = [];
  dynamic gender = [];
  dynamic product = [];
  dynamic product1 = [];
  String currentindex = '0';
  String currentindexgen = '0';
  String delivery_charges = '';
  String baseImage = '';
  String baseImageProduct = '';
  var cate_id = '', id = '';
  bool isHome = false;
  int page = 1, count = 10;
  dynamic? routes, customer_id;
  late ScrollController _controller = ScrollController();
  TextEditingController _txtinput = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // print("Hello");
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print(_controller.position.pixels);
      }
    });
    Future.delayed(Duration(seconds: 1), () {
      _category_list();
    });
    Future.delayed(Duration(seconds: 2), () {
      _subcategory_list();
    });
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  _category_list() async {
    setState(() {
      delivery = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=${page}' + '&' + 'limit=${count}';
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/product/category-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      setState(() {});
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        baseImage = data['data']['image_path'];
        for (int? i = 0; i! < size!; i++) {
          arr.add({
            "id": data['data']['data'][i]['id'],
            "name": data['data']['data'][i]['category_name'],
            "image": data['data']['data'][i]['new_category_image_name'],
            "isSelect": false,
          });
        }
        log('104 ${data['data']['data'][0]?['id']}');
        setState(() {
          delivery = arr;
          cate_id = data['data']['data'][0]['id'].toString();
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}
  }

  _subcategory_list() async {
    setState(() {
      gender = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=${page}' + '&' + 'limit=${count}';
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/product/sub-category-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'],
            "sub_category_name":
                data['data']['data'][i]['sub_category_name'].toString(),
            "isSelect": false,
          });
        }
        setState(() {
          gender = arr;
          id = data['data']['data'][0]['id'].toString();
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}

    Future.delayed(Duration(microseconds: 1200), () {
      _product_list();
    });
  }

  _product_list() async {
    log('@@ ${routes}');
    setState(() {
      product = [];
      product1 = [];
      customer_id = routes['customer_id'];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'category_id=' +
          cate_id.toString() +
          '&' +
          'sub_category_id=' +
          id.toString() +
          "&" +
          "customer_id=" +
          customer_id;
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/product/product-list-with-special-price?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        // baseImageProduct = data['data']['image_path'];
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'],
            "name": data['data']['data'][i]['product_name'],
            "image": data['data']['data'][i]['new_product_image_name'],
            "rate": "",
          });
          arr1.add({
            "product_id": data['data']['data'][i]['id'].toString(),
            "rate": "",
          });
        }
        setState(() {
          product = arr;
          product1 = arr1;
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}
  }

  int currentDateSelectedIndex = 0; //For Horizontal Date
  ScrollController scrollController = ScrollController();
  List<FocusNode> _focusNodes = List.generate(10, (index) => FocusNode());

  bool isSelect = false;
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool isSelect3 = false;

  void showAlert(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 320,
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: showAlertDialog(context),
          ),
        );
      },
    );
  }

  showAlertDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/Welcome.png'),
                width: 126,
                height: 180,
                fit: BoxFit.contain,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 15, top: 0),
                // color: Colors.white,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Congratulations. You can start taking Orders Now",
                  style: TextStyle(
                    color: lightBlackColor,
                    fontFamily: "Poppins-Regular",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: ActionButton("Ok", () {
                      Navigator.pushNamed(context, '/screens/BottomTab',
                          arguments: {"isHome": false});
                    }, MediaQuery.of(context).size.width * 0.45,
                        HexColor('#1C2941'), Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  submit() async {
    var arr = [];
    Map<String, dynamic> data1;
    log('@@ ${product1}');
    for (var i = 0; i < product1.length; i++) {
      if (product1[i]['rate'] != '') {
        arr.add(product1[i]);
      }
    }

    if (arr.length == 0) {
      toast('Enter amount should be grater than 0');
    } else if (delivery_charges == '') {
      toast('Enter delivery charges');
    } else {
      data1 = {
        "service_list": arr,
        "delivery_charge": delivery_charges.toString(),
      };
      showLoader(context);
      log('${data1}');
      try {
        showLoader(context);
        final data = await ApiService().sendPostRequest(
            '/v1/delivery-boy/product/add-update-product-special-price', data1);
        if (kDebugMode) {
          log('@@ ${data}');
        }
        hideLoader(context);
        log('@@ ${data?['data']['data']}');
        // log('message@@@${data['data']['status']![0]}');
        if (data?['data']['status'] == 1) {
          var arr = [];
          var mes = '';
          for (var i = 0; i < data['data']['data'].length; i++) {
            // log('@@@ ${res['data'][i]}');
            arr.add(data['data']['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              mes = value.replaceAll('"', '') + '.';
            });
          }
          // toast(mes);
          // Navigator.pushNamed(context, '/screens/BottomTab');
          showAlert(context);
        } else {
          var arr = [];
          var mes = '';
          // log(data['data']['data']);
          for (var i = 0; i < data['data']['data'].length; i++) {
            log('@@@ ${data['data']['data'][i]}');
            arr.add(data['data']['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              mes = value.replaceAll('"', '') + '.';
            });
          }
          toast(mes.replaceAll('_', ' '));
          log("error!");
          //toast()
        }
      } catch (ex) {
        if (kDebugMode) {
          print('x');
        }
        if (kDebugMode) {
          print(ex);
        }
        Future.delayed(const Duration(milliseconds: 200), () {
          hideLoader(context);
        });
      }

      // toast(msg!);
      hideLoader(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    routes = ModalRoute?.of(context)?.settings.arguments as dynamic;
    log('@@@ !${ModalRoute?.of(context)?.settings.arguments as dynamic}');
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Special Service Rate',
        ),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(children: <Widget>[
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              color: const Color.fromRGBO(28, 41, 65, 1.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                child: Center(
                  child: ListView.builder(
                    itemCount: delivery.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      print('delivery $delivery');
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentindex = index.toString();
                            cate_id = delivery[index]['id'].toString();
                            // delivery[index]['isSelect'] =
                            //     !delivery[index]['isSelect'];
                          });
                          log('@@ ${delivery[index]['id'].toString()}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9)),
                              color: currentindex == ''
                                  ? Color.fromRGBO(92, 136, 218, 1)
                                  : currentindex == index.toString()
                                      ? Colors.grey
                                      : Color.fromRGBO(92, 136, 218, 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        baseImage + delivery[index]['image']),
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    delivery[index]['name'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 12),
              height: 35,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 14.0, 0),
                child: ListView.builder(
                  itemCount: gender.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        _product_list();
                        currentindexgen = index.toString();
                        id = gender[index]['id'].toString();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: currentindexgen == ''
                                ? HexColor('#1C2941')
                                : currentindexgen == index.toString()
                                    ? Colors.grey
                                    : HexColor('#1C2941'),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 19.0,
                              vertical: 10,
                            ),
                            child: Text(
                              gender![index]['sub_category_name'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 35,
              color: const Color.fromRGBO(210, 210, 210, 1.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Item",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Service Rate",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(236, 241, 255, 1.0),
              height: 250,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7.0, 0, 7, 0),
                child: ListView.builder(
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    print((product[index]));
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 9,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10, 10, 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.network(
                                product[index]['image'],
                                height: 29,
                                width: 29,
                                semanticsLabel: 'A shark?!',
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        padding: const EdgeInsets.all(7.0),
                                        child:
                                            const CircularProgressIndicator()),
                              ),
                              // Text(
                              //   product[index]['name'],
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.black,
                              //     // backgroundColor: Colors.amber,
                              //   ),
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Container(
                              //       height: 22,
                              //       width: 22,
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(12),
                              //         color: Colors.grey[400],
                              //       ),
                              //       child: const Center(
                              //         child: Text(
                              //           "-",
                              //           style: TextStyle(
                              //               // fontSize: 19,
                              //               ),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 12,
                              //     ),
                              //     Text(
                              //       cloths[index]['qty'].toString(),
                              //       style: const TextStyle(
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.black,
                              //         // backgroundColor: Colors.amber,
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 12,
                              //     ),
                              //     Container(
                              //       height: 21,
                              //       width: 21,
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(12),
                              //         color: Colors.grey[400],
                              //       ),
                              //       child: const Icon(Icons.add, size: 12),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                width: 45,
                                height: 42,
                                child: TextFormField(
                                  onChanged: (value) => {
                                    setState(() {
                                      product[index]['rate'] = value;
                                      product1[index]['rate'] = value;
                                    }),
                                    print('product 466 $product')
                                  },
                                  initialValue:
                                      product[index]['rate'].toString()!,
                                  // controller: _txtinput,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .grey), // Color of the bottom border when not focused
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .black), // Color of the bottom border when focused
                                    ),
                                    hintText: 'Rs.',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18, 18.0, 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Charges",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            delivery_charges = text;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.grey,
                            ),
                          ),
                          filled: false,
                          hintText: "Enter delivery charges",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18, 18.0, 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Text(
                        //   "Total",
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.normal,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Rs",
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 21,
                        //     ),
                        //     Text(
                        //       "210",
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.normal,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 105,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(236, 241, 255, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 180,
                    height: 52,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                    child: TextButton(
                      onPressed: () {
                        submit();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(
                            28, 41, 65, 1.0), // Background color
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 20, vertical: 10), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(9), // Button shape
                        ),
                        // textStyle: TextStyle(fontSize: 16), // Text style
                        alignment: Alignment
                            .center, // Alignment of text within the button
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
                        child: Text(
                          "Apply".toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
