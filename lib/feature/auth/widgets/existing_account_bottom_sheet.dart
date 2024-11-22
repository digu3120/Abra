import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ExistingAccountBottomSheet extends StatefulWidget {
  final UserInfoModel userInfoModel;
  final String socialLoginMedium;
  const ExistingAccountBottomSheet({
    super.key,
    required this.userInfoModel,
    required this.socialLoginMedium
  });


  @override
  State<ExistingAccountBottomSheet> createState() => _ExistingAccountBottomSheetState();
}

class _ExistingAccountBottomSheetState extends State<ExistingAccountBottomSheet> {
  @override
  Widget build(BuildContext context) {
    if(ResponsiveHelper.isDesktop(context)) {
      return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor(){
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: ResponsiveHelper.isWeb()? 0 :Dimensions.cartDialogPadding),
      child: PointerInterceptor(
        child: GetBuilder<AuthController>(builder: (authProvider){
          return Container(
            width: ResponsiveHelper.isDesktop(context) ? 550 : Dimensions.webMaxWidth,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: ResponsiveHelper.isDesktop(context) ? const BorderRadius.all(Radius.circular(20)) : const BorderRadius.vertical(top: Radius.circular(20)),
              color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surface,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              const SizedBox(height: Dimensions.paddingSizeLarge),
              ResponsiveHelper.isDesktop(context) ? const SizedBox() : Container(
                height: 5, width: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Theme.of(context).hintColor.withOpacity(0.50)
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeLarge * 1.5),

              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CustomImage(
                  image: widget.userInfoModel.imageFullPath ?? "",
                  fit: BoxFit.cover, height: 100, width: 100,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text("${widget.userInfoModel.fName} ${widget.userInfoModel.lName}",
                style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Text('is_it_you'.tr,
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.isDesktop(context) ? size.width * 0.03 : size.height * 0.02,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children:[

                    TextSpan(
                      text: 'it_looks_like_the_email'.tr,
                      style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    TextSpan(
                      text: ' ${StringParser.obfuscateMiddle(widget.userInfoModel.email??"")} ',
                      style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                          height: 2
                      ),
                    ),

                    TextSpan(
                      text: 'already_used_existing_account'.tr,
                      style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).hintColor,
                          height: 1.2
                      ),
                    ),

                  ],),),
              ),
              SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.03 : size.height * 0.05),

              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Row(children: [
                  Expanded(flex: 5, child: CustomButton(
                    backgroundColor: Theme.of(context).hintColor,
                    isLoading: authProvider.isLoading,
                    buttonText: 'no'.tr,
                    onPressed: (){
                      Navigator.pop(context);
                      authProvider.existingAccountCheck(email: widget.userInfoModel.email!, userResponse: 0, medium: widget.socialLoginMedium);
                    },
                  ),),

                  Expanded(child: Container()),

                  Expanded(flex: 5,child: CustomButton(
                    isLoading: authProvider.isLoading,
                    buttonText : 'yes_its_me'.tr,
                    onPressed: (){
                      Navigator.pop(context);
                      authProvider.existingAccountCheck(email: widget.userInfoModel.email!, userResponse: 1, medium: widget.socialLoginMedium);
                    },
                  ),),
                ],),
              ),
              SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.04 : Dimensions.paddingSizeLarge),


            ],),
          );
        }),
      ),
    );
  }
}