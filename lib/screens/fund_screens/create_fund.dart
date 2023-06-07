import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../../components/app_styles.dart';
import '../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../components/loading_dialogue.dart';
import '../../components/text_field_class.dart';
import '../../functions/categories_data.dart';
import '../../models/sinking_fund_model.dart';

class CreateFund extends StatefulWidget {
  SinkingModel? model;
  CreateFund({Key? key,this.model}) : super(key: key);

  @override
  State<CreateFund> createState() => _CreateFundState();
}

class _CreateFundState extends State<CreateFund> {
  TextEditingController fundNameController = TextEditingController();
  TextEditingController fundAmountController = TextEditingController();
  DateTime date = DateTime.now();
  DateTime? newDate;
  String? formattedDate;
  num? duration;
  double depositPerMonth = 0;
  String title = "Create Fund ";
  String buttonName = "Create";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.model!=null){
      setState(() {
        title = "Edit Fund";
        buttonName = "Update";
        fundNameController.text=widget.model!.title;
        fundAmountController.text= widget.model!.goalAmount.toString();
        var dueDate = DateTime.fromMillisecondsSinceEpoch(widget.model!.dueDate);
        formattedDate = DateFormat('dd-MM-yyyy')
            .format(dueDate);
        duration = int.parse(widget.model!.duration);
        depositPerMonth = widget.model!.monthlyDeposit;
        newDate =DateTime.fromMillisecondsSinceEpoch(widget.model!.dueDate);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          title,
          style: AppStyles.popins(
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: ChangeNotifierProvider(
          create:(BuildContext context) {
            CategoriesData();

          },
          child: Consumer<CategoriesData>(
              builder: (BuildContext context, value, Widget? child) {

                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        "This is for your long term spending goals, like vacation, or car repairs. Not monthly expenses, but expenses that you know are coming! Enter an amount for your goal, and when you need to be that goal, then SEBET will let you know how much you need to budget each month to reach it!",
                        style: AppStyles.popins(
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w300)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10, left: 10, right: 10),
                        child: TextFieldClass(
                          textFieldController: fundNameController,
                          hintText: "Fund Name",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: TextFieldClass(
                          onChanged:(v){
                            setState(() {
                              if(widget.model!=null){
                                depositPerMonth = int.tryParse(v)!/duration!;
                              }else{
                                depositPerMonth=int.tryParse(v)!/1;
                              }
                            });
                          },
                          textFieldController: fundAmountController,
                          keyboardType: TextInputType.number,
                          hintText: "Amount of goal",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                        child: Text(
                          "Select a date when you need this fund",
                          style: AppStyles.popins(
                              style:
                              const TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12, top: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  (formattedDate == null) ? "Due date" : formattedDate!,
                                  style: AppStyles.popins(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 16))),
                              IconButton(
                                  onPressed: () async {
                                    if (fundNameController.text.isEmpty ||
                                        fundAmountController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "please enter fund info properly")));
                                    } else {
                                      newDate = await showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100));
                                      if (newDate != null) {
                                        duration = Jiffy(newDate)
                                            .diff(DateTime.now(), Units.MONTH);
                                        if (duration != 0) {
                                          setState(() {
                                            formattedDate = DateFormat('dd-MM-yyyy')
                                                .format(newDate!);
                                            depositPerMonth = (int.tryParse(
                                                fundAmountController.text)! /
                                                duration!);
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Duration must be greater than or equal to 1 month")));
                                          setState(() {
                                            depositPerMonth = 0;
                                          });
                                        }
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.calendar_month,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Months to achieve this goal",
                        style: AppStyles.popins(
                            style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: DottedBorder(
                            dashPattern: const [10, 10, 10, 10],
                            strokeWidth: 4,
                            radius: const Radius.circular(16),
                            borderType: BorderType.RRect,
                            color: ColorsClass.textFieldBackground,
                            child: Center(
                              child: Text(
                                (duration == null) ? "0" : duration.toString(),
                                style: AppStyles.popins(
                                    style: TextStyle(
                                        color: ColorsClass.textRed, fontSize: 32)),
                              ),
                            )),
                      ),
                      Text(
                        "Deposit per month to achieve the goal",
                        style: AppStyles.popins(
                            style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: DottedBorder(
                            dashPattern: const [10, 10, 10, 10],
                            strokeWidth: 4,
                            radius: const Radius.circular(16),
                            borderType: BorderType.RRect,
                            color: ColorsClass.textFieldBackground,
                            child: Center(
                              child: Text(
                                "\$${depositPerMonth.toStringAsFixed(1)}",
                                style: AppStyles.popins(
                                    style: TextStyle(
                                        color: ColorsClass.textRed, fontSize: 32)),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ButtonClass(
                          onPressed: () async{
                            if(widget.model!=null){
                              await value.updateFund(fundName: fundNameController.text, fundAmount: int.tryParse(fundAmountController.text)!,
                                  startDate:widget.model!.startDate, dueDate:newDate!, duration: duration.toString(),
                                  fundId:widget.model!.fundId, paid:0, monthlyDeposit:depositPerMonth);
                              Navigator.pop(context);
                            }
                            else if (fundNameController.text.isEmpty ||
                                fundAmountController.text.isEmpty ||
                                newDate == null) {
                              return ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text("Please Enter Info Properly")));
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (context) => LoadingDialogue(
                                    content: "Adding Fund",
                                    color: ColorsClass.green,
                                  ));
                              await Future.delayed(const Duration(seconds: 3));
                              value.createFund(fundName: fundNameController.text,
                                  fundAmount: int.tryParse(fundAmountController.text.trim())!, startDate:date ,
                                  dueDate:newDate!, duration: duration.toString(), monthlyDeposit:depositPerMonth,
                                  paid: 0);
                              Navigator.pop(context);
                            }
                            Navigator.pop(context);
                          },
                          buttonName: buttonName,
                        ),
                      )
                    ],
                  ),
                );}
          ),
        ),
      ),
    );
  }
}
