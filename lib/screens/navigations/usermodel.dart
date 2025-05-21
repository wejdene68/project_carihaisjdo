class UserModel {
  final String fullName;
  final String email;

  UserModel({required this.fullName, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'],
      email: map['email'],
    );
  }
}
