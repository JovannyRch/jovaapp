import 'package:jova_app/models/Customer.dart';

class CollectionCategoryDetails {
  int? id;
  String? name;
  String? image;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<Customer>? customers;

  CollectionCategoryDetails(
      {this.id,
      this.name,
      this.image,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.customers});

  CollectionCategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['customers'] != null) {
      customers = <Customer>[];
      json['customers'].forEach((v) {
        customers!.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customers != null) {
      data['customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
