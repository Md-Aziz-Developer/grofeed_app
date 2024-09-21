class LockedContentList {
  int? status;
  String? message;
  List<LockedContent>? lockedContent;

  LockedContentList({this.status, this.message, this.lockedContent});

  LockedContentList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['locked_content'] != null) {
      lockedContent = <LockedContent>[];
      json['locked_content'].forEach((v) {
        lockedContent!.add(new LockedContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.lockedContent != null) {
      data['locked_content'] =
          this.lockedContent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LockedContent {
  String? lockedContentId;
  String? partnerId;
  String? title;
  String? category;
  String? visibleMessage;
  String? lockedMessage;
  List<String>? media;
  String? amount;
  String? date;
  String? status;
  String? addedTime;
  String? updatedTime;
  String? shareUrl;

  LockedContent(
      {this.lockedContentId,
      this.partnerId,
      this.title,
      this.category,
      this.visibleMessage,
      this.lockedMessage,
      this.media,
      this.amount,
      this.date,
      this.status,
      this.addedTime,
      this.updatedTime,
      this.shareUrl});

  LockedContent.fromJson(Map<String, dynamic> json) {
    lockedContentId = json['locked_content_id'];
    partnerId = json['partner_id'];
    title = json['title'];
    category = json['category'];
    visibleMessage = json['visible_message'];
    lockedMessage = json['locked_message'];
    media = json['media'].cast<String>();
    amount = json['amount'];
    date = json['date'];
    status = json['status'];
    addedTime = json['added_time'];
    updatedTime = json['updated_time'];
    shareUrl = json['share_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locked_content_id'] = this.lockedContentId;
    data['partner_id'] = this.partnerId;
    data['title'] = this.title;
    data['category'] = this.category;
    data['visible_message'] = this.visibleMessage;
    data['locked_message'] = this.lockedMessage;
    data['media'] = this.media;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['status'] = this.status;
    data['added_time'] = this.addedTime;
    data['updated_time'] = this.updatedTime;
    data['share_url'] = this.shareUrl;
    return data;
  }
}
