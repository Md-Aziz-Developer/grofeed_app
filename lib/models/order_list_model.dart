class OrderList {
  int? status;
  String? message;
  List<Order>? order;

  OrderList({this.status, this.message, this.order});

  OrderList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  String? orderId;
  String? contentId;
  String? contentType;
  String? subscriptionPlanId;
  String? partnerId;
  String? userId;
  String? orderNumber;
  String? userName;
  String? userEmail;
  String? userNumber;
  String? orderAmount;
  String? orderPaymentId;
  String? orderStatus;
  String? orderDate;
  String? addedTime;
  String? updatedTime;
  String? title;

  Order(
      {this.orderId,
      this.contentId,
      this.contentType,
      this.subscriptionPlanId,
      this.partnerId,
      this.userId,
      this.orderNumber,
      this.userName,
      this.userEmail,
      this.userNumber,
      this.orderAmount,
      this.orderPaymentId,
      this.orderStatus,
      this.orderDate,
      this.addedTime,
      this.updatedTime,
      this.title});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    contentId = json['content_id'];
    contentType = json['content_type'];
    subscriptionPlanId = json['subscription_plan_id'];
    partnerId = json['partner_id'];
    userId = json['user_id'];
    orderNumber = json['order_number'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userNumber = json['user_number'];
    orderAmount = json['order_amount'];
    orderPaymentId = json['order_payment_id'];
    orderStatus = json['order_status'];
    orderDate = json['order_date'];
    addedTime = json['added_time'];
    updatedTime = json['updated_time'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['content_id'] = this.contentId;
    data['content_type'] = this.contentType;
    data['subscription_plan_id'] = this.subscriptionPlanId;
    data['partner_id'] = this.partnerId;
    data['user_id'] = this.userId;
    data['order_number'] = this.orderNumber;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_number'] = this.userNumber;
    data['order_amount'] = this.orderAmount;
    data['order_payment_id'] = this.orderPaymentId;
    data['order_status'] = this.orderStatus;
    data['order_date'] = this.orderDate;
    data['added_time'] = this.addedTime;
    data['updated_time'] = this.updatedTime;
    data['title'] = this.title;
    return data;
  }
}
