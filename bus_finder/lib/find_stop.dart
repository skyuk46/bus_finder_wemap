import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'ePage.dart';

class FindStopPage extends EPage {
  FindStopPage() : super(const Icon(Icons.map), 'Full screen map');

  @override
  Widget build(BuildContext context) {
    return FindStop();
  }
}

class FindStop extends StatefulWidget {
  FindStop();

  @override
  State createState() => FindStopState();
}

class FindStopState extends State<FindStop> {
  List<LatLng> points = [];
  FocusNode _focus = new FocusNode();
  static LatLng center = LatLng(21.03786, 105.78163);
  TextEditingController editingController = TextEditingController();

  var items = [];
  var shownItems = [];

  WeMapDirections directionAPI = WeMapDirections();
  WeMapController mapController;
  int searchType = 1; //Type of search bar
  LatLng myLatLng = LatLng(21.03708, 105.78227);
  bool reverse = true;
  WeMapPlace place;
  Symbol _selectedSymbol;
  int count = 0;
  bool searchHintVisible = false;
  LatLng stopLatLng;

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/busstop.json');
    setState(() {
      final duplicateItems = jsonDecode(jsonText)['busStop'];
      items = duplicateItems != null ? List.from(duplicateItems) : null;
      for (var x in items) {
        shownItems.add(x);
      }
    });

    return 'success';
  }

  @override
  void initState() {
    loadJsonData();

    _focus.addListener(() {
      setState(() {
        if (searchHintVisible == false) {
          searchHintVisible = true;
        }
        else {
          searchHintVisible = false;
        }
      });
    });
  }

  Future<LatLng> getFutureStopLatLng(String stop) async{
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
      var jsoninfo = JsonInfo.fromJson(jsonDecode(response.body));

      return LatLng(jsoninfo.dt.data[0].geo.Lat, jsoninfo.dt.data[0].geo.Lng);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return null;
    }
  }

  void getStopLatLng(String stop) async {
    stopLatLng = await getFutureStopLatLng(stop);

    if (mapController.symbols.isNotEmpty) {
      mapController.removeSymbol(mapController.symbols.first);
    }
    _add("images/mark-location.png", stopLatLng );

    points.clear();
    points.add(stopLatLng);

    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: stopLatLng, zoom: 16.0),
      ),
    );
    mapController.showPlaceCard?.call(place);
  }

  void searchItemsList(String value) {
    shownItems.clear();
    if (value == "") {
      place = null;
      mapController.showPlaceCard?.call(place);
      for (var x in items) {
        shownItems.add(x);
      }
      print(shownItems);
    }
    else {
      print(items);
      for (var x in items) {
        if (x.toUpperCase().contains(value.toUpperCase())) {
          shownItems.add(x);
        }
      }
    }
  }

  void _onMapCreated(WeMapController controller) {
    mapController = controller;
    mapController.onSymbolTapped.add(_onSymbolTapped);
    count++;
  }

  @override
  void dispose() {
    mapController.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  void _onSymbolTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      _updateSelectedSymbol(const SymbolOptions(iconSize: 1.0));
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedSymbol(SymbolOptions(iconSize: 1.4));
  }

  void _updateSelectedSymbol(SymbolOptions changes) {
    mapController.updateSymbol(_selectedSymbol, changes);
  }

  void _add(String iconImage, LatLng stop) {
    mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          stop.latitude,
          stop.longitude,
        ),
        iconImage: iconImage,
        iconSize: 0.3,
      ),
    );
  }

  void onStyleLoadedCallback() async {
    final json = await directionAPI.getResponseMultiRoute(
        0, points); //0 = car, 1 = bike, 2 = foot
    List<LatLng> _route = directionAPI.getRoute(json);
    List<LatLng> _waypoins = directionAPI.getWayPoints(json);

    await mapController.addLine(
      LineOptions(
        geometry: _route,
        lineColor: "#0071bc",
        lineWidth: 5.0,
        lineOpacity: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          WeMap(
            onMapClick: (point, latlng, _place) async {
              place = _place;
            },
            onPlaceCardClose: () {
              // print("Place Card closed");
            },
            reverse: true,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: onStyleLoadedCallback,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 14.0,
            ),
            destinationIcon: "images/destination.png",
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, left: 15),
            child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: searchHintVisible,
                child: Container(
                  color: Colors.white,
                  width: 380,
                  height: 300,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: shownItems.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            var currentFocus = FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            getStopLatLng(shownItems[index]);
                          });
                        },
                        child: ListTile(
                          title: Text('${shownItems[index]}'),
                        ),
                      );
                    },
                  ),
                )
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      focusNode: _focus,
                      onChanged: (value) {
                        searchItemsList(value);
                        setState(() {

                        });
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                ),
            ),
        ],
      ),
    );
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
  final List<Data> data;

  Dt({this.data});

  factory Dt.fromJson(Map<String, dynamic> json) {
    var list = json['Data'] as List;
    print(list.runtimeType);
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();
    return Dt(
      data: dataList,
    );
  }
}

class Data {
  final Geo geo;
  final String FleetOver;

  Data({this.geo, this.FleetOver});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      geo: Geo.fromJson(json["Geo"]),
      FleetOver: json["FleetOver"]
    );
  }
}

class Geo {
  final double Lng;
  final double Lat;

  Geo({this.Lng, this.Lat});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      Lng: json['Lng'],
      Lat: json['Lat'],
    );
  }
}

