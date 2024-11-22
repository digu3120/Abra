import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ServiceAreaRepo{
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  ServiceAreaRepo({required this.sharedPreferences,required this.apiClient});


  Future<Response> getZoneList()async{
    return await apiClient.postData(AppConstants.getZoneListApi, {});
  }

}