import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:real_project/screens/profile_screen.dart';
import 'package:real_project/screens/report_screen.dart';
import 'package:real_project/screens/schedule_screen.dart';
import 'package:real_project/screens/transaction.dart';
import 'auth_screens/login_screen.dart';
import 'budget_screen.dart';
import '../components/app_styles.dart';
import '../components/color_class.dart';
import '../components/drop_down_button.dart';
import '../components/loading_dialogue.dart';
import 'debt_screens/debt_snowball.dart';
import '../functions/categories_data.dart';
import 'fund_screens/sinking_fund.dart';
import 'mileage_tracking.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var dropDownValue;
  int expectedIncome = 0 ;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context){
        CategoriesData();
      },
      child: Consumer<CategoriesData>(
          builder: (BuildContext context,value,Widget? child,){
            if(value.model!=null){
              expectedIncome = value.model!.amount ;}
            return Scaffold(
                drawer: Drawer(
                  backgroundColor: Colors.black,
                  child: drawer(value),
                ),
                appBar: AppBar(
                  centerTitle: true,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Builder(
                      builder: (context) => InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Image.asset(
                            "assets/images/Combined-Shape.png",
                            color: ColorsClass.green,
                            width: 40,
                          )),
                    ),
                  ),
                  backgroundColor: ColorsClass.backGroundColor,
                ),
                backgroundColor: ColorsClass.backGroundColor,
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: ColorsClass.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 15, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 195,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        const MonthlyBudgetScreen()));
                                              },
                                              child: firstBox()),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          secondBox(),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          thirdBox()
                                        ]),
                                  )
                                ],
                              ),
                            ),
                            chartBox(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>Transaction()));
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 12, right: 12, top: 16),
                                child: bottomBox(ColorsClass.green, ColorsClass.green1,
                                    "TRANSACTIONS", IconlyBold.swap),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 12, right: 12, top: 16),
                              child: bottomBox(ColorsClass.textRed, ColorsClass.red1,
                                  "Reports", IconlyBold.paper),
                            ),
                          ]),
                    ),
                  ),
                ));}
      ),
    );
  }

  Widget firstBox() {
    return Container(
      // height: 190,
      width: MediaQuery.of(context).size.width * 0.91,
      decoration: BoxDecoration(
          gradient: ColorsClass.redGradient,
          borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "JAN\n2022",
                      style: AppStyles.popins(
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        textAlign: TextAlign.end,
                        "MONTHLY\nBUDGET",
                        style: AppStyles.popins(
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white))),
                    Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 160,
                        child:
                        Divider(thickness: 1, color: ColorsClass.textWhite),
                      ),
                      Positioned(
                          top: 10,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: ColorsClass.textWhite,
                          )),
                      Positioned(
                          top: 12,
                          left: 15,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: ColorsClass.textWhite,
                          ))
                    ])
                  ],
                ),
              ],
            ),
          ),
          Text(
            "EXPECTED BUDGET FOR THIS MONTH IS",
            style: AppStyles.popins(
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400)),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "\$$expectedIncome",
            style: TextStyle(
                color: ColorsClass.textWhite,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget secondBox() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.91,
      decoration: BoxDecoration(
          gradient: ColorsClass.buttonGradient,
          borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //SizedBox(width: 10,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: Text(
                        textAlign: TextAlign.start,
                        "DEBT\nSNOWBALL",
                        style: AppStyles.popins(
                          style: TextStyle(
                              fontSize: 24,
                              color: ColorsClass.textWhite,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 10),
                        width: 160,
                        child:
                        Divider(thickness: 1, color: ColorsClass.textWhite),
                      ),
                      Positioned(
                          top: 10,
                          right: 0,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: ColorsClass.textWhite,
                          )),
                      Positioned(
                          top: 12,
                          right: 15,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: ColorsClass.textWhite,
                          ))
                    ]),
                  ],
                ),
                Text("2/10\nPAID",
                    style: AppStyles.popins(
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700),
                    )),
              ],
            ),
          ),
          Text(
            "40%",
            style: AppStyles.popins(
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ),
          LinearPercentIndicator(
            animation: true,
            width: MediaQuery.of(context).size.width * 0.9,
            restartAnimation: true,
            progressColor: Colors.white,
            lineHeight: 10,
            barRadius: const Radius.circular(10),
            backgroundColor: Colors.black,
            percent: 0.5,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            textAlign: TextAlign.center,
            "40% OF YOUR DEBTS HAVE BEEN CLEARED",
            style: AppStyles.popins(
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          )
        ],
      ),
    );
  }

  Widget thirdBox() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.91,
      decoration: BoxDecoration(
          gradient: ColorsClass.redGradient,
          borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                bottom: 78.0,
              ),
              child: Text(
                "61\n%",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 78.0, right: 20),
              child: CircularPercentIndicator(
                center: Image.asset(
                  "assets/images/logo_2.png",
                  width: 40,
                ),
                radius: 40,
                backgroundColor: Colors.black,
                progressColor: Colors.white,
                percent: 0.61,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "SINKING",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Fund",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 150,
                      child: const Divider(thickness: 1, color: Colors.white),
                    ),
                    const Positioned(
                        top: 10,
                        right: 0,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.white,
                        )),
                    const Positioned(
                        top: 12,
                        right: 15,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.white,
                        ))
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomBox(Color color1, Color color2, String text, IconData icon) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2])),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 5),
                  //  width: MediaQuery.of(context).size.width * 0.15,
                  //  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.bottomLeft,
                          colors: [color1, color2])),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      icon,
                      size: 40,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(text,
                    style: AppStyles.popins(
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
              )
            ],
          ),
        ));
  }

  Widget drawer(modelValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(1),
            leading: Container(
              // width: 20,
              //height:20,
              width: MediaQuery.of(context).size.width * 0.14,
              height: MediaQuery.of(context).size.height * 0.064,
              decoration: BoxDecoration(
                  gradient: ColorsClass.redGradient,
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  "assets/images/logo_3.png",
                  width: 5,
                  height: 5,
                ),
              ),
            ),
            title: const Text(
              "Hello!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w200),
            ),
            subtitle:Text(
              (modelValue.userModel!=null)?modelValue.userModel!.firstName:"",
              style:const TextStyle(color: Colors.white, fontSize: 20),
            ),
            trailing: TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));
              },
              child: Text(
                "View Profile",
                style: TextStyle(
                  color: ColorsClass.green,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade900,
            thickness: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                listTile("Dashboard", "assets/images/Category.png", 35),
                Divider(color: Colors.grey.shade900, thickness: 1),
                listTile("Sinking Funds", "assets/images/Chart.png", 40,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SinkingFunds(),
                        ))),
                listTile("Debt Snowball", "assets/images/Group_148.png", 40,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DebtSnowBall(),
                          ));
                    }),
                Divider(color: Colors.grey.shade900, thickness: 1),
                listTile("Mileage Tracking", "assets/images/Swap.png", 40,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MileageTracking()));
                    }),
                listTile("Weekly schedule", "assets/images/Calendar.png", 40,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScheduleScreen(),
                          ));
                    }),
                listTile(
                  "Reports",
                  "assets/images/Paper.png",
                  40,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportsScreen(),
                      )),
                ),
                Divider(color: Colors.grey.shade900, thickness: 1),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 30, bottom: 30),
                  child: DottedBorder(
                      radius: const Radius.circular(16),
                      dashPattern: const [10, 10, 10, 10],
                      borderType: BorderType.RRect,
                      strokeWidth: 2,
                      color: Colors.grey.shade900,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 33,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height:
                              MediaQuery.of(context).size.height * 0.056,
                              decoration: BoxDecoration(
                                  gradient: ColorsClass.buttonGradient,
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Icon(
                                Icons.add,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 23,
                            ),
                            Text(
                              "Upload CSV File",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Text(
                              "of your bank transaction",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      )),
                ),
                Divider(
                  color: Colors.grey.shade900,
                  thickness: 1,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => LoadingDialogue(content: "Signing Out",));
                            await Future.delayed(const Duration(seconds: 3));
                            await FirebaseAuth.instance.signOut().then((value){
                              print(FirebaseAuth.instance.currentUser?.uid);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),(route)=>false);
                            });
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                                color: ColorsClass.textRed, fontSize: 16),
                          )),
                      Image.asset(
                        "assets/images/Logout.png",
                        width: 30,
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget listTile(String name, String imageAddress, double imageWidth,
      {Function()? onTap}) {
    return ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.only(left: 8),
        leading: Image.asset(imageAddress, width: 30),
        title: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            name,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ));
  }

  Widget chartBox() {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(41, 41, 41, 1),
          borderRadius: BorderRadius.circular(20)),
      child: Stack(children: [
        LineChart(LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            lineBarsData: [
              LineChartBarData(
                  gradient: LinearGradient(
                      colors: [Colors.green.shade300, Colors.green.shade300]),
                  dotData: FlDotData(show: false),
                  isCurved: true,
                  spots: const [
                    FlSpot(0, 0.5),
                    FlSpot(2, 2),
                    FlSpot(3, 2.1),
                    FlSpot(4, 2.5),
                    FlSpot(5, 2.2),
                    FlSpot(6, 2),
                    FlSpot(8, 2.7),
                    FlSpot(9, 3.5),
                    FlSpot(9.5, 3),
                    FlSpot(10.4, 3),
                  ]),
              LineChartBarData(
                  gradient:
                  const LinearGradient(colors: [Colors.red, Colors.red]),
                  dotData: FlDotData(show: false),
                  isCurved: true,
                  spots: const [
                    FlSpot(0, 0.5),
                    FlSpot(1.8, 2.5),
                    FlSpot(2.7, 3),
                    FlSpot(4, 2.6),
                    FlSpot(5, 4.2),
                    FlSpot(6, 3),
                    FlSpot(7, 2),
                    FlSpot(8, 3.5),
                    FlSpot(9, 2.5),
                    FlSpot(10.5, 2.8)
                  ]),
              LineChartBarData(
                  dotData: FlDotData(
                    show: false,
                  ),
                  gradient:
                  const LinearGradient(colors: [Colors.grey, Colors.grey]),
                  isCurved: true,
                  spots: const [
                    FlSpot(0, 0.5),
                    FlSpot(1.6, 1.8),
                    FlSpot(2.6, 2),
                    FlSpot(4, 1.5),
                    FlSpot(5, 3),
                    FlSpot(6, 2.7),
                    FlSpot(7, 3.4),
                    FlSpot(9, 3.5),
                    FlSpot(10, 3.7)
                  ])
            ])),
        Positioned(
          bottom: 12,
          left: 80,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                "Income",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: const Color(0xff32ED9E),
                    borderRadius: BorderRadius.circular(5)),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                "Savings",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(237, 50, 55, 1),
                    borderRadius: BorderRadius.circular(5)),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                "Expense",
                style: TextStyle(color: Colors.white, fontSize: 12),
              )
            ],
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Container(
              height: 35,
              width: 93,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: DropDownClass(
                dropDownValue: dropDownValue,
                onChanged: (val) {
                  setState(() {
                    dropDownValue = val;
                  });
                },
                dropDownValueColor: Colors.black,
                dropDownItems: const ["2022", "2021", "2020"],
                hintText: "2022",
                iconColor: Colors.black,
                hintTextColor: Colors.black,
              )),
        ),
      ]),
    );
  }
}
