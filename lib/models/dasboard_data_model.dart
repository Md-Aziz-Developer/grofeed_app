class DashboardData {
  int? status;
  String? message;
  Today? today;
  Today? total;
  List<Order>? order;
  List<GraphData>? graphData;

  DashboardData(
      {this.status,
      this.message,
      this.today,
      this.total,
      this.order,
      this.graphData});

  DashboardData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    today = json['today'] != null ? new Today.fromJson(json['today']) : null;
    total = json['total'] != null ? new Today.fromJson(json['total']) : null;
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.add(new Order.fromJson(v));
      });
    }
    if (json['graph_data'] != null) {
      graphData = <GraphData>[];
      json['graph_data'].forEach((v) {
        graphData!.add(new GraphData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.today != null) {
      data['today'] = this.today!.toJson();
    }
    if (this.total != null) {
      data['total'] = this.total!.toJson();
    }
    if (this.order != null) {
      data['order'] = this.order!.map((v) => v.toJson()).toList();
    }
    if (this.graphData != null) {
      data['graph_data'] = this.graphData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Today {
  String? orderCount;
  String? totalAmount;
  String? actualAmount;

  Today({this.orderCount, this.totalAmount, this.actualAmount});

  Today.fromJson(Map<String, dynamic> json) {
    orderCount = json['order_count'];
    totalAmount = json['total_amount'];
    actualAmount = json['actual_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_count'] = this.orderCount;
    data['total_amount'] = this.totalAmount;
    data['actual_amount'] = this.actualAmount;
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

class GraphData {
  String? date;
  String? orderCount;
  String? orderAmount;
  String? orderEarning;

  GraphData({this.date, this.orderCount, this.orderAmount, this.orderEarning});

  GraphData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    orderCount = json['order_count'];
    orderAmount = json['order_amount'];
    orderEarning = json['order_earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['order_count'] = this.orderCount;
    data['order_amount'] = this.orderAmount;
    data['order_earning'] = this.orderEarning;
    return data;
  }
}
