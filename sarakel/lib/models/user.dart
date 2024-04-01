class User {
  String? username;
  String email;
  String password;
  String? token;

  User(
      {this.username, required this.email, required this.password, this.token});
}
