class UserModel {
  final String fullName;
  final String email;
  final String? bio;
  final String? proexp;
  final String? address;
  final bool isDoctor;

  UserModel({
    required this.fullName,
    required this.email,
    required this.isDoctor,
    this.bio,
    this.proexp,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'bio': bio,
      'proexp': proexp,
      'address': address,
      'isDoctor': isDoctor,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'],
      email: map['email'],
      bio: map['bio'],
      proexp: map['proexp'],
      address: map['address'],
      isDoctor: map['isDoctor'],
    );
  }
}
