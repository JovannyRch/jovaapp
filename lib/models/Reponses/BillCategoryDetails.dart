import 'package:jova_app/models/Bill.dart';

class BillCategoryDetails {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? total;
  List<Bill>? bills;

  BillCategoryDetails(
      {this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.total,
      this.bills});

  BillCategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    total = json['total'];
    if (json['bills'] != null) {
      bills = <Bill>[];
      json['bills'].forEach((v) {
        bills!.add(new Bill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total'] = this.total;
    if (this.bills != null) {
      data['bills'] = this.bills!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
