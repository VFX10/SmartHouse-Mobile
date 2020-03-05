class UserDataModel {
  const UserDataModel({this.id, this.email, this.firstName, this.lastName});

  final int id;
  final String email;
  final String firstName;
  final String lastName;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
