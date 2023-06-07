import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/expense_model.dart';
import '../../components/app_styles.dart';
import '../../components/color_class.dart';
import '../../functions/categories_data.dart';
import '../../models/public_category_model.dart';
import 'add_expense.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  late CategoriesData data;
  List<ExpenseModel> uniqueList = [];
  ExpenseModel? model;
  List<ExpenseModel> searchItems = [];
  int oneExpensePrice = 0;
  int subCatPrice = 0;
  String? searchBarValue;
  void searchExpense(String searchValue, List<ExpenseModel> expenseList) {
    searchItems = [];
    final result = expenseList.where((element) {
      final expenseTitle = element.categoryTitle!.toLowerCase();
      final input = searchValue.toLowerCase();
      return expenseTitle.contains(input);
    }).toList();
    setState(() {
      searchItems = result;
    });
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
              "Expense",
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
        child: ChangeNotifierProvider(
          create: (BuildContext context) {
            CategoriesData();
          },
          child: Consumer<CategoriesData>(
              builder: (BuildContext context, value, Widget? child) {
                String month =  DateFormat.MMMM().format(DateTime.now()).substring(0, 3);
                print(month);
                print(value.currentMonth);
                data = value;
                value.expenses = [];
                value.doubleExpenses = [];
                value.getExpenseList(currentMonth: value.currentMonth);
                value.getDoubleTransactions();
                print(value.remainingAmount);
                return Container(
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.grey.shade900,
                        thickness: 1,
                      ),
                      Container(
                          margin:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 41, 41, 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            onChanged: (v) {
                              setState(() {
                                searchBarValue = v;
                              });
                              searchExpense(searchBarValue!, value.expenses);
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 14, top: 14),
                                hintText: "Search list",
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                )),
                          )),
                      (value.remainingAmount != 0 && value.currentMonth == month)
                          ? Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              // width: MediaQuery.of(context).size.width * 0.09,
                              // height: MediaQuery.of(context).size.height * 0.040,
                              decoration: BoxDecoration(
                                  color: ColorsClass.green,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.add,
                                  size: 28,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddExpenseScreen(),
                                      ));
                                },
                                child: Text(
                                  "Add Expense",
                                  style: AppStyles.popins(
                                      style: TextStyle(
                                          color: ColorsClass.green,
                                          fontSize: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(left:16.0,right:16,top:25,bottom: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin:const EdgeInsets.only(bottom: 5),
                                  // width: MediaQuery.of(context).size.width * 0.09,
                                  // height: MediaQuery.of(context).size.height * 0.040,
                                  decoration: BoxDecoration(
                                      color: ColorsClass.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: Text(
                                    "Add Expense",
                                    style: AppStyles.popins(
                                        style: TextStyle(
                                            color: ColorsClass.grey,
                                            fontSize: 15)),
                                  ),
                                ),
                              ],),
                            Text(
                              "You can’t add expense as you have already used 100% of your expected income",textAlign: TextAlign.center,
                              style: AppStyles.popins(
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                      (searchBarValue == null || searchBarValue!.isEmpty)
                          ? Container(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              height:
                              MediaQuery.of(context).size.height * 0.6,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: value.expenses.length,
                                  itemBuilder: (context, index) {
                                    oneExpensePrice = 0;
                                    value.expenses[index].transactions
                                        .forEach((element) {
                                      oneExpensePrice =
                                          oneExpensePrice + element.price!;
                                    });
                                    return Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 8.0),
                                      child: box1(value, index,
                                          oneExpensePrice, value.expenses,month),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                          : (searchItems.isNotEmpty)
                          ? Container(
                        margin: const EdgeInsets.all(15),
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: searchItems.length,
                            itemBuilder: (context, index) {
                              oneExpensePrice = 0;
                              searchItems[index]
                                  .transactions
                                  .forEach((element) {
                                oneExpensePrice =
                                    oneExpensePrice + element.price!;
                              });
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: box1(value, index, oneExpensePrice,
                                    searchItems,month),
                              );
                            }),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 30, bottom: 30),
                        child: DottedBorder(
                            radius: const Radius.circular(16),
                            dashPattern: const [10, 10, 10, 10],
                            borderType: BorderType.RRect,
                            strokeWidth: 2,
                            color: Colors.grey.shade900,
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 35,
                                    bottom: 35),
                                child: Center(
                                  child: Text(
                                    "You have not added any expense yet. Data will be visible once you will add an expense",
                                    textAlign: TextAlign.start,
                                    style: AppStyles.popins(
                                        style: TextStyle(
                                            color: Colors.grey.shade700)),
                                  ),
                                ))),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
  Widget box1(modelValue, index, price, List<ExpenseModel> list,month) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        const SizedBox(
          width: 3,
        ),
        SlidableAction(
          onPressed: (v) {
            if(modelValue.currentMonth == month){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpenseScreen(
                        model: PublicCategoryModel(
                            name: list[index].categoryTitle,
                            id: list[index]
                                .doubleTransactions
                                .first
                                .categoryId!,
                            color:
                            list[index].doubleTransactions.first.color!),
                      )));}
            else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("You can't edit expense ")));
            }
          },
          borderRadius: BorderRadius.circular(16),
          label: "Edit",
          backgroundColor: ColorsClass.green,
        ),
        const SizedBox(
          width: 5,
        ),
        SlidableAction(
          onPressed: (v) async {
            if(modelValue.currentMonth == month) {
              await modelValue.deleteTransaction(list[index].id);
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You can't delete the expense")));
            }
          },
          borderRadius: BorderRadius.circular(16),
          label: "Delete",
          backgroundColor: ColorsClass.textRed,
        )
      ]),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(
              (0xff292929),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.04,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                      color: Color((list[index].transactions[0].color==null)?4293734967:list[index].transactions[0].color!),
                      borderRadius: BorderRadius.circular(12)),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              //  'modelValue.tempRefTransaction[index].categoryTitle',
                              (list[index]
                                  .doubleTransactions
                                  .first
                                  .categoryTitle==null)?"":list[index]
                                  .doubleTransactions
                                  .first
                                  .categoryTitle!,
                              //"asad",
                              style: AppStyles.popins(
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Text(
                              price.toString(),
                              style: AppStyles.popins(
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600)),
                            )
                          ]),
                      for (var element in list[index].doubleTransactions)
                        Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: expenseDetails(
                                element.subCatTitle, "${element.price}")),
                    ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget expenseDetails(String? title, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        (title==null)?"":title!,
        style: AppStyles.popins(
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            )),
      ),
      Text(
        value,
        style: AppStyles.popins(
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            )),
      )
    ]);
  }
}
