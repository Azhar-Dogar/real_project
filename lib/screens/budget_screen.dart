
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../components/app_styles.dart';
import '../components/color_class.dart';
import '../components/dialogue_box.dart';
import '../components/drop_down_button.dart';
import 'expense_screens/expense_screen.dart';
import '../functions/categories_data.dart';

class MonthlyBudgetScreen extends StatefulWidget {
  const MonthlyBudgetScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyBudgetScreen> createState() => _MonthlyBudgetScreenState();
}

class _MonthlyBudgetScreenState extends State<MonthlyBudgetScreen> {
  TextEditingController incomeFieldController = TextEditingController();
  var dropDownValue1;
  var dropDownValue2;
  String totalAmount = "--";
  int totalExpense = 0;
  List<String> months = [
    'Jan',
    'Feb',
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<String> years = ["2022", "2021", "2020"];

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
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            height: 60,
            child: Stack(children: [
              Text(
                "Monthly",
                style: AppStyles.popins(
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500)),
              ),
              Positioned(
                  top: 21,
                  child: Text(
                    "Budget",
                    style: AppStyles.popins(
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500)),
                  )),
            ]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ChangeNotifierProvider(
          create: (context) {
            CategoriesData();
          },
          child: Consumer<CategoriesData>(
              builder: (BuildContext context, value, Widget? child) {
                String month =  DateFormat.MMMM().format(DateTime.now()).substring(0, 3);
                value.expenseDetails = [];
                totalAmount = "--";
                String buttonTitle = "Add Expected Income";

                if (value.model != null) {
                  buttonTitle = "Update Income";
                  totalAmount = "\$${value.model!.amount.toString()}";
                  value.expenses = [];
                  value.doubleExpenses = [];
                  value.getExpenseList(currentMonth: value.currentMonth);
                  value.getTotalExpense();
                } else {
                  buttonTitle = "Add Expected Income";
                }
                return Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.grey.shade900,
                          thickness: 1,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "YEAR: ",
                                style: AppStyles.popins(
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                              Container(
                                  width: 93,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: DropDownClass(
                                      dropDownValue: dropDownValue1,
                                      onChanged: (val) {
                                        setState(() {
                                          dropDownValue1 = val;
                                        });
                                      },
                                      dropDownColor: Colors.white,
                                      dropDownValueColor: Colors.black,
                                      dropDownItems: years,
                                      hintText: "2022",
                                      iconColor: Colors.black,
                                      hintTextColor: Colors.black)),
                              const SizedBox(
                                width: 19,
                              ),
                              Text(
                                "MONTH: ",
                                style: AppStyles.popins(
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                              Container(
                                  width: 90,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: ColorsClass.textWhite,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: DropDownClass(
                                    dropDownValue: dropDownValue2,
                                    onChanged: (val) {
                                      setState(() {
                                        dropDownValue2 = val;
                                        value.currentMonth = dropDownValue2;
                                        value.model = null;
                                        value.getExpectedIncome(
                                            currentMonth: dropDownValue2);
                                      });
                                    },
                                    dropDownColor: ColorsClass.textWhite,
                                    dropDownValueColor: Colors.black,
                                    dropDownItems: months,

                                    hintText: value.currentMonth!,
                                    hintTextColor: Colors.black,
                                    iconColor: Colors.black,
                                  )),
                            ],
                          ),
                        ),
                        (value.currentMonth == month)
                            ? Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width:
                                MediaQuery.of(context).size.width * 0.09,
                                height: MediaQuery.of(context).size.height *
                                    0.040,
                                decoration: BoxDecoration(
                                    color: ColorsClass.green,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Icon(
                                  Icons.edit,
                                  size: 28,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => DialogueBox(
                                        keyboardType:
                                        TextInputType.number,
                                        textFieldController:
                                        incomeFieldController,
                                        onPressedCancel: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            incomeFieldController.clear();
                                          });
                                        },
                                        onPressedSave: () async {
                                          if (value.totalExpense >
                                              int.parse(
                                                  incomeFieldController
                                                      .text)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Value must be equal or greater than \$${value.totalExpense}")));
                                            setState(() {
                                              incomeFieldController
                                                  .clear();
                                            });
                                          } else if (value.model !=
                                              null) {
                                            await value.updateIncome(
                                                int.parse(
                                                    incomeFieldController
                                                        .text),
                                                value.model!.incomeId);
                                            setState(() {
                                              incomeFieldController
                                                  .clear();
                                            });
                                            Navigator.pop(context);
                                          } else {
                                            await value.addExpectedIncome(
                                                int.parse(
                                                    incomeFieldController
                                                        .text));
                                            setState(() {
                                              incomeFieldController
                                                  .clear();
                                              Navigator.pop(context);
                                            });
                                          }
                                        },
                                        title: "Expected Income",
                                        hint: "Add Amount",
                                      ));
                                },
                                child: Text(
                                  buttonTitle,
                                  style: AppStyles.popins(
                                      style: TextStyle(
                                          color: ColorsClass.green,
                                          fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text(
                                "Expected Income",
                                style: AppStyles.popins(
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              // width: MediaQuery.of(context).size.width * 0.9,
                              // height: MediaQuery.of(context).size.height * 0.34,
                              decoration: BoxDecoration(
                                  color: const Color(0xff292929),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      budgetDetails(
                                          "EXPECTED INCOME\nOF THIS MONTH",
                                          totalAmount),
                                      const Padding(
                                        padding:
                                        EdgeInsets.only(top: 12.0, bottom: 12),
                                        child: Divider(
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                      ),
                                      budgetDetails("INCOME SPENT IN\nBUDGET",
                                          "${value.percentage.toStringAsFixed(1)}%"),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14.0, bottom: 14),
                                        child: LinearPercentIndicator(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          width: 284,
                                          animation: true,
                                          restartAnimation: false,
                                          progressColor: const Color(0xffED3237),
                                          lineHeight: 18,
                                          barRadius: const Radius.circular(10),
                                          backgroundColor: Colors.black,
                                          percent: value.percentValue,
                                        ),
                                      ),
                                      budgetDetails("REMAINING AMOUNT",
                                          "\$${value.remainingAmount}")
                                    ],
                                  )),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 60),
                              height: 120,
                              child: Stack(children: [
                                (value.expenseDetails.isEmpty)?
                                blankChart():
                                PieChart(PieChartData(
                                    centerSpaceRadius: 50,
                                    sectionsSpace: 0,
                                    sections: [
                                      for (var element in value.expenseDetails)
                                        PieChartSectionData(
                                          showTitle: false,
                                          value: element.totalPrice *
                                              100 /
                                              value.totalExpense,
                                          color: Color((element.color==null)?4293734967:element.color!),)
                                    ])),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const ExpenseScreen()));
                                    },
                                    child: Text(
                                      " View\nDetails",
                                      style: AppStyles.popins(
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(top: 45, left: 0, right: 7),
                              child: Wrap(
                                //direction: Axis.horizontal,
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  for (var element in value.expenseDetails)
                                    pieChartColorsName(
                                        Color((element.color==null)?4293734967:element.color!), (element.expenseTitle==null)?"":element.expenseTitle!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));
              }),
        ),
      ),
    );
  }
  Widget blankChart(){
    return PieChart(
        PieChartData(
            centerSpaceRadius: 50,
            sectionsSpace: 0,
            sections:[
              PieChartSectionData(
                  color:const Color(0xff292929)
              )
            ]
        ));
  }
  Widget pieChartColorsName(Color boxColor, String label) {
    return Wrap(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
              color: boxColor, borderRadius: BorderRadius.circular(4)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(label,
              style: AppStyles.popins(
                style: const TextStyle(color: Colors.white, fontSize: 11),
              )),
        )
      ],
    );
  }

  Widget budgetDetails(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.popins(
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
        ),
        Text(
          price,
          style: AppStyles.popins(
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600)),
        )
      ],
    );
  }
}
