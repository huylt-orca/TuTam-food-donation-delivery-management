import 'package:food_donation_delivery_app/app_config.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRScheduleRouteService {
  late HubConnection hubConnection;

  SignalRScheduleRouteService() {
    const serverUrl = "${AppConfig.SERVER_HUB}/schedule-route-hub";
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
  }

  Future startConnection() async {
    await hubConnection.start();
  }

  void registerListeners(Function onMessageReceived)  {
    
    hubConnection.on('schedule-route', (message) { 
      onMessageReceived(message);
    });
  }

  bool isConnected() {
    return hubConnection.state == HubConnectionState.connected;
  }

}