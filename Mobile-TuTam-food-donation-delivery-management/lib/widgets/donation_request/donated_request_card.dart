import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/donated_request_list.dart';
import 'package:food_donation_delivery_app/screens/donation/donated_request_detail_user_screen.dart';
import 'package:food_donation_delivery_app/utils/donated_request_utils.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/item_donation_card.dart';

class DonatedRequestCard extends StatefulWidget {
  final DonatedRequestList donatedRequest;
  final VoidCallback reload;
  const DonatedRequestCard({super.key, required this.donatedRequest, required this.reload});

  @override
  State<DonatedRequestCard> createState() => _DonatedRequestCardState();
}

class _DonatedRequestCardState extends State<DonatedRequestCard> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // DonatedRequestService.fetchDonatedRequestDetail(widget.donatedRequest.id)
        // .then((value){
        //    Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => DonationDetailUserScreen(donatedRequest: widget.donatedRequest,),
        //           ),
        //         );
        // });
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonatedRequestDetailUserScreen(idDonatedRequest: widget.donatedRequest.id,),
                  ),
                ).then((value) {
                  if (value == true){
                   widget.reload();
                  }
                });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
            borderRadius: BorderRadius.circular(10.0), color: AppTheme.mainBackground),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  height: 100,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: NetworkImage(widget.donatedRequest.images[0]),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.donatedRequest.simpleBranchResponse == null ? 'Chưa ai nhận' : '${widget.donatedRequest.simpleBranchResponse!.name} nhận',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: DonatedRequestUtils.colorStatus(widget.donatedRequest.status),
                        ),
                        child: Text(DonatedRequestUtils.textStatus(widget.donatedRequest.status),
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ),
                      Text( 'Ngày: ${
                        widget.donatedRequest.scheduledTimes.length == 1 
                        ? Utils.converDate(widget.donatedRequest.scheduledTimes[0].day)
                        : '${Utils.converDate(widget.donatedRequest.scheduledTimes.first.day)} - ${Utils.converDate(widget.donatedRequest.scheduledTimes.last.day)}'
                        }',
                        style: const TextStyle(fontSize: 12),
                      ),
                     Text('Địa chỉ: ${widget.donatedRequest.address}',
                        style: const TextStyle(fontSize: 12,),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        )
                    ],
                  ),
                )
              ],
            ),
            Visibility(
              visible: isOpen,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.donatedRequest.donatedItemResponses.length,
                itemBuilder: (context,index){
                  return ItemDonationCard(
                    isFinished: widget.donatedRequest.status == 'FINISHED',
                    item: widget.donatedRequest.donatedItemResponses[index],
                  );
                })
              ),
            Center(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                child: Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                )
            ),
          ],
        ),
      ),
    );
  }
}
