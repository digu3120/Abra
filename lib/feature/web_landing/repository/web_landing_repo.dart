import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class WebLandingRepo {
  final ApiClient apiClient;

  WebLandingRepo({required this.apiClient});

  Future<Response> getWebLandingContents() async {
    return await apiClient.getData(AppConstants.webLandingContents);
  }

}