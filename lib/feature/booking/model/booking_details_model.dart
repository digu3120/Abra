import 'package:demandium/common/models/user_model.dart';
import 'package:demandium/utils/core_export.dart';

class BookingDetailsModel {
  String? responseCode;
  String? message;
  BookingDetailsContent? content;

  BookingDetailsModel({this.responseCode, this.message, this.content});

  BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content = json['content'] != null ? BookingDetailsContent.fromJson(json['content']) : null;
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

class BookingDetailsContent {
  String? id;
  String? bookingId;
  String? readableId;
  String? customerId;
  String? providerId;
  String? zoneId;
  String? bookingStatus;
  int? isPaid;
  String? paymentMethod;
  String? transactionId;
  double? totalBookingAmount;
  double? totalTaxAmount;
  double? totalDiscountAmount;
  String? serviceSchedule;
  String? serviceAddressId;
  String? createdAt;
  String? updatedAt;
  String? categoryId;
  String? subCategoryId;
  List<ItemService>? bookingDetails;
  List<ScheduleHistories>? scheduleHistories;
  List<StatusHistories>? statusHistories;
  List<PartialPayment>? partialPayments;
  ServiceAddress? serviceAddress;
  Customer? customer;
  ProviderData? provider;
  Serviceman? serviceman;
  double? totalCampaignDiscountAmount;
  double? totalCouponDiscountAmount;
  String? bookingOtp;
  List<String>? photoEvidence;
  List<String>? photoEvidenceFullPath;
  double? extraFee;
  double ? additionalCharge;
  double ? totalReferralDiscountAmount;
  int? isRepeatBooking;
  String? time;
  String? startDate;
  String? endDate;
  int? totalCount;
  String? bookingType;
  List<String>? weekNames;
  int? completedCount;
  int? canceledCount;
  RepeatBooking ? nextService;
  List<RepeatBooking>? repeatBookingList;
  List<RepeatHistory>? repeatEditHistory;
  BookingDetailsContent? subBooking;


  BookingDetailsContent(
      {this.id,
        this.readableId,
        this.customerId,
        this.providerId,
        this.zoneId,
        this.bookingStatus,
        this.isPaid,
        this.paymentMethod,
        this.transactionId,
        this.totalBookingAmount,
        this.totalTaxAmount,
        this.totalDiscountAmount,
        this.serviceSchedule,
        this.serviceAddressId,
        this.createdAt,
        this.updatedAt,
        this.categoryId,
        this.subCategoryId,
        this.bookingDetails,
        this.scheduleHistories,
        this.statusHistories,
        this.partialPayments,
        this.serviceAddress,
        this.customer,
        this.provider,
        this.serviceman,
        this.totalCampaignDiscountAmount,
        this.totalCouponDiscountAmount,
        this.bookingOtp,
        this.photoEvidence,
        this.photoEvidenceFullPath,
        this.extraFee,
        this.additionalCharge,
        this.totalReferralDiscountAmount,
        this.time,
        this.startDate,
        this.endDate,
        this.totalCount,
        this.bookingType,
        this.completedCount,
        this.canceledCount,
        this.nextService,
        this.isRepeatBooking,
        this.weekNames,
        this.repeatBookingList,
        this.subBooking,
        this.repeatEditHistory,
        this.bookingId
      });

  BookingDetailsContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    readableId = json['readable_id'].toString();
    customerId = json['customer_id'];
    providerId = json['provider_id'];
    zoneId = json['zone_id'];
    bookingStatus = json['booking_status'];
    isPaid = json['is_paid'];
    paymentMethod = json['payment_method'];
    transactionId = json['transaction_id'];
    totalBookingAmount = double.tryParse(json['total_booking_amount'].toString());
    totalTaxAmount = double.tryParse(json['total_tax_amount'].toString());
    totalDiscountAmount = double.tryParse(json['total_discount_amount'].toString());
    serviceSchedule = json['service_schedule'];
    serviceAddressId = json['service_address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    if (json['detail'] != null) {
      bookingDetails = <ItemService>[];
      json['detail'].forEach((v) {
        bookingDetails!.add(ItemService.fromJson(v));
      });
    }
    if (json['schedule_histories'] != null) {
      scheduleHistories = <ScheduleHistories>[];
      json['schedule_histories'].forEach((v) {
        scheduleHistories!.add(ScheduleHistories.fromJson(v));
      });
    }
    if (json['status_histories'] != null) {
      statusHistories = <StatusHistories>[];
      json['status_histories'].forEach((v) {

        statusHistories!.add(StatusHistories.fromJson(v));
      });
    }

    if (json['booking_partial_payments'] != null) {
      partialPayments = <PartialPayment>[];
      json['booking_partial_payments'].forEach((v) {
        partialPayments!.add(PartialPayment.fromJson(v));
      });
    }

    serviceAddress = json['service_address'] != null
        ? ServiceAddress.fromJson(json['service_address'])
        : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    provider = json['provider'] != null
        ? ProviderData.fromJson(json['provider'])
        : null;
    serviceman = json['serviceman'] != null
        ? Serviceman.fromJson(json['serviceman'])
        : null;
    totalCampaignDiscountAmount = double.tryParse(json['total_campaign_discount_amount'].toString());
    totalCouponDiscountAmount = double.tryParse(json['total_coupon_discount_amount'].toString());
    bookingOtp = json["booking_otp"].toString();
    photoEvidence = json["evidence_photos"]!=null? json["evidence_photos"].cast<String>(): [];
    photoEvidenceFullPath = json["evidence_photos_full_path"]!=null? json["evidence_photos_full_path"].cast<String>(): [];
    extraFee = double.tryParse(json["extra_fee"].toString());
    additionalCharge = double.tryParse(json['additional_charge'].toString());
    totalReferralDiscountAmount = double.tryParse(json['total_referral_discount_amount'].toString());
    isRepeatBooking = int.tryParse(json['is_repeated'].toString());
    time = json['time'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    totalCount = json['totalCount'];
    bookingType = json['bookingType'];
    weekNames = json['weekNames']?.cast<String>();
    completedCount = json['completedCount'];
    canceledCount = json['canceledCount'];
    nextService = json['nextService'] != null
        ? RepeatBooking.fromJson(json['nextService'])
        : null;
    if (json['repeats'] != null) {
      repeatBookingList = <RepeatBooking>[];
      json['repeats'].forEach((v) {
        repeatBookingList!.add(RepeatBooking.fromJson(v));
      });
    }
    if (json['repeatHistory'] != null) {
      repeatEditHistory = <RepeatHistory>[];
      json['repeatHistory'].forEach((v) {
        repeatEditHistory!.add(RepeatHistory.fromJson(v));
      });
    }
    subBooking = json['booking'] != null
        ? BookingDetailsContent.fromJson(json['booking'])
        : null;


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['readable_id'] = readableId;
    data['customer_id'] = customerId;
    data['provider_id'] = providerId;
    data['zone_id'] = zoneId;
    data['booking_status'] = bookingStatus;
    data['is_paid'] = isPaid;
    data['payment_method'] = paymentMethod;
    data['transaction_id'] = transactionId;
    data['total_booking_amount'] = totalBookingAmount;
    data['total_tax_amount'] = totalTaxAmount;
    data['total_discount_amount'] = totalDiscountAmount;
    data['service_schedule'] = serviceSchedule;
    data['service_address_id'] = serviceAddressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    if (bookingDetails != null) {
      data['detail'] = bookingDetails!.map((v) => v.toJson()).toList();
    }
    if (scheduleHistories != null) {
      data['schedule_histories'] =
          scheduleHistories!.map((v) => v.toJson()).toList();
    }
    if (statusHistories != null) {
      data['status_histories'] =
          statusHistories!.map((v) => v.toJson()).toList();
    }

    if (partialPayments != null) {
      data['booking_partial_payments'] =
          partialPayments!.map((v) => v.toJson()).toList();
    }
    if (serviceAddress != null) {
      data['service_address'] = serviceAddress!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (serviceman != null) {
      data['serviceman'] = serviceman!.toJson();
    }
    data['time'] = time;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['totalCount'] = totalCount;
    data['bookingType'] = bookingType;
    data['completedCount'] = completedCount;
    data['canceledCount'] = canceledCount;

    return data;
  }
}

class ItemService {

  String? bookingId;
  String? serviceId;
  String? serviceName;
  String? variantKey;
  double? serviceCost;
  int? quantity;
  double? discountAmount;
  double? taxAmount;
  double? totalCost;
  String? createdAt;
  String? updatedAt;
  double? campaignDiscountAmount;
  double? overallCouponDiscountAmount;
  Service? service;

  ItemService.copy(ItemService value) {
    quantity = value.quantity;
  }


  ItemService(
      {
        this.bookingId,
        this.serviceId,
        this.serviceName,
        this.variantKey,
        this.serviceCost,
        this.quantity,
        this.discountAmount,
        this.taxAmount,
        this.totalCost,
        this.createdAt,
        this.updatedAt,
        this.service,
        this.campaignDiscountAmount,
        this.overallCouponDiscountAmount,});

  ItemService.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    variantKey = json['variant_key'];
    serviceCost = double.tryParse(json['service_cost'].toString());
    quantity = int.tryParse(json['quantity'].toString());
    discountAmount = double.tryParse(json['discount_amount'].toString());
    taxAmount = double.tryParse(json['tax_amount'].toString());
    totalCost = double.tryParse(json['total_cost'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    campaignDiscountAmount = double.tryParse(json['campaign_discount_amount'].toString());
    service = json['service'] != null ? Service.fromJson(json['service']) : null;
    overallCouponDiscountAmount = double.tryParse(json['overall_coupon_discount_amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['variant_key'] = variantKey;
    data['service_cost'] = serviceCost;
    data['quantity'] = quantity;
    data['discount_amount'] = discountAmount;
    data['tax_amount'] = taxAmount;
    data['total_cost'] = totalCost;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['campaign_discount_amount'] = campaignDiscountAmount;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    return data;
  }
}

class ScheduleHistories {
  int? id;
  String? bookingId;
  String? changedBy;
  String? schedule;
  String? createdAt;
  String? updatedAt;
  User? user;

  ScheduleHistories(
      {this.id,
        this.bookingId,
        this.changedBy,
        this.schedule,
        this.createdAt,
        this.updatedAt,
        this.user});

  ScheduleHistories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    changedBy = json['changed_by'];
    schedule = json['schedule'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['changed_by'] = changedBy;
    data['schedule'] = schedule;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class StatusHistories {
  int? id;
  String? bookingId;
  String? changedBy;
  String? bookingStatus;
  String? schedule;
  String? createdAt;
  String? updatedAt;
  User? user;

  StatusHistories(
      {this.id,
        this.bookingId,
        this.changedBy,
        this.bookingStatus,
        this.schedule,
        this.createdAt,
        this.updatedAt,
        this.user});

  StatusHistories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    changedBy = json['changed_by'];
    bookingStatus = json['booking_status'];
    schedule = json['schedule'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['changed_by'] = changedBy;
    data['booking_status'] = bookingStatus;
    data['schedule'] = schedule;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Serviceman {
  String? id;
  String? providerId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  User? user;


  Serviceman(
      {this.id,
        this.providerId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.user,
      });

  Serviceman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}



class ServiceAddress {
  int? id;
  String? userId;
  String? lat;
  String? lon;
  String? city;
  String? street;
  String? zipCode;
  String? country;
  String? address;
  String? createdAt;
  String? updatedAt;
  String? addressType;
  String? contactPersonName;
  String? contactPersonNumber;
  String? addressLabel;

  ServiceAddress(
      {this.id,
        this.userId,
        this.lat,
        this.lon,
        this.city,
        this.street,
        this.zipCode,
        this.country,
        this.address,
        this.createdAt,
        this.updatedAt,
        this.addressType,
        this.contactPersonName,
        this.contactPersonNumber,
        this.addressLabel});

  ServiceAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    lat = json['lat'];
    lon = json['lon'];
    city = json['city'];
    street = json['street'];
    zipCode = json['zip_code'];
    country = json['country'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addressType = json['address_type'];
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    addressLabel = json['address_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['lat'] = lat;
    data['lon'] = lon;
    data['city'] = city;
    data['street'] = street;
    data['zip_code'] = zipCode;
    data['country'] = country;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['address_type'] = addressType;
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;
    data['address_label'] = addressLabel;
    return data;
  }
}

class PartialPayment {
  String? id;
  String? bookingId;
  String? paidWith;
  double? paidAmount;
  double? dueAmount;
  String? createdAt;
  String? updatedAt;

  PartialPayment(
      {this.id,
        this.bookingId,
        this.paidWith,
        this.paidAmount,
        this.dueAmount,
        this.createdAt,
        this.updatedAt});

  PartialPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    paidWith = json['paid_with'];
    paidAmount = double.tryParse(json['paid_amount'].toString());
    dueAmount = double.tryParse(json['due_amount'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['paid_with'] = paidWith;
    data['paid_amount'] = paidAmount;
    data['due_amount'] = dueAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RepeatHistory {
  int? id;
  String? bookingId;
  String? bookingRepeatId;
  String? bookingRepeatDetailsId;
  String? readableId;
  int? oldQuantity;
  int? newQuantity;
  int? isMultiple;
  double? totalBookingAmount;
  double? totalTaxAmount;
  double? totalDiscountAmount;
  double? extraFee;
  String? createdAt;
  String? updatedAt;
  List<RepeatHistoryLog>? repeatHistoryLogs;

  RepeatHistory({this.id,
    this.bookingId,
    this.bookingRepeatId,
    this.bookingRepeatDetailsId,
    this.readableId,
    this.oldQuantity,
    this.newQuantity,
    this.isMultiple,
    this.createdAt,
    this.updatedAt,
    this.repeatHistoryLogs,
    this.totalBookingAmount,
    this.totalDiscountAmount,
    this.totalTaxAmount,
    this.extraFee
  });

  RepeatHistory.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    bookingId = json['booking_id'];
    bookingRepeatId = json['booking_repeat_id'];
    bookingRepeatDetailsId = json['booking_repeat_details_id'];
    readableId = json['readable_id'];
    oldQuantity = int.tryParse(json['old_quantity'].toString());
    newQuantity = int.tryParse(json['new_quantity'].toString());
    isMultiple = int.tryParse(json['is_multiple'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalBookingAmount = double.tryParse(json['total_booking_amount'].toString());
    totalTaxAmount = double.tryParse(json['total_tax_amount'].toString());
    totalDiscountAmount = double.tryParse(json['total_discount_amount'].toString());
    extraFee = double.tryParse(json['extra_fee'].toString());
    if (json['log_details'] != null) {
      repeatHistoryLogs = <RepeatHistoryLog>[];
      json['log_details'].forEach((v) {
        repeatHistoryLogs!.add(RepeatHistoryLog.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['booking_repeat_id'] = bookingRepeatId;
    data['booking_repeat_details_id'] = bookingRepeatDetailsId;
    data['readable_id'] = readableId;
    data['old_quantity'] = oldQuantity;
    data['new_quantity'] = newQuantity;
    data['is_multiple'] = isMultiple;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RepeatHistoryLog {
  String? serviceId;
  int? quantity;
  String? variantKey;
  String? serviceName;
  double? serviceCost;
  double? discountAmount;
  double? taxAmount;
  double? totalCost;
  String? repeatDetailsId;

  RepeatHistoryLog(
      {this.serviceId,
        this.quantity,
        this.variantKey,
        this.serviceName,
        this.serviceCost,
        this.discountAmount,
        this.taxAmount,
        this.totalCost,
        this.repeatDetailsId});

  RepeatHistoryLog.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    quantity = json['quantity'];
    variantKey = json['variant_key'].toString();
    serviceName = json['service_name'];
    serviceCost = double.tryParse(json['service_cost'].toString());
    discountAmount = double.tryParse(json['discount_amount'].toString());
    taxAmount = double.tryParse(json['tax_amount'].toString());
    totalCost = double.tryParse(json['total_cost'].toString());
    repeatDetailsId = json['repeat_details_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['quantity'] = quantity;
    data['variant_key'] = variantKey;
    data['service_name'] = serviceName;
    data['service_cost'] = serviceCost;
    data['discount_amount'] = discountAmount;
    data['tax_amount'] = taxAmount;
    data['total_cost'] = totalCost;
    data['repeat_details_id'] = repeatDetailsId;
    return data;
  }
}






