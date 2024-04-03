class User {
  final int userId;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String role;
  String? token;

  User(this.token, {
    required this.userId,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.role = 'patient',
  });

  // set token
  void setToken(String? token) {
    this.token = token;
  }

  get name => '$firstName $lastName';

  User copyWith(String? token, {
    required int userId,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String role = 'patient',
  }) {
    return User(
      token,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
    );
  }

  toJSON() {
    Map<String, dynamic> m = {};

    m['user_id'] = userId;
    m['username'] = username;
    m['password'] = password;
    m['first_name'] = firstName;
    m['last_name'] = lastName;
    m['phone_number'] = phoneNumber;
    m['role'] = role;

    return m;
  }

  static fromJSON(Map<String, dynamic> m) {
    return User(
      m['token'],
      userId: m['user_id'],
      username: m['username'],
      password: m['password'],
      firstName: m['first_name'],
      lastName: m['last_name'],
      phoneNumber: m['phone_number'],
      role: m['role'],
    );
  }
}