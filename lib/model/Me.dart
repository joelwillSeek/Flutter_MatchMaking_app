class Me {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String bio;
  final String deviceToken;
  final String profileUrl;
  final String? phoneNumber; // Make phoneNumber nullable
  final int age;
  final String address;
  final Map<String, dynamic> ageRange;
  final String preferencesGender;
  final List<dynamic> interests;

  Me({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.bio,
    required this.deviceToken,
    required this.profileUrl,
    this.phoneNumber, // Update here
    required this.age,
    required this.address,
    required this.ageRange,
    required this.preferencesGender,
    required this.interests,
  });

  factory Me.fromFirestore(
      Map<String, dynamic>? userData, Map<String, dynamic>? preferencesData) {
    if (userData == null || preferencesData == null) {
      throw ArgumentError("userData or preferencesData is null");
    }

    return Me(
      userId: userData['user_id'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      gender: userData['gender'],
      email: userData['email'],
      bio: userData['bio'],
      deviceToken: userData['deviceToken'],
      profileUrl: userData['profile_url'],
      phoneNumber: userData['phoneNumber'], // Updated here
      age: userData['age'],
      address: preferencesData['address'],
      ageRange: preferencesData['ageRange'],
      preferencesGender: preferencesData['gender'],
      interests: List<String>.from(preferencesData['interests']),
    );
  }
}
