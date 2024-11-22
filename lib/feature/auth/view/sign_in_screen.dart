import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';



class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final String? fromPage;
   const SignInScreen({super.key,required this.exitFromApp,  this.fromPage}) ;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  var signInPhoneController = TextEditingController();
  var signInPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _canExit = GetPlatform.isWeb ? true : false;
  final GlobalKey<FormState> customerSignInKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initializeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: ()=> _existFromApp(),
      child: Scaffold(

        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : !widget.exitFromApp ? AppBar(
          elevation: 0, backgroundColor: Colors.transparent,
          leading:  IconButton(
            hoverColor:Colors.transparent,
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
            color: Theme.of(context).textTheme.bodyLarge!.color,
            onPressed: () => Navigator.pop(context),
          ),
        ) : null,

        endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,

        body: SafeArea(child: FooterBaseView(
          isCenter: true,
          child: WebShadowWrap(
            child: Center(
              child: GetBuilder<AuthController>(builder: (authController) {

                var config = Get.find<SplashController>().configModel.content;
                var otpLogin = config?.customerLogin?.loginOption?.otpLogin;
                var manualLogin = config?.customerLogin?.loginOption?.manualLogin ?? 1;
                var socialLogin = config?.customerLogin?.loginOption?.socialMediaLogin;

                return Form(
                  autovalidateMode: ResponsiveHelper.isDesktop(context) ? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
                  key: customerSignInKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth /3.5 :
                      ResponsiveHelper.isTab(context) ? Dimensions.webMaxWidth / 5.5 : Dimensions.paddingSizeLarge,
                    ),
                    child: Column( children: [

                      Hero(tag: Images.logo,
                        child: Image.asset(Images.logo, width: Dimensions.logoSize),
                      ),
                     SizedBox(height: manualLogin == 1 || otpLogin == 1 ? Dimensions.paddingSizeExtraMoreLarge : Dimensions.paddingSizeDefault),


                      manualLogin == 1 || otpLogin == 1 ? CustomTextField(
                        onCountryChanged: (countryCode) => authController.countryDialCode = countryCode.dialCode!,
                        countryDialCode: authController.isNumberLogin || (manualLogin == 0 && otpLogin ==1) ? authController.countryDialCode : null,
                        title: 'email_phone'.tr,
                        hintText: authController.selectedLoginMedium == LoginMedium.otp || (manualLogin == 0 && otpLogin ==1)
                            ? "please_enter_phone_number".tr : 'enter_email_or_phone'.tr,
                        controller: signInPhoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _passwordFocus,
                        capitalization: TextCapitalization.words,
                        onChanged: (String text){
                          if(authController.selectedLoginMedium != LoginMedium.otp){
                            final numberRegExp = RegExp(r'^[+]?[0-9]+$');

                            if(text.isEmpty && authController.isNumberLogin){
                              authController.toggleIsNumberLogin();
                            }
                            if(text.startsWith(numberRegExp) && !authController.isNumberLogin && manualLogin == 1){
                              authController.toggleIsNumberLogin();
                              signInPhoneController.text = text.replaceAll("+", "");
                            }
                            final emailRegExp = RegExp(r'@');
                            if(text.contains(emailRegExp) && authController.isNumberLogin && manualLogin == 1){
                              authController.toggleIsNumberLogin();
                            }
                          }
                        },
                        onValidate: (String? value){
                          if(otpLogin == 1 && manualLogin == 0 && PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+signInPhoneController.text.trim(), withCountryCode: true) == ""){
                            return "enter_valid_phone_number".tr;
                          }
                          if(authController.isNumberLogin && PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+signInPhoneController.text.trim(), withCountryCode: true) == ""){
                           return "enter_valid_phone_number".tr;
                          }
                          return (GetUtils.isPhoneNumber(value!.tr) || GetUtils.isEmail(value.tr)) ? null : 'enter_email_or_phone'.tr;
                        },
                      ) : const SizedBox.shrink(),


                      SizedBox(height: manualLogin == 1 && authController.selectedLoginMedium == LoginMedium.manual ? Dimensions.paddingSizeTextFieldGap : 0),


                      manualLogin == 1 && authController.selectedLoginMedium == LoginMedium.manual ? CustomTextField(
                        title: 'password'.tr,
                        hintText: '************'.tr,
                        controller: signInPasswordController,
                        focusNode: _passwordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        inputAction: TextInputAction.done,
                        onValidate: (String? value){
                          return FormValidation().isValidPassword(value!.tr);
                        },
                      ) : const SizedBox.shrink(),
                      SizedBox(height: authController.selectedLoginMedium == LoginMedium.manual ? Dimensions.paddingSizeDefault : 0),


                      manualLogin == 1 || otpLogin == 1 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        InkWell(
                          onTap: () => authController.toggleRememberMe(),
                          child: Row( children: [
                            SizedBox( width: 20.0,
                              child: Checkbox(
                                activeColor: Theme.of(context).colorScheme.primary,
                                value: authController.isActiveRememberMe,
                                onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                            Text('remember_me'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          ]),
                        ),
                        manualLogin == 1  && authController.selectedLoginMedium == LoginMedium.manual ? TextButton(
                          onPressed: () => Get.toNamed(RouteHelper.getSendOtpScreen()),
                          child: Text('forgot_password'.tr, style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.tertiary,
                          )),
                        ) : const SizedBox.shrink(),
                      ]) : const SizedBox.shrink(),

                      SizedBox(height:  manualLogin == 1 || otpLogin == 1 ? Dimensions.paddingSizeLarge : 0),


                      manualLogin == 1 || otpLogin == 1 ? CustomButton(
                        buttonText: (authController.selectedLoginMedium == LoginMedium.otp) || (manualLogin == 0 && otpLogin == 1) ? "get_otp".tr :'sign_in'.tr,
                        onPressed:  ()  {
                          if(customerSignInKey.currentState!.validate()) {
                            _login(authController, manualLogin, otpLogin);
                          }
                        },
                        isLoading: authController.isLoading,
                      ) : const SizedBox.shrink(),
                      SizedBox(height:  manualLogin == 1 || otpLogin == 1 ? Dimensions.paddingSizeDefault : 0),


                      (manualLogin == 1 || otpLogin == 1) && socialLogin == 1 ? Center(child: Text('or'.tr,
                        style: ubuntuRegular.copyWith(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
                        fontSize: Dimensions.fontSizeSmall,
                      ))) : const SizedBox(),



                      (manualLogin == 1 || otpLogin == 1) &&  socialLogin == 1 ? Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('sign_in_with'.tr, style: ubuntuRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
                            fontSize: Dimensions.fontSizeSmall,
                          )),
                          otpLogin == 1 && manualLogin == 1 ? TextButton(
                            onPressed: (){

                              String phoneWithoutCountryCode = PhoneVerificationHelper.getValidPhoneNumber(Get.find<AuthController>().getUserNumber());
                              String countryCode = PhoneVerificationHelper.getCountryCode(Get.find<AuthController>().getUserNumber());

                              if(authController.selectedLoginMedium == LoginMedium.otp){
                                authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.manual);
                                signInPhoneController.text = phoneWithoutCountryCode !="" ? phoneWithoutCountryCode : authController.getUserNumber();
                                if(countryCode !="" ){
                                  authController.toggleIsNumberLogin(value: true);
                                }else{
                                  authController.toggleIsNumberLogin(value: false);
                                }
                                authController.initCountryCode(countryCode: countryCode != ""? countryCode : null);
                                signInPasswordController.text = authController.getUserPassword();

                                if(signInPasswordController.text.isEmpty){
                                  signInPhoneController.text = "";
                                  authController.toggleIsNumberLogin(value: false);
                                }
                              }else{
                                authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.otp);
                                authController.toggleIsNumberLogin(value: true);
                                signInPasswordController.clear();

                                signInPhoneController.text = phoneWithoutCountryCode;
                                authController.initCountryCode(countryCode: countryCode != "" ? countryCode : null);
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, minimumSize: const Size(30,30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(authController.selectedLoginMedium == LoginMedium.manual ? 'OTP'.tr : "email_phone".tr , style: ubuntuRegular.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).colorScheme.primary,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Dimensions.fontSizeSmall,
                              )),
                            ),
                          ) : const SizedBox()

                        ],
                      )) : const SizedBox.shrink(),


                      socialLogin == 1 ? SocialLoginWidget(fromPage: widget.fromPage,) : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),


                      manualLogin == 1 ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${'do_not_have_an_account'.tr} ',
                            style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),

                          TextButton(
                            onPressed: (){
                              signInPhoneController.clear();
                              signInPasswordController.clear();

                              Get.toNamed(RouteHelper.getSignUpRoute());

                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50,30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                            ),
                            child: Text('sign_up_here'.tr, style: ubuntuRegular.copyWith(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: Dimensions.fontSizeSmall,
                            )),
                          )
                        ],
                      ) : const SizedBox.shrink(),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),


                    ]),
                  ),
                );
              }),
            ),
          ),
        )),
      ),
    );
  }

  _initializeController(){
    var authController  = Get.find<AuthController>();
    String phoneWithoutCountryCode = PhoneVerificationHelper.getValidPhoneNumber(Get.find<AuthController>().getUserNumber());
    String countryCode = PhoneVerificationHelper.getCountryCode(Get.find<AuthController>().getUserNumber());

    var config = Get.find<SplashController>().configModel.content;
    var manualLogin = config?.customerLogin?.loginOption?.manualLogin ?? 1;

    WidgetsBinding.instance.addPostFrameCallback((_){
      if(countryCode != "" && phoneWithoutCountryCode !=""){
        authController.toggleIsNumberLogin(value: true);
      }else{
        authController.toggleIsNumberLogin(value: false);
      }
      authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.manual);
      authController.initCountryCode(countryCode: countryCode !="" ? countryCode : null);

      signInPhoneController.text = phoneWithoutCountryCode != "" ? phoneWithoutCountryCode : authController.isNumberLogin ? "" : Get.find<AuthController>().getUserNumber();
      signInPasswordController.text = Get.find<AuthController>().getUserPassword();

      if(manualLogin == 1 && signInPasswordController.text.isEmpty){
        signInPhoneController.text = "";
        authController.initCountryCode();
        authController.toggleIsNumberLogin(value: false);
      }
    });
    authController.toggleRememberMe(value: false, shouldUpdate: false);
  }

  Future<bool> _existFromApp() async{
    if(widget.exitFromApp) {
      if (_canExit) {
        if (GetPlatform.isAndroid) {
          SystemNavigator.pop();
        } else if (GetPlatform.isIOS) {
          exit(0);
        } else {
          Navigator.pushNamed(context, RouteHelper.getInitialRoute());
        }
        return Future.value(false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        ));
        _canExit = true;
        Timer(const Duration(seconds: 2), () {
          _canExit = false;
        });
        return Future.value(false);
      }
    }else {
      return true;
    }
  }

  void _login(AuthController authController, var manualLogin, var otpLogin) async {
    if(customerSignInKey.currentState!.validate()){

      var config = Get.find<SplashController>().configModel.content;

      SendOtpType type = config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;

      String phone = PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+signInPhoneController.text.trim(), withCountryCode: true);

      if((authController.selectedLoginMedium == LoginMedium.otp) || (manualLogin == 0 && otpLogin == 1) ){
        authController.sendVerificationCode(identity: phone, identityType : "phone", type: type, checkUser: 0).then((status) {
         if(status != null){
           if(status.isSuccess!){
             Get.toNamed(RouteHelper.getVerificationRoute(
               identity: phone,identityType: "phone",
               fromPage: config?.firebaseOtpVerification == 1 ? "firebase-otp" : "otp-login",
               firebaseSession: type == SendOtpType.firebase ? status.message : null,
             ));
           }else{
             customSnackBar(status.message.toString().capitalizeFirst);
           }
         }
        });
      }else{
        authController.login(fromPage : widget.fromPage, emailPhone :phone !="" ? phone : signInPhoneController.text.trim(), password : signInPasswordController.text.trim(), type : phone !="" ? "phone" : "email");
      }
    }
  }
}
