class UserModel{
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String? referalCode;
  String? streetAddress;
  String? city;
  String? zipCode;
  UserModel({
    this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.referalCode,
    this.streetAddress,
    this.zipCode
  });
  static UserModel fromJson(Map<String,dynamic>Json)=>UserModel(
      firstName: Json["First Name"],
      lastName: Json["Last Name"],
      email: Json["Email"],
      phoneNumber: Json["Phone Number"],
      referalCode: Json["Referal Code"],
      streetAddress: Json["Street Address"],
      city: Json["city"],
      zipCode: Json["ZipCode"]);
}