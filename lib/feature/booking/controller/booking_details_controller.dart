import 'package:demandium/common/models/popup_menu_model.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';


enum BookingDetailsTabs {bookingDetails, status}
class BookingDetailsController extends GetxController implements GetxService{
  BookingDetailsRepo bookingDetailsRepo;
  BookingDetailsController({required this.bookingDetailsRepo});

  BookingDetailsTabs _selectedDetailsTabs = BookingDetailsTabs.bookingDetails;
  BookingDetailsTabs get selectedBookingStatus =>_selectedDetailsTabs;


  final bookingIdController = TextEditingController();
  final phoneController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  BookingDetailsContent? _bookingDetailsContent;
  BookingDetailsContent? get bookingDetailsContent => _bookingDetailsContent;

  BookingDetailsContent? _subBookingDetailsContent;
  BookingDetailsContent? get subBookingDetailsContent => _subBookingDetailsContent;

  DigitalPaymentMethod? _selectedDigitalPaymentMethod;
  DigitalPaymentMethod ? get selectedDigitalPaymentMethod => _selectedDigitalPaymentMethod;


  void updateBookingStatusTabs(BookingDetailsTabs bookingDetailsTabs){
    _selectedDetailsTabs = bookingDetailsTabs;
    update();
  }


  Future<void> bookingCancel({required String bookingId, bool fromListScreen = false,})async{
    _isCancelling = true;
    update();
    Response? response =  await  bookingDetailsRepo.bookingCancel(bookingID: bookingId);
    if(response.statusCode == 200 && response.body['response_code']=="status_update_success_200"){
      _isCancelling = false;
      customSnackBar('booking_cancelled_successfully'.tr, type : ToasterMessageType.success);
      if(fromListScreen) {
        Get.find<ServiceBookingController>().updateBookingStatusTabs(
            Get.find<ServiceBookingController>().selectedBookingStatus,
        );
      }else{
        await getBookingDetails(bookingId: bookingId);
        Get.find<ServiceBookingController>().updateBookingStatusTabs(
          Get.find<ServiceBookingController>().selectedBookingStatus,
        );
      }

    }else if(response.statusCode == 200 && (response.body['response_code'] == "booking_already_accepted_200"
        || response.body['response_code'] == "booking_already_ongoing_200" || response.body['response_code'] == "booking_already_completed_200")){
      customSnackBar(response.body['message'] ?? "");
      await getBookingDetails(bookingId: bookingId);
      _isCancelling = false;
    }
    else{
      _isCancelling = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> subBookingCancel({required String subBookingId})async{
    _isCancelling = true;
    update();
    Response? response =  await  bookingDetailsRepo.subBookingCancel(bookingID: subBookingId);
    if(response.statusCode == 200 ){
      _isCancelling = false;

      await getSubBookingDetails(bookingId: subBookingId);
      if(_bookingDetailsContent != null){
        getBookingDetails(bookingId: _bookingDetailsContent?.id ?? "", reload : false );
      }
      customSnackBar('booking_cancelled_successfully'.tr, type : ToasterMessageType.success);
    } else{
      _isCancelling = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getBookingDetails({required String bookingId, bool reload = true})async{
    if(reload){
      _bookingDetailsContent = null;
    }
    Response response = await bookingDetailsRepo.getBookingDetails(bookingID: bookingId);
    if(response.statusCode == 200){
      _bookingDetailsContent = BookingDetailsContent.fromJson(response.body['content']);
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getSubBookingDetails({required String bookingId})async{

    _subBookingDetailsContent = null;
    Response response = await bookingDetailsRepo.getSubBookingDetails(bookingID: bookingId);
    if(response.statusCode == 200){
      _subBookingDetailsContent = BookingDetailsContent.fromJson(response.body['content']);

    } else {
      ApiChecker.checkApi(response);
    }
    update();

  }


  Future<void> trackBookingDetails(String bookingReadableId, String phone, {bool reload = false}) async {
    if(reload){
      _isLoading = true;
      update();
    }
    if( reload || _bookingDetailsContent == null){

      Response response = await bookingDetailsRepo.trackBookingDetails(bookingID: bookingReadableId, phoneNUmber: phone);
      if(response.statusCode == 200){
        _bookingDetailsContent = BookingDetailsContent.fromJson(response.body['content']);

      }else{
        _bookingDetailsContent = null;
        _isLoading = false;
        update();
      }
    }else{

    }
    if(reload){
      _isLoading = false;
      update();
    }
  }

  void updateSelectedDigitalPayment({DigitalPaymentMethod? value, bool shouldUpdate = true}){
    _selectedDigitalPaymentMethod = value;
    if(shouldUpdate){
      update();
    }
  }

  void resetBookingDetailsValue({bool shouldUpdate = false, bool resetBookingDetails = false}){
    _selectedDetailsTabs = BookingDetailsTabs.bookingDetails;
    _subBookingDetailsContent = null;
    if(resetBookingDetails){
      _bookingDetailsContent = null;
    }
  }


  void resetTrackingData({bool shouldUpdate = true}){
    bookingIdController.clear();
    phoneController.clear();
    _bookingDetailsContent = null;

    if(shouldUpdate){
      update();
    }
  }

  List<PopupMenuModel> getPopupMenuList(String status) {
    if (status == "pending") {
      return [
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        PopupMenuModel(title: "cancel", icon: Icons.cancel_outlined),
      ];
    } else if(status == "completed"){
      return [
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        PopupMenuModel(title: "review", icon: Icons.reviews_outlined),
      ];
    }
    return [];
  }

  List<PopupMenuModel> getPServiceLogMenuList({required String status,  bool nextService = false}) {

    if (status == "pending") {
      return [
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),

      ];
    } else if (status == "accepted") {
      return [
        if(nextService) PopupMenuModel(title: "booking_details", icon: Icons.remove_red_eye),
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        if(!nextService) PopupMenuModel(title: "cancel", icon: Icons.cancel_outlined),
      ];
    }

    else if (status == "ongoing" || status == "completed" || status == "canceled") {
      return [
        PopupMenuModel(title: "booking_details", icon: Icons.remove_red_eye),
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),

      ];
    }
    return [];
  }

}