import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/screens/bottom_bar.dart';
import 'package:food_donation_delivery_app/screens/collaborator/collaborator_register_screen.dart';

class AppBanner {
  int id;
  String textButton;
  String titlte;
  Color color = Colors.blue;
  Widget widget;

  AppBanner(this.id, this.textButton ,this.titlte,this.color, this.widget);
}

List<AppBanner> appBannerList = [
  AppBanner(1,'Quyên góp', 'Cùng Nhau Góp Đồ và Thực Phẩm Cho Một Cuộc Sống Tươi Đẹp Hơn!',Colors.blue, const BottomBar(currentTab: 4,),),
  AppBanner(2,'Tham gia' ,'Cùng Cộng Đồng Góp Sức Xây Tạo Một Thế Giới Tốt Đẹp Hơn!',Colors.red, const BottomBar(currentTab: 1,)),
  AppBanner(3,'Dăng ký' ,'Cùng Nhau Mang Đồ Đến Nơi Cần Đến, Đăng Ký Hỗ Trợ Vận Chuyển!', Colors.greenAccent, const CollaboratorRegisterScreen()),

];