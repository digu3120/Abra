import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class VerificationScreen extends StatefulWidget {
  final String? identity;
  final String fromPage;
  final String identityType;
  final String? firebaseSession;
  const VerificationScreen({super.key, this.identity, required this.fromPage, required this.identityType, this.firebaseSession});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {

  String? _identity;
  Timer? _timer;
  int? _seconds = 0;

  @override
  void initState() {
    super.initState();
    if(widget.identityType == "phone" && !widget.identity!.startsWith('+')){
      _identity = '+${widget.identity!.substring(1, widget.identity!.length)}';
    } else{
      _identity = widget.identity;
    }

    _startTimer();
  }

  void _startTimer() {
    _seconds = Get.find<SplashController>().configModel.content?.resentOtpTime?? 60 ;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds! - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title: 'otp_verification'.tr),
      body: SafeArea(child: FooterBaseView(
        isCenter:true,
        child: WebShadowWrap(
          child: Scrollbar(child: SizedBox(
            height: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height-130,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeLarge),
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.isDesktop(context)?Dimensions.webMaxWidth/3.5:
                        ResponsiveHelper.isTab(context)? Dimensions.webMaxWidth/5.5 : 0
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      Image.asset(Images.otp, width: 140),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                        // Text(
                        //   'for_demo_purpose'.tr, style: ubuntuRegular,
                        // ),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(text: 'we_have_sent_a_verification_code_to'.tr, style: ubuntuRegular.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),

                            )),
                            TextSpan(text: StringParser.obfuscateMiddle(_identity??""), style: ubuntuMedium.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color,)
                            ),
                            // const TextSpan(text: "\n"),
                            // TextSpan(text: 'otp_will_be_expire'.tr, style: ubuntuRegular.copyWith(
                            //     color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                            //   height: 2,
                            // )),

                          ],
                        ),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),

                      PinCodeTextField(
                        length: 6,
                        appContext: context,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.slide,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          fieldHeight: ResponsiveHelper.isMobile(context) ? width/9 : 60,
                          fieldWidth: ResponsiveHelper.isMobile(context) ? width/9 : 60,
                          borderWidth: 0.5,
                          activeBorderWidth: 0.5,
                          inactiveBorderWidth: 0.5,
                          errorBorderWidth: 0.5,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          selectedColor: authController.isWrongOtpSubmitted ? Theme.of(context).colorScheme.error.withOpacity(0.5) : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          selectedFillColor: Get.isDarkMode?Colors.grey.withOpacity(0.6):Colors.white,
                          inactiveFillColor: Theme.of(context).cardColor,
                          inactiveColor: Theme.of(context).colorScheme.primary.withOpacity(Get.isDarkMode ?  0.7 : 0.2),
                          activeColor: authController.isWrongOtpSubmitted ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          activeFillColor: Theme.of(context).cardColor,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        onChanged: authController.updateVerificationCode,
                        beforeTextPaste: (text) => true,
                        pastedTextStyle: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                        textStyle: ubuntuMedium,
                      ),

                        authController.isWrongOtpSubmitted ? Text('incorrect_otp'.tr,
                          style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.error),
                          textAlign: TextAlign.center,
                        ) : const Text(" "),

                        const SizedBox(height: Dimensions.paddingSizeSmall,),

                        CustomButton(
                          buttonText: "verify".tr,
                          isLoading: authController.isLoading,
                          onPressed: authController.verificationCode.length == 6 ? (){
                            _otpVerify(_identity!,widget.identityType, authController.verificationCode,authController);
                          } : null,
                        ) ,

                        const SizedBox(height: Dimensions.paddingSizeEight,),

                        (widget.identity != null && widget.identity!.isNotEmpty) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(
                            'did_not_receive_the_code'.tr,
                            style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5)),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                minimumSize: const Size(1, 40),
                                backgroundColor: Theme.of(context).cardColor,
                                textStyle: TextStyle(color: Theme.of(context).primaryColor)
                            ),
                            onPressed: _seconds! < 1 ? () {

                              var config = Get.find<SplashController>().configModel.content;
                              SendOtpType  type = config?.firebaseOtpVerification == 1 && widget.identityType == "phone"
                                  ? SendOtpType.firebase : widget.fromPage == "verification" ? SendOtpType.verification : SendOtpType.forgetPassword;

                              authController.sendVerificationCode(identity: _identity!, identityType: widget.identityType, type: type).then((status){
                                if(status !=null){
                                  if (status.isSuccess!) {
                                    _startTimer();
                                    customSnackBar('resend_code_successful'.tr, type : ToasterMessageType.success);
                                  } else {
                                    customSnackBar(status.message);
                                  }
                                }
                              });
                            } : null,
                            child: Text('${'resend'.tr}${_seconds! > 0 ? ' ($_seconds)' : ''}',style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.primary,)),
                          ),
                        ]) : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
                    ],),
                  );
                }),
              ),
            ),
          )),
        ),
      )),
    );
  }
  void _otpVerify(String identity,String identityType,String otp, AuthController authController) async {

    if(widget.fromPage == "verification" || widget.fromPage == "profile"){
      authController.verifyOtpForVerificationScreen(identity,identityType,otp).then((status){
        if(status.isSuccess!){
          customSnackBar(status.message,type : ToasterMessageType.success);
          if( widget.fromPage == "profile"){
            Get.find<UserController>().getUserInfo(reload: false);
           if(Navigator.canPop(Get.context!)){
             Navigator.pop(Get.context!);
           }else{
             Get.toNamed(RouteHelper.getEditProfileRoute());
           }
          }else{
            Get.toNamed(RouteHelper.getSignInRoute());
          }

        }else{
          customSnackBar(status.message.toString().capitalizeFirst);
        }
      });
    }else if(widget.fromPage == "otp-login"){
        authController.verifyOtpForPhoneOtpLogin(identity, otp);
    }
    else if(widget.fromPage == "firebase-otp"){
      authController.verifyOtpForFirebaseOtp(session: widget.firebaseSession, phone: identity, code: otp);
    }else{
      authController.updateForgetPasswordUrlSessionExpiredStatus(status: false);
      authController.verifyOtpForForgetPasswordScreen(identity,identityType,otp).then((status) async {
        if (status.isSuccess!) {
          Get.offNamed(RouteHelper.getChangePasswordRoute(body: ForgetPasswordBody(
            identity: identity,
            identityType: identityType,
            otp: otp,
            fromUrl: 0
          )));
        }else {
          customSnackBar(status.message.toString().capitalizeFirst);
        }
      });
    }
  }
}
