class CollectionCategory {
  int? id;
  String? name;
  String? image;
  String? description;
  String? createdAt;
  String? updatedAt;

  CollectionCategory(
      {this.id,
      this.name,
      this.image,
      this.description,
      this.createdAt,
      this.updatedAt});

  CollectionCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
