import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/charity_unit.dart';
import 'package:food_donation_delivery_app/models/sampledata.dart';
import 'package:food_donation_delivery_app/screens/statement/statements_screen.dart';
import 'package:food_donation_delivery_app/services/charity_service.dart';
import 'package:food_donation_delivery_app/services/charity_unit_service.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';
import 'package:food_donation_delivery_app/widgets/text_in_branch_widget.dart';

class CharityUnitDetailScreen extends StatefulWidget {
  final String idUnit;
  const CharityUnitDetailScreen({
    super.key, 
    required this.idUnit,
    });

  @override
  State<CharityUnitDetailScreen> createState() => _CharityUnitDetailScreenState();
}

class _CharityUnitDetailScreenState extends State<CharityUnitDetailScreen> {
  CharityUnit? _unitDetail;
  List<CharityUnit> _units = List.empty(growable: true);



  void _getData() async{
    CharityUnit unit = await CharityUnitService.fetchCharityUnitDetail(widget.idUnit);
  List<CharityUnit> units = await CharityService.fetchCharityUnitsListByCharityId(charityId: unit.charityId);
                        units.removeWhere((element) => element.id == unit.id);
    setState(() {
    _units = units;
      _unitDetail = unit;
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
      child:
      _unitDetail == null
            ? ShimmerWidget.rectangular(
                height: MediaQuery.of(context).size.height) :
       Scaffold(
        appBar: AppBar(
          title: Text(_unitDetail!.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.network(
                    _unitDetail!.image,
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
                        backgroundImage: NetworkImage(_unitDetail!.image),
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
                      _unitDetail!.name,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _unitDetail!.description,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                     Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        child: const Text('Xem sao kê quyên góp',
                         style:
                                      TextStyle(color: AppTheme.primarySecond),
                        ),
                        onTap: (){
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StatementsScreen(
                                        type: 1,
                                        id: _unitDetail!.id
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
                        TextInBranchWidget(
                          textBold: '${_unitDetail!.numberOfPost}',
                          text: 'Bài đăng',
                        ),
                        Container(
                          height: 50,
                          width: 1.0,
                          color: Colors.black,
                        ),
                        const TextInBranchWidget(
                          textBold: '0',
                          text: 'Hoạt động',
                        ),
                        Container(
                          height: 50,
                          width: 1.0,
                          color: Colors.black,
                        ),
                        TextInBranchWidget(
                          textBold: '${_units.length}',
                          text: 'Chi nhánh',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Địa chỉ: ${_unitDetail!.address}',
                      textAlign: TextAlign.left,
                      ),
                    ),
                   
                    const SizedBox(height: 10,),
                    _units.isEmpty ? const SizedBox() :
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _units.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          CharityUnitDetailScreen(idUnit: _units[index].id)
                        ),
                      );
                              },
                              child: ListTile(
                                leading: CircleAvatar(backgroundImage: NetworkImage(_units[index].image)),
                                title: Text(_units[index].name),
                                subtitle: Text(_units[index].address),
                              ),
                            );
                          })
                          ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
