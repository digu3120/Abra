import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {

  final TextEditingController _identityController = TextEditingController();


  String countryDialCode = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _identityFocus = FocusNode();

  bool _isNumberLogin = false;

  String _forgetPasswordMethod = "phone";

  @override
  void initState() {
    super.initState();
    countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content!.countryCode!).dialCode?? "+880";
    var config = Get.find<SplashController>().configModel.content;
    if(config?.forgetPasswordVerificationMethod?.phone == 1 && config?.forgetPasswordVerificationMethod?.email == 1){
      _forgetPasswordMethod = "both";
    }else if(config?.forgetPasswordVerificationMethod?.phone == 1){
      _forgetPasswordMethod = "phone";
    }else{
      _forgetPasswordMethod = "email";
    }
    toggleIsNumberLogin(value: false,isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title:'forgot_password'.tr.replaceAll("?", " "),
        onBackPressed: (){
        if(Navigator.canPop(context)){
          Get.back();
        }else{
          Get.toNamed(RouteHelper.getSignInRoute());
        }
        },
      ),

      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (authController){
            return FooterBaseView(
              isCenter: true,
              child: WebShadowWrap(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isDesktop(context)?Dimensions.webMaxWidth/3.5:
                    ResponsiveHelper.isTab(context)? Dimensions.webMaxWidth/5.5 : 0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Form(
                      key: formKey,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset(Images.forgotPass, width: 100, height: 100,),

                        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                          child: Center(child: Text('${"verify_your".tr} ${_forgetPasswordMethod == "email"? "email_address".tr.toLowerCase()
                              : _forgetPasswordMethod == "phone" ? "phone_number".tr.toLowerCase() : "email_phone".tr}',
                            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.9)),textAlign: TextAlign.center,
                          )),
                        ),

                        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge*1.5),
                          child: Center(child: Text('${"please_enter_your".tr} ${_forgetPasswordMethod == "email"?"email_address".tr.toLowerCase()
                              :  _forgetPasswordMethod == "phone" ? "phone_number".tr.toLowerCase() :"email_phone".tr} ${"to_receive_a_verification_code".tr}',
                            style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7)),textAlign: TextAlign.center,
                          )),
                        ),

                        CustomTextField(
                          onCountryChanged: (countryCode) => countryDialCode = countryCode.dialCode!,
                          countryDialCode: (_forgetPasswordMethod != "email" && _isNumberLogin)  ? countryDialCode : null,
                          title: _forgetPasswordMethod == "email" ? "email_address".tr : _forgetPasswordMethod == "phone_number" ? "phone".tr: 'email_phone'.tr,
                          hintText: _forgetPasswordMethod == "email" ? "enter_email_address".tr : _forgetPasswordMethod == "phone" ? 'ex : 1234567890'.tr : 'enter_email_or_phone'.tr,
                          controller: _identityController,
                          focusNode: _identityFocus,
                          inputType: TextInputType.emailAddress,
                          onChanged: (String text){
                            final numberRegExp = RegExp(r'^-?[0-9]+$');

                            if(text.isEmpty && _isNumberLogin){
                              toggleIsNumberLogin();
                            }
                            if(text.startsWith(numberRegExp) && !_isNumberLogin ){
                              toggleIsNumberLogin();
                            }
                            final emailRegExp = RegExp(r'@');
                            if(text.contains(emailRegExp) && _isNumberLogin){
                              toggleIsNumberLogin();
                            }

                          },
                          onValidate: (String? value){

                            if(_isNumberLogin && (_forgetPasswordMethod == "phone" || _forgetPasswordMethod == "both") &&  PhoneVerificationHelper.getValidPhoneNumber(countryDialCode+value!) == ""){
                              return "enter_valid_phone_number".tr;
                            }
                            if(_forgetPasswordMethod == "email" && !GetUtils.isEmail(value!)){
                              return "enter_valid_email_address".tr;
                            }
                            return (GetUtils.isPhoneNumber(value!.tr) || GetUtils.isEmail(value.tr)) ? null : 'enter_email_or_phone'.tr;
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge * 1.5),
                        GetBuilder<AuthController>(builder: (authController) {
                          return CustomButton(
                            buttonText: 'send_verification_code'.tr,
                            isLoading: authController.isLoading,
                            fontSize: Dimensions.fontSizeDefault,
                            onPressed: ()=> formKey.currentState!.validate() ? _forgetPass(countryDialCode,authController) : null,
                          );
                        }),
                       const SizedBox(height: Dimensions.paddingSizeLarge*4),
                          ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _forgetPass(String countryDialCode,AuthController authController) async {
    String phone = PhoneVerificationHelper.getValidPhoneNumber(countryDialCode + _identityController.text.trim(), withCountryCode: true);
    String identity = phone !="" ? phone : _identityController.text.trim();

    var config = Get.find<SplashController>().configModel.content;
    SendOtpType  type = config?.firebaseOtpVerification == 1 && phone != "" ? SendOtpType.firebase : SendOtpType.forgetPassword;

    authController.sendVerificationCode(identity: identity, identityType: phone !="" ? "phone" : "email", type: type).then((status){
      if(status != null){
        if(status.isSuccess!){
          Get.toNamed(RouteHelper.getVerificationRoute(
            identity: identity,identityType: phone !="" ? "phone" : "email",
            fromPage: "forget-password",
            firebaseSession: type == SendOtpType.firebase ? status.message : null,
          ));
        }else{
          customSnackBar(status.message.toString().capitalizeFirst ?? "" );
        }
      }
    });

    }

  toggleIsNumberLogin ({bool? value, bool isUpdate = true}){
    if(_forgetPasswordMethod == "both"){
      if(isUpdate){
        setState(() {
          if(value == null){
            _isNumberLogin = !_isNumberLogin;
          }else{
            _isNumberLogin = value;
          }
        });
      }else{
        if(value == null){
          _isNumberLogin = !_isNumberLogin;
        }else{
          _isNumberLogin = value;
        }
      }
    } else if(_forgetPasswordMethod == "phone"){
      _isNumberLogin= true;
    }
  }
}

