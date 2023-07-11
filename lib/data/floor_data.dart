class FloorData {
  final String name;
  final String? floorImageUrl;
  final String id;

  FloorData({required this.name, this.floorImageUrl, required this.id});

  factory FloorData.fromJson(Map<String, dynamic> json) {
    // logger.d(json);
    return FloorData(
      name: json['floor_name'],
      floorImageUrl: json['floor_image_url'],
      id: json['floor_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "floor_image_url": floorImageUrl};
  }

  factory FloorData.fromJsonForPref(Map<String, dynamic> json) {
    return FloorData(
        name: json['name'],
        id: json['id'],
        floorImageUrl: json['floor_image_url']);
  }
}
