class WarningItemData {
  final String tagId;
  final String tagName;
  final String siteId;
  final String siteName;
  final String createDateTime;
  var isChecked = false;

  WarningItemData({
    required this.tagId,
    required this.tagName,
    required this.siteId,
    required this.siteName,
    required this.createDateTime,
  });

  factory WarningItemData.fromJson(Map<String, dynamic> json) {
    return WarningItemData(
      tagId: json['tag_id'],
      tagName: json['tag_name'],
      siteId: json['site_id'],
      siteName: json['site_name'],
      createDateTime: json['created_datetime'],
    );
  }
}
