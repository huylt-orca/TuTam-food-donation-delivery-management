

import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/data/app_banner.dart';
import 'package:food_donation_delivery_app/models/activity.dart';
import 'package:food_donation_delivery_app/models/post_list.dart';
import 'package:food_donation_delivery_app/screens/bottom_bar.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/image_for_delivery_unit.dart';
import 'package:food_donation_delivery_app/screens/main/delivery_requests_screen.dart';
import 'package:food_donation_delivery_app/screens/post/posts_screen.dart';
import 'package:food_donation_delivery_app/services/activity_service.dart';
import 'package:food_donation_delivery_app/services/post_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_card.dart';
import 'package:food_donation_delivery_app/widgets/activity/shimmer_activity_card.dart';
import 'package:food_donation_delivery_app/widgets/home/app_banner_card.dart';
import 'package:food_donation_delivery_app/widgets/post/post_card.dart';
import 'package:food_donation_delivery_app/widgets/post/shimmer_post_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../widgets/indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBanner = 0;
  List<Activity> _activities = List.empty(growable: true);
  List<PostList> _posts = List.empty(growable: true);
  bool _isLoadingActivity = true;
  bool _isLoadingPost = true;
  // final ListPermissionController _listPermissionController = Get.find();
  final UserController _userController = Get.find();

  void _getData() {
    ActivityService.fetchActivitiesList(pageSize: 4).then((value) {
      _activities = value;
      setState(() {
        _isLoadingActivity = false;
      });
    });
    PostService.fetchPostList(pageSize: 5).then((value) {
      _posts = value;
      setState(() {
        _isLoadingPost = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getData();
    // print(_listPermissionController.hasPermittedPermission('READ-POST'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConfig.TITLE,
                  style: TextStyle(
                      color: AppTheme.primarySecond,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip),
                ),
              ],
            ),
          ),
          leading: const Padding(
            padding: EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 2.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/myassets/logo_capstone.png'),
            ),
          ),
          actions: <Widget>[
    //         IconButton(
    //             onPressed: () async {
    //               // StoreRedirect.redirect(
    //               //   androidAppId: 'com.garena.game.kgvn&hl=vi'
    //               // );
                  
    // //                final image = await ImagePicker().pickImage(source: ImageSource.camera);
    // //                if (image == null) return;

    // //                  Position position = await Geolocator.getCurrentPosition(
    // //                 desiredAccuracy: LocationAccuracy.high,
    // //               );
    // //   DateTime now = DateTime.now();

    // //    var imageRead = img.decodeImage(await File(image.path).readAsBytes());

    // //   img.drawString(imageRead!, '${position.latitude},${position.longitude}', font: img.arial48,x:10, y:20, color: img.ColorRgb8(255, 0, 0));
    // //   img.drawString(imageRead, now.toString(), font: img.arial48,x:10, y:70, color: img.ColorRgb8(255, 0, 0));

    // //                 // Lưu ảnh mới vào tập tin tạm thời
    // // final tempDir = await getTemporaryDirectory();
    // // File tempImage =  File('${tempDir.path}/temp_image.png')
    // //   ..writeAsBytesSync(img.encodePng(imageRead));

    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => ImageForDeliveryUnit(
    //                         idDeliveryRequest: '',
    //                       )),
    //                 );

    //             },
    //             icon: const Icon(Icons.new_releases)),
                
            !_userController.collaboratorStatus.value ? const SizedBox() :
            IconButton(
                icon: Image.asset('assets/myassets/shipper.jpg'),
              // icon: const Icon(
              //   Icons.motorcycle,
              //   size: 30,
              //   color: Colors.black87,
              // ),
              onPressed: () async {
                try {
                  DialogHelper.showLoading(context);
                  LocationPermission permission =
                      await Geolocator.requestPermission();

                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
                  bool isLocationServiceEnabled =
                      await Geolocator.isLocationServiceEnabled();

                  if(!context.mounted) return;
                  DialogHelper.hideLoading(context);

                  if (isLocationServiceEnabled) {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeliveryRequestsScreen()),
                    );
                  } else {

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Vui lòng bật GPS'),
                          content: const Text('Ứng dụng cần GPS để lấy tọa độ.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Đóng'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  DialogHelper.hideLoading(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Vui lòng cấp quyền truy cập vị trí'),
                        content: const Text(
                            'Ứng dụng cần quyền truy cập vị trí để lấy tọa độ.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Đóng'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Mở cài đặt'),
                            onPressed: () async {
                              await Geolocator.openAppSettings();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              height: 125,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _selectedBanner = index;
                  });
                },
                controller: PageController(viewportFraction: 1),
                itemCount: appBannerList.length,
                itemBuilder: (context, index) {
                  return AppBannerCard(appBanner: appBannerList[index]);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    appBannerList.length,
                    (index) => Indicator(
                          isActive: _selectedBanner == index ? true : false,
                        ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Các hoạt động đang diễn ra',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  GestureDetector(
                    child: const Text(
                      'Xem thêm',
                      style: TextStyle(
                        color: AppTheme.primarySecond,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomBar(
                            currentTab: 1,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              height: 166,
              child: _isLoadingActivity
                  ? const ShimmerActivityCard()
                  : PageView.builder(
                      controller: PageController(viewportFraction: 1),
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 350),
                          tween: Tween(begin: 1, end: 1),
                          curve: Curves.ease,
                          child: ActivityCard(activity: _activities[index]),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value.toDouble(),
                              child: child,
                            );
                          },
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Các bài đăng',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  GestureDetector(
                    child: const Text(
                      'Xem thêm',
                      style: TextStyle(
                        color: AppTheme.primarySecond,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostsScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _isLoadingPost ? 2 : _posts.length,
              itemBuilder: (context, index) =>
                  _isLoadingPost ? const ShimmerPostCard() : PostCard(post: _posts[index],), 
              separatorBuilder: (BuildContext context, int index) {
                 return Divider(color: Colors.grey.shade500, thickness: 4,);
                },
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppTheme.primarySecond),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(70.0, 30.0),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
