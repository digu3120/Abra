import 'package:demandium/common/models/popup_menu_model.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/booking/model/service_availability_model.dart';
import 'package:demandium/feature/booking/widget/provider_available_bottom_sheet.dart';
import 'package:demandium/feature/booking/widget/service_unavailable_dialog.dart';
import 'package:get/get.dart';

enum BookingStatusTabs {all, pending, accepted, ongoing,completed,canceled }

class ServiceBookingController extends GetxController implements GetxService {
  final ServiceBookingRepo serviceBookingRepo;

  ServiceBookingController({required this.serviceBookingRepo});

  List<BookingModel>? _bookingList;

  List<BookingModel>? get bookingList => _bookingList;
  int _offset = 1;

  int? get offset => _offset;
  BookingContent? _bookingContent;

  BookingContent? get bookingContent => _bookingContent;

  int _bookingListPageSize = 0;
  final int _bookingListCurrentPage = 0;

  int get bookingListPageSize => _bookingListPageSize;

  int get bookingListCurrentPage => _bookingListCurrentPage;
  BookingStatusTabs _selectedBookingStatus = BookingStatusTabs.all;

  BookingStatusTabs get selectedBookingStatus => _selectedBookingStatus;

  bool _isNotAvailable = false;
  bool get isNotAvailable => _isNotAvailable;

  bool _isPriceChanged = false;
  bool get isPriceChanged => _isPriceChanged;

  ServiceAvailabilityModel? serviceAvailability;

  int _rebookIndex=-1;
  int get  selectedRebookIndex => _rebookIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ServiceType selectedServiceType = ServiceType.all;


  void updateBookingStatusTabs(BookingStatusTabs bookingStatusTabs,
      {bool firstTimeCall = true, bool fromMenu = false}) {
    _selectedBookingStatus = bookingStatusTabs;
    if (firstTimeCall) {
      getAllBookingService(offset: 1, bookingStatus: _selectedBookingStatus.name.toLowerCase(), isFromPagination: false,
        serviceType: selectedServiceType.name
      );
    }
  }


  Future<void> getAllBookingService({required int offset, required String bookingStatus, required bool isFromPagination, bool fromMenu = false, required String serviceType}) async {
    _offset = offset;
    if (!isFromPagination) {
      _bookingList = null;
    }
    Response response = await serviceBookingRepo.getBookingList(offset: offset, bookingStatus: bookingStatus, serviceType: serviceType);
    if (response.statusCode == 200) {
      ServiceBookingList serviceBookingModel = ServiceBookingList.fromJson(
          response.body);
      if (!isFromPagination) {
        _bookingList = [];
      }
      for (var element in serviceBookingModel.content!.bookingModel!) {
        _bookingList!.add(element);
      }
      _bookingListPageSize = response.body['content']['last_page'];
      _bookingContent = serviceBookingModel.content!;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> rebook(String bookingId, {bool isBack = false}) async {
    _isLoading = true;
    update();
    Response response = await serviceBookingRepo.addRebookToServer(bookingId);
    _isLoading = false;
    update();
    if (response.statusCode == 200) {
      if(isBack){
        Get.back();
      }
      Get.find<CartController>().getCartListFromServer(shouldUpdate: true);
      customSnackBar(response.body['message'], type : ToasterMessageType.success);
    }
  }


  Future<void> checkRebookAvailability(String bookingId) async {
    _isPriceChanged = false;
    _isNotAvailable = false;
    _isLoading = true;
    update();

    Get.dialog(const CustomLoader(), barrierDismissible: true);

    Response response = await serviceBookingRepo.rebookCheck(bookingId);

    Get.back();
    serviceAvailability = ServiceAvailabilityModel.fromJson(response.body);
    _isLoading = false;
    update();
    if(response.statusCode == 200) {

      for(int i=0; i<serviceAvailability!.content!.services!.length; i++) {
        if (!_isPriceChanged && serviceAvailability!.content!.services![i].isPriceChanged == 1) {
          _isPriceChanged = true;
        }
        if (!_isNotAvailable && serviceAvailability!.content!.services![i].isAvailable == 0) {
          _isNotAvailable = true;
        }
        update();
      }

      if(serviceAvailability!.content!.isProviderAvailable! == 1 && !_isNotAvailable && !_isPriceChanged) {
        await rebook(bookingId);
      } else if (serviceAvailability!.content!.isProviderAvailable! == 0) {
        if (ResponsiveHelper.isDesktop(Get.context)) {
           Get.dialog(Center(child: RebookWarningBottomSheet(bookingId: bookingId)));
        } else {
          Get.bottomSheet(RebookWarningBottomSheet(bookingId: bookingId), backgroundColor: Colors.transparent, isScrollControlled: true);
        }
      } else if (_isNotAvailable || _isPriceChanged) {
        if (ResponsiveHelper.isDesktop(Get.context)) {
          Get.dialog(Center(child: ServiceUnavailableDialog(bookingId: bookingId, isPriceChanged: _isPriceChanged, isNotAvailable: _isNotAvailable, isAllNotAvailable: checkAllServiceAvailable(serviceAvailability!.content!.services),)));
        } else {
          Get.bottomSheet(ServiceUnavailableDialog(bookingId: bookingId, isPriceChanged: _isPriceChanged, isNotAvailable: _isNotAvailable, isAllNotAvailable: checkAllServiceAvailable(serviceAvailability!.content!.services)), backgroundColor: Colors.transparent, isScrollControlled: true);
        }
      }
    }else{
      ApiChecker.checkApi(response);
    }
  }


    Future<void> checkCartSubcategory(String bookingId, String subcategoryId) async {
      if(Get.find<CartController>().cartList.isNotEmpty) {
        List<CartModel> cartList =  Get.find<CartController>().cartList;
        if(cartList[0].subCategoryId != subcategoryId) {
          Get.dialog(ConfirmationDialog(
            icon: Images.warning,
            title: "are_you_sure_to_reset".tr,
            description: 'you_have_service_from_other_sub_category'.tr,
            onYesPressed: () async {
              Get.find<CartController>().removeAllCartItem();
              checkRebookAvailability(bookingId);
              Get.back();
            },
          ));
        }else {
          await checkRebookAvailability(bookingId);
        }
      } else {
        await checkRebookAvailability(bookingId);
      }
    }

  void updateRebookIndex (int index) {
    _rebookIndex = index;
    update();
  }


  bool checkAllServiceAvailable (List<Services>? services) {
    bool available = true;
    for (int i = 0; i< services!.length; i++) {
      if(available && services[i].isAvailable == 1) {
        available = false;
      }
    }
    return available;
  }

  void updateSelectedServiceType({ServiceType? type}){
    if(type!=null){
      selectedServiceType = type;
      update();
      getAllBookingService(offset: 1, bookingStatus: _selectedBookingStatus.name, isFromPagination: false, serviceType: type.name);
    }else{
      selectedServiceType = ServiceType.all;
    }
  }

  List<PopupMenuModel> getPopupMenuList({required String status, bool isRepeatBooking = false, RepeatBooking? ongoingRepeatBooking }) {
    if (status == "pending") {
      return [
        PopupMenuModel(title: "booking_details", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        PopupMenuModel(title: "cancel", icon: Icons.cancel_outlined),
      ];
    } else if (status == "accepted" || status == "ongoing") {
      return [
        PopupMenuModel(title: "booking_details", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
      ];
    }
    else if (status == "canceled"|| status == "completed") {
      return [
        PopupMenuModel(title: "booking_details", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        if(!isRepeatBooking)  PopupMenuModel(title: "rebook", icon: Icons.repeat),
      ];
    }
    return [];
  }

}
