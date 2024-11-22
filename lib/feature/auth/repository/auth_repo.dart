import 'dart:convert';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(AppConstants.registerUri, signUpBody.toJson());
  }

  Future<Response?> login({required String phone, required String password, required String type}) async {
    return await apiClient.postData(AppConstants.loginUri, {"email_or_phone": phone, "password": password , "type" : type,"guest_id": Get.find<SplashController>().getGuestId()});
  }


  Future<Response?> logOut() async {
    return await apiClient.postData(AppConstants.loginOut, {});
  }

  Future<Response> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(AppConstants.socialLoginUri, socialLogInBody.toJson(),headers: AppConstants.configHeader);
  }

  Future<Response> existingAccountCheck({required String email, required int userResponse, required String medium}) async {
    return await apiClient.postData(AppConstants.existingAccountCheck, {"email": email, "user_response": userResponse, "medium": medium});
  }

  Future<Response> registerWithSocialMedia({String? firstName, String? lastName, String? phone, String? email}) async {
    return await apiClient.postData(AppConstants.registerWithSocialMedia, {"first_name": firstName, "last_name" : lastName ,"email": email, "phone": phone});
  }

  Future<Response?> updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }

    if(!GetPlatform.isWeb){
      if(Get.find<LocationController>().getUserAddress() != null){
        FirebaseMessaging.instance.subscribeToTopic('${AppConstants.topic}-${Get.find<LocationController>().getUserAddress()!.zoneId!}');
      }
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      if (kDebugMode) {
        print("Subscribed ==>>>>> Token");
      }
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }catch(e) {
      if (kDebugMode) {
        print('');
      }
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }


  Future<Response> sendOtpForVerificationScreen({required String identity,required String identityType, required int checkUser}) async {
    return await apiClient.postData(AppConstants.sendOtpForVerification, {
      "identity": identity,
      "identity_type": identityType,
      "check_user": checkUser
    });
  }

  Future<Response> sendOtpForForgetPassword(String identity, String identityType) async {
    return await apiClient.postData(AppConstants.sendOtpForForgetPassword,
      {
        "identity": identity,
        "identity_type": identityType
      },

    );
  }

  Future<Response?> verifyOtpForVerificationScreen(String? identity,String identityType, String otp) async {
    return await apiClient.postData(AppConstants.verifyOtpForVerificationScreen,
      {
        "identity": identity,
        'otp':otp,
        "identity_type": identityType
      },
    );
  }

  Future<Response> verifyOtpForForgetPassword(String identity, String identityType, String otp) async {
    return await apiClient.postData(AppConstants.verifyOtpForForgetPasswordScreen,
      {
        "identity": identity,
        'otp':otp,
        "identity_type": identityType
      },
    );
  }

  Future<Response?> verifyOtpForPhoneOtpLogin(String? phone, String otp) async {
    return await apiClient.postData(AppConstants.phoneOtpVerification,
      {
        "phone": phone,
        'otp':otp,
      },
    );
  }
  Future<Response?> verifyOtpForFirebaseOtpLogin({String? session, String? phone, String? code }) async {
    return await apiClient.postData(AppConstants.firebaseOtpVerify,
      {
        "sessionInfo": session,
        'phoneNumber': phone,
        'code': code,
        "user_type" : "customer"
      },
    );
  }


  Future<Response> updateNewUserProfileAndLogin({String? firstName, String? lastName, String? phone, String? email}) async {
    return await apiClient.postData(AppConstants.registerWithOtp,
      {
        "first_name": firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
      },
    );
  }


  Future<Response?> resetPassword(String identity, String identityType, String otp, String password, String confirmPassword) async {
    return await apiClient.putData(
      AppConstants.resetPasswordUri,
      {
        "_method": "put",
        "identity": identity,
        "identity_type": identityType,
        "otp": otp,
        "password": password,
        "confirm_password": confirmPassword},
    );
  }



  Future<Response?> updateZone() async {
    return await apiClient.getData(AppConstants.updateZoneUri);
  }

  Future<bool?> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.userAddress) != null ?
    AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!)).zoneId :
    null, sharedPreferences.getString(AppConstants.languageCode), sharedPreferences.getString(AppConstants.guestId));
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData({Response? response}) {
    if(GetPlatform.isAndroid && !GetPlatform.isWeb){
      if(Get.find<LocationController>().getUserAddress() != null){
        if(Get.find<LocationController>().getUserAddress()!.zoneId != null){
          FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
          FirebaseMessaging.instance.unsubscribeFromTopic('${AppConstants.topic}-${Get.find<LocationController>().getUserAddress()!.zoneId!}');
        }
      }
    }
    apiClient.postData(AppConstants.tokenUri, {"_method": "put", "fcm_token": '@'});
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.referredBottomSheet);
    Get.find<AuthController>().updateSavedLocalAddress(saveContactPersonInfo: false);
    Get.find<AllSearchController>().removeHistory();
    Get.find<UserController>().setUserInfoModelData(null);
    sharedPreferences.setStringList(AppConstants.searchHistory, []);
    apiClient.token = null;
    if(response !=null && response.body['response_code'] != null && response.statusCode == 401 && response.body['response_code'] == "zone_404"){
      AddressModel? address = Get.find<LocationController>().getUserAddress();
      address?.zoneId = "";
      Get.find<LocationController>().saveUserAddress( address ?? AddressModel());
    }
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(AppConstants.userCountryCode, countryCode);

    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  toggleNotificationSound(bool isNotification){
    sharedPreferences.setBool(AppConstants.notification, isNotification);
  }

  toggleReferralBottomSheetShow (bool isShowBottomSheet){
    sharedPreferences.setBool(AppConstants.referredBottomSheet, isShowBottomSheet);
  }

  bool getIsShowReferralBottomSheet (){
    return sharedPreferences.getBool(AppConstants.referredBottomSheet) ?? true;
  }


  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  bool clearSharedAddress(){
    sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }
}
