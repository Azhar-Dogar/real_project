import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../components/dialogue_box.dart';
import '../../../models/category_model.dart';
import '../../components/app_styles.dart';
import '../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../functions/categories_data.dart';
import '../../models/public_category_model.dart';
import '../../models/subcatprice_model.dart';
import 'custom_categories.dart';

class AddExpenseScreen extends StatefulWidget {
  PublicCategoryModel? model;

  AddExpenseScreen({Key? key, this.model}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController titleFieldController = TextEditingController();
  TextEditingController priceFieldController = TextEditingController();
  List<PublicCategoryModel> dropDownItems = [];
  List<SubCatPriceModel> newSubCat = [];
  List<SubCatPriceModel> custSubCat = [];
  PublicCategoryModel? dropButtonValue;
  String? categoryId;
  String? categoryTitle;
  int? categoryColor;
  int price = 0;
  String? title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model != null) {
      title = "Edit Expense";
    } else {
      title = "Add Expense";
    }
  }

  Future<void> getSubCategories(modelValue, String id) async {
    await modelValue.findEditAbleSubCategories(dropButtonValue!.id);
    await modelValue.getTransaction();
    //await Future.delayed(
    //  const Duration(milliseconds: 2));
    await modelValue.addDataToPriceModel();
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
              title!,
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Divider(
              color: Colors.grey.shade700,
            ),
            ChangeNotifierProvider(create: (BuildContext context) {
              CategoriesData();
            }, child: Consumer<CategoriesData>(
                builder: (BuildContext context, modelValue, Widget? child) {
                  dropDownItems = modelValue.dropDownAllCategories;
                  if (widget.model != null && dropButtonValue == null) {
                    dropButtonValue = widget.model!;
                    categoryId = dropButtonValue!.id;
                    categoryTitle = dropButtonValue!.name;
                    categoryColor = dropButtonValue!.color;
                    getSubCategories(modelValue, dropButtonValue!.id);
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChangeNotifierProvider(
                                          create: (BuildContext context) {
                                            return CategoriesData();
                                          },
                                          child: const CustomCategories()),
                                    ));
                              },
                              child: Text(
                                "Custom categories",
                                style: AppStyles.popins(
                                    style: TextStyle(color: ColorsClass.green)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 18.0, left: 16, right: 16),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8),
                                child: DropdownButton<PublicCategoryModel>(
                                  icon: const Icon(IconlyLight.arrow_down_2),
                                  hint: Text(
                                      dropButtonValue?.name ?? "Select Category"),
                                  onChanged: (val) async {
                                    setState(() {
                                      dropButtonValue = val;
                                      categoryId = dropButtonValue!.id;
                                      categoryTitle = dropButtonValue!.name;
                                      categoryColor = dropButtonValue!.color;
                                      modelValue.addEditAbleCustSubCat = [];
                                    });
                                    await modelValue.findEditAbleSubCategories(
                                        dropButtonValue!.id);
                                    await modelValue.getTransaction();
                                    await Future.delayed(
                                        const Duration(milliseconds: 2));
                                    await modelValue.addDataToPriceModel();
                                  },
                                  items: dropDownItems
                                      .map<DropdownMenuItem<PublicCategoryModel>>(
                                          (value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                ),
                              ),
                            )),
                      ),
                      (dropButtonValue == null)
                          ? dottedBorder()
                          : category(modelValue, dropButtonValue!.id)
                    ],
                  );
                }))
          ],
        ),
      ),
    );
  }

  Widget dottedBorder() {
    return Padding(
      padding: const EdgeInsets.only(top: 168.0),
      child: DottedBorder(
          radius: const Radius.circular(16),
          dashPattern: const [10, 10, 10, 10],
          borderType: BorderType.RRect,
          strokeWidth: 2,
          color: Colors.grey.shade900,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 18, top: 25, bottom: 25),
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Select a category to add an expense\nto your budget but if you have an\nexpense that just doesn't fit any\ncurrent category.just click on",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      "Custom Categories",
                      style: AppStyles.popins(
                          style: TextStyle(color: ColorsClass.green)),
                    ),
                    Text("to  create any category  you need!",
                        style: TextStyle(color: Colors.grey.shade700))
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget category(modelValue, String catId) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, left: 16, right: 16),
      child: Column(
        children: [
          Divider(
            color: Colors.grey.shade700,
          ),
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: (modelValue.addEditAbleCustSubCat.isNotEmpty)
                  ? custSubCategoriesBuilder(modelValue, catId)
                  : publicCatBuilder(modelValue)),
          Padding(
            padding: const EdgeInsets.only(top: 48.0, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: ColorsClass.green,
                ),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => DialogueBox(
                              onPressedSave: () {
                                if (modelValue.addEditAbleCustSubCat.isEmpty) {
                                  setState(() {
                                    newSubCat.add(SubCatPriceModel(
                                        subCatId: "",
                                        subCatTitle: titleFieldController.text,
                                        price: price));
                                    titleFieldController.clear();
                                    Navigator.pop(context);
                                  });
                                } else {
                                  setState(() {
                                    modelValue.addEditAbleCustSubCat.add(
                                        SubCatPriceModel(
                                            subCatId: "",
                                            subCatTitle:
                                            titleFieldController.text,
                                            price: price));
                                    titleFieldController.clear();
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              onPressedCancel: () {
                                Navigator.pop(context);
                              },
                              title: "Title",
                              textFieldController: titleFieldController,
                              hint: "SubCat Title"));
                    },
                    child: Text("add more",
                        style: AppStyles.popins(
                          style: TextStyle(color: ColorsClass.green),
                        )))
              ],
            ),
          ),
          ButtonClass(onPressed: () {}, buttonName: "Add")
        ],
      ),
    );
  }

  Widget custSubCategoriesBuilder(modelValue, categoryID) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: modelValue.addEditAbleCustSubCat.length,
        itemBuilder: (context, index) {
          var price = modelValue.addEditAbleCustSubCat[index].price;
          return Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  modelValue.addEditAbleCustSubCat[index].subCatTitle,
                  style: AppStyles.popins(
                      style: TextStyle(color: ColorsClass.grey, fontSize: 16)),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => DialogueBox(
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "please enter price";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            onPressedCancel: () {
                              priceFieldController.clear();
                              Navigator.pop(context);
                            },
                            onPressedSave: () async {
                              if (priceFieldController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Please enter price")));
                              } else if (modelValue.remainingAmount <
                                  int.parse(priceFieldController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "price must be less than or equal to \$${modelValue.remainingAmount}")));
                              } else {
                                modelValue.addEditAbleCustSubCat[index].price =
                                    modelValue.addEditAbleCustSubCat[index]
                                        .price +
                                        int.tryParse(
                                            priceFieldController.text.trim())!;
                                await modelValue.addTransaction(
                                    categoryId: categoryId,
                                    catTitle: categoryTitle,
                                    subCatTitle: modelValue
                                        .addEditAbleCustSubCat[index]
                                        .subCatTitle,
                                    subCatId: modelValue
                                        .addEditAbleCustSubCat[index].subCatId,
                                    price: int.tryParse(
                                        priceFieldController.text.trim())!,
                                    categoryColor: categoryColor);
                                setState(() {
                                  priceFieldController.clear();
                                });
                                Navigator.pop(context);
                              }
                            },
                            title: "Price",
                            textFieldController: priceFieldController,
                            hint: "Price"));
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: ColorsClass.textFieldBackground,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "${modelValue.addEditAbleCustSubCat[index].price}",
                            style: AppStyles.popins(
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white60)),
                          ))),
                )
              ],
            ),
          );
        });
  }

  Widget publicCatBuilder(modelValue) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: newSubCat.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  newSubCat[index].subCatTitle,
                  //newSubCat[index].subCatTitle,
                  style: AppStyles.popins(
                      style: TextStyle(color: ColorsClass.grey, fontSize: 16)),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => DialogueBox(
                            keyboardType: TextInputType.number,
                            onPressedCancel: () {
                              priceFieldController.clear();
                              Navigator.pop(context);
                            },
                            onPressedSave: () async {
                              if (priceFieldController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Please enter price")));
                              } else if (modelValue.remainingAmount <
                                  int.parse(priceFieldController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "price must be less than or equal to \$${modelValue.remainingAmount}")));
                              } else {
                                print("save");
                                newSubCat[index].price = int.tryParse(
                                    priceFieldController.text.trim())!;
                                await modelValue.addTransaction(
                                  categoryId: categoryId,
                                  catTitle: categoryTitle,
                                  subCatTitle: newSubCat[index].subCatTitle,
                                  subCatId: newSubCat[index].subCatId,
                                  price: newSubCat[index].price,
                                  categoryColor: categoryColor,
                                );
                                setState(() {
                                  priceFieldController.clear();
                                });
                                Navigator.pop(context);
                              }
                            },
                            title: "Price",
                            textFieldController: priceFieldController,
                            hint: "Price"));
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: ColorsClass.textFieldBackground,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "${newSubCat[index].price}",
                            style: AppStyles.popins(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white60)),
                          ))),
                )
              ],
            ),
          );
        });
  }
}
