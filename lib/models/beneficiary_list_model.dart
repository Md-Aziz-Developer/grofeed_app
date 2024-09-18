class BeneficiaryList {
  int? status;
  String? message;
  List<Beneficiary>? beneficiary;

  BeneficiaryList({this.status, this.message, this.beneficiary});

  BeneficiaryList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['beneficiary'] != null) {
      beneficiary = <Beneficiary>[];
      json['beneficiary'].forEach((v) {
        beneficiary!.add(new Beneficiary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.beneficiary != null) {
      data['beneficiary'] = this.beneficiary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Beneficiary {
  String? benificeryId;
  String? partnerId;
  String? benificeryCode;
  String? accountHolderName;
  String? accountNumber;
  String? bankName;
  String? ifscCode;
  String? status;
  String? addedTime;
  String? updatedTime;

  Beneficiary(
      {this.benificeryId,
      this.partnerId,
      this.benificeryCode,
      this.accountHolderName,
      this.accountNumber,
      this.bankName,
      this.ifscCode,
      this.status,
      this.addedTime,
      this.updatedTime});

  Beneficiary.fromJson(Map<String, dynamic> json) {
    benificeryId = json['benificery_id'];
    partnerId = json['partner_id'];
    benificeryCode = json['benificery_code'];
    accountHolderName = json['account_holder_name'];
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    status = json['status'];
    addedTime = json['added_time'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['benificery_id'] = this.benificeryId;
    data['partner_id'] = this.partnerId;
    data['benificery_code'] = this.benificeryCode;
    data['account_holder_name'] = this.accountHolderName;
    data['account_number'] = this.accountNumber;
    data['bank_name'] = this.bankName;
    data['ifsc_code'] = this.ifscCode;
    data['status'] = this.status;
    data['added_time'] = this.addedTime;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}
