class CategoryPayments {
  String? total;
  List<Payment>? list;

  CategoryPayments({this.total, this.list});

  CategoryPayments.fromJson(Map<String, dynamic> json) {
    total = json['total'].toString();
    if (json['list'] != null) {
      list = <Payment>[];
      json['list'].forEach((v) {
        list!.add(new Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total.toString();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  int? id;
  String? amount;
  String? date;
  String? notes;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  Payment({
    this.id,
    this.amount,
    this.date,
    this.notes,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    date = json['date'];
    notes = json['notes'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['notes'] = this.notes;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
