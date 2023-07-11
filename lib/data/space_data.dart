class SpaceData {
  final id;
  final name;

  SpaceData({required this.id, required this.name});

  factory SpaceData.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return SpaceData(id: json['space_id'], name: json['space_name']);
    } else {
      throw Exception('failed getting space info');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  factory SpaceData.fromJsonForPref(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return SpaceData(id: json['id'], name: json['name']);
    }
    throw Exception();
  }
}
