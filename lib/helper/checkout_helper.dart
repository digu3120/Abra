import 'dart:convert';

import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:intl/intl.dart';

class CheckoutHelper {

  static final ConfigModel configModel = Get.find<SplashController>().configModel;

  static double getAdditionalCharge(){
    return Get.find<SplashController>().configModel.content?.additionalCharge == 1 ? configModel.content?.additionalChargeFeeAmount ?? 0.0 : 0.0;
  }


  static bool checkPartialPayment({required double walletBalance, required double bookingAmount }) => walletBalance < bookingAmount;

  static double calculatePaidAmount({required double walletBalance, required double bookingAmount }) => checkPartialPayment(walletBalance: walletBalance, bookingAmount: bookingAmount) ? walletBalance : bookingAmount;



  static double calculateDiscount({required List<CartModel> cartList, required DiscountType discountType, int daysCount = 1 }){
    double discount = 0;
    for (var cartModel in cartList) {
      if(discountType == DiscountType.general){
        discount = discount + (cartModel.discountedPrice * daysCount) ;
      }else if(discountType == DiscountType.campaign){
        discount = discount + (cartModel.campaignDiscountPrice * daysCount);
      }
      else if(discountType == DiscountType.coupon){
        discount = discount + (cartModel.couponDiscountPrice * daysCount);
      }
    }
    return discount ;
  }


  static double calculateVat({required List<CartModel> cartList, int daysCount = 1}){
    double vat = 0;
    for (var cartModel in cartList) {
      vat = vat + (cartModel.taxAmount * daysCount);
    }
    return vat;
  }


  static double calculateSubTotal({required List<CartModel> cartList, int daysCount = 1}){
    double subTotalPrice  = 0;
    for (var cartModel in cartList) {
      subTotalPrice = subTotalPrice + ((cartModel.serviceCost * cartModel.quantity) * daysCount);
    }
    return subTotalPrice ;
  }

  static double calculateGrandTotal({required List<CartModel> cartList , required double referralDiscount, int daysCount = 1, int applicableCouponCount = 1}){
    return
      calculateSubTotal(cartList: cartList, daysCount: daysCount)
      + calculateVat(cartList: cartList, daysCount: daysCount)
      + getAdditionalCharge()
      - (calculateDiscount(cartList: cartList, discountType: DiscountType.general, daysCount: daysCount)
          + calculateDiscount(cartList: cartList, discountType: DiscountType.coupon, daysCount: applicableCouponCount)
          + calculateDiscount(cartList: cartList, discountType: DiscountType.campaign, daysCount: daysCount)
          + referralDiscount
      );
  }


  static double calculateTotalAmountWithoutCoupon({required List<CartModel> cartList}){
    return
      calculateSubTotal(cartList: cartList)
          + calculateVat(cartList: cartList)
          + getAdditionalCharge()
          - (calculateDiscount(cartList: cartList, discountType: DiscountType.general)
          + calculateDiscount(cartList: cartList, discountType: DiscountType.campaign)
      );
  }

  static double calculateDueAmount({required List<CartModel> cartList, required bool walletPaymentStatus, required double walletBalance, required double bookingAmount, required double referralDiscount, int daysCount = 1}){
    return calculateGrandTotal(cartList: cartList, referralDiscount: referralDiscount, daysCount: daysCount) - (walletPaymentStatus ? calculatePaidAmount(walletBalance: walletBalance, bookingAmount: bookingAmount) : 0);
  }

  static double calculateRemainingWalletBalance({required double walletBalance, required double bookingAmount}){
    return checkPartialPayment(walletBalance: walletBalance, bookingAmount: bookingAmount)  ? 0 : walletBalance - bookingAmount;
  }

  static int calculateDaysCountBetweenDateRange(DateTimeRange? dateRange){
    if(dateRange == null){
      return 0;
    }
    return dateRange.end.difference(dateRange.start).inDays + 1;
  }

  static int calculateDaysCountBetweenDateRangeWithSpecificSelectedDay(
      DateTimeRange? dateRange, List<String> selectedDays) {

    if (dateRange == null) {
      return selectedDays.length;
    }

    Map<String, int> dayNameToInt = {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    };
    Set<int> selectedWeekdays = selectedDays
        .map((dayName) => dayNameToInt[dayName.toLowerCase()])
        .where((day) => day != null)
        .cast<int>()
        .toSet();

    int totalDaysCount = 0;

    for (DateTime currentDate = dateRange.start;
    !currentDate.isAfter(dateRange.end);
    currentDate = currentDate.add(const Duration(days: 1))) {
      if (selectedWeekdays.contains(currentDate.weekday)) {
        totalDaysCount++;
      }
    }

    return totalDaysCount;
  }

  static String? getRepeatBookingScheduleList({
    DateTimeRange? dateRange,
    TimeOfDay? time,
    RepeatBookingType? repeatBookingType,
    List<DateTime>? dateTimeList,
    List<String>? selectedDays,
  }) {
    if (repeatBookingType == null) return null;

    DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    List<Map<String, String>> result = [];

    DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
      return DateTime(date.year, date.month, date.day, time.hour, time.minute, 00);
    }

    if (repeatBookingType == RepeatBookingType.daily) {
      if (dateRange == null || time == null) return null;

      for (DateTime currentDate = dateRange.start;
      !currentDate.isAfter(dateRange.end);
      currentDate = currentDate.add(const Duration(days: 1))) {

        result.add({"date": dateTimeFormat.format(combineDateAndTime(currentDate, time))});
      }
    }
    else if (repeatBookingType == RepeatBookingType.weekly) {
      if (selectedDays == null || selectedDays.isEmpty) return null;

      Map<String, int> dayNameToInt = {
        'monday': DateTime.monday,
        'tuesday': DateTime.tuesday,
        'wednesday': DateTime.wednesday,
        'thursday': DateTime.thursday,
        'friday': DateTime.friday,
        'saturday': DateTime.saturday,
        'sunday': DateTime.sunday,
      };
      DateTime startDate = dateRange?.start ?? DateTime.now();
      DateTime endDate = dateRange?.end ?? DateTime.now().add(const Duration(days: 6));

      for (DateTime currentDate = startDate;
      !currentDate.isAfter(endDate);
      currentDate = currentDate.add(const Duration(days: 1))) {
        int currentWeekday = currentDate.weekday;
        if (selectedDays.contains(dayNameToInt.keys.firstWhere((dayName) => dayNameToInt[dayName] == currentWeekday,orElse: () => ""))) {
          result.add({"date": dateTimeFormat.format(combineDateAndTime(currentDate, time!))});
        }
      }
    }
    else if (repeatBookingType == RepeatBookingType.custom) {
      if (dateTimeList == null || dateTimeList.isEmpty) return null;
      dateTimeList.sort((a, b) => a.compareTo(b));
      for (DateTime dateTime in dateTimeList) {
        result.add({"date": dateTimeFormat.format(dateTime)});
      }
    }
    return jsonEncode(result);
  }

  static int? getNumberOfDaysForApplicableCoupon({required  int pickedScheduleDays}){

    int? numOfDays;
    List<CartModel> carts = Get.find<CartController>().cartList;

    if(carts.isNotEmpty && carts.first.couponCode != null){
      if( carts.first.couponRemainingUses != null && pickedScheduleDays > carts.first.couponRemainingUses!){
        numOfDays = carts.first.couponRemainingUses!;
      }else{
        numOfDays = pickedScheduleDays;
      }
    }
    return numOfDays;
  }
}