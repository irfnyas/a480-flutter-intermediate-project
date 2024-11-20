class Story {
  Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final String? createdAt;
  final num? lat;
  final num? lon;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['storyId'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      photoUrl: json['photoUrl'],
      createdAt: json['createdAt'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'lat': lat,
      'lon': lon,
    };
  }

  static List<Story> fromArray(List? json) =>
      List.from((json ?? []).map((data) => Story.fromJson(data)));
}
