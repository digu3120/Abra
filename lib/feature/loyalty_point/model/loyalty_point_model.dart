class LoyaltyPointModel {
  LoyaltyPointContent? content;
  LoyaltyPointModel({this.content});

  LoyaltyPointModel.fromJson(Map<String, dynamic> json) {
    content = json['content'] != null ? LoyaltyPointContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class LoyaltyPointContent {
  double? loyaltyPoint;
  String? loyaltyPointValuePerCurrencyUnit;
  String? minLoyaltyPointToTransfer;
  Transactions? transactions;

  LoyaltyPointContent(
      {this.loyaltyPoint,
        this.loyaltyPointValuePerCurrencyUnit,
        this.minLoyaltyPointToTransfer,
        this.transactions});

  LoyaltyPointContent.fromJson(Map<String, dynamic> json) {
    loyaltyPoint = double.tryParse(json['loyalty_point'].toString());
    loyaltyPointValuePerCurrencyUnit =
    json['loyalty_point_value_per_currency_unit'];
    minLoyaltyPointToTransfer = json['min_loyalty_point_to_transfer'];
    transactions = json['transactions'] != null
        ? Transactions.fromJson(json['transactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loyalty_point'] = loyaltyPoint;
    data['loyalty_point_value_per_currency_unit'] =
        loyaltyPointValuePerCurrencyUnit;
    data['min_loyalty_point_to_transfer'] = minLoyaltyPointToTransfer;
    if (transactions != null) {
      data['transactions'] = transactions!.toJson();
    }
    return data;
  }
}

class Transactions {
  int? currentPage;
  List<LoyaltyPointTransactionData>? data;

  int? total;

  Transactions(
      {this.currentPage,
        this.data,
        this.total});

  Transactions.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <LoyaltyPointTransactionData>[];
      json['data'].forEach((v) {
        data!.add(LoyaltyPointTransactionData.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class LoyaltyPointTransactionData {
  String? id;
  String? trxType;
  double? debit;
  double? credit;
  double? balance;
  String? fromUserId;
  String? toUserId;
  String? createdAt;
  String? updatedAt;
  String? toUserAccount;
  FromUser? fromUser;
  FromUser? toUser;

  LoyaltyPointTransactionData(
      {this.id,
        this.trxType,
        this.debit,
        this.credit,
        this.balance,
        this.fromUserId,
        this.toUserId,
        this.createdAt,
        this.updatedAt,
        this.toUserAccount,
        this.fromUser,
        this.toUser});

  LoyaltyPointTransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trxType = json['trx_type'];
    debit = double.tryParse(json['debit'].toString());
    credit = double.tryParse(json['credit'].toString());
    balance = double.tryParse(json['balance'].toString());
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    toUserAccount = json['to_user_account'];
    fromUser = json['from_user'] != null
        ? FromUser.fromJson(json['from_user'])
        : null;
    toUser =
    json['to_user'] != null ? FromUser.fromJson(json['to_user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    data['trx_type'] = trxType;
    data['debit'] = debit;
    data['credit'] = credit;
    data['balance'] = balance;
    data['from_user_id'] = fromUserId;
    data['to_user_id'] = toUserId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['to_user_account'] = toUserAccount;
    if (fromUser != null) {
      data['from_user'] = fromUser!.toJson();
    }
    if (toUser != null) {
      data['to_user'] = toUser!.toJson();
    }
    return data;
  }
}

class FromUser {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? identificationType;
  List<void>? identificationImage;
  String? gender;
  String? profileImage;
  String? fcmToken;
  int? isPhoneVerified;
  int? isEmailVerified;
  int? isActive;
  String? userType;
  String? createdAt;
  String? updatedAt;
  double? walletBalance;
  double? loyaltyPoint;

  FromUser(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.identificationType,
        this.identificationImage,
        this.gender,
        this.profileImage,
        this.fcmToken,
        this.isPhoneVerified,
        this.isEmailVerified,
        this.isActive,
        this.userType,
        this.createdAt,
        this.updatedAt,
        this.walletBalance,
        this.loyaltyPoint,
      });

  FromUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    identificationType = json['identification_type'];
    gender = json['gender'];
    profileImage = json['profile_image'];
    fcmToken = json['fcm_token'];
    isPhoneVerified = json['is_phone_verified'];
    isEmailVerified = json['is_email_verified'];
    isActive = json['is_active'];
    userType = json['user_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    walletBalance = double.tryParse(json['wallet_balance'].toString());
    loyaltyPoint = double.tryParse(json['loyalty_point'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['identification_type'] = identificationType;
    data['gender'] = gender;
    data['profile_image'] = profileImage;
    data['fcm_token'] = fcmToken;
    data['is_phone_verified'] = isPhoneVerified;
    data['is_email_verified'] = isEmailVerified;
    data['is_active'] = isActive;
    data['user_type'] = userType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['wallet_balance'] = walletBalance;
    data['loyalty_point'] = loyaltyPoint;
    return data;
  }
}
