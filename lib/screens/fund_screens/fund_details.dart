
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../components/app_styles.dart';
import '../../components/color_class.dart';
import '../../components/dialogue_box.dart';
import '../../functions/categories_data.dart';
import '../../models/sinking_fund_model.dart';

class FundsDetail extends StatefulWidget {
  SinkingModel model;
  FundsDetail({Key? key, required this.model}) : super(key: key);

  @override
  State<FundsDetail> createState() => _FundsDetailState();
}

class _FundsDetailState extends State<FundsDetail> {
  TextEditingController dialogueFieldController = TextEditingController();
  int remainingAmount = 0;
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
              "Funds Details",
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider(
          create: (BuildContext context) {
            CategoriesData();
          },
          child: Consumer<CategoriesData>(
              builder: (BuildContext context, value, Widget? child) {
                value.getCurrentFundDetails(widget.model.fundId);
                var dueDate =
                DateTime.fromMillisecondsSinceEpoch(widget.model.dueDate);
                var remainingMonth =
                Jiffy(dueDate).diff(DateTime.now(), Units.MONTH);
                var remainingAmount = widget.model.goalAmount - value.fundPaid;
                var percentage = value.fundPaid * 100 / widget.model.goalAmount;
                var indictorvalue = percentage / 100;
                return Column(
                  children: [
                    const Divider(
                      color: Colors.grey,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorsClass.textFieldBackground,
                          borderRadius: BorderRadius.circular(16)),
                      width: double.infinity,
                      //height: MediaQuery.of(context).size.height * 0.28,
                      margin: const EdgeInsets.all(15),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.model.title,
                                  style: AppStyles.popins(
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Text("\$${widget.model.goalAmount}",
                                  style: AppStyles.popins(
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 8),
                            child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                          budgetDetails("TOTAL MONTHS", widget.model.duration),
                          budgetDetails("MONTHLY DEPOSIT",
                              "\$${widget.model.monthlyDeposit.toStringAsFixed(1)}"),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                            child: LinearPercentIndicator(
                              padding: const EdgeInsets.all(0),
                              barRadius: const Radius.circular(12),
                              lineHeight: 15,
                              progressColor: ColorsClass.green,
                              backgroundColor: Colors.black,
                              percent: indictorvalue,
                            ),
                          ),
                          budgetDetails("REMAINING AMOUNT", "\$$remainingAmount"),
                          budgetDetails(
                              "REMAINING MONTHS", remainingMonth.toString())
                        ]),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 20.0, bottom: 18, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.09,
                            height: MediaQuery.of(context).size.height * 0.040,
                            decoration: BoxDecoration(
                                color: ColorsClass.green,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.add,
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => DialogueBox(
                                        keyboardType: TextInputType.number,
                                        textFieldController:
                                        dialogueFieldController,
                                        title: "Add Transaction",
                                        onPressedCancel: () {
                                          dialogueFieldController.clear();
                                          Navigator.pop(context);
                                        },
                                        onPressedSave: () async {
                                          if (remainingAmount >=
                                              int.tryParse(
                                                  dialogueFieldController.text)!) {
                                            await value.addFundTransaction(
                                                fundName: widget.model.title,
                                                goalAmount: widget.model.goalAmount,
                                                fundId: widget.model.fundId,
                                                price: int.tryParse(
                                                    dialogueFieldController.text
                                                        .trim())!);
                                            dialogueFieldController.clear();
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Payment must be less than or to $remainingAmount")));

                                            dialogueFieldController.clear();
                                          }
                                        }));
                              },
                              child: Text(
                                "Add Deposit",
                                style: AppStyles.popins(
                                    style: TextStyle(
                                        color: ColorsClass.green, fontSize: 15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.currentFundTransactions.length,
                          itemBuilder: (context, index) {
                            var date = DateTime.fromMillisecondsSinceEpoch(
                                value.currentFundTransactions[index].date!);
                            String formattedDate =
                                "${date.day}-${date.month}-${date.year}";
                            String formattedTime = DateFormat.jm().format(date);
                            String month =
                            DateFormat.MMMM().format(date).substring(0, 3);
                            var transactMonth = "$month ${date.year}";
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            transactMonth,
                                            style: AppStyles.popins(
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600)),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "AMOUNT",
                                              style: AppStyles.popins(
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14)),
                                            ),
                                            Text(
                                              value.currentFundTransactions[index]
                                                  .price
                                                  .toString(),
                                              style: AppStyles.popins(
                                                  style: TextStyle(
                                                      color: ColorsClass.grey)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "DATE",
                                            style: AppStyles.popins(
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: AppStyles.popins(
                                                style: TextStyle(
                                                    color: ColorsClass.grey)),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Time",
                                            style: AppStyles.popins(
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          Text(
                                            formattedTime,
                                            style: AppStyles.popins(
                                                style: TextStyle(
                                                    color: ColorsClass.grey)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                )
                              ],
                            );
                          }),
                    )
                  ],
                );
              }),
        ),
      ),
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
                color: Colors.white,
                fontSize: 14,
              )),
        ),
        Text(
          price,
          style: AppStyles.popins(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              )),
        )
      ],
    );
  }
}
