class Contact {
  String? id;
  String name;
  String phoneNumber;
  String icon;

  Contact(
      {this.id = "",
      required this.name,
      required this.phoneNumber,
      required this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'icon': icon,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map, String id) {
    return Contact(
      id: id,
      name: map['name'],
      phoneNumber: map['phone_number'],
      icon: map['icon'],
    );
  }
}
