import 'dart:convert';
import 'package:demandium/feature/web_landing/model/web_landing_model.dart';

class ConfigModel {
  String? responseCode;
  String? message;
  ConfigContent? content;

  ConfigModel({this.responseCode, this.message, this.content});

  ConfigModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? ConfigContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class ConfigContent {
  String? businessName;
  String? logo;
  String? logoFullPath;
  String? favicon;
  String? faviconFullPath;
  int? providerSelfRegistration;
  String? countryCode;
  String? businessAddress;
  String? businessPhone;
  String? businessEmail;
  String? currencyDecimalPoint;
  String? currencySymbolPosition;
  String? privacyPolicy;
  String? termsAndConditions;
  String? cancellationPolicy;
  String? refundPolicy;
  String? aboutUs;
  DefaultLocation? defaultLocation;
  String? appUrlAndroid;
  String? appUrlIos;
  int? smsVerification;
  int? paginationLimit;
  String? timeFormat;
  List<DigitalPaymentMethod>? paymentMethodList;
  List<SocialMedia>? socialMedia;
  AdminDetails? adminDetails;
  MinimumVersion? minimumVersion;
  String? footerText;
  int? phoneNumberVisibility;
  int? walletStatus;
  int? addFundToWallet;
  int? loyaltyPointStatus;
  int? referEarnStatus;
  int? biddingStatus;
  String? cookiesText;
  int? phoneVerification;
  int? emailVerification;
  int? firebaseOtpVerification;
  int? directProviderBooking;
  int? cashAfterService;
  int? digitalPayment;
  int? resentOtpTime;
  double? minBookingAmount;
  double? maxBookingAmount;
  int? guestCheckout;
  int? offlinePayment;
  int? partialPayment;
  String? additionalChargeLabelName;
  double? additionalChargeFeeAmount;
  int? additionalCharge;
  String? partialPaymentCombinator;
  bool? confirmationOtpStatus;
  String? currencySymbol;
  String? appEnvironment;
  int? instantBooking;
  int? scheduleBooking;
  int? scheduleBookingTimeRestriction;
  AdvanceBooking? advanceBooking;
  List<Language>? languageList;
  List<ErrorLog>? errorLogs;
  MaintenanceMode? maintenanceMode;
  CustomerLogin? customerLogin;
  ForgetPasswordVerificationMethod? forgetPasswordVerificationMethod;
  int? repeatBooking;


  ConfigContent(
      {this.businessName,
        this.logo,
        this.logoFullPath,
        this.favicon,
        this.faviconFullPath,
        this.providerSelfRegistration,
        this.countryCode,
        this.businessAddress,
        this.businessPhone,
        this.businessEmail,
        this.currencyDecimalPoint,
        this.currencySymbolPosition,
        this.privacyPolicy,
        this.cancellationPolicy,
        this.refundPolicy,
        this.aboutUs,
        this.defaultLocation,
        this.appUrlAndroid,
        this.appUrlIos,
        this.smsVerification,
        this.paginationLimit,
        this.timeFormat,
        this.paymentMethodList,
        this.minimumVersion,
        this.footerText,
        this.phoneNumberVisibility,
        this.walletStatus,
        this.addFundToWallet,
        this.loyaltyPointStatus,
        this.referEarnStatus,
        this.biddingStatus,
        this.cookiesText,
        this.phoneVerification,
        this.emailVerification,
        this.directProviderBooking,
        this.cashAfterService,
        this.digitalPayment,
        this.forgetPasswordVerificationMethod,
        this.socialMedia,
        this.resentOtpTime,
        this.minBookingAmount,
        this.maxBookingAmount,
        this.guestCheckout,
        this.offlinePayment,
        this.partialPayment,
        this.additionalChargeLabelName,
        this.additionalChargeFeeAmount,
        this.additionalCharge,
        this.partialPaymentCombinator,
        this.confirmationOtpStatus,
        this.currencySymbol,
        this.appEnvironment,
        this.instantBooking,
        this.scheduleBooking,
        this.scheduleBookingTimeRestriction,
        this.advanceBooking,
        this.languageList,
        this.maintenanceMode,
        this.customerLogin,
        this.firebaseOtpVerification,
        this.errorLogs,
        this.repeatBooking
      });

  ConfigContent.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    logoFullPath = json['logo_full_path'];
    favicon = json['favicon'];
    faviconFullPath = json['favicon_full_path'];
    countryCode = json['country_code'];
    providerSelfRegistration = int.tryParse(json['provider_self_registration'].toString());
    businessAddress = json['business_address'];
    businessPhone = json['business_phone'];
    businessEmail = json['business_email'];
    currencyDecimalPoint = json['currency_decimal_point'];
    currencySymbolPosition = json['currency_symbol_position'];
    privacyPolicy = json['privacy_policy'];
    termsAndConditions = json['terms_and_conditions'];
    cancellationPolicy = json['cancellation_policy'];
    refundPolicy = json['refund_policy'];
    aboutUs = json['about_us'];
    defaultLocation = json['default_location'] != null ?
    DefaultLocation.fromJson(json['default_location']) : null;
    appUrlAndroid = json['app_url_playstore'];
    appUrlIos = json['app_url_appstore'];
    smsVerification = json['sms_verification'];
    timeFormat = json['time_format'];
    paginationLimit = json['pagination_limit'];
    if (json['payment_gateways'] != null) {
      paymentMethodList = <DigitalPaymentMethod>[];
      json['payment_gateways'].forEach((v) {
        paymentMethodList!.add(DigitalPaymentMethod.fromJson(v));
      });
    }

    adminDetails = json['admin_details'] != null ? AdminDetails.fromJson(json['admin_details']) : null;
    minimumVersion = json['min_versions'] != null ? MinimumVersion.fromJson(json['min_versions']) : null;
    footerText = json['footer_text'];
    phoneNumberVisibility = json['phone_number_visibility_for_chatting'];
    walletStatus = json['wallet_status'];
    addFundToWallet = json['add_to_fund_wallet'];
    loyaltyPointStatus = json['loyalty_point_status'];
    referEarnStatus = json['referral_earning_status'];
    biddingStatus = json['bidding_status'];
    cookiesText = json['cookies_text'];
    phoneVerification = int.tryParse(json['phone_verification'].toString());
    emailVerification = int.tryParse(json['email_verification'].toString());
    firebaseOtpVerification = int.tryParse(json['firebase_otp_verification'].toString());
    directProviderBooking = json['direct_provider_booking'];
    cashAfterService = json['cash_after_service'];
    digitalPayment = json['digital_payment'];

    forgetPasswordVerificationMethod = json['forgot_password_verification_method'] != null
        ? ForgetPasswordVerificationMethod.fromJson(json['forgot_password_verification_method'])
        : null;
    if (json['social_media'] != null) {
      socialMedia = <SocialMedia>[];
      json['social_media'].forEach((v) {
        socialMedia!.add(SocialMedia.fromJson(v));
      });
    }
    resentOtpTime = json['otp_resend_time'];
    minBookingAmount = double.tryParse(json['min_booking_amount'].toString());
    maxBookingAmount = double.tryParse(json['max_booking_amount'].toString());
    guestCheckout = int.tryParse(json['guest_checkout'].toString());
    offlinePayment = int.tryParse(json['offline_payment'].toString());
    partialPayment = int.tryParse(json['partial_payment'].toString());
    additionalChargeLabelName = json['additional_charge_label_name'];
    additionalChargeFeeAmount = double.tryParse(json['additional_charge_fee_amount'].toString());
    additionalCharge = int.tryParse(json['booking_additional_charge'].toString());
    partialPaymentCombinator= json['partial_payment_combinator'];
    currencySymbol = json['currency_symbol'];
    appEnvironment = json['app_environment'];
    if (json['confirm_otp_for_complete_service'] != null) {
      confirmationOtpStatus= json['confirm_otp_for_complete_service'] == 1 ? true : false;
    }
    advanceBooking= json['advanced_booking'] != null ? AdvanceBooking.fromJson(json['advanced_booking']) : null;
    instantBooking = int.tryParse(json['instant_booking'].toString());
    scheduleBooking = int.tryParse(json['schedule_booking'].toString());
    scheduleBookingTimeRestriction = int.tryParse(json['schedule_booking_time_restriction'].toString());
    if (json['system_language'] != null) {
      languageList = <Language>[];
      json['system_language'].forEach((v) {
        languageList!.add(Language.fromJson(v));
      });
    }
    maintenanceMode = json['maintenance'] != null
        ? MaintenanceMode.fromJson(json['maintenance'])
        : null;

    customerLogin = json['login_setup'] != null
        ? CustomerLogin.fromJson(json['login_setup'])
        : null;

    if (json['error_logs'] != null) {
      errorLogs = <ErrorLog>[];
      json['error_logs'].forEach((v) {
        errorLogs!.add(ErrorLog.fromJson(v));
      });
    }
    repeatBooking = int.tryParse(json['repeat_booking'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_name'] = businessName;
    data['logo'] = logo;
    data['logo_full_path'] = logoFullPath;
    data['favicon_full_path'] = faviconFullPath;
    data['provider_self_registration'] = providerSelfRegistration;
    data['country_code'] = countryCode;
    data['business_address'] = businessAddress;
    data['business_phone'] = businessPhone;
    data['business_email'] = businessEmail;
    data['currency_decimal_point'] = currencyDecimalPoint;
    data['currency_symbol_position'] = currencySymbolPosition;
    data['terms_and_conditions'] = termsAndConditions;
    data['privacy_policy'] = privacyPolicy;
    data['cancellation_policy'] = cancellationPolicy;
    data['refund_policy'] = refundPolicy;
    data['about_us'] = aboutUs;
    if (defaultLocation != null) {
      data['default_location'] = defaultLocation!.toJson();
    }
    data['app_url_playstore'] = appUrlAndroid;
    data['app_url_appstore'] = appUrlIos;
    data['sms_verification'] = smsVerification;

    data['pagination_limit'] = paginationLimit;

    if (minimumVersion != null) {
      data['min_versions'] = minimumVersion!.toJson();
    }
    data['footer_text'] = footerText;
    data['phone_number_visibility_for_chatting'] = phoneNumberVisibility;
    data['wallet_status'] = walletStatus;
    data['add_to_fund_wallet'] = addFundToWallet;
    data['loyalty_point_status'] = loyaltyPointStatus;
    data['referral_earning_status'] = referEarnStatus;
    data['bidding_status'] = biddingStatus;
    data['cookies_text'] = cookiesText;
    data['phone_verification'] = phoneVerification;
    data['email_verification'] = emailVerification;
    data['direct_provider_booking'] = directProviderBooking;
    data['cash_after_service'] = cashAfterService;
    data['digital_payment'] = digitalPayment;
    data['forget_password_verification_method'] = forgetPasswordVerificationMethod;
    data['otp_resend_time'] = resentOtpTime;
    data['min_booking_amount'] = minBookingAmount;
    data['max_booking_amount'] = maxBookingAmount;
    data['guest_checkout'] = guestCheckout;
    data['confirm_otp_for_complete_service'] = confirmationOtpStatus;

    return data;
  }
}

class DefaultLocation {
  double? latitude;
  double? longitude;

  DefaultLocation({this.latitude, this.longitude});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    latitude = double.tryParse(json['latitude'].toString());
    longitude = double.tryParse(json['longitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class MinimumVersion {
  String? minVersionForAndroid;
  String? minVersionForIos;

  MinimumVersion({this.minVersionForAndroid, this.minVersionForIos});


  MinimumVersion.fromJson(Map<String, dynamic> json) {
    minVersionForAndroid = json['min_version_for_android'];
    minVersionForIos = json['min_version_for_ios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_version_for_android'] = minVersionForAndroid;
    data['min_version_for_ios'] = minVersionForIos;
    return data;
  }
}


class Languages {
  String? code;
  String? name;
  String? nativeName;

  Languages({this.code, this.name, this.nativeName});

  Languages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    nativeName = json['nativeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['nativeName'] = nativeName;
    return data;
  }
}

class Currencies {
  String? code;
  String? symbol;
  String? name;

  Currencies({this.code, this.symbol, this.name});

  Currencies.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    symbol = json['symbol'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['symbol'] = symbol;
    data['name'] = name;
    return data;
  }
}

class Countries {
  String? name;
  String? code;

  Countries({this.name, this.code});

  Countries.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}


class Zones {
  String? id;
  String? name;
  List<Coordinates>? coordinates;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Zones(
      {this.id,
        this.name,
        this.coordinates,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  Zones.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['coordinates'] != null) {
      coordinates = <Coordinates>[];
      json['coordinates'].forEach((v) {
        coordinates!.add(Coordinates.fromJson(v));
      });
    }
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = double.tryParse(json['latitude'].toString());
    longitude = double.tryParse(json['longitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Pivot {
  String? categoryId;
  String? zoneId;

  Pivot({this.categoryId, this.zoneId});

  Pivot.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    zoneId = json['zone_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['zone_id'] = zoneId;
    return data;
  }
}

String userLocationInfoToJson(UserLocationInfo data) => json.encode(data.toJson());

class UserLocationInfo {
  String? ip;
  String? countryName;
  String? countryCode;
  String? regionCode;
  String? regionName;
  String? cityName;
  String? zipCode;
  String? isoCode;
  String? postalCode;
  String? latitude;
  String? longitude;
  String? metroCode;
  String? areaCode;
  String? timezone;
  String? driver;

  UserLocationInfo(
      {this.ip,
        this.countryName,
        this.countryCode,
        this.regionCode,
        this.regionName,
        this.cityName,
        this.zipCode,
        this.isoCode,
        this.postalCode,
        this.latitude,
        this.longitude,
        this.metroCode,
        this.areaCode,
        this.timezone,
        this.driver});

  UserLocationInfo.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    countryName = json['countryName'];
    countryCode = json['countryCode'];
    regionCode = json['regionCode'];
    regionName = json['regionName'];
    cityName = json['cityName'];
    zipCode = json['zipCode'];
    isoCode = json['isoCode'];
    postalCode = json['postalCode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    metroCode = json['metroCode'];
    areaCode = json['areaCode'];
    timezone = json['timezone'];
    driver = json['driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ip'] = ip;
    data['countryName'] = countryName;
    data['countryCode'] = countryCode;
    data['regionCode'] = regionCode;
    data['regionName'] = regionName;
    data['cityName'] = cityName;
    data['zipCode'] = zipCode;
    data['isoCode'] = isoCode;
    data['postalCode'] = postalCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['metroCode'] = metroCode;
    data['areaCode'] = areaCode;
    data['timezone'] = timezone;
    data['driver'] = driver;
    return data;
  }
}

class AdminDetails {
  String? id;
  String? firstName;
  String? lastName;
  String? profileImage;

  AdminDetails(
      {String? id, String? firstName, String? lastName, String? profileImage}) {
    if (id != null) {
      this.id = id;
    }
    if (firstName != null) {
      this.firstName = firstName;
    }
    if (lastName != null) {
      this.lastName = lastName;
    }
    if (profileImage != null) {
      this.profileImage = profileImage;
    }
  }


  AdminDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_image'] = profileImage;
    return data;
  }
}


class DigitalPaymentMethod {
  String? gateway;
  String? gatewayImage;
  String? gatewayImageFullPath;
  String? label;


  DigitalPaymentMethod({this.gateway, this.gatewayImage, this.label, this.gatewayImageFullPath});

  DigitalPaymentMethod.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    gatewayImage = json['gateway_image'];
    gatewayImageFullPath = json['gateway_image_full_path'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gateway'] = gateway;
    data['gateway_image'] = gatewayImage;
    data['gateway_image_full_path'] = gatewayImageFullPath;
    data['label'] = label;
    return data;
  }
}

class AdvanceBooking {
  int? advancedBookingRestrictionValue;
  String? advancedBookingRestrictionType;

  AdvanceBooking(
      {this.advancedBookingRestrictionValue,
        this.advancedBookingRestrictionType});

  AdvanceBooking.fromJson(Map<String, dynamic> json) {
    advancedBookingRestrictionValue =
    json['advanced_booking_restriction_value'];
    advancedBookingRestrictionType = json['advanced_booking_restriction_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['advanced_booking_restriction_value'] =
        advancedBookingRestrictionValue;
    data['advanced_booking_restriction_type'] =
        advancedBookingRestrictionType;
    return data;
  }
}

class Language {
  String? languageCode;
  bool? isDefault;

  Language({this.languageCode, this.isDefault});

  Language.fromJson(Map<String, dynamic> json) {
    languageCode = json['code'];
    isDefault = json['default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = languageCode;
    data['default'] = isDefault;
    return data;
  }
}

class MaintenanceMode {
  int? maintenanceStatus;
  SelectedMaintenanceSystem? selectedMaintenanceSystem;
  MaintenanceMessages? maintenanceMessages;
  MaintenanceTypeAndDuration? maintenanceTypeAndDuration;

  MaintenanceMode(
      {this.maintenanceStatus,
        this.selectedMaintenanceSystem,
        this.maintenanceMessages, this.maintenanceTypeAndDuration});

  MaintenanceMode.fromJson(Map<String, dynamic> json) {
    maintenanceStatus = json['maintenance_status'];
    selectedMaintenanceSystem = json['selected_maintenance_system'] != null
        ? SelectedMaintenanceSystem.fromJson(
        json['selected_maintenance_system'])
        : null;
    maintenanceMessages = json['maintenance_messages'] != null
        ? MaintenanceMessages.fromJson(json['maintenance_messages'])
        : null;

    maintenanceTypeAndDuration = json['maintenance_type_and_duration'] != null
        ? MaintenanceTypeAndDuration.fromJson(
        json['maintenance_type_and_duration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_status'] = maintenanceStatus;
    if (selectedMaintenanceSystem != null) {
      data['selected_maintenance_system'] =
          selectedMaintenanceSystem!.toJson();
    }
    if (maintenanceMessages != null) {
      data['maintenance_messages'] = maintenanceMessages!.toJson();
    }
    if (maintenanceTypeAndDuration != null) {
      data['maintenance_type_and_duration'] =
          maintenanceTypeAndDuration!.toJson();
    }
    return data;
  }
}

class SelectedMaintenanceSystem {
  int? mobileApp;
  int? webApp;
  int? providerApp;
  int? servicemanApp;

  SelectedMaintenanceSystem(
      {this.mobileApp, this.webApp, this.providerApp, this.servicemanApp});

  SelectedMaintenanceSystem.fromJson(Map<String, dynamic> json) {
    mobileApp = json['mobile_app'];
    webApp = json['web_app'];
    providerApp = json['provider_app'];
    servicemanApp = json['serviceman_app'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_app'] = mobileApp;
    data['web_app'] = webApp;
    data['provider_app'] = providerApp;
    data['serviceman_app'] = servicemanApp;
    return data;
  }
}

class MaintenanceMessages {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessages(
      {this.businessNumber,
        this.businessEmail,
        this.maintenanceMessage,
        this.messageBody});

  MaintenanceMessages.fromJson(Map<String, dynamic> json) {
    businessNumber = json['business_number'];
    businessEmail = json['business_email'];
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_number'] = businessNumber;
    data['business_email'] = businessEmail;
    data['maintenance_message'] = maintenanceMessage;
    data['message_body'] = messageBody;
    return data;
  }
}

class MaintenanceTypeAndDuration {
  String? maintenanceDuration;
  String? startDate;
  String? endDate;

  MaintenanceTypeAndDuration(
      {String? maintenanceDuration, String? startDate, String? endDate});

  MaintenanceTypeAndDuration.fromJson(Map<String, dynamic> json) {
    maintenanceDuration = json['maintenance_duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_duration'] = maintenanceDuration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}

class CustomerLogin {
  LoginOption? loginOption;
  SocialMediaLoginOptions? socialMediaLoginOptions;

  CustomerLogin({this.loginOption, this.socialMediaLoginOptions});

  CustomerLogin.fromJson(Map<String, dynamic> json) {
    loginOption = json['login_option'] != null
        ? LoginOption.fromJson(json['login_option'])
        : null;
    socialMediaLoginOptions = json['social_media_login_options'] != null
        ? SocialMediaLoginOptions.fromJson(
        json['social_media_login_options'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loginOption != null) {
      data['login_option'] = loginOption!.toJson();
    }
    if (socialMediaLoginOptions != null) {
      data['social_media_login_options'] =
          socialMediaLoginOptions!.toJson();
    }
    return data;
  }
}

class LoginOption {
  int? manualLogin;
  int? otpLogin;
  int? socialMediaLogin;

  LoginOption({this.manualLogin, this.otpLogin, this.socialMediaLogin});

  LoginOption.fromJson(Map<String, dynamic> json) {
    manualLogin = json['manual_login'];
    otpLogin = json['otp_login'];
    socialMediaLogin = json['social_media_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manual_login'] = manualLogin;
    data['otp_login'] = otpLogin;
    data['social_media_login'] = socialMediaLogin;
    return data;
  }
}

class SocialMediaLoginOptions {
  int? google;
  int? facebook;
  int? apple;

  SocialMediaLoginOptions({this.google, this.facebook, this.apple});

  SocialMediaLoginOptions.fromJson(Map<String, dynamic> json) {
    google = json['google'];
    facebook = json['facebook'];
    apple = json['apple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google'] = google;
    data['facebook'] = facebook;
    data['apple'] = apple;
    return data;
  }
}

class ForgetPasswordVerificationMethod {
  int? phone;
  int? email;

  ForgetPasswordVerificationMethod({this.phone, this.email});

  ForgetPasswordVerificationMethod.fromJson(Map<String, dynamic> json) {
    phone = int.tryParse(json['phone'].toString());
    email = int.tryParse(json['email'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}

class ErrorLog {
  String? url;
  String? redirectUrl;

  ErrorLog({this.url, this.redirectUrl});

  ErrorLog.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['redirect_url'] = redirectUrl;
    return data;
  }
}


