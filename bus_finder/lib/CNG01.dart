import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CNG01 extends StatelessWidget {
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
          title: Text("Tuyến Bus CNG01")
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
                          child: Text("Lộ trình chiều đi tuyến: CNG01", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                    ),
                    Text("1 Điểm cuối bến xe Mỹ Đình"),
                    Text("2 Ngã tư Phạm Hùng - Đình Thôn (cột sau)"),
                    Text("3 Nhà CT5 - KĐT Sông Đà (Mỹ Đình) - Phạm Hùng"),
                    Text("4 Ngã Tư Phạm Hùng - Mễ Trì"),
                    Text("5 Chung cư Golden Palace - Mễ Trì"),
                    Text("6 Cầu vượt Phú Đô"),
                    Text("7 Xóm La - Đại Mỗ"),
                    Text("8 Đường vào trường THPT Đại Mỗ"),
                    Text("9 Làng Miêu Nha"),
                    Text("10 Thiên đường Bảo Sơn"),
                    Text("11 Cầu vượt An Khánh"),
                    Text("12 Đông y dược Bảo Long"),
                    Text("13 Chùa Bà - An Khánh"),
                    Text("14 Đê Song Phương"),
                    Text("15 Cầu Phương Bản"),
                    Text("16 Làng văn hóa thôn Quyết Tiến"),
                    Text("17 Chùa Sơn Trung - xã Yên Sơn "),
                    Text("18 Ngã ba chùa Thầy"),
                    Text("19 KĐT Sunny Garden"),
                    Text("20 Quỹ tín dụng nhân dân Sài Sơn"),
                    Text("21 Chùa Thầy"),
                    Text("22 Trường THCS Sài Sơn"),
                    Text("23 Cây xăng Liên Hiệp"),
                    Text("24 Thôn 3 - xã Dị Nậu"),
                    Text("25 Xã Canh Nậu"),
                    Text("26 Thôn 8 - xã Hương Ngải"),
                    Text("27 Sân bóng Hương Ngải"),
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
                        child: Text("Lộ trình chiều về tuyến: CNG01", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Text("1 Điểm cuối bến xe Sơn Tây"),
                    Text("2 Ngã ba chùa Thông "),
                    Text("3 Đội quản lý giao thông 4"),
                    Text("4 Trường hữu nghị T78"),
                    Text("5 KCN cụm 8 - thị trấn Phúc Thọ"),
                    Text("6 Bưu điện Phúc Thọ"),
                    Text("7 UBND huyện Phúc Thọ"),
                    Text("8 Công an huyện Phúc Thọ"),
                    Text("9 Ngã ba Cẩm Thanh"),
                    Text("10 Ngã tư Ngọc Lâu"),
                    Text("11 Làng Đại Đồng"),
                    Text("12 Phố Cấm - xã Phú Kim"),
                    Text("13 Làng Phú Nghĩa"),
                    Text("14 Ngã ba thị trấn Liên Quan"),
                    Text("15 UBND huyện Thạch Thất"),
                    Text("16 Xã Đồng Cam"),
                    Text("17 Công an huyện Thạch Thất"),
                    Text("18 Sân bóng Hương Ngải"),
                    Text("19 Thôn 8 - xã Hương Ngải"),
                    Text("20 Xã Canh Nậu"),
                    Text("21 Thôn 3 - xã Dị Nậu"),
                    Text("22 Cây xăng Liên Hiệp"),
                    Text("23 Trường THCS Sài Sơn"),
                    Text("24 Chùa Thầy"),
                    Text("25 Quỹ tín dụng nhân dân Sài Sơn"),
                    Text("26 KĐT Sunny Garden"),
                    Text("27 UBND xã Yên Sơn"),
                    Text("28 Xã Vân Côn - Hoài Đức"),
                    Text("29 Cầu Phương Bản"),
                    Text("30 Đê Song Phương"),
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