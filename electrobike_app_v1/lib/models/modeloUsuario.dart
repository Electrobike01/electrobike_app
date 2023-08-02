class UserModel {
  final id;
  final username;
  final password;

  UserModel({
    this.id,
    this.username,
    this.password,
  });

  factory UserModel.login(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }
}
