class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String fullName;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:       json['id']       as String,
      email:    json['email']    as String,
      fullName: json['fullName'] as String,
      phone:    json['phone']    as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':       id,
    'email':    email,
    'fullName': fullName,
    'phone':    phone,
  };
}