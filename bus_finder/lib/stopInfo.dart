import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_finder/busRoute.dart';

class stopInfo extends StatefulWidget {

  stopInfo(this.stop);
  String stop;

  _stopInfo createState() => new _stopInfo();
}

class _stopInfo extends State<stopInfo> {
  CollectionReference users = FirebaseFirestore.instance.collection('busStop');

  @override
  Widget build(BuildContext context) {
    String stop = "";
    if (widget.stop == "Phố Cầu    >") {
      stop = "Phố Cầu";
    }
    else if (widget.stop == "Dốc Vệ Tinh        >") {
      stop = "Dốc Vệ Tinh";
    }
    else if (widget.stop == "Bệnh viện đa khoa Thăng Long    >") {
      stop = "BVĐK Thăng Long";
    }
    else if (widget.stop == "Đại sứ quán Nhật Bản             >") {
      stop = "Sứ quán Nhật Bản";
    }
    else if (widget.stop == "Đình làng Bùng    >") {
      stop = 'Đình làng Bùng';
    }
    else if (widget.stop == "Ngã 3 Đỗ Xá    >") {
      stop = 'Ngã 3 Đỗ Xá';
    }
    else if (widget.stop == "Làng Lương Xá  >") {
      stop = 'Làng Lương Xá';
    }
    else if (widget.stop == "Bệnh viện K Hà Nội    >") {
      stop = "Bệnh viện K Hà Nội";
    }
    else if (widget.stop == "Nhà thi đấu Hà Đông   >") {
      stop = "Nhà thi đấu Hà Đông";
    }
    else if (widget.stop == "Thôn Xuân Tình        >") {
      stop = "Thôn Xuân Tình";
    }
    else if (widget.stop ==   'Đình Nam Dư Hạ        >'){
      stop = "Đình Nam Dư Hạ";
    }
    else if (widget.stop == "Bưu cục Trâu Quỳ      >") {
      stop = "Bưu cục Trâu Quỳ";
    }
    else if (widget.stop == "Đại học Hà Nội        >") {
      stop = "Đại học Hà Nội";
    }
    else if (widget.stop == "Nhà D10        >") {
      stop = "Nhà D10";
    }

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(stop).get(),
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
            return AlertDialog(
              title: Text(data["title"], textAlign: TextAlign.center,),
              content: Wrap(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Có " + data["numberOfRoute"] + " tuyến đi qua", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 200,
                        width: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: int.parse(data["numberOfRoute"]),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text((index + 1).toString()),
                              title: InkWell(
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => new busRoute(data["busRoute" + (index + 1).toString()]))
                                  );
                                },
                                child: Text("Xem tuyến " + data[(index + 1).toString()]),
                              ),
                              trailing: Icon(Ionicons.bus, color: Colors.blue,),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        )
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
