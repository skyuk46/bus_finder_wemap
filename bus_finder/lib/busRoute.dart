import 'package:bus_finder/full_map.dart';
import 'package:bus_finder/line.dart';
import 'package:bus_finder/map_ui.dart';
import 'package:bus_finder/place_geojson.dart';
import 'package:bus_finder/place_symbol.dart';
import 'package:bus_finder/route.dart';
import 'package:bus_finder/simpleDirection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ionicons/ionicons.dart';

class busRoute extends StatefulWidget {

  busRoute(this.route);
  String route;

  _busRoute createState() => new _busRoute();
}

List<String> routeList = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'];

class _busRoute extends State<busRoute> {
  String busRouteNumber = "";
  int _counter = 0;
  Widget widget1 = Row();
  Widget widget2 = Row();

  _navigateBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  _navigateToMapUi(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    /* final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.GRANTED) {
      await location.requestPermission();
    } */

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => new FullMapPage(busRouteNumber)));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.route == "01 - Bến xe Gia Lâm - Bến xe Yên Nghĩa    >") {
      busRouteNumber = "01";
    }
    else if (widget.route == "02 - Bác Cổ - Bến xe Yên Nghĩa    >") {
      busRouteNumber = "02";
    }
    else if (widget.route == "03A - Bến xe Giáp Bát - Bến xe Gia Lâm    >") {
      busRouteNumber = "03A";
    }
    else if (widget.route == "03B - Bến xe Nước Ngầm - Long Biên    >") {
      busRouteNumber = "03B";
    }
    else if (widget.route == "04 - Long Biên - Bệnh viện nội tiết TW CS2    >") {
      busRouteNumber = "04";
    }
    else if (widget.route == "05 - KĐT Linh Đàm - Phú Diễn    >") {
      busRouteNumber = "05";
    }
    else if (widget.route == "06A - Bến xe Giáp Bát - Cầu Giẽ    >") {
      busRouteNumber = "06A";
    }
    else if (widget.route == "06B - Bến xe Giáp Bát - Hồng Vân    >") {
      busRouteNumber = "06B";
    }
    else if (widget.route == "06C - Bến xe Giáp Bát - Phú Minh    >") {
      busRouteNumber = "06C";
    }
    else if (widget.route == "06D - Bến xe Giáp Bát - Tân Dân    >") {
      busRouteNumber = "06D";
    }
    else if (widget.route == "07 - Cầu Giấy - Nội Bài    >") {
      busRouteNumber = "07";
    }
    else if (widget.route == "08A - Long Biên - Đông Mỹ    >") {
      busRouteNumber = "08A";
    }
    else if (widget.route == "08B - Long Biên - Vạn Phúc    >") {
      busRouteNumber = "08B";
    }
    else if (widget.route == "09A - Bờ Hồ - Cầu Giấy    >") {
      busRouteNumber = "09A";
    }
    else if (widget.route == "09B - Bờ Hồ - Bến xe Mỹ Đình    >") {
      busRouteNumber = "09B";
    }
    else if (widget.route == "100 - Long Biên - Khu đô thị Đặng Xá    >") {
      busRouteNumber = "100";
    }
    else if (widget.route == "101A - Bến xe Giáp Bát - Vân Đình    >") {
      busRouteNumber = "101A";
    }
    else if (widget.route == "102 - Bến xe Yên Nghĩa - Vân Đình    >") {
      busRouteNumber = "102";
    }

    CollectionReference users = FirebaseFirestore.instance.collection('busRoute');

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
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(busRouteNumber).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            String title = "Tuyến: " + widget.route;
            title = title.substring(0, title.length -1);

            if (_counter == 0) {
              widget1 = Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.only(top: 20,bottom: 20),
                    child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                ),
              );

              widget2 = busStop(data);
            }
            else if (_counter == 2) {
              widget1 = Container();
              widget2 = routeContent(data);
            }
            else if (_counter == 3) {
              widget1 = busTime(data, "go");
              widget2 = busTime(data, "back");
            }
            
            return ListView(
              children: <Widget>[
                widget1,
                Divider(),
                widget2,
                BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _counter,
                    onTap: (int index) {
                      if (index == 1) {
                        _navigateToMapUi(context);
                        setState(() => _counter = index);
                      }
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
                          icon: Icon(Ionicons.alarm_outline),
                          label: "Giờ"
                      ),
                    ]
                )
              ],
            );
          }
          return Text("loading");
        },
      ),
    );
  }
}

class busStop extends StatelessWidget {
  
  busStop(this.data);
  Map<String, dynamic> data;
  
  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 470,
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: routeList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Ionicons.arrow_down, color: Colors.green,),
              title: Text(data[routeList[index]]),
              trailing: Icon(Ionicons.walk, color: Colors.blue,),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )
    );
  }
}

class routeContent extends StatelessWidget {
  routeContent(this.data);
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 530,
      child: Padding(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Đơn vị chủ quản: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Text(data["manager"],style: TextStyle(fontSize: 16),),
              Divider(),
              Text("Giá vé: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Text(data["price"],style: TextStyle(fontSize: 16),),
              Divider(),
              Text("Tần suất chạy: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Text(data["frequency"],style: TextStyle(fontSize: 16),),
              Divider(),
              Text("Lộ trình (chiều đi): ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Text(data["go route"],style: TextStyle(fontSize: 16),),
              Divider(),
              Text("Lộ trình (chiều về): ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Text(data["back route"],style: TextStyle(fontSize: 16),),
              Divider(),
            ],
          ),
        )
      ),
    );
  }
}

class busTime extends StatelessWidget {
  busTime(this.data, this.direction);
  Map<String, dynamic> data;
  String direction;

  @override
  Widget build(BuildContext context) {
    String title = "",span1 = "", span2 = "", span3 = "";
    if (direction == "go") {
      title = "Chiều Bến xe" + data["stop 1"];
      span1 = "T2-T6";
      span2 = "T7";
      span3 = "CN";
    }
    else if (direction == "back") {
      title = "Chiều Bến xe" + data["stop 2"];
      span1 = "T2-T6-back";
      span2 = "T7-back";
      span3 = "CN-back";
    }

    return Container(
      child: Column(
        children: [
          SizedBox(height: 86),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Thứ 2-6: "),
              Text(data[span1], style: TextStyle(fontStyle: FontStyle.italic),)
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Thứ 7: "),
              Text(data[span2], style: TextStyle(fontStyle: FontStyle.italic),)
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Chủ nhật: "),
              Text(data[span3], style: TextStyle(fontStyle: FontStyle.italic),)
            ],
          ),
          SizedBox(height: 86,)
        ],
      ),
    );
  }
}
