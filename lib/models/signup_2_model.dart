class Signup2Model {
  // String state;
  String zipCode;
  String city;
  String streetAddress;
  String? referalCode;

  Signup2Model(
      {required this.city,
        this.referalCode,
        // required this.state,
        required this.streetAddress,
        required this.zipCode});

  Map<String, dynamic> addData() {
    final Map<String, dynamic> data = Map<String, dynamic>();
//data["State"] = state;
    data["ZipCode"] = zipCode;
    data["city"] = city;
    data["Street Address"] = streetAddress;
    data["Referal Code"] = referalCode;
    return data;
  }
}
