import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class EditProfileAccountInfo extends StatefulWidget {
  const EditProfileAccountInfo({super.key}) ;

  @override
  State<EditProfileAccountInfo> createState() => _EditProfileAccountInfoState();
}

class _EditProfileAccountInfoState extends State<EditProfileAccountInfo> {
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> accountInfoKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if(accountInfoKey.currentState != null){
      accountInfoKey.currentState!.validate();
    }

    return Form(
      key: accountInfoKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GetBuilder<UserController>(builder: (editProfileTabController){
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      CustomTextField(
                        title: 'new_password'.tr,
                        hintText: '**************',
                        controller: passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        onValidate: (String? value){
                          return  FormValidation().isValidPassword(value!);
                        },
                      ),

                      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
                      CustomTextField(
                        title: 'confirm_new_password'.tr,
                        hintText: '**************',
                        controller: confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        onValidate: (String? value) {
                          if(value == null || value.isEmpty){
                            return 'this_field_can_not_empty'.tr;
                          }else{
                            return FormValidation().isValidConfirmPassword(
                              passwordController.text, confirmPasswordController.text,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],
                  ),
                ),
              ),

              CustomButton(
                isLoading: editProfileTabController.isLoading,
                buttonText: 'change_password'.tr,
                onPressed: () async {
                  if(accountInfoKey.currentState!.validate()){
                    UserInfoModel userInfoModel = UserInfoModel(
                      fName: editProfileTabController.userInfoModel?.fName ??"",
                      lName: editProfileTabController.userInfoModel?.lName ??"",
                      email: editProfileTabController.userInfoModel?.email ?? "",
                      phone: (editProfileTabController.userInfoModel?.phone ??""),
                      password: passwordController.text.trim(),
                      confirmPassword: confirmPasswordController.text.trim()
                    );
                    await editProfileTabController.updateUserProfile(userInfoModel: userInfoModel);
                  }},
              )
            ],
          );
        }),
      ),
    );
  }

  Widget customRichText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
          text: TextSpan(children: <TextSpan>[
        TextSpan(text: title, style: ubuntuRegular.copyWith(color: const Color(0xff2C3439))),
        TextSpan(text: ' *', style: ubuntuRegular.copyWith(color: Colors.red)),
      ])),
    );
  }
}
