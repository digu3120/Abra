import 'package:demandium/utils/core_export.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class NotificationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getNotificationList( int offset) async {
    return await apiClient.getData('${AppConstants.notificationUri}?limit=10&offset=$offset');
  }

  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.notificationCount, count);
  }

  int getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.notificationCount)!;
  }

}
