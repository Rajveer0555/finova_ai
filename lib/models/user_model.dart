class UserModel {
  final String name;
  final String email;
  final String phone;
  final String? image;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      image: map['profileImage'],
    );
  }
}