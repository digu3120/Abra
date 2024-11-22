import 'package:demandium/feature/loyalty_point/model/loyalty_point_model.dart';

class WalletTransactionModel {

  WalletTransactionContent? content;
  WalletTransactionModel({this.content});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    content = json['content'] != null ? WalletTransactionContent.fromJson(json['content']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class WalletTransactionContent {
  double? walletBalance;
  Transactions? transactions;

  WalletTransactionContent({this.walletBalance, this.transactions});

  WalletTransactionContent.fromJson(Map<String, dynamic> json) {
    walletBalance = double.tryParse(json['wallet_balance'].toString());
    transactions = json['transactions'] != null
        ? Transactions.fromJson(json['transactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet_balance'] = walletBalance;
    if (transactions != null) {
      data['transactions'] = transactions!.toJson();
    }
    return data;
  }
}

