class SiteData {
  final String id;
  final String name;

  SiteData({required this.id, required this.name});

  factory SiteData.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return SiteData(
        id: json['site_id'],
        name: json['site_name'],
      );
    } else {
      // logger.e('Cannot found value from the key');
    }
    throw Exception('SiteData from Json is failed');
  }
}
