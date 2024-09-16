class Item {
  String name;
  String number;
  String image;
  Item({required this.name, required this.number, required this.image});

  factory Item.fromToJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        number: json["number"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() =>
      {"name": name, "number": number, "image": image};
}
