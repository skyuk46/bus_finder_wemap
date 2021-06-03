import 'package:bus_finder/full_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';

class busRoute extends StatefulWidget {
  busRoute(this.route);
  String route;

  _busRoute createState() => new _busRoute();
}

class _busRoute extends State<busRoute> {
  int _counter = 0;
  Widget widget1 = Row();
  Widget widget2 = Row();
  Future<Dt> dt;

  Future<int> getFutureRouteId(String stop) async {
    Map<String, dynamic> body = {'act': 'searchfull', 'typ': "1", 'key': stop};

    final response = await http.post(
      "http://timbus.vn/Engine/Business/Search/action.ashx",
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
      var jsonidinfo = JsonIdInfo.fromJson(jsonDecode(response.body));

      return jsonidinfo.dt.data[0].ObjectId;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return null;
    }
  }

  Future<Dt> getFutureRouteInfo(String stop) async {
    int fid = await getFutureRouteId(stop);
    Map<String, dynamic> body = {'act': 'fleetdetail', 'fid': fid.toString()};

    final response = await http.post(
      "http://timbus.vn/Engine/Business/Search/action.ashx",
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
  void initState() {
    dt = getFutureRouteInfo(widget.route);
  }

  _navigateBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  _navigateToMapUi(
      BuildContext context, List<Station> station, String route) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    /* final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.GRANTED) {
      await location.requestPermission();
    } */

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => new FullMapPage(station, route)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Ionicons.arrow_back),
              onPressed: () => _navigateBack(context),
            ),
          ),
          backgroundColor: Colors.green,
          title: Text(widget.route),
        ),
        body: FutureBuilder<Dt>(
          future: dt,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              String title = "Tuyến: " + widget.route;
              var data = snapshot.data;

              if (_counter == 0) {
                widget1 = Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold))),
                );

                widget2 = busStop(data);
              } else if (_counter == 2) {
                widget1 = Container();
                widget2 = routeContent(data);
              } else if (_counter == 3) {
                widget1 = busTime(data, "go");
                widget2 = busTime(data, "back");
              }

              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  widget1,
                  Divider(),
                  widget2,
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
        bottomNavigationBar: FutureBuilder<Dt>(
            future: dt,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                var data = snapshot.data;

                return BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _counter,
                    onTap: (int index) {
                      if (index == 1) {
                        _navigateToMapUi(
                            context, data.go.station, widget.route);
                      }
                      setState(() => _counter = index);
                    },
                    selectedItemColor: Colors.blue,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Ionicons.storefront_outline),
                        label: 'Điểm dừng',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Ionicons.map),
                        label: "Bản đồ",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Ionicons.bus),
                        label: "Lộ trình",
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Ionicons.alarm_outline), label: "Giờ"),
                    ]);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            })
    );
  }
}

class busStop extends StatelessWidget {
  busStop(this.data);
  Dt data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for (var station in data.go.station)
                Wrap(
                  children: [
                    ListTile(
                      leading: Icon(
                        Ionicons.arrow_down,
                        color: Colors.green,
                      ),
                      title: Text(station.Name),
                      trailing: Icon(
                        Ionicons.walk,
                        color: Colors.blue,
                      ),
                    ),
                    Divider()
                  ],
                )
            ],
          )),
    );
  }
}

class routeContent extends StatelessWidget {
  routeContent(this.data);
  Dt data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đơn vị chủ quản: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  data.Enterprise,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                Text(
                  "Giá vé: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  data.Cost,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                Text(
                  "Tần suất chạy: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  data.Frequency,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                Text(
                  "Lộ trình (chiều đi): ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  data.go.Route,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                Text(
                  "Lộ trình (chiều về): ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  data.re.Route,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
              ],
            ),
          )),
    );
  }
}

class busTime extends StatelessWidget {
  busTime(this.data, this.direction);
  Dt data;
  String direction;

  @override
  Widget build(BuildContext context) {
    String title = "",
        span1 = "",
        span2 = "",
        span3 = "",
        time1 = "",
        time2 = "",
        time3 = "";
    var timeList = data.OperationsTime.split("###");
    var goTimeList = timeList[0].split(";");
    var backTimeList = timeList[1].split(";");

    if (direction == "go") {
      title = "Chiều " + data.FirstStation;
      span1 = goTimeList[0];
      span2 = goTimeList[1];
      span3 = goTimeList[2];
    } else if (direction == "back") {
      title = "Chiều " + data.LastStation;
      span1 = backTimeList[0];
      span2 = backTimeList[1];
      span3 = backTimeList[2];
    }

    time1 = span1.split("|")[2];
    time2 = span2.split("|")[2];
    time3 = span3.split("|")[2];

    return Container(
      child: Column(
        children: [
          SizedBox(height: 86),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Thứ 2-6: "),
              Text(
                time1,
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Thứ 7: "),
              Text(
                time2,
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Chủ nhật: "),
              Text(
                time3,
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            ],
          ),
          SizedBox(
            height: 86,
          )
        ],
      ),
    );
  }
}

class JsonIdInfo {
  final IdDt dt;

  JsonIdInfo({this.dt});

  factory JsonIdInfo.fromJson(Map<String, dynamic> json) {
    return JsonIdInfo(
      dt: IdDt.fromJson(json["dt"]),
    );
  }
}

class IdDt {
  final List<IdData> data;

  IdDt({this.data});

  factory IdDt.fromJson(Map<String, dynamic> json) {
    var list = json['Data'] as List;
    print(list.runtimeType);
    List<IdData> dataList = list.map((i) => IdData.fromJson(i)).toList();

    return IdDt(data: dataList);
  }
}

class IdData {
  int ObjectId;

  IdData({this.ObjectId});

  factory IdData.fromJson(Map<String, dynamic> json) {
    return IdData(ObjectId: json["ObjectID"]);
  }
}

class JsonInfo {
  final Dt dt;

  JsonInfo({this.dt});
  factory JsonInfo.fromJson(Map<String, dynamic> json) {
    return JsonInfo(
      dt: Dt.fromJson(json["dt"]),
    );
  }
}

class Dt {
  String Enterprise;
  String Code;
  String Name;
  String Frequency;
  String BusCount;
  String Cost;
  String FirstStation;
  String LastStation;
  Go go;
  Re re;
  String OperationsTime;

  Dt(
      {this.Enterprise,
      this.Code,
      this.Name,
      this.Frequency,
      this.BusCount,
      this.Cost,
      this.FirstStation,
      this.LastStation,
      this.go,
      this.re,
      this.OperationsTime});

  factory Dt.fromJson(Map<String, dynamic> json) {
    return Dt(
      Enterprise: json['Enterprise'],
      Code: json['Code'],
      Name: json['Name'],
      Frequency: json['Frequency'],
      BusCount: json['BusCount'],
      Cost: json['Cost'],
      FirstStation: json["FirstStation"],
      LastStation: json["LastStation"],
      go: Go.fromJson(json["Go"]),
      re: Re.fromJson(json["Re"]),
      OperationsTime: json["OperationsTime"],
    );
  }
}

class Go {
  String Route;
  List<Station> station;

  Go({this.Route, this.station});

  factory Go.fromJson(Map<String, dynamic> json) {
    var list = json['Station'] as List;
    print(list.runtimeType);
    List<Station> stationList = list.map((i) => Station.fromJson(i)).toList();

    return Go(Route: json["Route"], station: stationList);
  }
}

class Re {
  String Route;
  List<Station> station;

  Re({this.Route, this.station});

  factory Re.fromJson(Map<String, dynamic> json) {
    var list = json['Station'] as List;
    print(list.runtimeType);
    List<Station> stationList = list.map((i) => Station.fromJson(i)).toList();

    return Re(Route: json["Route"], station: stationList);
  }
}

class Station {
  String Name;
  String FleetOver;
  Geo geo;

  Station({this.Name, this.FleetOver, this.geo});
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
        Name: json["Name"],
        FleetOver: json['FleetOver'],
        geo: Geo.fromJson(json["Geo"]));
  }
}

class Geo {
  double Lat;
  double Lng;

  Geo({this.Lat, this.Lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(Lat: json["Lat"], Lng: json["Lng"]);
  }
}
