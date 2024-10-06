class Profile {
  final String name;
  final String email;
  final String password;
  final String role;
  final String headshotURL;

  Profile(
      {required this.name,
        required this.email,
        required this.password,
        required this.role,
        required this.headshotURL});

  Map<String, dynamic> toMap(){
    return {
      'name':name,
      'email': email,
      'password': password,
      'role': role,
      'headshotURL': headshotURL,
    };
  }

  Profile fromMap(Map<String, dynamic> json) {
    return Profile(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        role: json['role'],
        headshotURL: json['headshotURL']
    );
  }
}