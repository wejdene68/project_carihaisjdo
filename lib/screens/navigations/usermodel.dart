class UserModel {
  final String fullName;
  final String email;
  final int? age;
  final String? profileImage;
  final List<String>? diseases;
  final List<String>? medications;
  final bool isDoctor;

  UserModel({
    required this.fullName,
    required this.email,
    this.age,
    this.profileImage,
    this.diseases,
    this.medications,
    this.isDoctor = false,
  });

  // Convert the UserModel object to a map for saving to SharedPreferences or Firebase
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'age': age,
      'profileImage': profileImage,
      'diseases': diseases,
      'medications': medications,
      'isDoctor': isDoctor,
    };
  }

  // Create a UserModel object from a map (e.g., when retrieving data from SharedPreferences or Firebase)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] ?? 'Unknown User',
      email: map['email'] ?? 'Unknown Email',
      age: map['age'] ?? 0,
      profileImage: map['profileImage'] ?? 'assets/default_profile.png',
      diseases: List<String>.from(map['diseases'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
      isDoctor: map['isDoctor'] ?? false,
    );
  }
}
