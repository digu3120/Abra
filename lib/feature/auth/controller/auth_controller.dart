import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;


  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _forgetPasswordUrlSessionExpired = false;
  bool savedCookiesData = false;

  AuthController({required this.authRepo});
  bool get isLoading => _isLoading;
  bool get forgetPasswordUrlSessionExpired => _forgetPasswordUrlSessionExpired;
  bool get acceptTerms => _acceptTerms;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  bool _isNumberLogin = false;
  bool get isNumberLogin => _isNumberLogin;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  bool _isWrongOtpSubmitted = false;
  bool get isWrongOtpSubmitted => _isWrongOtpSubmitted;

  LoginMedium  _selectedLoginMedium = LoginMedium.manual;
  LoginMedium  get selectedLoginMedium => _selectedLoginMedium;



  var countryDialCode= "+880";
  final String _mobileNumber = '';
  String get mobileNumber => _mobileNumber;

  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content != null ? Get.find<SplashController>().configModel.content!.countryCode!:"BD").dialCode!;
  }

  Future<void> registration({required SignUpBody signUpBody}) async {

    _isLoading = true;
    update();

      Response response = await authRepo.registration(signUpBody);
      if (response.statusCode == 200 && response.body['response_code'] == 'registration_200') {

        var config = Get.find<SplashController>().configModel.content;
        if(config?.phoneVerification == 1 || config?.emailVerification == 1){

          String identity = config?.phoneVerification == 1 ? signUpBody.phone!.trim() : signUpBody.email!.trim();
          String identityType = config?.phoneVerification == 1 ? "phone" : "email";
          SendOtpType type = config?.phoneVerification == 1 && config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;
          await sendVerificationCode(identity:  identity , identityType: identityType, type: type).then((status){
            if(status !=null){
              if(status.isSuccess!){
                Get.toNamed(RouteHelper.getVerificationRoute(
                  identity: identity,identityType: identityType,
                  fromPage: config?.phoneVerification == 1 && config?.firebaseOtpVerification == 1 ? "firebase-otp" : "verification",
                  firebaseSession: type == SendOtpType.firebase ? status.message : null,
                ));
              }else{
                customSnackBar(status.message.toString().capitalizeFirst);
              }
            }
          });

        }else{
          Get.toNamed(RouteHelper.getSignInRoute());
        }
        customSnackBar('registration_200'.tr,type : ToasterMessageType.success);
      }
      else if(response.statusCode == 404 && response.body['response_code']=="referral_code_400"){
        customSnackBar("invalid_refer_code".tr);
      } else if(response.statusCode == 400 && response.body['response_code']=="default_400"){
        customSnackBar(response.body['errors'][0]['message']);
      }
      else {
        customSnackBar(response.statusText);
      }

    _isLoading = false;
    update();
  }

  Future<void> login({String? fromPage, required String emailPhone, required String password, required String type}) async {
      _isLoading = true;
      update();
      Response? response = await authRepo.login(phone: emailPhone, password: password, type: type);
      if (response!.statusCode == 200 && response.body['response_code']=="auth_login_200") {
        await _saveTokenAndNavigate(fromPage: fromPage, token: response.body['content']['token'], emailPhone: emailPhone, password: password);

      }else if(response.statusCode == 401 && (response.body["response_code"]=="unverified_phone_401") || response.body["response_code"]=="unverified_email_401"){

        var config = Get.find<SplashController>().configModel.content;

        SendOtpType sendOtpType = type == "phone" && config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;
        await sendVerificationCode(identity:  emailPhone , identityType: type,type: sendOtpType).then((status){
          if(status !=null){
            if(status.isSuccess!){
              Get.toNamed(RouteHelper.getVerificationRoute(
                identity: emailPhone,identityType: type,
                fromPage: type == "phone" && config?.firebaseOtpVerification == 1 ? "firebase-otp" : "verification",
                firebaseSession: sendOtpType == SendOtpType.firebase ? status.message : null,
              ));
            }else{
              customSnackBar(status.message.toString().capitalizeFirst);
            }
          }
        });
      }
      else{
        customSnackBar(response.body["message"].toString().capitalizeFirst??response.statusText);
      }
      _isLoading = false;
      update();

  }

  Future<void> logOut() async {
    Response? response = await authRepo.logOut();
    if(response?.statusCode == 200){
      if (kDebugMode) {
        print("Logout successfully with ${response?.body}");
      }
    }else{
      if (kDebugMode) {
        print("Logout Failed");
      }
    }
  }

  _saveTokenAndNavigate({String? fromPage, required String token, String? emailPhone, String? password}) async {

    authRepo.saveUserToken(token);

    Get.find<SplashController>().updateLanguage(true);
    Get.find<LocationController>().getAddressList();

    if (_isActiveRememberMe) {
      saveUserNumberAndPassword(number : emailPhone ?? "", password : password ?? "", );
    } else {
      clearUserNumberAndPassword();
    }
    if( fromPage == null || fromPage == "null"){
      if (Get.find<LocationController>().getUserAddress() != null) {

        updateSavedLocalAddress();

        if(fromPage=="booking"){
          Get.offAllNamed(RouteHelper.getMainRoute('booking'));
        }else{
          Get.offAllNamed(RouteHelper.getMainRoute('home'));
        }
      } else {
        Get.offAllNamed(RouteHelper.getAccessLocationRoute('home'));
      }
    }else{
      Get.offAllNamed(fromPage);
    }
  }

  updateSavedLocalAddress({bool saveContactPersonInfo = true}) async {

    AddressModel addressModel = Get.find<LocationController>().getUserAddress()!;

    if(saveContactPersonInfo){
      if(Get.find<UserController>().userInfoModel == null){
        Get.find<UserController>().getUserInfo(reload: true);
      }else{
        String? firstName;
        if( Get.find<AuthController>().isLoggedIn() && Get.find<UserController>().userInfoModel?.phone!=null && Get.find<UserController>().userInfoModel?.fName !=null){
          firstName = "${Get.find<UserController>().userInfoModel?.fName} ";
        }

        addressModel.contactPersonNumber = firstName !=null? Get.find<UserController>().userInfoModel?.phone ?? "" : "";
        addressModel.contactPersonName = firstName!=null ? "$firstName${Get.find<UserController>().userInfoModel?.lName ?? "" }" : "";
        addressModel.addressLabel = 'others';

      }
    }else{
      addressModel.contactPersonNumber =  "";
      addressModel.contactPersonName =  "";
    }
    Get.find<LocationController>().saveUserAddress(addressModel);
  }


  Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody ,Function callback,{String? fromPage}) async {
    _isLoading = true;
    update();
    Response response = await authRepo.loginWithSocialMedia(socialLogInBody);
    _isLoading = false;
    if (response.statusCode == 200  && response.body['response_code']=="auth_login_200") {
      Map map = response.body;
      String? message = '';
      String? token = '';
      String? tempToken = '';
      String? email;
      UserInfoModel? userInfoModel;
      try{
        message = map['message'] ?? '';
      }catch(e){
        debugPrint('error ===> $e');
      }

      try{
        token = map['content']['token'];
      }catch(e){

        if (kDebugMode) {
          print(e);
        }
      }
      try{
        tempToken = map['content']['temporary_token'];
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }

      try{
        email = map['content']['email'];
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }


      if(map['content']['user'] != null){
        try{
          userInfoModel = UserInfoModel.fromJson(map['content']['user']);
          callback(true, null, message, null, userInfoModel, socialLogInBody.medium, null, null);
        }catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
      }

      if(token != null){
        saveUserNumberAndPassword(number : "", password : "", );
        await authRepo.saveUserToken(token);
        await authRepo.saveUserToken(token);
        await Get.find<UserController>().getUserInfo(reload: true);
        authRepo.updateToken();
        callback(true, token, message,null, null, null, socialLogInBody.userName, socialLogInBody.email);
      }

      if(tempToken != null){
        callback(true, null, message, tempToken, null, null, socialLogInBody.userName, socialLogInBody.email ?? email);
      }

      update();

    }else {
      String? errorMessage = response.body['message'] ?? response.statusText;
      callback(false, '', errorMessage, null, null, null, socialLogInBody.userName, socialLogInBody.email);
      update();
    }
  }


  Future<ResponseModel?> sendVerificationCode({required String identity, required String identityType,required  SendOtpType type, int checkUser = 1, String fromPage = ""}) async {
    ResponseModel? responseModel;
    if(type == SendOtpType.firebase){
       _sendOtpForFirebaseVerification(identity, identityType, fromPage);
    } else if(type == SendOtpType.verification){
      responseModel = await _sendOtpForVerificationScreen(identity: identity, identityType: identityType, checkUser: checkUser);
    }else{
      responseModel = await _sendOtpForForgetPassword(identity, identityType);
    }
    return responseModel;
  }

  Future<ResponseModel> _sendOtpForVerificationScreen({required String identity,required String identityType, required int checkUser}) async {
    _isLoading = true;
    update();
    Response  response = await authRepo.sendOtpForVerificationScreen(identity: identity,identityType: identityType, checkUser: checkUser);
    if (response.statusCode == 200 && response.body["response_code"]=="default_200") {
      _isLoading = false;
      update();
      return ResponseModel(true, "");
    } else {
      _isLoading = false;
      update();
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }
  }

  Future<ResponseModel> _sendOtpForForgetPassword(String identity, String identityType) async {
    _isLoading = true;
    update();
    Response response = await authRepo.sendOtpForForgetPassword(identity,identityType);

    if (response.statusCode == 200 && response.body["response_code"]=="default_200") {
      _isLoading = false;
      update();
      return ResponseModel(true, "");
    } else {
      _isLoading = false;
      update();
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }
  }

  Future<void> _sendOtpForFirebaseVerification(String identity, String identityType, String fromPage ) async {
    _isLoading = true;
    update();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: identity,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        _isLoading = false;
        update();
        if(fromPage == "profile"){
          Get.back();
        }
        if(e.code == 'invalid-phone-number') {
          customSnackBar('please_submit_a_valid_phone_number', type: ToasterMessageType.info);

        }else{
          customSnackBar('${e.message}'.replaceAll('_', ' ').capitalizeFirst);
        }

      },
      codeSent: (String vId, int? resendToken) {
        _isLoading = false;
        update();
        if(fromPage == "profile"){
          Get.back();
        }
        Get.toNamed(RouteHelper.getVerificationRoute(identity:identity, identityType : identityType, fromPage:  "firebase-otp", firebaseSession: vId));

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }


  Future<ResponseModel>  verifyOtpForVerificationScreen(String identity,  String identityType, String otp,) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.verifyOtpForVerificationScreen(identity,identityType,otp);
    ResponseModel responseModel;
    if (response!.statusCode == 200 && response.body['response_code']=="default_200") {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = _checkWrongOtp(response);
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  Future<ResponseModel> verifyOtpForForgetPasswordScreen(String identity, String identityType, String otp, {bool fromOutsideUrl = false , bool shouldUpdate = true}) async {

    _isLoading = true;

    if(fromOutsideUrl){
      _forgetPasswordUrlSessionExpired = true;
    }

    if(shouldUpdate){
      update();
    }

    Response response = await authRepo.verifyOtpForForgetPassword(identity, identityType, otp);

    if (response.statusCode==200 &&  response.body['response_code'] == 'default_200') {
      _isLoading = false;
      _forgetPasswordUrlSessionExpired = false;
      update();
      return ResponseModel(true, "successfully_verified");
    }else{
      _isLoading = false;
      update();
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else if(response.statusCode == 400 && response.body['errors'] !=null ){
        responseText = response.body['errors'][0]['message'];
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }

  }


  Future<void>  verifyOtpForPhoneOtpLogin(String phone, String otp,) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.verifyOtpForPhoneOtpLogin(phone,otp);

    if (response!.statusCode == 200) {

      if(response.body['content']['token'] !=null){
       await _saveTokenAndNavigate( fromPage : RouteHelper.getMainRoute("home"), token: response.body['content']['token'], emailPhone: phone, password: "");
      } else if(response.body['content']['temporary_token'] !=null){
        Get.offNamed(RouteHelper.getUpdateProfileRoute(phone: phone));
      }

    } else {
      ResponseModel responseModel = _checkWrongOtp(response);
      customSnackBar(responseModel.message ?? "");
    }
    _isLoading = false;
    update();
  }


  Future<void>  verifyOtpForFirebaseOtp({String? session, String? phone, String? code }) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.verifyOtpForFirebaseOtpLogin(session: session, phone: phone, code: code);

    if (response!.statusCode == 200) {
      if(response.body['content']['token'] !=null){
        await _saveTokenAndNavigate( fromPage : RouteHelper.getMainRoute("home"), token: response.body['content']['token'], emailPhone: phone);
      } else if(response.body['content']['temporary_token'] !=null){
        Get.offNamed(RouteHelper.getUpdateProfileRoute(phone: phone ??""));
      }

    } else {
      ResponseModel responseModel = _checkWrongOtp(response);
      customSnackBar(responseModel.message);
    }
    _isLoading = false;
    update();
  }


  Future<void>  updateNewUserProfileAndLogin({String? firstName, String? lastName, String? phone, String? email}) async {
    _isLoading = true;
    update();

    Response response = await authRepo.updateNewUserProfileAndLogin(firstName: firstName, lastName: lastName, phone: phone, email: email);

    if (response.statusCode == 200) {
      if(response.body['content']['token'] !=null){
        await _saveTokenAndNavigate(fromPage: RouteHelper.getMainRoute("home"), token: response.body['content']['token'], emailPhone: phone, password: "");
      }

    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> registerWithSocialMedia ({String? firstName, String? lastName, String? phone, String? email}) async{
    _isLoading = true;
    update();
    Response response = await authRepo.registerWithSocialMedia(firstName: firstName, lastName: lastName, phone: phone, email: email);

    if (response.statusCode == 200) {
      if(response.body['content']['token'] !=null){
        await _saveTokenAndNavigate(fromPage: RouteHelper.getMainRoute("home"), token: response.body['content']['token'], emailPhone: "", password: "");
      }
      else if(response.body['content']['temporary_token'] != null){
        var config = Get.find<SplashController>().configModel.content;
        SendOtpType  type = config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;

        await sendVerificationCode(identity: phone!, identityType: "phone", type: type).then((status){
          if(status !=null){
            if(status.isSuccess!){
              Get.toNamed(RouteHelper.getVerificationRoute(
                identity: phone,identityType: "phone",
                fromPage: type == SendOtpType.firebase ? "firebase-otp" : "otp-login",
                firebaseSession: type == SendOtpType.firebase ? status.message : null
              ));
            }else{
              customSnackBar(status.message.toString().capitalizeFirst);
            }
          }
        });
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  Future<void> existingAccountCheck ({String? email, required int userResponse, required String medium}) async{
    _isLoading = true;
    update();
    Response response = await authRepo.existingAccountCheck(email: email ?? "", userResponse: userResponse, medium: medium);
    if (response.statusCode == 200) {

      if(response.body['content']['token'] !=null){
       await _saveTokenAndNavigate(fromPage: RouteHelper.getMainRoute("home"), token: response.body['content']['token']);
      }else if(response.body['content']['temporary_token'] !=null){
        Get.offNamed(RouteHelper.getUpdateProfileRoute(email: email ??"", tempToken: response.body['content']['temporary_token']));
      }

    } else {
     ApiChecker.checkApi(response);
    }
    _isLoading= false;
    update();
  }





  Future<void> resetPassword(String identity,String identityType, String otp, String password, String confirmPassword) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.resetPassword(identity,identityType, otp, password, confirmPassword);

    if (response!.statusCode == 200 && response.body['response_code']=="default_password_reset_200") {
      Get.offNamed(RouteHelper.getSignInRoute());
      customSnackBar('password_changed_successfully'.tr,type : ToasterMessageType.success);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  ResponseModel _checkWrongOtp (Response response){
    if (verificationCode.length == 6 && response.statusCode == 403){
      _isWrongOtpSubmitted = true;
    }
    String responseText = "";
    if(response.statusCode == 500){
      responseText = "Internal Server Error";
    }else{
      responseText = response.body["message"] ?? "verification_failed".tr ;
    }
    return ResponseModel(false, responseText);
  }


  void updateVerificationCode(String query) {
    _verificationCode = query;
    _isWrongOtpSubmitted = false;
    update();
  }

  void updateForgetPasswordUrlSessionExpiredStatus({required bool status, bool shouldUpdate = false}){
    _forgetPasswordUrlSessionExpired = status;
    if(shouldUpdate){
      update();
    }
  }


  void toggleTerms({bool? value , bool shouldUpdate = true}) {
    if(value != null){
      _acceptTerms = value;
    }else{
      _acceptTerms = !_acceptTerms;
    }
    if(shouldUpdate){
      update();
    }
  }

  toggleIsNumberLogin ({bool? value, bool isUpdate = true}){
    if(value == null){
      _isNumberLogin = !_isNumberLogin;
    }else{
      _isNumberLogin = value;
    }
    initCountryCode();
    if(isUpdate){
      update();
    }
  }

  toggleSelectedLoginMedium ({required LoginMedium loginMedium, bool isUpdate = true}){
    _selectedLoginMedium = loginMedium;
    if(isUpdate){
      update();
    }
  }


  void cancelTermsAndCondition(){
    _acceptTerms = false;
  }

  void toggleRememberMe({bool? value, bool shouldUpdate = true}) {

    if(value != null){
      _isActiveRememberMe = value;
    }else{
      _isActiveRememberMe = !_isActiveRememberMe;
    }
    if(shouldUpdate){
      update();
    }
  }

  void toggleReferralBottomSheetShow (){
    authRepo.toggleReferralBottomSheetShow(false);
    update();
  }

  bool getIsShowReferralBottomSheet (){
    return authRepo.getIsShowReferralBottomSheet();
  }


  bool isLoggedIn() => authRepo.isLoggedIn();
  String getUserNumber() => authRepo.getUserNumber();
  String getUserCountryCode() => authRepo.getUserCountryCode();
  String getUserPassword() => authRepo.getUserPassword();
  bool isNotificationActive() => authRepo.isNotificationActive();

  void saveUserNumberAndPassword({ required String number, required String password}) =>
      authRepo.saveUserNumberAndPassword(number, password, countryDialCode);
  Future<bool> clearUserNumberAndPassword() async => authRepo.clearUserNumberAndPassword();

  bool clearSharedData({Response? response}) => authRepo.clearSharedData(response: response);
  String getUserToken() => authRepo.getUserToken();


  toggleNotificationSound(){
    authRepo.toggleNotificationSound(!isNotificationActive());
    update();
  }




  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? googleAccount;
  GoogleSignInAuthentication? auth;

  Future<void> socialLogin() async {
    googleAccount = (await _googleSignIn.signIn());
    auth = await googleAccount?.authentication;
    update();
  }



  Future<void> googleLogout() async {
    try{
      googleAccount = (await _googleSignIn.disconnect())!;
      auth = await googleAccount!.authentication;
    }catch(e){
      if (kDebugMode) {
        print("");
      }
    }
  }


  Future<void> signOutWithFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  void initCountryCode({String? countryCode}){
    countryDialCode = countryCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode ?? "+880";
  }
}