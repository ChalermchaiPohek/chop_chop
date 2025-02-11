import 'dart:convert';

ProductRespond productRespondFromJson(String str) => ProductRespond.fromJson(json.decode(str));

String productRespondToJson(ProductRespond data) => json.encode(data.toJson());

class ProductRespond {
  final List<Item> items;
  final String nextCursor;

  ProductRespond({
    required this.items,
    required this.nextCursor,
  });

  factory ProductRespond.fromJson(Map<String, dynamic> json) => ProductRespond(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    nextCursor: json["nextCursor"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "nextCursor": nextCursor,
  };
}

class Item {
  final int id;
  final String name;
  final int price;

  Item({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
  };
}