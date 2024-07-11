class Profile {
  final String name;
  final String email;
  final String password;
  final String userType;
  final String pairs;

  Profile({
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    required this.pairs,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
      'pairs': pairs,
    };
  }
}
