import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:get/get.dart';



class ScheduleRouteController extends GetxController{
 var scheduleRouteDetail = ScheduleRouteDetail(
    id: '',
    numberOfDeliveryRequests: 0,
    scheduledTime: ScheduledTime(day: '', startTime: '', endTime: ''),
    orderedDeliveryRequests: [],
    totalDistanceAsMeters: 0.0,
    totalTimeAsSeconds: 0.0,
    bulkyLevel: '',
    type: '',
    status: ''
  ).obs;

  // Add Schedule Route
  void updateScheduleRouteDetail(ScheduleRouteDetail newDetail) {
    scheduleRouteDetail.value = newDetail;
    scheduleRouteDetail.refresh();
  }

  void updateStatusDeliveryRequest(String idDeliveryRequest, String status){
    for (var item in scheduleRouteDetail.value.orderedDeliveryRequests){
      if (item.id == idDeliveryRequest){
        item.status = status;
      }
    }
    scheduleRouteDetail.refresh();
  }

  void updateListItemOfDeliveryRequest(String idDeliveryRequest, List<DeliveryItems> items){
    for (var item in scheduleRouteDetail.value.orderedDeliveryRequests){
      if (item.id == idDeliveryRequest){
        item.deliveryItems = items;
      }
    }
    scheduleRouteDetail.refresh();
  }

  OrderedDeliveryRequests getOrderDeliveryRequestById (String id){
    return scheduleRouteDetail.value.orderedDeliveryRequests.firstWhere((element) => element.id == id);
  }

  void updateReceiveQuantity({
    required String idDeliveryRequest,
    required String idItem,
    required int quantity,
  }){
    scheduleRouteDetail.value.orderedDeliveryRequests.firstWhere(
      (element) => element.id == idDeliveryRequest).deliveryItems?.firstWhere((element) => element.deliveryItemId == idItem).receivedQuantity = quantity;
      
    if (scheduleRouteDetail.value.type == 'IMPORT'){
      scheduleRouteDetail.value.orderedDeliveryRequests.last.deliveryItems?.firstWhere((element) => element.deliveryItemId == idItem).receivedQuantity = quantity;
    } else {
      scheduleRouteDetail.value.orderedDeliveryRequests.first.deliveryItems?.firstWhere((element) => element.deliveryItemId == idItem).receivedQuantity = quantity;
    }
    scheduleRouteDetail.refresh();
  }

  List<DeliveryItems> getListDeliveryItemsClone (String idDeliveryRequest){
    return scheduleRouteDetail.value.orderedDeliveryRequests.firstWhere((element) => element.id == idDeliveryRequest).deliveryItems!.map((e) => 
    DeliveryItems(deliveryItemId: e.deliveryItemId, 
    name: e.name, 
    image: e.image,
    unit: e.unit, 
    quantity: e.quantity, 
    receivedQuantity: e.receivedQuantity, 
    expiredDate: e.expiredDate)).toList();
  }

}