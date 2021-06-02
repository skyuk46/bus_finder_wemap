import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:bus_finder/busRoute.dart';

import 'ePage.dart';

class FullMapPage extends EPage{
  FullMapPage(this.station, this.route) : super(const Icon(Icons.map), 'Full screen map');
  List<Station> station;
  String route;

  @override
  Widget build(BuildContext context) {
    return FullMap(this.station, this.route);
  }
}

class FullMap extends StatefulWidget {
  FullMap(this.station, this.route);
  List<Station> station;
  String route;

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  static LatLng center = LatLng(21.03786, 105.78163);

  WeMapDirections directionAPI = WeMapDirections();
  WeMapController mapController;
  int searchType = 1; //Type of search bar
  String searchInfoPlace = "Tìm kiếm ở đây"; //Hint text for InfoBar
  LatLng myLatLng = LatLng(21.03708, 105.78227);
  bool reverse = true;
  WeMapPlace place;
  Symbol _selectedSymbol;
  int _tripDistance = 0;
  int _tripTime = 0;
  int count = 0;
  LatLng start;
  LatLng destination;
  bool isMarked = false;

  @override
  void initState() {
    int stationLenght = widget.station.length;
    start = LatLng(widget.station[0].geo.Lat, widget.station[0].geo.Lng);
    destination = LatLng(widget.station[stationLenght - 1].geo.Lat, widget.station[stationLenght - 1].geo.Lng);
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

  void _add(String iconImage, LatLng point) {

    mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          point.latitude,
          point.longitude,
        ),
        iconImage: iconImage,
        iconSize: 0.3,
      ),
    );
  }

  void onStyleLoadedCallback() async {
    List<LatLng> points = [];

    points.add(start);
    for (var i = 1; i < widget.station.length - 1; i++) {
      points.add(LatLng(widget.station[i].geo.Lat, widget.station[i].geo.Lng));
    }
    points.add(destination); //destination Point

    final json = await directionAPI.getResponseMultiRoute(0, points); //0 = car, 1 = bike, 2 = foot
    List<LatLng> _route = directionAPI.getRoute(json);
    List<LatLng> _waypoins = directionAPI.getWayPoints(json);

    setState(() {
      _tripDistance = directionAPI.getDistance(json);
      _tripTime = directionAPI.getTime(json);
    });

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
    String busRoute = widget.route;

    if (count > 0 && isMarked == false) {
      print("true");
      _add("images/mark-location.png", start);
      _add("images/mark-location.png", destination);
      for (var i = 1; i< widget.station.length - 1; i++) {
        _add("images/mark-location.png", LatLng(widget.station[i].geo.Lat, widget.station[i].geo.Lng));
      }
      isMarked = true;
    }

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
              target: destination,
              zoom: 16.0,
            ),
            destinationIcon: "images/destination.png",
          ),
          WeMapSearchBar(
            location: myLatLng,
            onSelected: (_place) {
              setState(() {
                place = _place;
              });
              mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: place?.location, zoom: 14.0),
                ),
              );
              mapController.showPlaceCard?.call(place);
            },
            onClearInput: () {
              setState(() {
                place = null;
                mapController.showPlaceCard?.call(place);
              });
            },
          ),
          Padding(
              padding: EdgeInsets.only(top: 570, left: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(busRoute,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Ionicons.arrow_forward_circle, color: Colors.blue,),
                        Column(
                          children: [
                            Text("       Quãng đường:", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                            Text(" " + (_tripDistance/1000.0).toStringAsPrecision(3) + " km", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                          ],
                        ),
                        Column(
                          children: [
                            Text("    Thời gian:", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                            Text(" " + (_tripTime/100/3600).toStringAsPrecision(2) + " giờ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
          )
        ],
      ),
    );
  }
}

