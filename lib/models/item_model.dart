class Item {
  String name;
  String number;

  Item({required this.name, required this.number});

  factory Item.fromToJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {"name": name, "number": number};
}
