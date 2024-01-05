import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/branch.dart';
import 'package:food_donation_delivery_app/screens/branch/branch_detail_screen.dart';
import 'package:food_donation_delivery_app/widgets/branch/shimmer_branch_card.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class BranchListWidget extends StatelessWidget {
  final List<Branch> listBranches;
  final bool isLoading;

  const BranchListWidget(
      {super.key, required this.listBranches, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return (listBranches.isEmpty && !isLoading)
        ? const Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.search,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  'Không tìm thấy chi nhánh',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: isLoading ? 6 : listBranches.length,
            itemBuilder: (context, index) {
              return isLoading
                  ? const ShimmerBranchCard()
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchDetailScreen(
                              idBranch: listBranches[index].id,
                            ),
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
                                  listBranches[index].image,
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
                            Text(
                              listBranches[index].name,
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
