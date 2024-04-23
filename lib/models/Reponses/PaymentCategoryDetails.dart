import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/models/Customer.dart';

class PaymentCategoryDetailsResponse {
  int? id;
  String? name;
  String? budget;
  int? customerId;
  String? createdAt;
  String? updatedAt;
  String? total;
  double? percentage;
  List<Payment>? payments;
  Customer? customer;

  PaymentCategoryDetailsResponse(
      {this.id,
      this.name,
      this.budget,
      this.customerId,
      this.createdAt,
      this.updatedAt,
      this.total,
      this.percentage,
      this.payments,
      this.customer});

  PaymentCategoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    budget = json['budget'];
    customerId = json['customer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    total = json['total'];
    percentage = json['percentage'];
    if (json['payments'] != null) {
      payments = <Payment>[];
      json['payments'].forEach((v) {
        payments!.add(Payment.fromJson(v));
      });
    }
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['budget'] = this.budget;
    data['customer_id'] = this.customerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total'] = this.total;
    data['percentage'] = this.percentage;
    if (this.payments != null) {
      data['payments'] = this.payments!.map((v) => v.toJson()).toList();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}
