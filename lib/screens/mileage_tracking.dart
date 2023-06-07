
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/app_styles.dart';
import '../components/color_class.dart';
import '../functions/categories_data.dart';

class MileageTracking extends StatefulWidget {
  const MileageTracking({Key? key}) : super(key: key);

  @override
  State<MileageTracking> createState() => _MileageTrackingState();
}

class _MileageTrackingState extends State<MileageTracking> {
  Position? currentPosition;
  bool start = false;
  String? currentMonth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    currentMonth =  DateFormat("MMMM").format(now);
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
              "Mileage Tracking",
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: Container(
        child: ChangeNotifierProvider(
          create: (context){CategoriesData();},
          child: Consumer<CategoriesData>(
              builder: (BuildContext context,value,Widget? child){
                print(value.totalMileage.length);
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                      child: Text(
                        currentMonth!,
                        style: AppStyles.popins(
                            style: TextStyle(
                                color: ColorsClass.textRed,
                                fontSize: 30,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            mileageDetails("Total\nMileage", value.totalDistance),
                            VerticalDivider(
                              color: Colors.grey.shade700,
                            ),
                            mileageDetails("Today's\nMileage",value.todayDistance),
                            VerticalDivider(
                              color: Colors.grey.shade700,
                            ),
                            mileageDetails("Last\nMileage", 200),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Start your mileage tracking ",
                              style:
                              AppStyles.popins(style:const TextStyle(color: Colors.white,fontSize: 16)),
                            ),

                            Container(
                                child:(start==false)? GestureDetector(
                                    onTap: ()async{
                                      setState(() {
                                        start = true;
                                      });
                                      value.startTime = DateTime.now();
                                      await Geolocator.checkPermission();
                                      await Geolocator.requestPermission();
                                      value.startPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                    },
                                    child: Image.asset("assets/images/start.png",width: 100,)):
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      start= false;
                                    });
                                    await value.findDistance();
                                    await value.addDistanceCovered(value.startTime!.millisecondsSinceEpoch,DateTime.now().millisecondsSinceEpoch);
                                  },
                                  child: Image.asset("assets/images/stop.png",width: 100,),))
                          ],
                        ),
                        Divider(color: Colors.grey.shade700,)
                      ],
                    ),
                    mileageEntries(value),
                    const Divider(
                      color: Colors.grey,
                    )
                  ],
                );}
          ),
        ),
      ),
    );
  }
  Widget mileageEntries(value){
    return Expanded(
      child: ListView.builder(
          itemCount: value.totalMileage.length,
          itemBuilder: (context,index) {
            var startTime = DateTime.fromMillisecondsSinceEpoch(value.totalMileage[index].startTime);
            String formStartTime = DateFormat.jm().format(startTime);
            String formattedDate = "${startTime.day}-${startTime.month}-${startTime.year}";
            var endTime = DateTime.fromMillisecondsSinceEpoch(value.totalMileage[index].endTime);
            String formEndTime = DateFormat.jm().format(endTime);
            return Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        value.totalMileage[index].distance.toStringAsFixed(3),
                        style: AppStyles.popins(
                            style: TextStyle(
                                color: ColorsClass.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Start Time",
                        style: AppStyles.popins(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                      ),
                      Text(
                        formStartTime,
                        style: AppStyles.popins(
                            style:
                            TextStyle(color: ColorsClass.grey)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "End Time",
                        style: AppStyles.popins(
                            style: const TextStyle(
                                color: Colors.white)),
                      ),
                      Text(
                        formEndTime,
                        style: AppStyles.popins(
                            style:
                            TextStyle(color: ColorsClass.grey)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Date",
                        style: AppStyles.popins(
                            style: const TextStyle(
                                color: Colors.white)),
                      ),
                      Text(
                        formattedDate,
                        style: AppStyles.popins(
                            style:
                            TextStyle(color: ColorsClass.grey)),
                      )
                    ],
                  )
                ],
              ),
            );
          }
      ),
    );
  }
  Widget mileageDetails(String mileageName, double value) {
    return Column(
      children: [
        Text(
          mileageName,
          textAlign: TextAlign.center,
          style: AppStyles.popins(
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            value.toStringAsFixed(1),
            style: AppStyles.popins(
                style: TextStyle(
                    color: ColorsClass.green, fontWeight: FontWeight.w600)),
          ),
        )
      ],
    );
  }
}
