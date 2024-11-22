import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class EditProfileGeneralInfo extends StatefulWidget {
  final JustTheController tooltipController;
  const EditProfileGeneralInfo({super.key, required this.tooltipController}) ;

  @override
  State<EditProfileGeneralInfo> createState() => _EditProfileGeneralInfoState();
}

class _EditProfileGeneralInfoState extends State<EditProfileGeneralInfo> {
  final GlobalKey<FormState> updateProfileKey = GlobalKey<FormState>();

  final FocusNode _firstName = FocusNode();
  final FocusNode _lastName = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneWithCountry = FocusNode();

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setControllerValue();
  }
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController){
      return GetBuilder<UserController>(builder: (userController){

        var userInfo = userController.userInfoModel;
        var config = Get.find<SplashController>().configModel.content;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Form(
                    key: updateProfileKey,
                    child: Column(
                      children: [
                        SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge  : 0 ),
                        _profileImageSection(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        CustomTextField(
                          title: 'first_name'.tr,
                          hintText: 'first_name'.tr,
                          controller: firstNameController,
                          inputType: TextInputType.name,
                          focusNode: _firstName,
                          nextFocus: _lastName,
                          capitalization: TextCapitalization.words,
                          onValidate: (String? value){
                            return FormValidation().isValidFirstName(value!);
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
                        CustomTextField(
                          title: 'last_name'.tr,
                          hintText: 'last_name'.tr,
                          focusNode: _lastName,
                          isEnabled: true,
                          nextFocus: _phoneWithCountry,
                          controller: lastNameController,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          onValidate: (String? value){
                            return FormValidation().isValidLastName(value!);
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                        Tooltip(
                          preferBelow: false,
                          triggerMode: TooltipTriggerMode.manual,
                          message: config?.emailVerification == 1 ? userInfo?.isEmailVerified == 1 ? "email_is_verified".tr : 'email_not_verified'.tr : "",
                          child: CustomTextField(
                            title: 'email'.tr,
                            hintText: 'email'.tr,
                            focusNode: _emailFocus,
                            controller: emailController,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            suffixIconUrl:  emailController.text != "" ? userInfo?.isEmailVerified == 1 ? Images.verified : config?.emailVerification == 1 ? Images.error : null : null,
                            onSuffixTap: userInfo?.isEmailVerified == 0 && config?.emailVerification == 1 ? () async {
                              SendOtpType  type = SendOtpType.verification ;
                              Get.dialog(const CustomLoader(), barrierDismissible: false);
                              await authController.sendVerificationCode(identity: emailController.text, identityType: "email", type: type).then((status){
                                Get.back();
                                if(status != null){
                                  if(status.isSuccess!){
                                    Get.toNamed(RouteHelper.getVerificationRoute(
                                      identity: emailController.text,identityType: "email",
                                      fromPage: "profile",
                                      firebaseSession: type == SendOtpType.firebase ? status.message : null,
                                    ));
                                  }else{
                                    customSnackBar(status.message.toString().capitalizeFirst ?? "" );
                                  }
                                }
                              });
                            } : null ,
                            onValidate: (String? value){
                              return FormValidation().isValidEmail(value);
                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Tooltip(
                          preferBelow: false,
                          triggerMode: TooltipTriggerMode.manual,
                          message: config?.phoneVerification == 1 ? userInfo?.isPhoneVerified == 1 ? 'cant_update_phone_number'.tr : 'phone_number_not_verified'.tr : "",
                          child: Container(
                            decoration: BoxDecoration(
                              color: userInfo?.isPhoneVerified == 1 ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
                            ),
                            child: CustomTextField(
                              onCountryChanged: (CountryCode countryCode) {
                                userController.countryDialCode = countryCode.dialCode!;
                              },
                              countryDialCode: userController.countryDialCode,
                              title: 'phone'.tr,
                              hintText: 'enter_phone_number'.tr,
                              isEnabled: userInfo?.isPhoneVerified == 1 ? false : true,
                              inputType: TextInputType.phone,
                              focusNode: _phoneWithCountry,
                              controller: phoneController,
                              suffixIconUrl: userInfo?.isPhoneVerified == 1 ? Images.verified : config?.phoneVerification == 1 ? Images.error : null,

                              onSuffixTap: userInfo?.isPhoneVerified == 0 && config?.phoneVerification == 1 ? () async {
                                Get.dialog(const CustomLoader(), barrierDismissible: false);
                                SendOtpType  type = config?.firebaseOtpVerification == 1 ? SendOtpType.firebase :  SendOtpType.verification ;
                                await authController.sendVerificationCode(identity: userController.countryDialCode + phoneController.text, identityType: "phone", type: type, fromPage: "profile").then((status){

                                  if(status != null){
                                    Get.back();
                                    if(status.isSuccess!){
                                      Get.toNamed(RouteHelper.getVerificationRoute(
                                        identity: userController.countryDialCode + phoneController.text,identityType: "phone",
                                        fromPage: "profile",
                                        firebaseSession: type == SendOtpType.firebase ? status.message : null,
                                      ));
                                    }else{
                                      customSnackBar(status.message.toString().capitalizeFirst ?? "" );
                                    }
                                  }
                                });


                              } : null ,

                              onValidate: (String? value) {
                                if(value == null || value.isEmpty){
                                  return 'enter_phone_number'.tr;
                                }else{
                                  return FormValidation().isValidPhone(userController.countryDialCode+value,fromAuthPage: true
                                  );
                                }
                              },
                            ),
                          ),
                        ),


                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: CustomButton(
                isLoading: userController.isLoading,
                fontSize: Dimensions.fontSizeDefault,
                width: Get.width,
                radius: Dimensions.radiusDefault,
                buttonText: 'update_information'.tr,
                onPressed: () {
                  if (updateProfileKey.currentState!.validate()) {
                    UserInfoModel userInfoModel = UserInfoModel(
                      fName: firstNameController.text.trim(),
                      lName: lastNameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: userController.countryDialCode + phoneController.value.text.trim(),
                    );
                    userController.updateUserProfile(userInfoModel: userInfoModel);
                  }
                },
              ),
            ),
          ],
        );
      });
    });
  }

  Widget _profileImageSection() {
    return GetBuilder<UserController>(builder: (editProfileTabController){
      return Container(
        height: 120,
        width: Get.width,
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(Get.context!)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(.2),
                      width: 1),
                ),
                child: ClipOval(
                  child: editProfileTabController.pickedProfileImageFile == null
                      ? CustomImage(
                      placeholder: Images.placeholder,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      image: Get.find<UserController>().userInfoModel?.imageFullPath ?? "")
                      : kIsWeb
                      ? Image.network(editProfileTabController.pickedProfileImageFile!.path,
                      height: 100.0, width: 100.0, fit: BoxFit.cover)
                      : Image.file(
                      File(editProfileTabController.pickedProfileImageFile!.path)),
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.camera_enhance_rounded,
                  color: Theme.of(Get.context!).cardColor,
                ),
                onTap: () {
                  Get.find<UserController>().pickProfileImage();

                  },
              )
            ],
          ),
        ),
      );
    });
  }

  _setControllerValue(){
    UserController userController = Get.find<UserController>();
    firstNameController.text = userController.userInfoModel?.fName ?? "";
    lastNameController.text = userController.userInfoModel?.lName ?? "";
    emailController.text = userController.userInfoModel?.email ?? "";
    phoneController.text = PhoneVerificationHelper.updateCountryAndNumberInEditProfilePage(
        userController.userInfoModel?.phone != null ? Get.find<UserController>().userInfoModel!.phone! :'');
  }
}

