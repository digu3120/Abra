import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  final String? route;
  const SplashScreen({super.key, @required this.body, this.route});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if(!firstTime) {
        bool isNotConnected = result.first != ConnectivityResult.wifi && result.first != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    if( Get.find<SplashController>().getGuestId().isEmpty){
      var uuid = const Uuid().v1();
      Get.find<SplashController>().setGuestId(uuid);
    }

    Get.find<SplashController>().initSharedData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged?.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) async {

      if(Get.find<LocationController>().getUserAddress() != null){
        AddressModel addressModel = Get.find<LocationController>().getUserAddress()!;
        ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(addressModel.latitude.toString(), addressModel.longitude.toString(), false);
        addressModel.availableServiceCountInZone = responseModel.totalServiceCount;
        Get.find<LocationController>().saveUserAddress(addressModel);
      }


      if(isSuccess) {
        Timer(const Duration(seconds: 1), () async {

          if(_checkAvailableUpdate()) {
            Get.offNamed(RouteHelper.getUpdateRoute('update'));
          }
          else if(_checkMaintenanceModeActive() && !AppConstants.avoidMaintenanceMode){
            Get.offAllNamed(RouteHelper.getMaintenanceRoute());
          }
          else {
            if(widget.body != null) {
              _notificationRoute();
            }
            else {
              if(Get.find<SplashController>().isShowInitialLanguageScreen()){
                Get.offNamed(RouteHelper.getLanguageScreen('fromOthers'));
              } else if(Get.find<SplashController>().isShowOnboardingScreen()){
                Get.offAllNamed(RouteHelper.onBoardScreen);
              }else{
                Get.offNamed(RouteHelper.getInitialRoute());
              }

            }
          }
        });
      }else{

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        PriceConverter.getCurrency();
        return Center(
          child: splashController.hasConnection ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Image.asset(
                Images.logo,
                width: Dimensions.logoSize,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ],
          ) : NoInternetScreen(child: SplashScreen(body: widget.body)),
        );
      }),
    );
  }

  bool _checkAvailableUpdate (){
    ConfigModel? configModel = Get.find<SplashController>().configModel;
    final localVersion = Version.parse(AppConstants.appVersion);
    final serverVersion = Version.parse(GetPlatform.isAndroid
        ? configModel.content?.minimumVersion?.minVersionForAndroid ?? ""
        :  configModel.content?.minimumVersion?.minVersionForIos ?? ""
    );
    return localVersion.compareTo(serverVersion) == -1;
  }

  bool _checkMaintenanceModeActive(){
    final ConfigModel configModel = Get.find<SplashController>().configModel;
    return (configModel.content?.maintenanceMode?.maintenanceStatus == 1 && configModel.content?.maintenanceMode?.selectedMaintenanceSystem?.mobileApp == 1);
  }

  void _notificationRoute(){

    String notificationType = widget.body?.notificationType??"";

    switch(notificationType) {

      case "chatting": {
        Get.toNamed(RouteHelper.getInboxScreenRoute(fromNotification: "fromNotification"));
      } break;

      case "bidding": {
        Get.toNamed(RouteHelper.getMyPostScreen(fromNotification: "fromNotification"));
      } break;

      case "booking" || 'booking_ignored': {
        if( widget.body!.bookingId!=null&& widget.body!.bookingId!=""){
          if(widget.body?.bookingType == "repeat" && widget.body?.repeatBookingType == "single"){
            Get.toNamed(RouteHelper.getBookingDetailsScreen( subBookingId : widget.body!.bookingId!,fromPage: 'fromNotification'));
          }else if(widget.body?.bookingType == "repeat" && widget.body?.repeatBookingType != "single"){
            Get.toNamed(RouteHelper.getRepeatBookingDetailsScreen( bookingId : widget.body!.bookingId, fromPage : "fromNotification"));
          }else{
            Get.toNamed(RouteHelper.getBookingDetailsScreen( bookingID:widget.body!.bookingId!,fromPage: 'fromNotification'));
          }
        }else{
          Get.toNamed(RouteHelper.getMainRoute(""));
        }
      } break;

      case "privacy_policy": {
        Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
      } break;

      case "terms_and_conditions": {
        Get.toNamed(RouteHelper.getHtmlRoute("terms-and-condition"));
      } break;

      case "wallet": {
        Get.toNamed(RouteHelper.getMyWalletScreen(fromNotification: "fromNotification"));
      } break;

      case "loyalty_point": {
        Get.toNamed(RouteHelper.getLoyaltyPointScreen(fromNotification: "fromNotification"));
      } break;

      default: {
        Get.toNamed(RouteHelper.getNotificationRoute());
      } break;
    }
  }
}
