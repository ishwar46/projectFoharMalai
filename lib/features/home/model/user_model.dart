class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String? address;
  final String? mobileNo;
  final bool isAdmin;
  final String? image;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    this.address,
    this.mobileNo,
    required this.isAdmin,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      username: json['username'],
      address: json['address'],
      mobileNo: json['mobileNo'],
      isAdmin: json['isAdmin'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
      'address': address,
      'mobileNo': mobileNo,
      'isAdmin': isAdmin,
      'image': image,
    };
  }
}
