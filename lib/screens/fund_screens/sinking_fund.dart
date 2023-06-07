
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../functions/categories_data.dart';
import '../../components/app_styles.dart';
import '../../components/color_class.dart';
import 'create_fund.dart';
import 'fund_details.dart';

class SinkingFunds extends StatefulWidget {
  const SinkingFunds({Key? key}) : super(key: key);

  @override
  State<SinkingFunds> createState() => _SinkingFundsState();
}

class _SinkingFundsState extends State<SinkingFunds> {
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
              "Sinking Funds",
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
          create: (BuildContext context) {
            CategoriesData();
          },
          child: Consumer<CategoriesData>(
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  children: [
                    Divider(
                      color: ColorsClass.grey,
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const Text(
                            "Put in your long term financial goal like vacation\nor auto repair on this form. The last column, is\nyour monthly deposit for that goal",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 28.0, bottom: 18),
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateFund(),
                                        ));
                                  },
                                  child: Text(
                                    "Add Fund",
                                    style: AppStyles.popins(
                                        style: TextStyle(
                                            color: ColorsClass.green,
                                            fontSize: 15)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.66,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: value.funds.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                          extentRatio: 0.8,
                                          motion: const ScrollMotion(),
                                          children: [
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            SlidableAction(
                                              onPressed: (v) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FundsDetail(model: value.funds[index],)));
                                              },
                                              borderRadius:
                                              BorderRadius.circular(16),
                                              label: "View\nDetails",
                                              backgroundColor: ColorsClass.green,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SlidableAction(
                                              onPressed: (v) {
                                                Navigator.push(context, MaterialPageRoute(builder:(context)=>
                                                    CreateFund(model:value.funds[index] ,)));
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
                                                await value.deleteFund(value.funds[index].fundId);
                                              },
                                              borderRadius:
                                              BorderRadius.circular(16),
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
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.all(10),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          value.funds[index].title,
                                                          style: AppStyles.popins(
                                                              style: const TextStyle(
                                                                  color:
                                                                  Colors.white,
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                        ),
                                                        const Divider(
                                                          color: Color(0xff181818),
                                                          thickness: 1,
                                                        ),
                                                        Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(top: 6.0),
                                                            child: expenseDetails(
                                                                "goal",
                                                                value.funds[index]
                                                                    .goalAmount.toString())),
                                                        expenseDetails("Duration",
                                                            "${value.funds[index].duration} months"),
                                                        expenseDetails(
                                                            "Monthly Deposit",
                                                            value.funds[index]
                                                                .monthlyDeposit
                                                                .toStringAsFixed(
                                                                1)),
                                                      ]),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       left: 15.0, right: 20),
                                              //   child: Container(
                                              //     child: CircularPercentIndicator(
                                              //       radius: 35,
                                              //       backgroundColor: Colors.black,
                                              //       progressColor: ColorsClass.green,
                                              //       percent: 0.61,
                                              //       center: Text(
                                              //         boxes[index].percentage,
                                              //         style: AppStyles.popins(
                                              //             style: const TextStyle(
                                              //                 color: Colors.white,
                                              //                 fontSize: 22,
                                              //                 fontWeight:
                                              //                     FontWeight.w600)),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // )
                                            ],
                                          )),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget expenseDetails(String title, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
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
