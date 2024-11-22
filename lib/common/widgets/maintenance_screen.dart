import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> with WidgetsBindingObserver {

  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final SplashController splashController = Get.find<SplashController>();
      splashController.getConfigData().then((bool isSuccess) {
        if(isSuccess){
          final config = splashController.configModel;
          if(config.content?.maintenanceMode?.maintenanceStatus == 0) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    var configModel = Get.find<SplashController>().configModel.content;

    return CustomPopScopeWidget(
      onPopInvoked: (){
        if(_canExit) {
          exit(0);
        }else {
          customSnackBar('back_press_again_to_exit'.tr, type : ToasterMessageType.info);
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: WebShadowWrap(
            child: Container(
              width: Dimensions.webMaxWidth,
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                  Image.asset(Images.maintenance, width: ResponsiveHelper.isDesktop(context)? 350 : 250),
                  SizedBox(height: size.height * 0.07),

                  Text(configModel?.maintenanceMode?.maintenanceMessages?.maintenanceMessage ?? "maintenance_title".tr,
                    textAlign: TextAlign.center,
                    style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(configModel?.maintenanceMode?.maintenanceMessages?.messageBody ?? "maintenance_subtitle".tr,
                    textAlign: TextAlign.center,
                    style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                  if(configModel?.maintenanceMode?.maintenanceMessages?.businessEmail == 1 ||
                      configModel?.maintenanceMode?.maintenanceMessages?.businessNumber == 1) ...[

                    Row(
                      children: List.generate(size.width ~/10, (index) => Expanded(
                        child: Container(
                          color: index%2==0?Colors.transparent
                              :Theme.of(context).hintColor.withOpacity(0.2),
                          height: 1.2,
                        ),
                      )),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                    Text(configModel?.maintenanceMode?.maintenanceMessages?.businessEmail == 1 && configModel?.maintenanceMode?.maintenanceMessages?.businessNumber == 1
                        ? 'any_query_feel_free_to_call_or_email'.tr : configModel?.maintenanceMode?.maintenanceMessages?.businessEmail == 1
                        ? "any_query_feel_free_to_email".tr : "any_query_feel_free_to_call".tr,
                      style: ubuntuMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    configModel?.maintenanceMode?.maintenanceMessages?.businessNumber == 1 ? InkWell(
                      onTap: (){
                        launchUrl(Uri.parse(
                          'tel:${configModel?.businessPhone ?? ""}',
                        ), mode: LaunchMode.externalApplication);
                      },
                      child: Text(configModel?.businessPhone ?? "",
                        style: ubuntuMedium.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Dimensions.fontSizeDefault,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ): const SizedBox(),

                    SizedBox(height:configModel?.maintenanceMode?.maintenanceMessages?.businessNumber == 1 ? Dimensions.paddingSizeExtraSmall : 0),

                    configModel?.maintenanceMode?.maintenanceMessages?.businessEmail == 1 ? InkWell(
                      onTap: () async {
                        await launchUrl(Uri(
                          scheme: 'mailto',
                          path: configModel?.businessEmail ?? "",
                        ));
                      },
                      child: Text(configModel?.businessEmail ?? "",
                        style: ubuntuMedium.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Dimensions.fontSizeDefault,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ) : const SizedBox(),

                  ]
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
