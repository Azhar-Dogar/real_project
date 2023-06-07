
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../components/app_styles.dart';
import '../../components/color_class.dart';
import '../../functions/categories_data.dart';
import 'add_debt.dart';
import 'debts_details.dart';

class DebtSnowBall extends StatefulWidget {
  const DebtSnowBall({Key? key}) : super(key: key);

  @override
  State<DebtSnowBall> createState() => _DebtSnowBallState();
}

class _DebtSnowBallState extends State<DebtSnowBall> {
  Color textColor = Colors.white;
  Gradient boxColor = ColorsClass.redGradient;
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
              "Debt Snowball",
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
          create: (context){
            CategoriesData();
          },
          child: Consumer<CategoriesData>(
              builder:(BuildContext context,value,Widget? child){
                if(value.debts.isEmpty){
                  textColor = Colors.grey.shade700;
                  boxColor =const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                      colors:[
                        Color(0xff292929),
                        Color(0xff292929)
                      ]);
                }else{
                  textColor = Colors.white;
                  boxColor = ColorsClass.redGradient;
                }
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Enter your debts here.  Add something extra that\nyou want to throw at these debts if you can and\npress the button to begin your debt snowball\nplan!",
                        style: AppStyles.popins(
                            style:
                            const TextStyle(color: Colors.white, fontSize: 13.8)),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    accountDetails(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.142,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.debts.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                accountEntries(
                                    debtName: value.debts[index].debtName,
                                    yourBalance:
                                    value.debts[index].yourBalance.toString(),
                                    interestRate:
                                    value.debts[index].interestRate.toString(),
                                    yourPayment:
                                    value.debts[index].minPayment.toString(),
                                    minPayment: value.debts[index].minPayment.toString()),
                                Divider(
                                  color: Colors.grey.shade700,
                                )
                              ],
                            );
                          }),
                    ),
                    total(value.totalBalance,value.totalMinPayment),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 18),
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
                                Navigator.push(context, MaterialPageRoute(builder:(context) =>AddDebtScreen(),));
                              },
                              child: Text(
                                "Add a Debt",
                                style: AppStyles.popins(
                                    style: TextStyle(
                                        color: ColorsClass.green, fontSize: 15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (value.debts.isEmpty)?Column(
                      children: [
                        Image.asset("assets/images/layer_2.png",width: 200,),
                        Text("No data found",style: AppStyles.popins(style:const TextStyle(color: Colors.white)),)
                      ],
                    ):
                    Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ListView.builder(
                            itemCount: value.debts.length,
                            itemBuilder: (context, index) {
                              value.getCurrentDebtDetails(value.debts[index].debtId,value.debts[index].yourBalance);
                              return singleAccountDetail(
                                  indicatorColor: value.debtColor,
                                  title: value.debts[index].debtName,
                                  initialValue:value.debtPaid.toString(),
                                  percentValue: value.debtPercentValue,
                                  finalValue: value.debts[index].yourBalance.toString(),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DebtDetails(model: value.debts[index],),
                                        ));
                                  });
                            }))
                  ],
                );}
          ),
        ),
      ),
    );
  }

  Widget singleAccountDetail(

      {required String title,
        required Color indicatorColor,
        required String initialValue,
        required String finalValue,
        required  double percentValue,
        void Function()? onTap}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: InkWell(
            onTap: onTap,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    style: AppStyles.popins(
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        flex:1,
                        child: Text(
                          textAlign: TextAlign.start,
                          initialValue,
                          style: AppStyles.popins(
                              style: TextStyle(color: Colors.grey.shade700)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: LinearPercentIndicator(
                          barRadius: const Radius.circular(12),
                          padding: const EdgeInsets.all(3),
                          width: 90,
                          lineHeight: 15,
                          progressColor:indicatorColor,
                          percent: percentValue,
                          backgroundColor: ColorsClass.textFieldBackground,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          textAlign: TextAlign.start,
                          finalValue,
                          style: AppStyles.popins(
                              style: TextStyle(color: Colors.grey.shade700)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 40,
                )
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey.shade700,
        )
      ],
    );
  }

  Widget accountEntriesTitle(String name) {
    return Expanded(
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: AppStyles.popins(
            style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget totalValues(String value) {
    return Expanded(
      child: Text(
        textAlign: TextAlign.center,
        value,
        style: AppStyles.popins(
            style:TextStyle(
                color:textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget total(int totalBalance,int totalMinPayment ) {
    return Container(
      margin: const EdgeInsets.only(left: 7, right: 7),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient:boxColor,
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            totalValues("Total"),
            totalValues("\$$totalBalance"),
            totalValues("value"),
            totalValues("\$$totalMinPayment"),
            totalValues("\$$totalMinPayment")
          ],
        ),
      ),
    );
  }

  Widget accountDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          accountEntriesTitle("Debt\nName"),
          accountEntriesTitle("Your\nBalance"),
          accountEntriesTitle("Interest\nrate"),
          accountEntriesTitle("Minimum\nPayment"),
          accountEntriesTitle("Your\nPayment")
        ],
      ),
    );
  }

  Widget accountEntries(
      {required String debtName,
        required String yourBalance,
        required String interestRate,
        required String minPayment,
        required String yourPayment}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        accountEntriesValue(debtName),
        accountEntriesValue(yourBalance),
        accountEntriesValue(interestRate),
        accountEntriesValue(minPayment),
        accountEntriesValue(yourPayment)
      ],
    );
  }

  Widget accountEntriesValue(String value) {
    return Expanded(
      child: Text(
        textAlign: TextAlign.center,
        value,
        style: AppStyles.popins(
            style: TextStyle(color: ColorsClass.grey, fontSize: 12)),
      ),
    );
  }
}
