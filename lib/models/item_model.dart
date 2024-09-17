class Item {
  String name;
  String detail;
  String imagePartDowload;
  String imagePart;
  Item(
      {required this.name,
      required this.detail,
      required this.imagePartDowload,
      required this.imagePart});

  factory Item.fromToJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        detail: json["detail"],
        imagePartDowload: json["imagePartDowload"],
        imagePart: json["imagePart"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "detail": detail,
        "imagePartDowload": imagePartDowload,
        "imagePart": imagePart,
      };
}
