import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phone,
    super.profileImage,
    super.dateOfBirth,
    super.gender,
    super.bloodGroup,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['FirstName'] ?? json['first_name'] ?? '';
    final lastName = json['LastName'] ?? json['last_name'] ?? '';
    final nameFromParts = '$firstName $lastName'.trim();

    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      fullName: json['name'] ?? json['fullName'] ?? (nameFromParts.isNotEmpty ? nameFromParts : ''),
      email: json['email'] ?? '',
      phone: json['mobile'] ?? json['phone'],
      profileImage: json['profile_image'] ?? json['profileImage'] ?? json['avatar'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'bloodGroup': bloodGroup,
    };
  }
}
