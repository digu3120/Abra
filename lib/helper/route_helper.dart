import'dart:convert';
import 'package:demandium/feature/auth/view/update_profile_screen.dart';
import 'package:demandium/feature/booking/view/repeat_booking_details_screen.dart';
import 'package:demandium/feature/provider/view/nearby_provider/near_by_provider_screen.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class RouteHelper {

  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String offers = '/offers';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  static const String verification = '/verification';
  static const String sendOtpScreen = '/send-otp';
  static const String changePassword = '/change-password';
  static const String searchScreen = '/search';
  static const String serviceDetails = '/service-details';
  static const String profile = '/profile';
  static const String profileEdit = '/profile-edit';
  static const String notification = '/notification';
  static const String address = '/address';
  static const String orderSuccess = '/order-completed';
  static const String checkout = '/checkout';
  static const String customPostCheckout = '/custom-checkout';
  static const String html = '/html';
  static const String categories = '/categories';
  static const String categoryProduct = '/category';
  static const String support = '/support';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String chatScreen = '/chat-screen';
  static const String chatInbox = '/chat-inbox';
  static const String onBoardScreen = '/onBoardScreen';
  static const String settingScreen = '/settingScreen';
  static const String languageScreen = '/language';
  static const String voucherScreen = '/vouchers';
  static const String bookingListScreen = '/booking-list';
  static const String bookingDetailsScreen = '/booking-details';
  static const String repeatBookingDetailsScreen = '/repeat-booking';
  static const String trackBooking = '/track-booking';
  static const String rateReviewScreen = '/rate-review-screen';
  static const String allServiceScreen = '/service';
  static const String featheredServiceScreen = '/feathered-service-screen';
  static const String subCategoryScreen = '/subcategory-screen';
  static const String notLoggedScreen = '/not-logged-screen';
  static const String suggestService = '/suggest-service';
  static const String suggestServiceList = '/suggest-service-list';
  static const String myWallet = '/my-wallet';
  static const String loyaltyPoint = '/my-point';
  static const String referAndEarn = '/refer-and-earn';
  static const String allProviderList = '/all-provider';
  static const String providerDetailsScreen = '/provider-details';
  static const String providerReviewScreen = '/provider-review-screen';
  static const String providerAvailabilityScreen = '/provider-availability-screen';
  static const String createPost = '/create-post';
  static const String createPostSuccessfully = '/create-post-successfully';
  static const String myPost = '/my-post';
  static const String providerOfferList = '/provider-offer-list';
  static const String providerOfferDetails = '/provider-offer-details';
  static const String providerWebView = '/provider-web-view';
  static const String serviceArea = '/service-area';
  static const String serviceAreaMap = '/service-area-map';
  static const String customImageListScreen = '/custom-image-list-screen';
  static const String zoomImage = '/zoom-image';
  static const String favorite = '/favorite';
  static const String nearByProvider = '/nearby-provider';
  static const String maintenance = '/maintenance';
  static const String updateProfile = '/update-profile';



  static String getInitialRoute() => initial;
  static String getSplashRoute(NotificationBody? body, String? route) {
    String data = 'null';
    if(body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data&route=$route';
  }
  static String getOffersRoute() => offers;
  static String getSignInRoute({String? fromPage}) => '$signIn?page=$fromPage';
  static String getSignUpRoute() => signUp;
  static String getSendOtpScreen() => sendOtpScreen;

  static String getVerificationRoute({required String identity,required String identityType,required  String fromPage, String? firebaseSession}) {
    String data = Uri.encodeComponent(jsonEncode(identity));
    String session = base64Url.encode(utf8.encode(firebaseSession ?? ''));


    return '$verification?identity=$data&identity_type=$identityType&fromPage=$fromPage&session=$session';
  }

  static String getChangePasswordRoute({ForgetPasswordBody? body}) {
    String data= "";
    if( body !=null ){
      List<int> encodedCBody= utf8.encode(jsonEncode(body.toJson()));
      data  = base64Encode(encodedCBody);
    }
    return '$changePassword?token=$data';
  }

  static String getAccessLocationRoute(String page) => '$accessLocation?page=$page';
  static String getPickMapRoute(String page, bool canRoute, String isFromCheckout, ZoneModel? zone, AddressModel? previousAddress) {
    String zoneData = "";
    String addressData = "";
    if( zone !=null ){
      List<int> encodedCategory = utf8.encode(jsonEncode(zone.toJson()));
      zoneData  = base64Encode(encodedCategory);
    }
    if(previousAddress != null) {
      List<int> encodedAddress = utf8.encode(jsonEncode(previousAddress.toJson()));
      addressData  = base64Encode(encodedAddress);
    }
   return '$pickMap?page=$page&route=${canRoute.toString()}&checkout=$isFromCheckout&zone=$zoneData&address=$addressData';
  }

  static String getMainRoute(String page, {AddressModel? previousAddress, String? showServiceNotAvailableDialog}) {
    String data = '';
    if(previousAddress != null){
      List<int> encoded = utf8.encode(jsonEncode(previousAddress.toJson()));
      data = base64Encode(encoded);
    }
    return '$home?page=$page&address=$data&showDialog=$showServiceNotAvailableDialog';
  }

  static String getSearchResultRoute({String? queryText, String? fromPage}) {
    String data = '';
    if(queryText != null && queryText != '' && queryText != 'null'){
      List<int> encoded = utf8.encode(jsonEncode(queryText));
      data = base64Encode(encoded);
    }
    return '$searchScreen?fromPage=${fromPage??''}&query=$data';
  }

  static String getServiceRoute(String id, {String fromPage="others"}) => '$serviceDetails?id=$id&fromPage=$fromPage';
  static String getProfileRoute() => profile;
  static String getEditProfileRoute() => profileEdit;
  static String getNotificationRoute() => notification;
  static String getAddressRoute(String fromPage) => '$address?fromProfileScreen=$fromPage';
  static String getOrderSuccessRoute( String status) => '$orderSuccess?flag=$status';
  static String getCheckoutRoute(String page,String currentPage,String addressId, {bool? reload, String? token} ) =>
      '$checkout?currentPage=$currentPage&addressID=$addressId&reload=$reload&token=$token';

  static String getCustomPostCheckoutRoute(String postId,String providerId,String amount, String bidId) {
    List<int> encoded = utf8.encode(amount);
    String data = base64Encode(encoded);
    return "$customPostCheckout?postId=$postId&providerId=$providerId&amount=$data&bid_id=$bidId";
  }
  static String getTrackBookingRoute() => trackBooking;
  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getCategoryRoute(String fromPage,String campaignID) => '$categories?fromPage=$fromPage&campaignID=$campaignID';
  static String getCategoryProductRoute(String id, String name, String subCategoryIndex) {
    return '$categoryProduct?id=$id&index=$subCategoryIndex';
  }
  static String getSupportRoute() => support;
  static String getUpdateRoute(String fromPage) => '$update?update=$fromPage';
  static String getCartRoute() => cart;
  static String getAddAddressRoute(bool fromCheckout) => '$addAddress?page=${fromCheckout ? 'checkout' : 'address'}';
  static String getEditAddressRoute(AddressModel address,bool fromCheckout) {
    String data = base64Url.encode(utf8.encode(jsonEncode(address.toJson())));
    return '$editAddress?data=$data&page=${fromCheckout ? 'checkout' : 'address'}';
  }
  static String getChatScreenRoute(String channelId,String name,String image,String phone,String userType, {String? fromNotification}) =>
      '$chatScreen?channelID=$channelId&name=$name&image=$image&phone=$phone&userType=$userType&fromNotification=$fromNotification';
  static String getSettingRoute() => settingScreen;
  static String getBookingScreenRoute(bool isFromMenu) => '$bookingListScreen?isFromMenu=$isFromMenu';
  static String getInboxScreenRoute({String? fromNotification}) => '$chatInbox?fromNotification=$fromNotification';
  static String getVoucherRoute({required String fromPage}) => "$voucherScreen?fromCheckout=$fromPage";
  static String getBookingDetailsScreen({String? bookingID, String? subBookingId ,  String? phone , String? fromPage} ) =>
      '$bookingDetailsScreen?booking_id=$bookingID&sub_booking_id=$subBookingId&phone=$phone&fromPage=$fromPage';
  static String getRepeatBookingDetailsScreen({String? bookingId,  String? fromPage, String? subBookingId}) =>
      '$repeatBookingDetailsScreen?booking_id=$bookingId&sub_booking_id=$subBookingId&fromPage=$fromPage';
  static String getRateReviewScreen(String id) => '$rateReviewScreen?id=$id';
  static String allServiceScreenRoute(String fromPage, {String campaignID = ''}) => '$allServiceScreen?fromPage=$fromPage&campaignID=$campaignID';
  static String getFeatheredCategoryService(String fromPage, String categoryId) => '$featheredServiceScreen?fromPage=$fromPage&categoryId=$categoryId';
  static String subCategoryScreenRoute(String categoryName,String categoryID,int subCategoryIndex) =>
      '$subCategoryScreen?categoryName=$categoryName&categoryId=$categoryID&subCategoryIndex=$subCategoryIndex';
  static String getLanguageScreen(String fromPage) => '$languageScreen?fromPage=$fromPage';
  static String getNotLoggedScreen(String fromPage,String appbarTitle) => '$notLoggedScreen?fromPage=$fromPage&appbarTitle=$appbarTitle';
  static String getMyWalletScreen({String? flag , String? token, String? fromNotification}) =>
      '$myWallet?flag=$flag&&token=$token&fromNotification=$fromNotification';
  static String getLoyaltyPointScreen({String? fromNotification}) => '$loyaltyPoint?fromNotification=$fromNotification';
  static String getReferAndEarnScreen() => referAndEarn;
  static String getNewSuggestedServiceScreen() => suggestService;
  static String getNewSuggestedServiceList() => suggestServiceList;
  static String getAllProviderRoute() => allProviderList;
  static String getProviderDetails(String providerId) =>
      '$providerDetailsScreen?id=$providerId';
  static String getProviderReviewScreen(String providerId) =>
      '$providerReviewScreen?id=$providerId';
  static String getProviderAvailabilityScreen(String providerId) =>
      '$providerAvailabilityScreen?provider_id=$providerId';
  static String getCreatePostScreen({String? schedule}){
    List<int> encoded = utf8.encode(jsonEncode(schedule));
    String data = base64Encode(encoded);
    return "$createPost?schedule=$data";
  }
  static String getCreatePostSuccessfullyScreen() => createPostSuccessfully;
  static String getMyPostScreen({String? fromNotification}) => '$myPost?fromNotification=$fromNotification';
  static String getProviderOfferListScreen(String postId ,String status, MyPostData myPostData) {
    List<int> encoded = utf8.encode(jsonEncode(myPostData.toJson()));
    String data = base64Encode(encoded);
     return "$providerOfferList?postId=$postId&myPostData=$data&status=$status";
  }
  static String getProviderOfferDetailsScreen(String postId , ProviderOfferData providerOfferData) {
    List<int> encoded = utf8.encode(jsonEncode(providerOfferData.toJson()));
    String data = base64Encode(encoded);
    return "$providerOfferDetails?postId=$postId&providerOfferData=$data";
  }
  static String getProviderWebView() => providerWebView;
  static String getServiceArea() => serviceArea;
  static String getServiceAreaMap() => serviceAreaMap;
  static String getNearByProviderScreen({int tabIndex = 0}) => "$nearByProvider?tabIndex=$tabIndex";
  static String getCustomImageListScreen({required List<String> imageList, required String imagePath,required int index, String? appBarTitle, String? createdAt}) {
    String imageListString = base64Encode(utf8.encode(jsonEncode(imageList)));
    return '$customImageListScreen?imageList=$imageListString&imagePath=$imagePath&index=$index&appBarTitle=$appBarTitle&createdAt=$createdAt';
  }
  static String getZoomImageScreen({required String image, required String imagePath, String? createdAt}) =>
      '$zoomImage?image=$image&imagePath=$imagePath&createdAt=$createdAt';
  static String getMyFavoriteScreen() => favorite;
  static String getMaintenanceRoute() => maintenance;
  static String getUpdateProfileRoute({String? phone, String? email, String? tempToken, String? userName}) {
    final String data1= Uri.encodeComponent(jsonEncode(phone??""));
    final String data2= Uri.encodeComponent(jsonEncode(email??""));
    final String data3= Uri.encodeComponent(jsonEncode(tempToken??""));
    final String data4= Uri.encodeComponent(jsonEncode(userName??""));
    return "$updateProfile?phone=$data1&email=$data2&temp-token=$data3&user-name=$data4";
  }


  static List<GetPage> routes = [
    GetPage(
      name: initial, binding: BottomNavBinding(),
      page: () => getRoute(ResponsiveHelper.isDesktop(Get.context)
          ? AccessLocationScreen(fromSignUp: false,route: RouteHelper.getMainRoute('home'))
          : const BottomNavScreen(pageIndex: 0, previousAddress: null, showServiceNotAvailableDialog: true,)),
    ),
    GetPage(name: splash, page: () {
      NotificationBody? data;
      if(Get.parameters['data'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
        data = NotificationBody.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return SplashScreen(body: data, route: Get.parameters['route'],);
    }),
    GetPage(name: languageScreen, page: () => LanguageScreen(fromPage: Get.parameters['fromPage'],)),
    GetPage(name: offers, page: () => getRoute(const OfferScreen())),
    GetPage(name: signIn, page: () =>
        SignInScreen(
          exitFromApp: Get.parameters['page'] == signUp || Get.parameters['page'] == splash,
          fromPage: Get.parameters['page'] ,
        )),
    GetPage(name: signUp, page: () => const SignUpScreen()),


    GetPage(name: accessLocation, page: () => AccessLocationScreen(
      fromHome: Get.parameters['page'] == 'home',
      fromSignUp: Get.parameters['page'] == signUp, route: null,
    )),
    GetPage(
        name: pickMap,
        page: () {
          PickMapScreen? pickMapScreen = Get.arguments;
          bool fromAddress = Get.parameters['page'] == 'add-address';
          ZoneModel? zoneData;
          AddressModel? addressData;
          if(Get.parameters['zone'] != ""){
            try{
              List<int> category = base64Decode(Get.parameters['zone'] ?? "");
              zoneData = ZoneModel.fromJson(jsonDecode(utf8.decode(category)));
            }catch(e){
              if (kDebugMode) {
                print("");
              }
            }
          }
          if(Get.parameters['address'] != ""){
            try{
              List<int> address = base64Decode(Get.parameters['address'] ?? "");
              addressData = AddressModel.fromJson(jsonDecode(utf8.decode(address)));
            }catch(e){
              if (kDebugMode) {
                print("");
              }
            }
          }

          return (fromAddress && pickMapScreen == null) ? const NotFoundScreen() :
            pickMapScreen ?? PickMapScreen(
              fromSignUp: Get.parameters['page'] == signUp,
              fromAddAddress: fromAddress,
              route: Get.parameters['page'],
              canRoute: Get.parameters['route'] == 'true',
              formCheckout: Get.parameters['checkout'] == 'true',
              zone: zoneData, previousAddress: addressData,
      );
    }),

    GetPage(binding: BottomNavBinding(), name: home, page: () {
      AddressModel? addressData;
        if(Get.parameters['address'] != ""){
          try{
            List<int> address = base64Decode(Get.parameters['address']!.replaceAll(" ", "+"));
            addressData = AddressModel.fromJson(jsonDecode(utf8.decode(address)));
          }catch(e){
            if (kDebugMode) {
              print("Address Model : $addressData");
            }
          }
        }
        return getRoute( BottomNavScreen(
          pageIndex: Get.parameters['page'] == 'home' ? 0 :
          Get.parameters['page'] == 'booking' ? 1 :
          Get.parameters['page'] == 'cart' ? 2 :
          Get.parameters['page'] == 'order' ? 3 :
          Get.parameters['page'] == 'menu' ? 4 : 0,
          previousAddress: addressData,
          showServiceNotAvailableDialog: Get.parameters['showDialog'] == 'false' ? false : true,
        ));
      },
    ),

    GetPage(name: sendOtpScreen, page:() {
      return  const ForgetPassScreen();
    }),

    GetPage(name: verification, page:() {
      String data = Uri.decodeComponent(jsonDecode(Get.parameters['identity']!));
      return VerificationScreen(
        identity: data,
        identityType: Get.parameters['identity_type']!,
        fromPage: Get.parameters['fromPage']!,
        firebaseSession: Get.parameters['session'] == 'null' ? null
            : utf8.decode(base64Url.decode(Get.parameters['session'] ?? '')),
      );
    }),

    GetPage(name: changePassword, page:() {
      List<int> decode = base64Decode(Get.parameters['token']!);
      ForgetPasswordBody? forgetPasswordBody = ForgetPasswordBody.fromJson(jsonDecode(utf8.decode(decode)));
      return NewPassScreen(
        forgetPasswordBody: forgetPasswordBody,
      );
    }),

    GetPage(name: featheredServiceScreen, page: () {
      return AllFeatheredCategoryServiceView(
        fromPage: Get.parameters['fromPage'],
        categoryId: Get.parameters['categoryId'],
      );
    }),

    GetPage(
        name: searchScreen,
        page: () {
          List<int> decode = [];
          String queryText = '';
         try{
           if(Get.parameters['query'] != '' && Get.parameters['query'] != "null"){
             decode = base64Decode(Get.parameters['query']!.replaceAll(' ', '+'));
             queryText = jsonDecode(utf8.decode(decode));
           }
         }catch (e){
           if (kDebugMode) {
             print("Error : $e");
           }
         }
          return getRoute(SearchResultScreen(
            queryText: queryText,
            fromPage: Get.parameters['fromPage'],
          ));
        }),

    GetPage(
      name: serviceDetails, binding: ServiceDetailsBinding(),
      page: () {
        return getRoute(Get.arguments ?? ServiceDetailsScreen(serviceID: Get.parameters['id'],fromPage: Get.parameters['fromPage'],));},
    ),

    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: profileEdit, page: () => getRoute(const EditProfileScreen())),
    GetPage(name: notification, page: () => getRoute(const NotificationScreen())),

      GetPage(
        name: orderSuccess,
        page: () => getRoute(OrderSuccessfulScreen(status: Get.parameters['flag'].toString().contains('success') ? 1 : 0,)),
      ),
      GetPage(name: checkout, page: () {

          if(Get.parameters['flag'] == 'failed' || Get.parameters['flag'] == 'fail' || Get.parameters['flag'] == 'cancelled' || Get.parameters['flag'] == 'canceled' || Get.parameters['flag'] == 'cancel')  {
            return getRoute(const OrderSuccessfulScreen(status: 0,));
          }
          return getRoute(CheckoutScreen(
            Get.parameters.containsKey('flag') && Get.parameters['flag']! == 'success' ? 'complete' : Get.parameters['currentPage'] ?? "orderDetails",
            Get.parameters['addressID'] != null ? Get.parameters['addressID']! :'null' ,
            reload : Get.parameters['reload'].toString() == "true" || Get.parameters['reload'].toString() == "null" ? true : false,
            token: Get.parameters["token"],
          ));
      }),

      GetPage(name: customPostCheckout, page: (){
        List<int> decode = base64Decode(Get.parameters['amount']!);
        String data = utf8.decode(decode);
        return CustomPostCheckoutScreen(
          postId: Get.parameters['postId']!,
          providerId: Get.parameters['providerId']!,
          amount: data,
          bidId: Get.parameters['bid_id']!,
        );
      }),

      GetPage(
          binding: InitialBinding(),
          name: html,
          page: () => HtmlViewerScreen(
              htmlType:
              Get.parameters['page'] == 'terms-and-condition' ? HtmlType.termsAndCondition :
              Get.parameters['page'] == 'privacy-policy' ? HtmlType.privacyPolicy :
              Get.parameters['page'] == 'cancellation_policy' ? HtmlType.cancellationPolicy :
              Get.parameters['page'] == 'refund_policy' ? HtmlType.refundPolicy :
              HtmlType.aboutUs
      )),

      GetPage(name: categories,
          page: () => getRoute(CategoryScreen(fromPage: Get.parameters['fromPage'],campaignID:Get.parameters['campaignID']))
      ),
      GetPage(name: categoryProduct, page: () {
        return getRoute(CategorySubCategoryScreen(
          categoryID: Get.parameters['id'] ?? "",
          categoryIndex: Get.parameters['index'] ?? "0",
        ));
      }),
      GetPage(name: support, page: () => SupportScreen()),
      GetPage(name: update, page: () => UpdateScreen(fromPage: Get.parameters['update'])),
      GetPage(name: cart, page: () => getRoute(const CartScreen(fromNav: false))),
      GetPage(name: addAddress, page: () => AddAddressScreen(fromCheckout: Get.parameters['page'] == 'checkout')),
      GetPage(name: editAddress, page: () {

        AddressModel? address;

        try{
          address = AddressModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['data']!.replaceAll(' ', '+')))));
        }catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
        return getRoute(AddAddressScreen(
          fromCheckout: Get.parameters['page'] == 'checkout',
          address: address,
        ));
      }),

    GetPage( name: chatScreen, transition: Transition.topLevel, page: () => ConversationDetailsScreen(
      channelID: Get.parameters['channelID'],
      name: Get.parameters['name'],
      phone: Get.parameters['phone'],
      image: Get.parameters['image'],
      userType: Get.parameters['userType'] ??"",
      formNotification: Get.parameters['fromNotification'] ?? "",
    )),

    GetPage(name: chatInbox,binding: ConversationBinding(), page: () =>  ConversationListScreen(
      fromNotification: Get.parameters['fromNotification'],
    )),

    GetPage(name: address, page: ()=> AddressScreen(fromPage:Get.parameters['fromProfileScreen'])),
    GetPage(binding: OnBoardBinding(),name: onBoardScreen, page: ()=>const OnBoardingScreen(),),
    GetPage(name: settingScreen, page: ()=>const SettingScreen(),),
    GetPage(name: voucherScreen, page: ()=>  getRoute(CouponScreen(fromCheckout: Get.parameters['fromCheckout'] == "checkout")),),
    GetPage(binding: BookingBinding(),name: bookingDetailsScreen, page: (){

      String? subBookingId;
      String? token = Get.parameters['token'];
      if(token !=null){
        try{
          subBookingId = StringParser.parseString(utf8.decode(base64Url.decode(token)), "booking_repeat_id");
        }catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
      }
      return BookingDetailsScreen(
        bookingID:  Get.parameters['booking_id'],
        subBookingId: subBookingId ?? Get.parameters['sub_booking_id'],
        phone: Get.parameters['phone'],
        fromPage: Get.parameters['fromPage'],
      );
    }),

    GetPage(binding: BookingBinding(),name: repeatBookingDetailsScreen, page: ()=> RepeatBookingDetailsScreen(
      bookingId: Get.parameters['booking_id'].toString(),
      fromPage: Get.parameters['fromPage'],
    )),

    GetPage(binding: BookingBinding(),name: trackBooking, page: ()=> const BookingTrackScreen(),),
    GetPage(binding: ServiceBinding(),name: allServiceScreen, page:  ()=> getRoute(AllServiceView(fromPage: Get.parameters['fromPage'],campaignID: Get.parameters['campaignID'],)),),
    GetPage(binding: ServiceBinding(),name: subCategoryScreen, page: ()=> SubCategoryScreen(
      categoryTitle: Get.parameters['categoryName'],
      categoryID: Get.parameters['categoryId'],
      subCategoryIndex: int.tryParse(Get.parameters['subCategoryIndex']??""),
    )),
    GetPage(
      binding: SubmitReviewBinding(),
      name: rateReviewScreen, page: () {
      return RateReviewScreen(
        id : Get.parameters['id'],
      );
    }),
    GetPage(name: bookingListScreen, page: ()=> BookingListScreen( isFromMenu: Get.parameters['isFromMenu'] == "true"? true: false)),
    GetPage(name: notLoggedScreen, page: ()=> NotLoggedInScreen(
        fromPage: Get.parameters['fromPage']!,
      appbarTitle: Get.parameters['appbarTitle']!,
    )
    ),
    GetPage(binding: SuggestServiceBinding(),name:suggestService, page:() => getRoute(const SuggestServiceScreen(),)),
    GetPage(binding: SuggestServiceBinding(),name:suggestServiceList, page:() => getRoute(const SuggestedServiceListScreen(),)),
    GetPage(binding: WalletBinding(), name: myWallet, page:() =>
        WalletScreen(status: Get.parameters['flag'], token: Get.parameters['token'], fromNotification: Get.parameters['fromNotification'],)),
    GetPage(binding: LoyaltyPointBinding(),name:loyaltyPoint, page:() => LoyaltyPointScreen(
      fromNotification: Get.parameters['fromNotification'],
    )),
    GetPage(name:referAndEarn, page:() => const ReferAndEarnScreen()),
    GetPage(name:allProviderList, page:() => getRoute(const AllProviderView(),)),
    GetPage(name:providerDetailsScreen, page:() => getRoute(ProviderDetailsScreen(providerId: Get.parameters['id']!,))),
    GetPage(name:providerReviewScreen, page:() => getRoute(ProviderReviewScreen(providerId: Get.parameters['id'],))),
    GetPage(name:providerAvailabilityScreen, page:() =>
        getRoute(ProviderAvailabilityWidget(
          providerId: Get.parameters['provider_id']!,
        ))),
    GetPage( name:createPost, page:() {
      return const CreatePostScreen(
      );
    }),
    GetPage(name:createPostSuccessfully, page:() => getRoute(const PostCreateSuccessfullyScreen(),)),
    GetPage(name:myPost, page:() => AllPostScreen(
      fromNotification: Get.parameters["fromNotification"],
    )),
    GetPage( name:providerOfferList, page:() {
      MyPostData? post;
      try{
        List<int> decode = base64Decode(Get.parameters['myPostData']!.replaceAll(' ', '+'));
        post = MyPostData.fromJson(jsonDecode(utf8.decode(decode)));
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }
     return ProviderOfferListScreen(
        postId: Get.parameters['postId'],
        myPostData: post,
        status: Get.parameters['status'],
      );
    }),

    GetPage( name:providerOfferDetails, page:() {

      List<int> decode = base64Decode(Get.parameters['providerOfferData']!.replaceAll(' ', '+'));
      ProviderOfferData data = ProviderOfferData.fromJson(jsonDecode(utf8.decode(decode)));
       return ProviderOfferDetailsScreen(
         postId: Get.parameters['postId'],
         providerOfferData: data,
       );
    }),

    GetPage(name: providerWebView, page: () => const ProviderWebView()),
    GetPage( name: serviceArea, page: () => const ServiceAreaScreen()),
    GetPage(name: serviceAreaMap, page: () => const ServiceAreaMapScreen()),
    GetPage(name: nearByProvider, page: () =>  NearByProviderScreen(
      tabIndex: int.tryParse(Get.parameters['tabIndex'] ?? "0") ?? 0,
    )),


    GetPage(
        name:customImageListScreen,
        page:() {

          List<int> decode = base64Decode(Get.parameters['imageList']!.replaceAll(' ', '+'));
          var value = jsonDecode(utf8.decode(decode));
          List<String> imageList = (value as List).map((item) => item.toString()).toList();

          return ImageDetailScreen(
            imageList: imageList,
            index : int.parse(Get.parameters['index']!),
            appbarTitle: Get.parameters['appBarTitle'],
            createdAt: Get.parameters['createdAt'],
      );
    }),


    GetPage(
      name: zoomImage,
      page:() {
        return ZoomImage(
          image: Get.parameters['image']!,
          imagePath: Get.parameters['imagePath']!,
          createdAt: Get.parameters['createdAt'],
        );
      },
    ),

    GetPage(
      name: favorite,
      page:() {
        return const MyFavoriteScreen();
      },
    ),
    GetPage(name: maintenance, page: () => const MaintenanceScreen()),
    GetPage(name: updateProfile, page: () {
      String phone = Uri.decodeComponent(jsonDecode(Get.parameters['phone']??""));
      String email = Uri.decodeComponent(jsonDecode(Get.parameters['email']??""));
      String tempToken = Uri.decodeComponent(jsonDecode(Get.parameters['temp-token']??""));
      String userName = Uri.decodeComponent(jsonDecode(Get.parameters['user-name']??""));
      return UpdateProfileScreen(
        phone: phone,
        email: email,
        tempToken: tempToken,
        userName: userName,
      );
    }),

  ];



  static getRoute(Widget navigateTo) {
    bool isRouteExist = Get.currentRoute == "/" || routes.any((route) {
      String routeName = route.name == "/" ? "*" : route.name.replaceAll("/", "");
      return Get.currentRoute.split('?')[0].replaceAll("/", "") == routeName;
    });
    var config = Get.find<SplashController>().configModel.content?.maintenanceMode;
    bool maintenance = config?.maintenanceStatus == 1 && config?.selectedMaintenanceSystem?.webApp == 1 && kIsWeb && !AppConstants.avoidMaintenanceMode;
    return !isRouteExist ?  const NotFoundScreen() : maintenance ? const MaintenanceScreen() : Get.find<LocationController>().getUserAddress() != null ? navigateTo
        : AccessLocationScreen(fromSignUp: false, route: Get.currentRoute);
  }
}
