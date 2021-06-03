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
import 'package:wemapgl/wemapgl.dart';

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

List<String> bus_stop_base = [];
List<String> bus_stop_search = [];

LatLng cityCenter = LatLng(21.02880, 105.85212);

WeMapController mapController;
WeMapPlace start;
WeMapPlace destination;

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<List<Dt>> pathsList;

  Future<String> loadJsonStopData() async {
    var jsonText = await rootBundle.loadString('assets/busstop.json');
    setState(() {
      final duplicateItems = jsonDecode(jsonText)['busStop'];
      bus_stop_base = duplicateItems != null ? List.from(duplicateItems) : null;
      for (var x in bus_stop_base) {
        bus_stop_search.add(x);
      }
    });

    return 'success';
  }

  Future<String> loadJsonRouteData() async {
    var jsonText = await rootBundle.loadString('assets/bus.json');
    setState(() {
      final duplicateItems = jsonDecode(jsonText)['busRoute'];
      bus_route_base = duplicateItems != null ? List.from(duplicateItems) : null;
      for (var x in bus_route_base) {
        bus_route_search.add(x);
      }
    });

    return 'success';
  }

  void initState() {
    loadJsonRouteData();
    loadJsonStopData();
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

  Future<List<Dt>> getData() async {
    String slng = start.location.longitude.toString();
    String slat = start.location.latitude.toString();
    String elng = destination.location.longitude.toString();
    String elat = destination.location.latitude.toString();
    Map<String, String> body = {
      'act': 'route',
      'opts': "2",
      'slng' : slng,
      'slat' : slat,
      'elng' : elng,
      'elat' : elat,
    };

    final response = await http.post("http://timbus.vn/Engine/Business/Route/action.ashx",
      body: body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "http://timbus.vn/",
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsoninfo = JsonInfo.fromJson(jsonDecode(response.body));

      return jsoninfo.dt;
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
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              buttonColor: Colors.green,
              minWidth: 300.0,
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    pathsList = getData();
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
            child: (pathsList == null) ? Column() : buildFutureBuilder(),
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
        ],
      ),
        bottomNavigationBar:  BottomNavigationBar(
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
            ]
        )
    );
  }

  FutureBuilder<List<Dt>> buildFutureBuilder() {
    return FutureBuilder<List<Dt>>(
      future: pathsList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                for (var path in data)
                  Wrap(
                    children: [
                      Container(
                        color: Colors.grey,
                        child: Row(
                          children: [
                            Container(
                              color: Colors.blue,
                              child: Text("PA." + data.indexOf(path).toString() + " ", style: TextStyle(color: Colors.white),),
                            ),
                            for (var result in path.result)
                              Wrap(
                                children: [
                                  Icon(Ionicons.car_outline, size: 20,),
                                  for (var fleet in result.Fleet)
                                    (result.Fleet.length > 1) ? Text(fleet + ", ") : Text(fleet + " ")
                                ],
                              ),
                            Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text((path.DistTotal - path.DistWalk).toString() + "m"),
                                )
                            )
                          ],
                        ),
                      ),
                      Text(start.placeName),
                      for (var result in path.result)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text(result.start.Name, style: TextStyle(color: Colors.green),),
                            Row(
                              children: [
                                Icon(Ionicons.bus),
                                Text("Đi bus tuyến "),
                                for (var fleet in result.Fleet)
                                  Text(fleet + ", ", style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            Text("Khoảng " + result.Distance.toString() + "m ~ " + result.Time.toString() + " giây" ),
                            Text(result.end.Name, style: TextStyle(color: Colors.red),),
                          ],
                        ),
                      Divider(),
                      Text(destination.placeName),
                      Divider()
                    ],
                  )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class JsonInfo {
  List<Dt> dt;

  JsonInfo({this.dt});

  factory JsonInfo.fromJson(Map<String, dynamic> json) {
    var list = json['dt'] as List;
    print(list.runtimeType);
    List<Dt> dtList = list.map((i) => Dt.fromJson(i)).toList();
    return JsonInfo(
      dt: dtList,
    );
  }
}

class Dt {
  Start start;
  List<Result> result;
  End end;
  int DistTotal;
  int DistWalk;

  Dt({this.start, this.result, this.end, this.DistTotal, this.DistWalk});

  factory Dt.fromJson(Map<String, dynamic> json) {
    var list = json['Result'] as List;
    print(list.runtimeType);
    List<Result> resultList = list.map((i) => Result.fromJson(i)).toList();
    return Dt(
      start: Start.fromJson(json["Start"]),
      result: resultList,
      end: End.fromJson(json["End"]),
      DistTotal: json["DistTotal"],
      DistWalk: json["DistWalk"]
    );
  }
}

class Start {
  String Address;
  Geo geo;
  int Distance;

  Start({this.Address, this.geo, this.Distance});

  factory Start.fromJson(Map<String, dynamic> json) {
    return Start(
        Address: json["Address"],
        geo: Geo.fromJson(json["Geo"]),
        Distance: json["Distance"]
    );
  }
}

class End {
  String Address;
  Geo geo;
  int Distance;

  End({this.Address, this.geo, this.Distance});

  factory End.fromJson(Map<String, dynamic> json) {
    return End(
        Address: json["Address"],
        geo: Geo.fromJson(json["Geo"]),
        Distance: json["Distance"]
    );
  }
}

class Geo {
  double Lat;
  double Lng;

  Geo({this.Lat, this.Lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
        Lat: json["Lat"],
        Lng: json["Lng"]
    );
  }
}

class Result {
  List<dynamic> Fleet;
  ResultStart start;
  ResultEnd end;
  int DistanceWalk;
  int Distance;
  int Time;
  
  Result({this.Fleet, this.start, this.end, this.DistanceWalk, this.Distance, this.Time});

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['Fleet'] as List;
    print(list.runtimeType);
    List<dynamic> fleetList = list.map((i) => i).toList();
    return Result(
      Fleet: fleetList,
      start: ResultStart.fromJson(json["Start"]),
      end: ResultEnd.fromJson(json["End"]),
      DistanceWalk: json["DistanceWalk"],
      Distance: json["Distance"],
      Time: json["Time"]
    );
  }
}

class ResultStart {
  String Name;
  
  ResultStart({this.Name});

  factory ResultStart.fromJson(Map<String, dynamic> json) {
    return ResultStart(
      Name: json["Name"]
    );
  }
}

class ResultEnd {
  String Name;

  ResultEnd({this.Name});

  factory ResultEnd.fromJson(Map<String, dynamic> json) {
    return ResultEnd(
        Name: json["Name"]
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

class StartPointBar extends StatefulWidget {
  StartPointBar();

  _StartPointBar createState() => _StartPointBar();
}

class _StartPointBar extends State<StartPointBar> {
  @override
  Widget build(BuildContext context) {
    return WeMapSearchBar(
      location: cityCenter,
      hintText: "Điểm đi",
      onSelected: (_place) {
        setState(() {
          start = _place;
        });
      },
      onClearInput: () {
        setState(() {
          start = null;
        });
      },
    );
  }
}

class EndPointBar extends StatefulWidget {
  EndPointBar();

  _EndPointBar createState() => _EndPointBar();
}

class _EndPointBar extends State<EndPointBar> {
  void findWay() {}

  @override
  Widget build(BuildContext context) {
    return WeMapSearchBar(
      location: cityCenter,
      hintText: "Điểm đến",
      onSelected: (_place) {
        setState(() {
          destination = _place;
        });
      },
      onClearInput: () {
        setState(() {
          start = null;
        });
      },
    );
  }
}
