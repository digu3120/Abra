import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';


class PhoneVerificationHelper {

  static String isPhoneValid(String number , {required bool fromAuthPage}) {
    if (kDebugMode) {
      print("Phone number that will be parsed : $number");
    }
    bool isValid = false;
    try {
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      if(isValid && fromAuthPage == false){
        Get.find<LocationController>().countryDialCode = "+${phoneNumber.countryCode}";
        return phoneNumber.nsn.toString();
      }else if(isValid && fromAuthPage == true){
        Get.find<LocationController>().countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode!;
        return phoneNumber.nsn.toString();
      }else{
        Get.find<LocationController>().countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode!;
        return "";
      }
    } catch (e) {
      Get.find<LocationController>().countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode!;
      debugPrint('Phone Number is not parsing: $e');
      return "";
    }
  }


  static String getValidPhoneNumber(String number, {bool withCountryCode = false}) {
    bool isValid = false;
    String phone = "";

    try{
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      if(isValid){
        phone =  withCountryCode ? "+${phoneNumber.countryCode}${phoneNumber.nsn}" : phoneNumber.nsn.toString();
        if (kDebugMode) {
          print("Phone Number : $phone");
        }
      }
    }catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return phone;
  }

  static String getCountryCode(String number, {bool withCountryCode = false}) {
    bool isValid = false;
    String countryCode = "";

    try{
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      if(isValid){
        countryCode = "+${phoneNumber.countryCode}";
        if (kDebugMode) {
          print("Country Code : $countryCode");
        }
      }
    }catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return countryCode;
  }



  static String updateCountryAndNumberInEditProfilePage (String number){
    try {
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      if (kDebugMode) {
        print("phone number is : $number");
      }
      bool isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      if(isValid){
        Get.find<UserController>().countryDialCode = "+${phoneNumber.countryCode}";
        return phoneNumber.nsn.toString();
      }else{
        Get.find<UserController>().countryDialCode =
        CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content != null ?
        Get.find<SplashController>().configModel.content!.countryCode!:"BD").dialCode!;
        return number;
      }
    } catch (e) {
      Get.find<UserController>().countryDialCode =
      CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content != null ?
      Get.find<SplashController>().configModel.content!.countryCode!:"BD").dialCode!;
      debugPrint('Phone Number is not parsing: $e');
      return number;

    }
  }

}