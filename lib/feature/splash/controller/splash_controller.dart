import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  ConfigModel? _configModel = ConfigModel();
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;
  final bool _isLoading = false;


  bool get isLoading => _isLoading;
  ConfigModel get configModel => _configModel!;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get hasConnection => _hasConnection;

  bool savedCookiesData = false;

  Future<bool> getConfigData() async {
    _hasConnection = true;
    Response response = await splashRepo.getConfigData();
    bool isSuccess = false;
    if(response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);

      if(_configModel?.content?.maintenanceMode?.maintenanceStatus == 1
          && _configModel?.content?.maintenanceMode?.selectedMaintenanceSystem?.mobileApp == 1 && !kIsWeb && !AppConstants.avoidMaintenanceMode ){
        Get.offAllNamed(RouteHelper.getMaintenanceRoute());
      }
      else if((Get.currentRoute.contains(RouteHelper.maintenance) &&
          (_configModel?.content?.maintenanceMode?.maintenanceStatus == 0 ||
              (_configModel?.content?.maintenanceMode?.selectedMaintenanceSystem?.mobileApp == 0 && !kIsWeb)))) {
        Get.offAllNamed(RouteHelper.getInitialRoute());
      }
      else if(_configModel?.content?.maintenanceMode?.maintenanceStatus == 0){
        if(_configModel?.content?.maintenanceMode?.selectedMaintenanceSystem?.mobileApp == 1){
          if(_configModel?.content?.maintenanceMode?.maintenanceTypeAndDuration?.maintenanceDuration == 'customize'){

            DateTime now = DateTime.now();
            DateTime specifiedDateTime = DateTime.parse(_configModel!.content!.maintenanceMode!.maintenanceTypeAndDuration!.startDate!);

            Duration difference = specifiedDateTime.difference(now);

            if(difference.inMinutes > 0 && (difference.inMinutes < 60 || difference.inMinutes == 60)){
              _startTimer(specifiedDateTime);
            }
          }
        }
      }

      isSuccess = true;
    }else {
      ApiChecker.checkApi(response);
      if(response.statusText == ApiClient.noInternetMessage) {
        _hasConnection = false;
      }
      isSuccess = false;
    }
    update();
    return isSuccess;
  }


  void _startTimer (DateTime startTime){
    Timer.periodic(const Duration(seconds: 30), (Timer timer){
      DateTime now = DateTime.now();
      if (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) {
        timer.cancel();
        Get.offAllNamed(RouteHelper.getMaintenanceRoute());
      }
    });
  }


  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  void setGuestId(String guestId){
    splashRepo.setGuestId(guestId);
  }

  String getGuestId (){
    return splashRepo.getGuestId();
  }




  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }



  void saveCookiesData(bool data) {
    splashRepo.saveCookiesData(data);
    savedCookiesData = true;
    update();
  }

  getCookiesData(){
    savedCookiesData = splashRepo.getSavedCookiesData();
    update();
  }


  void cookiesStatusChange(String? data) {
    if(data != null){
      splashRepo.sharedPreferences.setString(AppConstants.cookiesManagement, data);
    }
  }

  bool getAcceptCookiesStatus(String data) => splashRepo.sharedPreferences.getString(AppConstants.cookiesManagement) != null
      && splashRepo.sharedPreferences.getString(AppConstants.cookiesManagement) == data;

  void disableShowOnboardingScreen() {
    splashRepo.disableShowOnboardingScreen();
  }

  bool  isShowOnboardingScreen() {
    return splashRepo.isShowOnboardingScreen();
  }

  void  disableShowInitialLanguageScreen() {
    splashRepo.disableShowInitialLanguageScreen();
  }

  bool isShowInitialLanguageScreen() {
    return splashRepo.isShowInitialLanguageScreen();
  }


  Future<void> updateLanguage(bool isInitial) async {
    Response response = await splashRepo.updateLanguage(getGuestId());

    if(!isInitial){
      if(response.statusCode == 200 && response.body['response_code'] == "default_200"){

      }else{
        customSnackBar("${response.body['message']}");
      }
    }

  }

  Future<void> addError404UrlToServer(String url) async {
    Response response = await splashRepo.addError404UrlToServer(url);
    if (kDebugMode) {
      print("Error Url Add Response Status : ${response.statusCode}");
    }
  }

}
