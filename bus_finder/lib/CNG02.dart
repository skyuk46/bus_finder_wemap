import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CNG02 extends StatelessWidget {
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
          title: Text("Tuyến Bus CNG02")
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
                      child: Text("Lộ trình chiều đi tuyến: CNG02", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text("1 Điểm cuối bến xe Yên Nghĩa"),
                  Text("2 Trường Trung cấp kinh tế - tài chính Hà Nội"),
                  Text("3 Nissan Hà Đông"),
                  Text("4 Ngã ba Ba La"),
                  Text("5 Chợ Văn La"),
                  Text("6 Tòa nhà Lacasta"),
                  Text("7 Sân goft Hà Đông - Văn Phú"),
                  Text("8 34 - 35 TT9 đường Văn Phú"),
                  Text("9 Ngã tư Mậu Lương - Phúc La"),
                  Text("10 Khách sạn Mường Thanh - KĐT Xa La"),
                  Text("11 Nhà CT2B"),
                  Text("12 Cầu Bươu - Bệnh viện K (cơ sở 3)"),
                  Text("13 KĐT Cầu Bươu"),
                  Text("14 KĐT Đại Thanh"),
                  Text("15 Chùa Long Quang "),
                  Text("16 UBND xã Thanh Liệt"),
                  Text("17 Xóm Chùa Nhĩ - Kim Giang"),
                  Text("18 6 Cầu Dậu"),
                  Text("19 Ao sen làng Đại Từ"),
                  Text("20 Nhà văn hóa Đại Từ"),
                  Text("21 Ngã ba Giải Phóng - Linh Đàm"),
                  Text("22 Điểm cuối bến xe Giáp Bát"),
                  Text("23 Kim Đồng"),
                  Text("24 Trường THCS Tân Mai"),
                  Text("25 Công viên Đền Lừ"),
                  Text("26 Chợ đầu mối phía Nam"),
                  Text("27 441 Nguyễn Tam Trinh"),
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
                      child: Text("Lộ trình chiều về tuyến: CNG02", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text("1 Điểm cuối khu đô thị Đặng Xá"),
                  Text("2 Nhà D16"),
                  Text("3 Nhà D5"),
                  Text("4 Nhà A3"),
                  Text("5 Nhà CT8B"),
                  Text("6 Nhà thi đấu Gia Lâm"),
                  Text("7 Bưu cục Trâu Quỳ"),
                  Text("8 Cầu Thanh Trì - Nguyễn Đức Thuận"),
                  Text("9 Ngã ba cầu Thanh Trì - Nguyễn Văn Linh"),
                  Text("10 Công ty May 10"),
                  Text("11 Cây xăng Sài Đồng"),
                  Text("12 Trung tâm sát hạch lái xe Sài Đồng"),
                  Text("13 Ngã tư Trần Danh Tuyên - đường Hoa Hồng"),
                  Text("14 Trường Vinschool"),
                  Text("15 Trường tiểu học Phúc Đồng"),
                  Text("16 Sân goft Long Biên"),
                  Text("17 423 Minh Khai"),
                  Text("18 Cầu Mai Động"),
                  Text("19 Đối diện 63 Nguyễn Tam Trinh"),
                  Text("20 Đối diện 163 Nguyễn Tam Trinh"),
                  Text("21 Cầu KUO"),
                  Text("22 411 Nguyễn Tam Trinh"),
                  Text("23 Chợ đầu mối phía Nam"),
                  Text("24 Công viên Đền Lừ"),
                  Text("25 Trường THCS Tân Mai"),
                  Text("26 Kim Đồng"),
                  Text("27 Đối diện Bến xe Giáp Bát"),
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