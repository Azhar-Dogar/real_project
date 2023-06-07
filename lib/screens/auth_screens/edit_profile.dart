import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../components/drop_down_button.dart';
import '../../components/text_field_class.dart';
import '../../models/edit_profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}
var profile = FirebaseFirestore.instance.collection("profile");
class _EditProfileState extends State<EditProfile> {
  TextEditingController userNameController = TextEditingController();
  File? image;
  String? imageUrl;
  String? dropDownValue;
  ProfileModel? obj;
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        image = imageFile;
      });
    }
  }
  uploadImage()async{
    var firebaseStorage =
    FirebaseStorage.instance.ref().child("storage/${DateTime.now().toString()}");
    UploadTask uploadTask = firebaseStorage.putFile(image!);
    TaskSnapshot snapshotTask = await uploadTask.whenComplete(() => null);
    imageUrl = await snapshotTask.ref.getDownloadURL();
    print(imageUrl);
  }
  editProfile(String userName)async{
    await profile.add(
        ProfileModel(userName:userName,
            profilePic:imageUrl,
            shift:dropDownValue,
            uid:"",
            deviceId: "",
            email:"").toMap());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin:const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await _getFromGallery();
                  },
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80"
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top:30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: ColorsClass.textFieldBackground,),
              child: DropDownClass(dropDownValueColor: Colors.white,
                  isExpanded: true,
                  dropDownValue: dropDownValue,
                  onChanged: (v){
                    setState(() {
                      dropDownValue = v;
                    });                },
                  dropDownColor: ColorsClass.textFieldBackground,
                  dropDownItems:const ["Morning","Evening"],
                  hintText: "Shift", iconColor: Colors.white, hintTextColor: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top:15.0,bottom: 30),
              child: TextFieldClass(hintText: "user name",textFieldController: userNameController,),
            ),
            ButtonClass(onPressed:()async{
              await uploadImage();
              await editProfile(userNameController.text);
            }, buttonName:"Save")
          ],
        ),
      ),
    );
  }
}
