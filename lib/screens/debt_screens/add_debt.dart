
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/app_styles.dart';
import '../../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../components/loading_dialogue.dart';
import '../../components/text_field_class.dart';
import '../../functions/categories_data.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({Key? key}) : super(key: key);

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  TextEditingController debtNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController minPaymentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
              "SEBET",
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider(
          create: (context) {
            CategoriesData();
          },
          child: Consumer<CategoriesData>(
              builder: (BuildContext context, value, Widget? child) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.start,
                          "Enter your debt balance,interest rate and\nminimum payment.\nSEBET will arrange your debts and ask you\nwhat you want to add to your smallest debt minimum payment every month.\$25?\$125? what can you find in your budget? Then SEBET will calculate every month for every debt until you are debt FREE!",
                          style: AppStyles.popins(
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ),
                        Container(
                            margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 40),
                            child: TextFieldClass(
                              textFieldController: debtNameController,
                              hintText: "Debt",
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "please enter debt Name";
                                }
                                return null;
                              },
                            )),
                        Container(
                            margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: TextFieldClass(
                              textFieldController: amountController,
                              keyboardType: TextInputType.number,
                              hintText: "Amount",
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "please enter amount";
                                }
                                return null;
                              },
                            )),
                        Container(
                            margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: TextFieldClass(
                              hintText: "Interest Rate",
                              textFieldController: interestRateController,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "please enter interest rate";
                                }
                                return null;
                              },
                            )),
                        Container(
                            margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: TextFieldClass(
                              hintText: "Minimum Payment",
                              textFieldController: minPaymentController,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "please enter min payment";
                                }
                                return null;
                              },
                            )),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 40),
                          child: ButtonClass(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                int amount = int.tryParse(amountController.text)!;
                                int minPayment =
                                int.tryParse(minPaymentController.text)!;
                                if (amount >= minPayment) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => LoadingDialogue(
                                        content: "Adding Debt",
                                        color: ColorsClass.green,
                                      ));
                                  await Future.delayed(const Duration(seconds: 3));
                                  await value.addDebt(
                                      debtName: debtNameController.text,
                                      amount: int.tryParse(amountController.text)!,
                                      interestRate: int.tryParse(
                                          interestRateController.text)!,
                                      minPayment:
                                      int.tryParse(minPaymentController.text)!);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    minPaymentController.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "MinPayment must be less than or equal to debt Amount")));
                                }}
                            },
                            buttonName: "Create",
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
