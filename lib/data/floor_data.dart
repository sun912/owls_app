class FloorData {
  final String name;
  final String floorImageUrl;
  final String id;

  FloorData(
      {required this.name, required this.floorImageUrl, required this.id});

  factory FloorData.fromJson(Map<String, dynamic> json) {
    return FloorData(
        name: json['floor_name'],
        floorImageUrl: json['floor_image_url'],
        id: json['floor_id']);
  }
}
