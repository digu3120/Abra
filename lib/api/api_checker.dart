import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';


class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData(response: response);
      if(Get.currentRoute != RouteHelper.getInitialRoute()){
        Get.offAllNamed(RouteHelper.getInitialRoute());
        customSnackBar("${response.statusCode!}".tr);
      }
    }else if(response.statusCode == 500){
      customSnackBar("${response.statusCode!}".tr);
    }
    else if(response.statusCode == 400 && response.body['errors'] !=null){
      customSnackBar("${response.body['errors'][0]['message']}");
    }
    else if(response.statusCode == 429){
      customSnackBar(response.statusText);
    }
    else{
      customSnackBar("${response.body['message']}");
    }
  }
}