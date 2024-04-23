class Payment {
  int? id;
  String? amount;
  String? date;
  Null? notes;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  Payment(
      {this.id,
      this.amount,
      this.date,
      this.notes,
      this.categoryId,
      this.createdAt,
      this.updatedAt});

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
