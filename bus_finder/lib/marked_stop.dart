import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'ePage.dart';

class MarkedStopPage extends EPage {
  MarkedStopPage(this.stopLat, this.stopLng) : super(const Icon(Icons.map), 'Full screen map');

  double stopLat;
  double stopLng;

  @override
  Widget build(BuildContext context) {
    return MarkedStop(this.stopLat, this.stopLng);
  }
}

class MarkedStop extends StatefulWidget {
  MarkedStop(this.stopLat, this.stopLng);

  double stopLat;
  double stopLng;

  @override
  State createState() => MarkedStopState();
}

class MarkedStopState extends State<MarkedStop> {
  List<LatLng> points = [];

  WeMapDirections directionAPI = WeMapDirections();
  WeMapController mapController;
  int searchType = 1; //Type of search bar
  LatLng myLatLng = LatLng(21.03708, 105.78227);
  bool reverse = true;
  WeMapPlace place;
  Symbol _selectedSymbol;
  LatLng stopLatLng;

  @override
  void initState() {
    stopLatLng = LatLng(widget.stopLat, widget.stopLng);
  }

  void _onMapCreated(WeMapController controller) {
    mapController = controller;
    mapController.onSymbolTapped.add(_onSymbolTapped);
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
    _add("images/mark-location.png", stopLatLng );

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
              target: stopLatLng,
              zoom: 14.0,
            ),
            destinationIcon: "images/destination.png",
          ),
        ],
      ),
    );
  }
}
