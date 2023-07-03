class MapImageData {
  final String imageUrl;
  final String floorName;
  final String floorId;

  MapImageData(
      {required this.imageUrl, required this.floorName, required this.floorId});

  factory MapImageData.fromJson(Map<String, dynamic> json) {
    return MapImageData(
        imageUrl: json['floor_image_url'],
        floorId: json['floor_id'],
        floorName: json['floor_name']);
  }
}
