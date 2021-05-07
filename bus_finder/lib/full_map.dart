import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:ionicons/ionicons.dart';

import 'ePage.dart';

class FullMapPage extends EPage{
  FullMapPage(this.busRouteNumber) : super(const Icon(Icons.map), 'Full screen map');
  String busRouteNumber = "";

  @override
  Widget build(BuildContext context) {
    return FullMap(this.busRouteNumber);
  }
}

class FullMap extends StatefulWidget {
  FullMap(this.busRouteNumber);
  String busRouteNumber;

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

  void _add(String iconImage) {
    mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconImage: iconImage,
        iconSize: 0.3,
      ),
    );
  }

  void onStyleLoadedCallback() async {
    List<LatLng> points = [];

    points.add(start); //origin Point
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
    String busRoute = "";
    if (widget.busRouteNumber == "01") {
      start = LatLng(21.04863, 105.87832);
      destination = LatLng(20.95002, 105.74746);
      busRoute = "01 - Yên Nghĩa - Gia Lâm";
    }
    else if (widget.busRouteNumber == "02") {
      start = LatLng(21.02556, 105.85947);
      destination = LatLng(20.95002, 105.74746);
      busRoute = "02 - Bác Cổ - Yên Nghĩa";
    }
    else if (widget.busRouteNumber == "03A") {
      start = LatLng(20.98035, 105.84178);
      destination = LatLng(20.95002, 105.74746);
      busRoute = "03A - Giáp Bát - Gia Lâm";
    }
    else if (widget.busRouteNumber == "03B") {
      start = LatLng(20.96509, 105.84306);
      destination = LatLng(21.03844, 105.89592);
      busRoute = "03B - Nước Ngầm - Long Biên";
    }
    else if (widget.busRouteNumber == "04") {
      start = LatLng(21.03844, 105.89592);
      destination = LatLng(21.01341, 105.81485);
      busRoute = "04 - Long Biên - Bệnh viện nội tiết TW CS2";
    }
    else if (widget.busRouteNumber == "05") {
      start = LatLng(20.96610, 105.83431);
      destination = LatLng(21.04285, 105.75962);
      busRoute = "05 - KĐT Linh Đàm - Phú Diễn";
    }
    else if (widget.busRouteNumber == "06A") {
      start = LatLng(20.98035, 105.84178);
      destination = LatLng(20.84646, 105.88556);
      busRoute = "06A - Giáp Bát - Cầu Giẽ";
    }
    else if (widget.busRouteNumber == "06B") {
      start = LatLng(20.98035, 105.84178);
      destination = LatLng(20.87580, 105.90764);
      busRoute = "06B - Giáp Bát - Hồng Vân";
    }
    else if (widget.busRouteNumber == "06C") {
      start = LatLng(20.98035, 105.84178);
      destination = LatLng(20.78112, 105.91660);
      busRoute = "06C - Giáp Bát - Phú Minh";
    }
    else if (widget.busRouteNumber == "06D") {
      start = LatLng(20.98035, 105.84178);
      destination = LatLng(20.74233, 105.88029);
      busRoute = "06D - Giáp Bát - Tân Dân";
    }
    else if (widget.busRouteNumber == "07") {
      start = LatLng(21.03484, 105.79613);
      destination = LatLng(21.21890, 105.80421);
      busRoute = "07 - Cầu Giấy - Nội Bài";
    }
    else if (widget.busRouteNumber == "08A") {
      start = LatLng(21.04277, 105.84825);
      destination = LatLng(20.91671, 105.87242);
      busRoute = "08A - Long Biên - Đông Mỹ";
    }
    else if (widget.busRouteNumber == "08B") {
      start = LatLng(21.04277, 105.84825);
      destination = LatLng(20.91168, 105.89127);
      busRoute = "08B - Long Biên - Vạn Phúc";
    }
    else if (widget.busRouteNumber == "09A") {
      start = LatLng(21.02865, 105.85125);
      destination = LatLng(21.03484, 105.79613);
      busRoute = "09A - Bờ Hồ - Cầu Giấy";
    }
    else if (widget.busRouteNumber == "09B") {
      start = LatLng(21.02865, 105.85125);
      destination = LatLng(21.03593, 105.77969);
      busRoute = "09B - Bờ Hồ - Mỹ Đình";
    }
    else if (widget.busRouteNumber == "100") {
      start = LatLng(21.04277, 105.84825);
      destination = LatLng(21.01637, 105.95220);
      busRoute = "100 - Long Biên - Khu đô thị Đặng Xá";
    }
    else if (widget.busRouteNumber == "101A") {
      start = LatLng(20.98035, 105.84178);
      destination = LatLng(20.73306, 105.77041);
      busRoute = "101A - Giáp Bát - Vân Đình";
    }
    else if (widget.busRouteNumber == "102") {
      start = LatLng(20.95002, 105.74746);
      destination = LatLng(20.73306, 105.77041);
      busRoute = "102 - Yên Nghĩa - Vân Đình";
    }

    if (count > 0 && isMarked == false) {
      center = start;
      _add("images/mark-location.png");
      center = destination;
      _add("images/mark-location.png");
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
              target: start,
              zoom: 14.0,
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
                    Text("Tuyến " + busRoute,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
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