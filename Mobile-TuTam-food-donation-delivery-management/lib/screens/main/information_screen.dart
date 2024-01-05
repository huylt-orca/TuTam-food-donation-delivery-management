import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/screens/account/login_screen.dart';
import 'package:food_donation_delivery_app/screens/activity/my_activities_screen.dart';
import 'package:food_donation_delivery_app/screens/branch/search_branch_unit_screen.dart';
import 'package:food_donation_delivery_app/screens/collaborator/collaborator_infor_screen.dart';
import 'package:food_donation_delivery_app/screens/collaborator/collaborator_register_screen.dart';
import 'package:food_donation_delivery_app/screens/other/app_screen.dart';
import 'package:food_donation_delivery_app/screens/other/help_screen.dart';
import 'package:food_donation_delivery_app/screens/other/privacy_policy_screen.dart';
import 'package:food_donation_delivery_app/screens/other/terms_of_use_screen.dart';
import 'package:food_donation_delivery_app/screens/profile/change_password_screen.dart';
import 'package:food_donation_delivery_app/screens/profile/link_account_screen.dart';
import 'package:food_donation_delivery_app/screens/profile/update_profile_screen.dart';
import 'package:food_donation_delivery_app/screens/statement/statements_screen.dart';
import 'package:food_donation_delivery_app/services/auth_service.dart';
import 'package:food_donation_delivery_app/services/collaborator_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';
import 'package:food_donation_delivery_app/widgets/shortcut_information_widget.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../widgets/profile_menu_widget.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final AuthService _authService = AuthService();
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  _userController.avatar.value,
                  fit: BoxFit.fitHeight,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const ShimmerWidget.circular(
                        width: 120,
                         height: 120);
                      // return CircularProgressIndicator(
                      //   value: loadingProgress.expectedTotalBytes != null
                      //       ? loadingProgress.cumulativeBytesLoaded /
                      //           (loadingProgress.expectedTotalBytes ?? 1)
                      //       : null,
                      // );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _userController.name.value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ShortcutInformationWidget(
                    text: 'Chi nhánh Từ Tâm',
                    icon: Icons.store,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchBranchUnitScreen(),
                        ),
                      );
                    },
                  ),
                  ShortcutInformationWidget(
                    text: 'Tổ chức liên kết',
                    icon: Icons.location_city,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchBranchUnitScreen(
                            selectedOption: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.mainBackground,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  ProfileMenuWidget(
                    title: "Chỉnh sửa thông tin cá nhân",
                    icon: Icons.person,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 75,
                    endIndent: 30,
                    height: 0,
                  ),
                  ProfileMenuWidget(
                    title: "Thay đổi mật khẩu",
                    icon: Icons.linear_scale,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 75,
                    endIndent: 30,
                    height: 0,
                  ),
                  ProfileMenuWidget(
                    title: "Liên kết tài khoản",
                    icon: Icons.link,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LinkAccountScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 75,
                    endIndent: 30,
                    height: 0,
                  ),
                  ProfileMenuWidget(
                    title: "Hoạt động tham gia",
                    icon: FontAwesomeIcons.handHoldingHeart,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            const MyActivitiesScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 75,
                    endIndent: 30,
                    height: 0,
                  ),
                  ProfileMenuWidget(
                    title: "Vật phẩm đã đóng góp",
                    icon: Icons.card_giftcard,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            const StatementsScreen(type: 3, id: ''),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.mainBackground,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  ProfileMenuWidget(
                    title: _userController.collaboratorStatus.value ? "Vận chuyển" : "Đăng ký vận chuyển",
                    icon: FontAwesomeIcons.personBiking,
                    onPress: () async {
                      if (_userController.collaboratorStatus.value){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CollaboratorInforScreen(),
                        ),
                      ); 
                      } else{ 
                        try {
                          DialogHelper.showLoading(context);
                          bool isSend =  await CollaboratorService.checkUserSendCollaboratorApplication();

                          if (!context.mounted) return;
                          DialogHelper.hideLoading(context);

                        if ( isSend) {
                        Fluttertoast.showToast(msg: 'Bạn đã gửi yêu cầu, vui lòng đợi');
                        } else {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const CollaboratorRegisterScreen(),
                        ),
                      );
                      }
                        }
                        catch (error){
                          DialogHelper.hideLoading(context);
                          DialogHelper.showAwesomeDialogError(context, error.toString());
                        }
                        
                      }
                    },
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppTheme.mainBackground,
            //     borderRadius: BorderRadius.circular(16.0),
            //   ),
            //   child: Column(
            //     children: [
            //       ProfileMenuWidget(
            //         title: "Ứng dụng",
            //         icon: FontAwesomeIcons.mobileScreen,
            //         onPress: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (context) => const AppScreen(),
            //           //   ),
            //           // );
            //         },
            //       ),
            //       const Divider(
            //         indent: 75,
            //         endIndent: 30,
            //         height: 0,
            //       ),
            //       ProfileMenuWidget(
            //         title: "Liên hệ",
            //         icon: FontAwesomeIcons.headset,
            //         onPress: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (context) => const HelpScreen(),
            //           //   ),
            //           // );
            //         },
            //       ),
            //       const Divider(
            //         indent: 75,
            //         endIndent: 30,
            //         height: 0,
            //       ),
            //       ProfileMenuWidget(
            //         title: "Điều khoản sử dụng",
            //         icon: Icons.format_align_left,
            //         onPress: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (context) => const TermsOfUseScreen(),
            //           //   ),
            //           // );
            //         },
            //       ),
            //       const Divider(
            //         indent: 75,
            //         endIndent: 30,
            //         height: 0,
            //       ),
            //       ProfileMenuWidget(
            //         title: "Chính sách bảo mật",
            //         icon: Icons.lock,
            //         onPress: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (context) => const PrivacyPolicyScreen(),
            //           //   ),
            //           // );
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.mainBackground,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  ProfileMenuWidget(
                    title: "Đăng xuất",
                    icon: LineAwesomeIcons.alternate_sign_out,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () async {
                      await _authService.signOut();

                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
