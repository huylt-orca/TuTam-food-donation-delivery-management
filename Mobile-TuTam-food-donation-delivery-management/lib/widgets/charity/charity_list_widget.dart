import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/charity_unit.dart';
import 'package:food_donation_delivery_app/screens/charity/charity_unit_detail_screen.dart';
import 'package:food_donation_delivery_app/widgets/branch/shimmer_branch_card.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class CharityListWidget extends StatelessWidget {
  final List<CharityUnit> listCharities ;
  final bool isLoading;

  const CharityListWidget({super.key,
  required this.listCharities,
  required this.isLoading
  });


  @override
  Widget build(BuildContext context) {
    return
    (listCharities.isEmpty && !isLoading )
    ? const Center(
                child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Icon(
                        Icons.search,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Text('Không tìm thấy tổ chức liên kết', style: TextStyle(color: Colors.grey),),
                    ],
                  ),
              )
    : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: isLoading ? 6 : listCharities.length,
                  itemBuilder: (context, index) {
                    return  isLoading ? const ShimmerBranchCard()
                    : GestureDetector(
                      onTap: () async {
                        
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CharityUnitDetailScreen(
                                idUnit: listCharities[index].id,
                                );
                            } 
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  listCharities[index].image,
                                  fit: BoxFit.fitHeight,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const ShimmerWidget.circular(
                                          width: 70, height: 70);
                                    }
                                  },
                                ),
                              ),
                            ),
                            Text(listCharities[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
  }
}