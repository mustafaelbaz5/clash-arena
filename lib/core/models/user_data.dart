class UserData {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final int age;
  final String? profileImageUrl;

  UserData({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.age,
    this.profileImageUrl,
  });

  /// Factory for creating a UserData object from a Supabase map
  factory UserData.fromMap(final Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String?,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      age: map['age'] ?? 0,
      profileImageUrl: map['profile_image'],
    );
  }

  /// Converts UserData into a map for inserting/updating Supabase
  Map<String, dynamic> toMap(final String uid) {
    return {
      'id': uid,
      'name': name,
      'phone_number': phoneNumber,
      'age': age,
      'email': email,
      'profile_image': profileImageUrl,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  UserData copyWith({final String? profileImageUrl}) {
    return UserData(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      age: age,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
