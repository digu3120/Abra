import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String? phone;
  final String? email;
  final String? tempToken;
  final String? userName;
  const UpdateProfileScreen({super.key, this.phone, this.email, this.tempToken, this.userName});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailPhoneController = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _phoneEmailFocus = FocusNode();

  bool _canExit = GetPlatform.isWeb ? true : false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setUserName();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: ()=> _existFromApp(),
      child: Scaffold(

        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : AppBar(
          elevation: 0, backgroundColor: Colors.transparent,
          leading:  IconButton(
            hoverColor:Colors.transparent,
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
            color: Theme.of(context).textTheme.bodyLarge!.color,
            onPressed: () {
              Navigator.pop(context);
              _socialLogout();
            },
          ),
        ) ,

        endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,

        body: SafeArea(child: FooterBaseView(
          isCenter: true,
          child: WebShadowWrap(
            child: Center(
              child: GetBuilder<AuthController>(builder: (authController) {

                return Form(
                  autovalidateMode: ResponsiveHelper.isDesktop(context) ?AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth /3.5 :
                      ResponsiveHelper.isTab(context) ? Dimensions.webMaxWidth / 5.5 : Dimensions.paddingSizeLarge,
                    ),
                    child: Column( children: [


                      Hero(tag: Images.logo,
                        child: Image.asset(Images.logo, width: Dimensions.logoSize),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Text('just_one_step_away'.tr,
                          style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        title: 'first_name'.tr,
                        hintText: 'first_name'.tr,
                        controller: firstNameController,
                        inputType: TextInputType.name,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        capitalization: TextCapitalization.words,
                        onValidate: (String? value){
                          return FormValidation().isValidFirstName(value!);
                        },
                      ),

                      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
                      CustomTextField(
                        title: 'last_name'.tr,
                        hintText: 'last_name'.tr,
                        focusNode: _lastNameFocus,
                        nextFocus: _phoneEmailFocus,
                        controller: lastNameController,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        onValidate: (String? value){
                          return FormValidation().isValidLastName(value!);
                        },
                      ),

                      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                      CustomTextField(
                        onCountryChanged: (CountryCode countryCode) {
                          authController.countryDialCode = countryCode.dialCode!;
                        },
                        countryDialCode: (widget.email !="") ? authController.countryDialCode : null,
                        title: 'email_address'.tr,
                        hintText: (widget.email !="") ? "please_enter_phone_number".tr :'enter_email_address'.tr,
                        inputType: TextInputType.emailAddress,
                        focusNode: _phoneEmailFocus,
                        controller: emailPhoneController,
                        onValidate: (String? value){
                          if(widget.email != "" && PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+ emailPhoneController.text.trim(), withCountryCode: true) == ""){
                            return "enter_valid_phone_number".tr;
                          }else if(widget.email == ""){
                            return null;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                      CustomButton(buttonText: "done".tr, onPressed: (){
                        _updateProfileAndNavigate(authController);
                      }, isLoading: authController.isLoading,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeTextFieldGap * 2),

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



  void _setUserName (){
    if(widget.userName  !=null && widget.userName !=""){
      String fullName = widget.userName!.trim();
      List<String> nameParts = fullName.split(' ');

      if (nameParts.length == 1) {
        firstNameController.text = nameParts.first;
        lastNameController.text = "";
      }else{
        firstNameController.text = nameParts.first;
        lastNameController.text = nameParts.sublist(1).join(' ');
      }
    }
  }

  _socialLogout(){
    Get.find<AuthController>().googleLogout();
    Get.find<AuthController>().signOutWithFacebook();
  }

  Future<bool> _existFromApp() async{
    if (_canExit) {
      if (GetPlatform.isAndroid) {
        SystemNavigator.pop();
      } else if (GetPlatform.isIOS) {
        exit(0);
      } else {
        _socialLogout();
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
  }

  _updateProfileAndNavigate (AuthController authController) async {

    if(formKey.currentState!.validate()){
      final String firstName = firstNameController.text.toString();
      final String lastName = lastNameController.text.toString();
      final String email = emailPhoneController.text.trim();
      String phone = PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+ emailPhoneController.text.trim(), withCountryCode: true);

     if(widget.tempToken != ""){
       await authController.registerWithSocialMedia(firstName: firstName, lastName: lastName, email: widget.email, phone: phone);

     }else{
       await authController.updateNewUserProfileAndLogin(firstName: firstName, lastName: lastName, email: email, phone: widget.phone);
     }

    }
  }
}
