import 'package:bus_finder/find_stop.dart';
import 'package:bus_finder/find_stop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:bus_finder/CNG01.dart';
import 'package:bus_finder/CNG02.dart';
import 'package:bus_finder/CNG03.dart';
import 'package:bus_finder/CNG04.dart';
import 'package:bus_finder/busRoute.dart';
import 'package:bus_finder/stopInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';

import 'package:wemapgl/wemapgl.dart' as WEMAP;

void main() async {
  WEMAP.Configuration.setWeMapKey('GqfwrZUEfxbwbnQUhtBMFivEysYIxelQ');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Finder',
      home: MyHomePage(title: 'Xe Bus Hà Nội'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  String title = "a";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Widget widget1 = Row();
Widget widget2 = Row();
Widget widget3 = Container();

List<String> bus_route_base = [];

List<String> bus_route_search = [];

List<String> bus_stop_base = [
  'Phố cầu    >',
  'Dốc Vệ Tinh        >',
  'Bệnh viện đa khoa Thăng Long    >',
  'Đại sứ quán Nhật Bản             >',
  'Đình làng Bùng    >',
  'Ngã 3 Đỗ Xá    >',
  'Làng Lương Xá  >',
  'Bệnh viện K Hà Nội    >',
  'Nhà thi đấu Hà Đông   >',
  'Thôn Xuân Tình        >',
  'Đình Nam Dư Hạ        >',
  'Bưu cục Trâu Quỳ      >',
  'Đại học Hà Nội        >',
  'Nhà D10        >',
];
List<String> bus_stop_search = [
  'Phố Cầu    >',
  'Dốc Vệ Tinh        >',
  'Bệnh viện đa khoa Thăng Long    >',
  'Đại sứ quán Nhật Bản             >',
  'Đình làng Bùng    >',
  'Ngã 3 Đỗ Xá    >',
  'Làng Lương Xá  >',
  'Bệnh viện K Hà Nội    >',
  'Nhà thi đấu Hà Đông   >',
  'Thôn Xuân Tình        >',
  'Đình Nam Dư Hạ        >',
  'Bưu cục Trâu Quỳ      >',
  'Đại học Hà Nội        >',
  'Nhà D10        >',
];

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<Data> _futureData;

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/bus.json');
    setState(() {
      final duplicateItems = jsonDecode(jsonText)['busRoute'];
      bus_route_base = duplicateItems != null ? List.from(duplicateItems) : null;
      for (var x in bus_route_base) {
        bus_route_search.add(x);
      }
    });
  }

  void initState() {
    loadJsonData();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void update() {
    setState(() {});
  }

  void _navigateToFindStop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => new FindStopPage()));
  }

  void _navigateToCNG(BuildContext context, String route) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    if (route == "CNG01") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => new CNG01()));
    } else if (route == "CNG02") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => new CNG02()));
    } else if (route == "CNG03") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => new CNG03()));
    } else if (route == "CNG04") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => new CNG04()));
    }
  }

  Future<Data> getData() async {
    final response = await http.post(
      Uri.parse(
          'https://busroutes.azurewebsites.net/api/routes?fbclid=IwAR19GRyS4XjetGmzVTrjQxrDil2NBNY3kfSbfscGaNDab9NXOYqecdF-3OQ'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_counter == 0) {
      widget1 = SearchRouteBar(this.update);
      widget2 = BusRouteList();
      widget3 = Container();
    }
    else if (_counter == 1) {
      widget1 = StartPointBar();
      widget2 = EndPointBar();
      widget3 = Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 60),
            child: ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              buttonColor: Colors.green,
              minWidth: 300.0,
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _futureData = getData();
                  });
                },
                child: Text(
                  "Tìm đường",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            child: (_futureData == null) ? Column() : buildFutureBuilder(),
          ),
        ],
      );
    } else if (_counter == 3) {
      widget1 = SearchStopBar(this.update);
      widget2 = BusStopList();
      widget3 = Container();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Ionicons.apps_outline),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.green,
        title: Text(widget.title),
        actions: [
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 50,
                              child: RaisedButton.icon(
                                  onPressed: () {
                                    _navigateToCNG(context, "CNG01");
                                  },
                                  icon: Icon(Ionicons.bus),
                                  label: Text(
                                      "       CNG01                                                                            ")),
                            ),
                            Container(
                              height: 50,
                              child: RaisedButton.icon(
                                  onPressed: () {
                                    _navigateToCNG(context, "CNG02");
                                  },
                                  icon: Icon(Ionicons.bus),
                                  label: Text(
                                      "       CNG02                                                                            ")),
                            ),
                            Container(
                              height: 50,
                              child: RaisedButton.icon(
                                  onPressed: () {
                                    _navigateToCNG(context, "CNG03");
                                  },
                                  icon: Icon(Ionicons.bus),
                                  label: Text(
                                      "       CNG03                                                                            ")),
                            ),
                            Container(
                              height: 50,
                              child: RaisedButton.icon(
                                  onPressed: () {
                                    _navigateToCNG(context, "CNG04");
                                  },
                                  icon: Icon(Ionicons.bus),
                                  label: Text(
                                      "       CNG04                                                                            ")),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,
                child: Text('Bus CNG',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: Image(
                  image: AssetImage('images/Bus_icon.png'),
                  height: 150,
                )),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text("App thực hiện bởi nhóm 11",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text("Ứng dụng tìm bus",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text("Áp dụng We Map SDK",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text("Tiện lợi cho người dùng",
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Phiên bản 1.0",
                ))
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          widget1,
          widget2,
          widget3,
          BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _counter,
              onTap: (int index) {
                if (index == 2) {
                  _navigateToFindStop(context);
                }
                setState(() => _counter = index);
              },
              selectedItemColor: Colors.green,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.bus),
                  label: 'Tuyến Bus',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.search),
                  label: "Tìm đường",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.map),
                  label: "Bản đồ",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Ionicons.walk_outline), label: "Điểm dừng"),
              ])
        ],
      ),
    );
  }

  FutureBuilder<Data> buildFutureBuilder() {
    return FutureBuilder<Data>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text("Quãng đường cần đi:   " + snapshot.data.distance.toString() + " km", style: TextStyle(fontSize: 18),),
              Text("Đầu tiên đi tới: " + snapshot.data.path[0].name, style: TextStyle(fontSize: 18),)
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class Data {
  final double distance;
  final List<Path> path;

  Data({this.distance, this.path});

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['path'] as List;
    print(list.runtimeType);
    List<Path> pathsList = list.map((i) => Path.fromJson(i)).toList();
    return Data(
      distance: json['distance'],
      path: pathsList,
    );
  }
}

class Path {
  final String name;
  final Location location;

  Path({this.name, this.location});

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      name: json['name'],
      location: Location.fromJson(json['location']),
    );
  }
}

class Location {
  final double lattitude;
  final double longitude;

  Location({this.lattitude, this.longitude});
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lattitude: json['lattitude'],
      longitude: json['longitude'],
    );
  }
}

class SearchRouteBar extends StatefulWidget {
  SearchRouteBar(this.update);

  Function update;

  @override
  _SearchRouteBar createState() => new _SearchRouteBar();
}

class _SearchRouteBar extends State<SearchRouteBar> {
  TextEditingController searchroutecontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        onChanged: (text) {
          setState(() {
            bus_route_search.clear();
            if (text == "") {
              for (var x in bus_route_base) {
                bus_route_search.add(x);
              }
            } else {
              for (var x in bus_route_base) {
                if (x.toUpperCase().contains(text.toUpperCase())) {
                  bus_route_search.add(x);
                }
              }
            }
            this.widget.update();
          });
        },
        controller: searchroutecontroller,
        decoration: InputDecoration(
            prefixIcon: Icon(Ionicons.search),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: 'Tìm tuyến'),
      ),
    );
  }
}

class BusRouteList extends StatefulWidget {
  BusRouteList({Key key}) : super(key: key);

  @override
  _BusRouteList createState() => new _BusRouteList();
}

class _BusRouteList extends State<BusRouteList> {
  void _navigateToBusRoute(BuildContext context, String route) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => new busRoute(route)));
  }

  void BusRoute(String route) {
    _navigateToBusRoute(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for (var x in bus_route_search)
                InkWell(
                    onTap: () {
                      BusRoute(x);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 10, left: 30),
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(x, style: TextStyle(fontSize: 18))))),
            ],
          )
      ),
    );
  }
}

class SearchStopBar extends StatefulWidget {
  SearchStopBar(this.update);
  Function update;

  _SearchStopBar createState() => _SearchStopBar();
}

class _SearchStopBar extends State<SearchStopBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        onChanged: (text) {
          setState(() {
            bus_stop_search.clear();
            if (text == "") {
              for (var x in bus_stop_base) {
                bus_stop_search.add(x);
              }
            } else {
              for (var x in bus_stop_base) {
                if (x.toUpperCase().contains(text.toUpperCase())) {
                  bus_stop_search.add(x);
                }
              }
            }
            this.widget.update();
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Ionicons.search),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: 'Điểm dừng'),
      ),
    );
  }
}

class BusStopList extends StatelessWidget {
  _showDialog(BuildContext context, String x) {
    showDialog(context: context, builder: (context) => new stopInfo(x));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for (var x in bus_stop_search)
                InkWell(
                    onTap: () {
                      _showDialog(context, x);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 15, left: 30),
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(x, style: TextStyle(fontSize: 18))))),
            ],
          )),
    );
  }
}

class StartPointBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Ionicons.location_outline),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: 'Điểm đi'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          child: Icon(
            Ionicons.arrow_down_circle_sharp,
            size: 30,
          ),
        )
      ],
    );
  }
}

class EndPointBar extends StatelessWidget {
  void findWay() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Ionicons.arrow_forward_circle_outline),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: 'Điểm đi'),
          ),
        ),
      ],
    );
  }
}
