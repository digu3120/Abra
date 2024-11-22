import 'package:demandium/feature/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class SocialLoginButton extends StatelessWidget {
  final String? title;
  final String ? fromPage;
  final SocialLoginType socialLoginType;
  final bool showPadding;
  const SocialLoginButton({super.key, this.title, required this.socialLoginType, required this.fromPage, required this.showPadding});

  @override
  Widget build(BuildContext context) {
    return  Padding( padding:  EdgeInsets.only(
      right : showPadding && Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 2,
      left : showPadding && !Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 2 ,
    ),
      child: InkWell(
        onTap: ()=> _onTap(socialLoginType: socialLoginType, fromPage: fromPage),
        child: TextHover(
          builder: (hovered){
            return  Container(
              height: title !=null ? 47 : 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(hovered ? 0.1 : 0.05),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.15), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(padding: EdgeInsets.symmetric(
                      horizontal: title?.trim() == "" ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeEight ,
                  ),
                    child: Image.asset(
                      socialLoginType == SocialLoginType.google ? Images.google :
                      socialLoginType == SocialLoginType.facebook ? Images.facebook : Images.apple,
                      height: ResponsiveHelper.isDesktop(context) ? 25 :ResponsiveHelper.isTab(context) ? 25 :20,
                      width: ResponsiveHelper.isDesktop(context) ?  25 :ResponsiveHelper.isTab(context) ? 25 : 20,
                    ),
                  ),
                  title !=null && title!.trim() != "" ? Text( title!.tr,style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)
                  ),) : const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void route(bool isRoute, String? token, String errorMessage, String? tempToken, UserInfoModel? userInfoModel, String? socialLoginMedium, String? userName, String? email) async {
    if (isRoute) {
      if(token != null){
        Get.offAllNamed(RouteHelper.getMainRoute("home"));
      }else if(tempToken != null){
        Get.toNamed(RouteHelper.getUpdateProfileRoute(email: email ?? "", tempToken: tempToken, userName: userName ?? ""));

      }else if(userInfoModel != null){
        showModalBottomSheet(
          context: Get.context!,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) => ExistingAccountBottomSheet(userInfoModel: userInfoModel, socialLoginMedium: socialLoginMedium!),
          backgroundColor: Colors.transparent,
        );
      }
      else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(errorMessage),
            backgroundColor: Colors.red));
      }

    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(errorMessage),
          backgroundColor: Colors.red));
    }
  }



  _onTap ({required SocialLoginType socialLoginType,String? fromPage}) async {

    if(socialLoginType == SocialLoginType.google){
      await Get.find<AuthController>().socialLogin();
      String? id = '', token = '', email = '', medium ='', userName = '';
      if(Get.find<AuthController>().googleAccount != null){
        id = Get.find<AuthController>().googleAccount?.id;
        email = Get.find<AuthController>().googleAccount?.email;
        userName = Get.find<AuthController>().googleAccount?.displayName;
        token = Get.find<AuthController>().auth?.accessToken ;
        medium = 'google';

        Get.find<AuthController>().loginWithSocialMedia(
          SocialLogInBody(email: email, userName: userName, token: token, uniqueId: id, medium: medium, guestId: Get.find<SplashController>().getGuestId()
          ), route, fromPage: fromPage,
        );

      }
    }

    else if(socialLoginType == SocialLoginType.facebook){
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        Map userData = await FacebookAuth.instance.getUserData();
        Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
            email: userData['email'], userName: userData['name'], token: result.accessToken!.token, uniqueId: result.accessToken!.userId, medium: 'facebook',
            guestId: Get.find<SplashController>().getGuestId()
        ), route ,fromPage: fromPage);
      }
    }

    else if(socialLoginType == SocialLoginType.apple){
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
          email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: "apple",
          guestId: Get.find<SplashController>().getGuestId(),
        userName: credential.givenName ?? credential.familyName
      ),route,fromPage: fromPage);
    }
  }
}
