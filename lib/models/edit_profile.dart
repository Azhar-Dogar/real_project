class ProfileModel {
  late String userName; //editable
  late String uid, deviceId, email;

  String? profilePic;
  String? shift;
  bool? restricted;
  ProfileModel({
    this.shift,
    required this.userName,
    required this.uid,
    required this.profilePic,
    required this.deviceId,
    required this.email,
  });

  ProfileModel.fromMap(Map<String, dynamic> data){

    userName = data["username"];
    uid = data["uid"];
    profilePic = data["profilePic"];
    deviceId = data["deviceId"];
    email = data["email"];
    shift = data["shift"];
    restricted = data["restricted"] ?? false;
  }

  Map<String, dynamic> toMap(){
    return {
      "username" : userName,
      "uid" : uid,
      "profilePic" : profilePic,
      "deviceId" : deviceId,
      "email" : email,
      "shift" : shift,
      "restricted" : restricted,
    };
  }
}
