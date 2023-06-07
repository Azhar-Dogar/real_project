import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../components/app_styles.dart';
import '../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../components/dialogue_box.dart';
import '../../components/loading_dialogue.dart';
import '../../components/text_field_class.dart';
import '../../functions/categories_data.dart';
import '../../models/category_model.dart';
import '../../models/edit_category_model.dart';

class AddCategories extends StatefulWidget {
  EditCategoryModel? editCategoryModel;
  List? editAbleSubCategories;
  String? categoryId;

  AddCategories(
      {Key? key,
        this.categoryId,
        this.editCategoryModel,
        this.editAbleSubCategories})
      : super(key: key);

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  late final catDoc;
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List subCategories = [];
  List newSubCategories = [];
  List? rawList;
  var color = ColorsClass.red1;
  String? screenTitle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editCategoryModel != null) {
      screenTitle = widget.editCategoryModel!.screenTitle;
      categoryController.text = widget.editCategoryModel!.categoryTitle!;
    } else {
      screenTitle = "Add Category";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/arrow_left.png",
                width: 30,
              )),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Container(
            height: 60,
            child: Text(
              screenTitle!,
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: ChangeNotifierProvider(
            create: (context) {
              CategoriesData();
            },
            child: Consumer<CategoriesData>(
                builder: (context, value, Widget? child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey.shade700),
                      Consumer<CategoriesData>(
                          builder: (BuildContext context, value, Widget? child) {
                            return Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 25, bottom: 25),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFieldClass(
                                        textFieldController: categoryController,
                                        validator: (v) {
                                          if (v!.isEmpty) {
                                            return "Please enter category title";
                                          }
                                        },
                                        hintText: "Category Title",
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              actionsPadding: const EdgeInsets.only(
                                                  bottom: 60, left: 15, right: 15),
                                              content: ColorPicker(
                                                pickerColor: color,
                                                onColorChanged: (color) {
                                                  setState(() {
                                                    this.color = color;
                                                  });
                                                },
                                              ),
                                              actions: [
                                                ButtonClass(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonName: "Done")
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.color_lens,
                                          color: Colors.white,
                                          size: 35,
                                        ))
                                  ],
                                ));
                          }),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.24,
                          child: (widget.editCategoryModel != null)
                              ? Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: editScreenBuilder())
                              : addScreenBuilder()),
                      newSubCat(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: ColorsClass.green),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => DialogueBox(textFieldController: subCatController,
                                      title:"Sub Category", onPressedCancel:(){
                                        Navigator.pop(context);
                                      }, onPressedSave:(){
                                        if (widget.editCategoryModel != null) {
                                          setState(() {
                                            newSubCategories.add(subCatController.text);
                                            subCatController.clear();
                                            Navigator.pop(context);
                                          });
                                        }
                                        subCategories.add(CategoryModel(title: subCatController.text));
                                        subCatController.clear();
                                        Navigator.pop(context);
                                      },hint: "title",)
                                );
                              },
                              child: Text(
                                "add sub-category",
                                style: AppStyles.popins(
                                    style: TextStyle(color: ColorsClass.green)),
                              ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 20,
                        ),
                        child: ButtonClass(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  widget.editCategoryModel == null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => LoadingDialogue(content: "Adding Category",color: ColorsClass.green,));
                                await value.addCustCategories(
                                    categoryController, color.value);
                                if (subCategories.isNotEmpty) {
                                  for (var element in subCategories) {
                                    await value.addSubCategories(
                                        element.title, value.catDoc.id);
                                  }
                                }
                                Navigator.pop(context);
                              } else {
                                await value.editCategory(
                                    categoryController,
                                    color.value,
                                    newSubCategories,
                                    widget.categoryId!);
                              }
                              Navigator.pop(context);
                            },
                            buttonName: "Add"),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget addScreenBuilder() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  subCategories[index].title,
                  style: AppStyles.popins(
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Divider(
                color: Colors.grey.shade700,
              )
            ],
          );
        });
  }
  Widget editScreenBuilder() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.editAbleSubCategories!.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  widget.editAbleSubCategories?[index].subCatTitle,
                  style: AppStyles.popins(
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Divider(
                color: Colors.grey.shade700,
              )
            ],
          );
        });
  }

  Widget newSubCat() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: newSubCategories.length,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 14.0, top: 8, bottom: 8),
                child: Text(
                  newSubCategories[index],
                  style: AppStyles.popins(
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Divider(
                color: Colors.grey.shade700,
              )
            ],
          )),
    );
  }
}
