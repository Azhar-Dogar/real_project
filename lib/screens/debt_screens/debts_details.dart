

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../models/debt_account_model.dart';
import '../../components/app_styles.dart';
import '../../components/color_class.dart';
import '../../components/dialogue_box.dart';
import '../../functions/categories_data.dart';

class DebtDetails extends StatefulWidget {
  DebtAccountModel model;
  DebtDetails({Key? key, required this.model}) : super(key: key);

  @override
  State<DebtDetails> createState() => _DebtDetailsState();
}

class _DebtDetailsState extends State<DebtDetails> {
  TextEditingController dialogueFieldController = TextEditingController();
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
              widget.model.debtName,
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
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
                value.getCurrentDebtDetails(
                    widget.model.debtId, widget.model.yourBalance);
                var remainingDebt = widget.model.yourBalance - value.debtPaid;
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade700,
                      indent: 0,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                "DEBT\n\$${widget.model.yourBalance}",
                                style: AppStyles.popins(
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              )),
                          VerticalDivider(
                            color: Colors.grey.shade700,
                            indent: 0,
                            endIndent: 0,
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              "PAID\n\$${value.debtPaid}",
                              style: AppStyles.popins(
                                  style: TextStyle(
                                      color: ColorsClass.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: LinearPercentIndicator(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: ColorsClass.textFieldBackground,
                        progressColor: value.debtColor,
                        percent: value.debtPercentValue,
                        lineHeight: 15,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          accountInfo(
                              "Your Balance", "\$${widget.model.yourBalance}"),
                          accountInfo(
                              "Interest Rate", "${widget.model.interestRate}%"),
                          accountInfo(
                              "Minimum Payment", "\$${widget.model.minPayment}")
                        ],
                      ),
                    ),
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
                            padding: const EdgeInsets.only(left: 8.0, right: 10),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => DialogueBox(
                                        keyboardType: TextInputType.number,
                                        textFieldController:
                                        dialogueFieldController,
                                        title: "Debt Transaction",
                                        hint: "debt transaction",
                                        onPressedCancel: () {
                                          setState(() {
                                            dialogueFieldController.clear();
                                            Navigator.pop(context);
                                          });
                                        },
                                        onPressedSave: () async {
                                          if (remainingDebt >=
                                              int.tryParse(
                                                  dialogueFieldController.text)!) {
                                            await value.addDebtTransaction(
                                                debtName: widget.model.debtName,
                                                debtBalance:
                                                widget.model.yourBalance,
                                                price: int.tryParse(
                                                    dialogueFieldController.text)!,
                                                debtId: widget.model.debtId);
                                            setState(() {
                                              dialogueFieldController.clear();
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar( SnackBar(
                                                content: Text(
                                                    "payment must be less than or equal to $remainingDebt")));
                                          }
                                        }));
                              },
                              child: Text(
                                "Add Payment",
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
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.currentDebtTransactions.length,
                          itemBuilder: (context, index) {
                            var date = DateTime.fromMillisecondsSinceEpoch(
                                value.currentDebtTransactions[index].date!);
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
                                      Column(
                                        children: [
                                          Text(
                                            "AMOUNT",
                                            style: AppStyles.popins(
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)),
                                          ),
                                          Text(
                                            value.currentDebtTransactions[index]
                                                .price
                                                .toString(),
                                            style: AppStyles.popins(
                                                style: TextStyle(
                                                    color: ColorsClass.grey)),
                                          )
                                        ],
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

  Widget accountInfo(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.popins(
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w300)),
        ),
        Text(
          value,
          style: AppStyles.popins(style: const TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
