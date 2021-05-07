import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CNG04 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Ionicons.arrow_back),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          backgroundColor: Colors.green,
          title: Text("Tuyến Bus CNG04")
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Dữ liệu về các điểm dừng, thời gian hoạt động, giá vé đang bị thiếu. Chúng tôi đang chờ tìm nguồn dữ liệu đầy đủ để cập nhật.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Lộ trình chiều đi tuyến: CNG04", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text("1 Điểm cuối bãi đỗ xe Cầu Giấy"),
                  Text("2 ĐH giao thông vận tải - cột trước"),
                  Text("3 1166 đường Láng - cầu Yên Hòa"),
                  Text("4 1014 đường Láng - cầu Cót"),
                  Text("5 Cầu 361"),
                  Text("6 Cầu Trung Hòa"),
                  Text("7 Chợ Láng Hạ B"),
                  Text("8 Cầu Cống Mọc"),
                  Text("9 348 đường Láng"),
                  Text("10 Ngã tư Sở"),
                  Text("11 94 Nguyễn Trãi"),
                  Text("12 Chợ Thượng Đình"),
                  Text("13 ĐH Khoa học tự nhiên"),
                  Text("14 Cục Sở hữu Trí Tuệ"),
                  Text("15 Viện công nghệ Thực phẩm Trung ương"),
                  Text("16 262 Nguyễn Xiển"),
                  Text("17 Nguyễn Xiển - Nghiêm Xuân Yêm"),
                  Text("18 ĐH Thăng Long"),
                  Text("19 Trung tâm Huấn luyện thể thao Công an nhân dân"),
                  Text("20 Xóm Chùa Nhĩ - Kim Giang"),
                  Text("21 UBND xã Thanh Liệt"),
                  Text("22 Chùa Long Quang"),
                  Text("23 Cầu Tó - Kim Giang"),
                  Text("24 Trung tâm Giáo dục thường xuyên huyện Thanh Trì"),
                  Text("25 Nghĩa trang Văn Điển"),
                  Text("26 Ngã ba đường vào Tam Hiệp"),
                  Text("27 Điểm cuối Tam Hiệp (Thanh Trì)"),
                ],
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Lộ trình chiều về tuyến: CNG04", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text("1 Điểm cuối Tam Hiệp (Thanh Trì)"),
                  Text("2 Ngã ba đường vào Tam Hiệp"),
                  Text("3 Nghĩa trang Văn Điển"),
                  Text("4 Trung tâm Giáo dục thường xuyên huyện Thanh Trì "),
                  Text("6 Cầu Tó - Kim Giang"),
                  Text("7 chùa Long Quang"),
                  Text("8 Xóm chùa Nhĩ - Kim Giang"),
                  Text("9 Trung tâm Huấn luyện thể thao Công an nhân dân"),
                  Text("10 ĐH Thăng Long"),
                  Text("11 Ngã ba Nguyễn Xiển - Hoàng Đạo Thành"),
                  Text("12 Tập thể Cao su Sao Vàng - Nguyễn Xiển"),
                  Text("13 Viện Công nghệ thực phẩm Trung ương"),
                  Text("14 Giày Thượng Đình"),
                  Text("15 ĐH Khoa học tự nhiên"),
                  Text("16 Ngã ba Kim Giang - chợ Thượng Đình"),
                  Text("17 Sân vận động Thượng Đình"),
                  Text("18 65 Nguyễn Trãi"),
                  Text("19 Ngã tư Sở"),
                  Text("20 Trường Đảng Lê Hồng Phong"),
                  Text("21 Cầu Cổng Mọc"),
                  Text("22 Chợ Láng Hạ A"),
                  Text("23 764 đường Láng - cầu 361"),
                  Text("24 1014 đường Láng - cầu Cót"),
                  Text("25 1152D đường Láng - cầu Yên Hòa"),
                  Text("26 ĐH Giao thông vận tải - cột sau"),
                  Text("27 Điểm cuối Bãi đỗ xe Cầu Giấy"),
                ],
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
          )
        ],
      ),
    );
  }
}