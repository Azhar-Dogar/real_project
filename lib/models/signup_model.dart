class SignupModel {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;

  // String state;
  // String zipCode;
  // String city;
  // String streetAddress;
  // String referalCode;
  SignupModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    // required this.city,
    // required this.referalCode,
    // required this.state,
    // required this.streetAddress,
    // required this.zipCode
  });

  Map<String, dynamic> addData() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["First Name"] = firstName;
    data["Last Name"] = lastName;
    data["Email"] = email;
    data["Phone Number"] = phoneNumber;
    return data;
  }
}
