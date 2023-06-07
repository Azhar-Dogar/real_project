
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../components/app_styles.dart';
import '../../components/color_class.dart';
import '../../functions/categories_data.dart';
import '../../models/custom_model.dart';
import '../../models/edit_category_model.dart';
import 'add_categories.dart';

class CustomCategories extends StatefulWidget {
  const CustomCategories({Key? key}) : super(key: key);

  @override
  State<CustomCategories> createState() => _CustomCategoriesState();
}

class _CustomCategoriesState extends State<CustomCategories> {
  List customCategories = [
    CustomModel(title: "Custom1"),
    CustomModel(title: "Custom2"),
    CustomModel(title: "Custom3"),
    CustomModel(title: "Custom4"),
  ];

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
                "Custom Categories",
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
            child: ChangeNotifierProvider(create: (context) {
              CategoriesData();
            }, child: Consumer<CategoriesData>(
                builder: (BuildContext context, value, Widget? child) {
                  return Column(children: [
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: ColorsClass.green,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.add,
                                size: 28,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextButton(
                              onPressed: () async {
                                //  await getCategories();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddCategories(),
                                    ));
                              },
                              child: Text(
                                "Add Category",
                                style: AppStyles.popins(
                                    style: TextStyle(
                                        color: ColorsClass.green, fontSize: 15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.70,
                      width: double.infinity,
                      child: (value.allCustCategories.isEmpty)
                          ? Container(
                        margin: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/layer_2.png",
                              height: 200,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "No data found",
                                style: AppStyles.popins(
                                    style:
                                    const TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      )
                          : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.allCustCategories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Slidable(
                                  endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SlidableAction(
                                          onPressed: (v) {
                                            value.findEditAbleSubCategories(
                                                value.allCustCategories[index]
                                                    .id!);

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AddCategories(
                                                      categoryId: value
                                                          .editAbleSubCategories[
                                                      index]
                                                          .categoryId,
                                                      editAbleSubCategories: value
                                                          .editAbleSubCategories,
                                                      editCategoryModel:
                                                      EditCategoryModel(
                                                          screenTitle:
                                                          "Edit Category",
                                                          categoryTitle: value
                                                              .allCustCategories[
                                                          index]
                                                              .name)),
                                                ));
                                          },
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          label: "Edit",
                                          backgroundColor: ColorsClass.green,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SlidableAction(
                                          onPressed: (v) async {
                                            await value.deleteCustCategories(
                                                value.allCustCategories[index]
                                                    .id!);
                                          },
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          label: "Delete",
                                          backgroundColor: ColorsClass.textRed,
                                        )
                                      ]),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorsClass.textFieldBackground,
                                        borderRadius:
                                        BorderRadius.circular(16)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, top: 18, bottom: 18),
                                      child: Text(
                                        value.allCustCategories[index].name!,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  )),
                            );
                          }),
                    )
                  ]);
                }))));
  }
}
