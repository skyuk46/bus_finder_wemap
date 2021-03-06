import 'package:bus_finder/marked_stop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_finder/busRoute.dart';
import 'package:bus_finder/find_stop.dart' as findStop;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class stopInfo extends StatefulWidget {

  stopInfo(this.stop);
  String stop;

  _stopInfo createState() => new _stopInfo();
}

class _stopInfo extends State<stopInfo> {
  Future<String> fleetover;
  List<String> busRouteList;
  double stopLat;
  double stopLng;

  void loadJsonRouteData() async {
    var jsonText = await rootBundle.loadString('assets/bus.json');
    setState(() {
      final duplicateItems = jsonDecode(jsonText)['busRoute'];
      busRouteList = duplicateItems != null ? List.from(duplicateItems) : null;
    });
  }

  Future<String> getFutureStopFleetOver(String stop) async{
    Map<String, dynamic> body = {'act': 'searchfull', 'typ': "2", 'key': stop};

    final response = await http.post("http://timbus.vn/Engine/Business/Search/action.ashx",
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
      var jsoninfo = findStop.JsonInfo.fromJson(jsonDecode(response.body));
      stopLat = jsoninfo.dt.data[0].geo.Lat;
      stopLng = jsoninfo.dt.data[0].geo.Lng;

      return jsoninfo.dt.data[0].FleetOver;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return null;
    }
  }

  void _navigateToMarkedStopMap(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => new MarkedStopPage(this.stopLat, this.stopLng)));
  }

  @override
  void initState() {
    loadJsonRouteData();
    fleetover = getFutureStopFleetOver(widget.stop);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
        future: fleetover,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          else if (snapshot.hasData) {
            var data = snapshot.data;
            List<String> fleetsList = data.split(",");
            return AlertDialog(
              title: Text(widget.stop, textAlign: TextAlign.center,),
              content: Wrap(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("C?? " + fleetsList.length.toString() + " tuy???n ??i qua", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 200,
                        width: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: fleetsList.length,
                          itemBuilder: (context, index) {
                            String route;
                            for (var x in busRouteList) {
                              if (x.contains(fleetsList[index]))   {
                                route = x;
                                break;
                              }
                            };

                            return ListTile(
                              leading: Text((index + 1).toString()),
                              title: InkWell(
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => new busRoute(route))
                                  );
                                },
                                child: Text("Xem tuy???n " + fleetsList[index]),
                              ),
                              trailing: Icon(Ionicons.bus, color: Colors.blue,),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        )
                    ),
                  ),
                  Divider(),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text("Hi???n th??? tr??n b???n ?????", style: TextStyle(color: Colors.lightBlueAccent),),
                      onTap: () {
                        _navigateToMarkedStopMap(context);
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return Text("loading");
        }
    );
  }
}
