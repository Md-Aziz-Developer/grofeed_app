class WalletDataList {
  int? status;
  String? message;
  List<Wallet>? wallet;

  WalletDataList({this.status, this.message, this.wallet});

  WalletDataList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['wallet'] != null) {
      wallet = <Wallet>[];
      json['wallet'].forEach((v) {
        wallet!.add(new Wallet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wallet {
  String? walletCreditId;
  String? collectedAmount;
  String? commissionAmount;
  String? actualAmount;
  String? creditDate;
  String? withdrawalStatus;
  String? orderNumber;

  Wallet(
      {this.walletCreditId,
      this.collectedAmount,
      this.commissionAmount,
      this.actualAmount,
      this.creditDate,
      this.withdrawalStatus,
      this.orderNumber});

  Wallet.fromJson(Map<String, dynamic> json) {
    walletCreditId = json['wallet_credit_id'];
    collectedAmount = json['collected_amount'];
    commissionAmount = json['commission_amount'];
    actualAmount = json['actual_amount'];
    creditDate = json['credit_date'];
    withdrawalStatus = json['withdrawal_status'];
    orderNumber = json['order_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_credit_id'] = this.walletCreditId;
    data['collected_amount'] = this.collectedAmount;
    data['commission_amount'] = this.commissionAmount;
    data['actual_amount'] = this.actualAmount;
    data['credit_date'] = this.creditDate;
    data['withdrawal_status'] = this.withdrawalStatus;
    data['order_number'] = this.orderNumber;
    return data;
  }
}
