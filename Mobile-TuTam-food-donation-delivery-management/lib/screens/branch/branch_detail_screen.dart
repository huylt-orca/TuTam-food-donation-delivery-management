import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/activity.dart';
import 'package:food_donation_delivery_app/models/branch.dart';
import 'package:food_donation_delivery_app/models/branch_detail.dart';
import 'package:food_donation_delivery_app/models/sampledata.dart';
import 'package:food_donation_delivery_app/screens/statement/statements_screen.dart';
import 'package:food_donation_delivery_app/services/activity_service.dart';
import 'package:food_donation_delivery_app/services/branch_service.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_card.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';
import 'package:food_donation_delivery_app/widgets/text_in_branch_widget.dart';

class BranchDetailScreen extends StatefulWidget {
  final String idBranch;
  const BranchDetailScreen({super.key, required this.idBranch});

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  BranchDetail? _branchDetail;
  List<Branch> _branches = List.empty(growable: true);
  List<Activity> _activities = List.empty(growable: true);

  void _getData() async {
    await ActivityService.fetchActivitiesList(pageSize: 4).then((value) {
      _activities = value;
    });

    await BranchService.fetchBranchesList().then((value) => _branches = value);

    await BranchService.fetchBranchDetail(idBranch: widget.idBranch).then((value) {
      setState(() {
        _branchDetail = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _branchDetail == null
            ? ShimmerWidget.rectangular(
                height: MediaQuery.of(context).size.height)
            : Scaffold(
                appBar: AppBar(
                  title: Text(_branchDetail!.name),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.network(
                            _branchDetail!.image,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: -60,
                            left: MediaQuery.of(context).size.width * 0.5 - 60,
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(_branchDetail!.image),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              _branchDetail!.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _branchDetail!.description,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: const Text(
                                  'Xem sao kê quyên góp',
                                  style:
                                      TextStyle(color: AppTheme.primarySecond),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StatementsScreen(
                                              type: 0,
                                              id: _branchDetail!.id,
                                            )),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                const TextInBranchWidget(
                                  textBold: '10N',
                                  text: 'Bài đăng',
                                ),
                                Container(
                                  height: 50,
                                  width: 1.0,
                                  color: Colors.black,
                                ),
                                const TextInBranchWidget(
                                  textBold: '10N',
                                  text: 'Hoạt động',
                                ),
                                Container(
                                  height: 50,
                                  width: 1.0,
                                  color: Colors.black,
                                ),
                                TextInBranchWidget(
                                  textBold: _branches.length.toString(),
                                  text: 'Chi nhánh',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Địa chỉ: ${_branchDetail!.address}',
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Các hoạt động đang diễn ra',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16)),
                                    GestureDetector(
                                      child: const Text(
                                        'Xem thêm',
                                        style: TextStyle(
                                          color: AppTheme.primarySecond,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  height: 166,
                                  child: PageView.builder(
                                    controller:
                                        PageController(viewportFraction: 1),
                                    itemCount: _activities.length,
                                    itemBuilder: (context, index) {
                                      return TweenAnimationBuilder(
                                        duration:
                                            const Duration(milliseconds: 350),
                                        tween: Tween(begin: 1, end: 1),
                                        curve: Curves.ease,
                                        child: ActivityCard(
                                            activity:
                                                _activities[index]),
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
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Các chi nhánh khác',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16)),
                                    GestureDetector(
                                      child: const Text(
                                        'Xem thêm',
                                        style: TextStyle(
                                          color: AppTheme.primarySecond,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _branches.length,
                                    itemBuilder: ((context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BranchDetailScreen(
                                                        idBranch:
                                                            _branches[index]
                                                                .id)),
                                          );
                                        },
                                        child: ListTile(
                                          leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  _branches[index].image)),
                                          title: Text(
                                            _branches[index].name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            _branches[index].address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    })),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
