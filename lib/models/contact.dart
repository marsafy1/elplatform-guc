class Contact {
  String? id;
  String name;
  String phoneNumber;
  int iconCodePoint;
  String iconFontFamily;

  Contact(
      {this.id = "",
      required this.name,
      required this.phoneNumber,
      required this.iconCodePoint,
      required this.iconFontFamily});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'icon_code_point': iconCodePoint,
      'icon_font_family': iconFontFamily,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map, String id) {
    return Contact(
      id: id,
      name: map['name'],
      phoneNumber: map['phone_number'],
      iconCodePoint: map['icon_code_point'],
      iconFontFamily: map['icon_font_family'],
    );
  }
}
