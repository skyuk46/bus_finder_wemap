import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CNG03 extends StatelessWidget {
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
          title: Text("Tuyến Bus CNG03")
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
                      child: Text("Lộ trình chiều đi tuyến: CNG03", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text("1 Điểm cuối Bệnh viện Bệnh nhiệt đới Trung ương (cơ sở 2)"),
                  Text("2 Chợ Mun"),
                  Text("3 Cổng KCN Bắc Thăng Long"),
                  Text("4 Đường vào Xóm Đoài"),
                  Text("5 Xã Kim Nỗ"),
                  Text("6 Đầm Vân Trì"),
                  Text("7 Thôn Ngọc Chi"),
                  Text("8 Ngã tư Vĩnh Ngọc - Võ Nguyên Giáp"),
                  Text("9 Công an quận Tây Hồ"),
                  Text("10 KĐT Nam Thăng Long"),
                  Text("11 Phòng Cảnh sát Phòng cháy chữa cháy - Công an Thành Phố"),
                  Text("12 Bệnh viện tim Hà Nội (cơ sở 2)"),
                  Text("13 Ngã tư Xuân La - Võ Chí Công"),
                  Text("14 Nhà thi đấu quận Tây Hồ"),
                  Text("15 Trung đoàn Cảnh sát cơ động - công an Thành phố"),
                  Text("16 Cầu vượt đi bộ Võ Chí Công"),
                  Text("17 Ngã ba Hoàng Quốc Việt"),
                  Text("18 Ngã ba Đội Cấn"),
                  Text("19 UBND phường Cống Vị"),
                  Text("20 Chợ Cống Vị"),
                  Text("21 Viện Hàn lâm Khoa học xã hội Việt Nam"),
                  Text("22 Trường quốc tế Hà Nội"),
                  Text("23 Ngã ba Kim Mã - Ngọc Khánh"),
                  Text("24 UBND phường Kim Mã"),
                  Text("25 Tòa nhà PTA - số 1 Kim Mã"),
                  Text("26 145 Nguyễn Thái Học - sân vận động Hàng Đẫy"),
                  Text("27 Trường tiểu học Lý Thường Kiệt "),
                  Text("28 116 Lê Duẩn - ga Hà Nội"),
                  Text("29 Cung văn hóa hữu nghị Việt - Xô"),
                  Text("30 67 Trần Hưng Đạo - thư viện Hà Nội"),
                  Text("31 Bệnh viện Mắt Trung ương"),
                  Text("32 Bệnh viện Mắt Trung ương"),
                  Text("33 TTTM Vincom Bà Triệu"),
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
                      child: Text("Lộ trình chiều về tuyến: CNG03", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Text("1 Điểm cuối khu đô thị Times City"),
                  Text("2 KĐT Times City"),
                  Text("3 423 Minh Khai"),
                  Text("4 Cầu Mai Động"),
                  Text("5 Cầu Mai Động"),
                  Text("6 Tập thể E6 Quỳnh Mai"),
                  Text("7 Bệnh viện Thanh Nhàn"),
                  Text("8 Ngã ba Võ Thị Sáu - Công viên Tuổi trẻ"),
                  Text("9 55 Võ Thị Sáu - công viên Tuổi trẻ"),
                  Text("10 Chợ Hòa Bình"),
                  Text("11 Ngã tư Phố Huế - Nguyễn Công Trứ"),
                  Text("12 Trường THCS Ngô Sĩ Liên"),
                  Text("13 54E Trần Hưng Đạo - Thư viện Hà Nội"),
                  Text("14 Bộ Giao thông vận tải"),
                  Text("15 Chùa Quán Sứ"),
                  Text("16 Cửa Nam"),
                  Text("17 Cột cờ Hà Nội"),
                  Text("18 60 Trần Phú - Bệnh viện Saint Paul"),
                  Text("19 140 Sơn Tây - Bến xe Kim Mã"),
                  Text("20 UBND phường Kim Mã"),
                  Text("21 Ngã ba Kim Mã - Vạn Bảo"),
                  Text("22 Đại sứ quán Nhật Bản"),
                  Text("23 Bệnh viện Hàn lâm Khoa học Xã hội Việt Nam"),
                  Text("24 Chợ Cống Vị"),
                  Text("25 Bảo tàng Pháo Binh"),
                  Text("26 Ngõ 378 đường Bưởi"),
                  Text("27 66 đường Bưởi"),
                  Text("28 Cầu vượt đi bộ Võ Chí Công"),
                  Text("29 Trung đoàn Cảnh sát cơ động - Công an Thành phố"),
                  Text("30 Nhà thi đấu quận Tây Hồ"),
                  Text("31 Ngã tư Xuân La - Võ Chí Công"),
                  Text("32 Khu liên cơ quan sở, ngành Hà Nội"),
                  Text("33 Phòng Cảnh sát Phòng cháy chữa cháy - Công an Thành Phố"),
                  Text("34 KĐT Nam Thăng Long"),
                  Text("35 Công an quận Tây Hồ"),
                  Text("36 Ngã tư Vĩnh Ngọc - Võ Nguyên Giáp"),
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