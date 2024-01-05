import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/notification_controller.dart';
import 'package:food_donation_delivery_app/screens/main/activities_screen.dart';
import 'package:food_donation_delivery_app/screens/main/home_screen.dart';
import 'package:food_donation_delivery_app/screens/main/information_screen.dart';
import 'package:food_donation_delivery_app/screens/main/items_screen.dart';
import 'package:food_donation_delivery_app/screens/main/notification_screen.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  final int currentTab;
  const BottomBar({super.key, this.currentTab = 0});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // final NotificationController _notificationController = Get.find();
  int _currentTab = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const ActivitiesScreen(),
    const NotificationScreen(),
    const InformationScreen(),
    const ItemsScreen()
  ];

  final PageStorageBucket _bucket = PageStorageBucket();
  Widget _currentScreen = const HomeScreen();

  @override
  void initState() {
    super.initState();
    _currentTab = widget.currentTab;
    _currentScreen = _screens[_currentTab];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PageStorage(
          bucket: _bucket,
          child: _currentScreen,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            _currentTab == 4 ? AppTheme.primarySecond : AppTheme.bottomBarColor,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: _currentTab == 4 ? Colors.white : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _currentScreen = _screens[4];
            _currentTab = 4;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            _currentScreen = _screens[0];
                            _currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color: _currentTab == 0
                                  ? AppTheme.primarySecond
                                  : Colors.grey,
                            ),
                            Text(
                              'Trang chủ',
                              style: TextStyle(
                                fontSize: 10,
                                color: _currentTab == 0
                                    ? AppTheme.primarySecond
                                    : Colors.grey,
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            _currentScreen = _screens[1];
                            _currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.handHoldingHeart,
                              color: _currentTab == 1
                                  ? AppTheme.primarySecond
                                  : Colors.grey,
                            ),
                            Text(
                              'Hoạt động',
                              style: TextStyle(
                                fontSize: 10,
                                color: _currentTab == 1
                                    ? AppTheme.primarySecond
                                    : Colors.grey,
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            _currentScreen = _screens[2];
                            _currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             GetBuilder<NotificationController>(
                               builder: (notificationController) {
                                 return Badge.count(
                                      isLabelVisible: notificationController.number.value != 0,
                                      count: notificationController.number.value,
                                      child: Icon(
                                        FontAwesomeIcons.bell,
                                        color: _currentTab == 2
                                            ? AppTheme.primarySecond
                                            : Colors.grey,
                                      ),
                            );
                               }
                             ),
                            Text(
                              'Thông báo',
                              style: TextStyle(
                                fontSize: 10,
                                color: _currentTab == 2
                                    ? AppTheme.primarySecond
                                    : Colors.grey,
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _currentScreen = _screens[3];
                          _currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: _currentTab == 3
                                ? AppTheme.primarySecond
                                : Colors.grey,
                          ),
                          Text(
                            'Cá nhân',
                            style: TextStyle(
                              fontSize: 10,
                              color: _currentTab == 3
                                  ? AppTheme.primarySecond
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
