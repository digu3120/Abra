import 'package:demandium/feature/booking/model/booking_details_model.dart';
import 'package:demandium/feature/booking/model/service_booking_model.dart';

class BookingHelper {

  static double getSubTotalCost(BookingDetailsContent booking) {
    double subTotal = 0;
    for (var element in booking.bookingDetails!) {
      subTotal = subTotal + ((element.serviceCost ?? 1) * (element.quantity ?? 1));
    }
    return subTotal;
  }

  static double getBookingServiceUnitConst(ItemService? item) {
    return  (item?.serviceCost ?? 0) * (item?.quantity ?? 1);
  }

  static RepeatBooking? getNextUpcomingRepeatBooking(BookingDetailsContent? bookingRequest) {

    if (bookingRequest  == null || bookingRequest.repeatBookingList == null || bookingRequest.repeatBookingList!.isEmpty || bookingRequest.bookingStatus == "pending") {
      return null;
    }
    for (var repeatBooking in bookingRequest.repeatBookingList!) {
      if (repeatBooking.bookingStatus == "ongoing") {
        return repeatBooking;
      }
    }
    for (var repeatBooking in bookingRequest.repeatBookingList!) {
      if (repeatBooking.bookingStatus == "accepted") {
        return repeatBooking;
      }
    }
    return null;
  }

  static String? getRepeatBookingCurrentSchedule(BookingModel bookingRequest) {
    if (bookingRequest.repeatBookingList == null || bookingRequest.repeatBookingList!.isEmpty ) {
      return bookingRequest.serviceSchedule;
    }

    final ongoingSchedule = bookingRequest.repeatBookingList?.firstWhere((repeatBooking) => repeatBooking.bookingStatus == "ongoing", orElse: () => RepeatBooking()).serviceSchedule;
    if (ongoingSchedule != null) return ongoingSchedule;

    final acceptedSchedule = bookingRequest.repeatBookingList?.firstWhere((repeatBooking) => repeatBooking.bookingStatus == "accepted", orElse: () => RepeatBooking()).serviceSchedule;
    if (acceptedSchedule != null) return acceptedSchedule;

    final completedSchedule = bookingRequest.repeatBookingList?.firstWhere((repeatBooking) => repeatBooking.bookingStatus == "completed", orElse: () => RepeatBooking()).serviceSchedule;
    if (completedSchedule != null) return completedSchedule;

    final canceledSchedule = bookingRequest.repeatBookingList?.firstWhere((repeatBooking) => repeatBooking.bookingStatus == "canceled", orElse: () => RepeatBooking()).serviceSchedule;
    if (canceledSchedule != null) return canceledSchedule;

    final pendingSchedule = bookingRequest.repeatBookingList?.firstWhere((repeatBooking) => repeatBooking.bookingStatus == "pending", orElse: () => RepeatBooking()).serviceSchedule;
    return pendingSchedule;

  }

  static double getRepeatBookingPaidAmount(BookingDetailsContent bookingDetails){

    double amount = 0;

    if(bookingDetails.repeatBookingList == null || bookingDetails.repeatBookingList!.isEmpty){
      return 0;
    }

    for(var repeatBooking in bookingDetails.repeatBookingList!){
      if(repeatBooking.isPaid ==1){
        amount = amount + (repeatBooking.totalBookingAmount ?? 0);
      }
    }
    return amount;
  }

  static double getRepeatBookingCanceledAmount(BookingDetailsContent bookingDetails){

    double amount = 0;

    if(bookingDetails.repeatBookingList == null || bookingDetails.repeatBookingList!.isEmpty){
      return 0;
    }

    for(var repeatBooking in bookingDetails.repeatBookingList!){
      if(repeatBooking.bookingStatus == "canceled"){
        amount = amount + (repeatBooking.totalBookingAmount ?? 0);
      }
    }
    return amount;
  }

  static int getRepeatPaidBookingCount(BookingDetailsContent bookingDetails){

    int count = 0;
    if(bookingDetails.repeatBookingList == null || bookingDetails.repeatBookingList!.isEmpty){
      return 0;
    }
    for(var repeatBooking in bookingDetails.repeatBookingList!){
      if(repeatBooking.isPaid == 1){
        count ++;
      }
    }
    return count;
  }

  static int getRepeatCanceledBookingCount(BookingDetailsContent bookingDetails){

    int count = 0;
    if(bookingDetails.repeatBookingList == null || bookingDetails.repeatBookingList!.isEmpty){
      return 0;
    }
    for(var repeatBooking in bookingDetails.repeatBookingList!){
      if(repeatBooking.bookingStatus == "canceled"){
        count ++;
      }
    }
    return count;
  }
}