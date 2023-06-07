
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/app_styles.dart';
import '../components/color_class.dart';
import '../functions/categories_data.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
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
              "Transactions",
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) {
          CategoriesData();
        },
        child: Consumer<CategoriesData>(
            builder: (BuildContext context, value, Widget? child) {
              return Container(
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: value.totalTransactions.length,
                          itemBuilder: (context, index) {
                            var date = DateTime.fromMillisecondsSinceEpoch(
                                value.totalTransactions[index].date!);
                            String formattedDate =
                                "${date.day}-${date.month}-${date.year}";
                            String? transactName =
                                value.totalTransactions[index].fundName;
                            String? transactSubName = "fund";
                            if (transactName == null) {
                              transactName =
                                  value.totalTransactions[index].categoryTitle;
                              transactSubName =
                                  value.totalTransactions[index].subCatTitle;
                              if (transactName == null) {
                                transactName =
                                    value.totalTransactions[index].debtName;
                                transactSubName = "debt";
                              }
                            }
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Amount",
                                            style: AppStyles.popins(
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            "\$${value.totalTransactions[index].price}",
                                            style: AppStyles.popins(
                                                style: TextStyle(
                                                    color: ColorsClass.grey)),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Date",
                                            style: AppStyles.popins(
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
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
                                            transactName!,
                                            style: AppStyles.popins(
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            transactSubName!,
                                            style: AppStyles.popins(
                                                style: TextStyle(
                                                    color: ColorsClass.grey)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade700,
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
