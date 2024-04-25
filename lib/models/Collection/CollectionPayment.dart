class CollectionPayment {
  int? id;
  String? notes;
  String? amount;
  String? date;
  int? customerId;
  int? collectionId;

  CollectionPayment(
      {this.id,
      this.notes,
      this.amount,
      this.date,
      this.customerId,
      this.collectionId});

  CollectionPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notes = json['notes'];
    amount = json['amount'];
    date = json['date'];
    customerId = json['customer_id'];
    collectionId = json['collection_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notes'] = this.notes;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['customer_id'] = this.customerId;
    data['collection_id'] = this.collectionId;
    return data;
  }
}
