class Location {
  String? id;
  String? name;
  String? description;
  double? latitude;
  double? longitude;

  Location({
    this.id = '',
    this.name,
    this.description,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map, String id) {
    return Location(
      id: id,
      name: map['name'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
