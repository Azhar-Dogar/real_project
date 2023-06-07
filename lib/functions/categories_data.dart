import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import '../screens/auth_screens/login_screen.dart';
import '../components/color_class.dart';
import '../models/debt_account_model.dart';
import '../models/expected_income-model.dart';
import '../models/expense_details_model.dart';
import '../models/expense_model.dart';
import '../models/mileage_model.dart';
import '../models/public_category_model.dart';
import '../models/sinking_fund_model.dart';
import '../models/subcat_model.dart';
import '../models/subcatprice_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class CategoriesData with ChangeNotifier {
  CategoriesData() {
    userStream();
  }

  final users = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final _categories = FirebaseFirestore.instance.collection("categories");
  List<MileageModel> totalMileage = [];
  var catDoc;
  var transactId;
  int totalBalance = 0;
  int totalMinPayment = 0;
  Color debtColor = ColorsClass.textRed;
  String currentMonth =
  DateFormat.MMMM().format(DateTime.now()).substring(0, 3);
  List<PublicCategoryModel> dropDownAllCategories = [];
  List<ExpenseModel> expenses = [];
  List<DebtAccountModel> debts = [];
  List<ExpenseDetailsModel> expenseDetails = [];
  List<TransactionModel> editAbleTransactions = [];
  List<TransactionModel> doubleTransactions = [];
  List<TransactionModel> doubleExpensePrice = [];
  List<TransactionModel> doubleExpenses = [];
  List<TransactionModel> totalTransactions = [];
  List<PublicCategoryModel> allCategories = [];
  List<PublicCategoryModel> allCustCategories = [];
  List<SubCategoryModel> allSubCategories = [];
  List<SubCategoryModel> editAbleSubCategories = [];
  List<SubCatPriceModel> addEditAbleCustSubCat = [];
  List<String> dropDownListItems = [];
  ExpectedIncomeModel? model;
  List<ExpectedIncomeModel> incomesList = [];
  List<SinkingModel> funds = [];
  List<TransactionModel> currentFundTransactions = [];
  List<TransactionModel> currentDebtTransactions = [];
  Position? startPosition;
  DateTime? startTime;
  Position? endPosition;
  double todayDistance = 0.0;
  double totalDistance = 0.0;
  int totalExpense = 0;
  int fundPaid = 0;
  int price = 0;
  int debtPaid = 0;
  int subCatPrice = 0;
  double percentage = 0.0;
  int remainingAmount = 0;
  double percentValue = 0.0;
  double debtPercentValue = 0.0;
  double distance = 0.0;
  List<num> differences = [];
  UserModel? userModel;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? transactionStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? custCategoriesStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subCatStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? expectedIncomeStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? fundsStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? mileageStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? debtsStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? currentUserStream;
  getConnectivity(context){
subscription = Connectivity().onConnectivityChanged.listen((event) {
  (ConnectivityResult result) async {
isDeviceConnected = await InternetConnectionChecker().hasConnection;
if(isDeviceConnected && isAlertSet == false){
  showDialog(
      context: context,
      builder: (context) =>const AlertDialog(
        title: Text("No Connection"),
        content: Text("Your Phone Has No Internet Connection"),
      ));
}
  };
});
  }
  userStream()async {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        getCurrentUser();
        getCategories();
        getCustCategories();
        getSubCategories();
        fetchTransactions();
        getExpectedIncome();
        getFunds();
        getMileage();
        getDebts();
      } else {
        cancelSubscriptions();
      }
    });
    notifyListeners();
  }

  findDistance() async {
    endPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    distance = Geolocator.distanceBetween(
        startPosition!.latitude,
        startPosition!.longitude,
        endPosition!.latitude,
        endPosition!.longitude);
    notifyListeners();
  }

  getCurrentUser() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      //userModel = null;
      userModel = UserModel.fromJson(event.data()!);
    });
  }

  addDistanceCovered(int startTime, int endTime) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("mileage")
        .add(
        {"distance": distance, "startTime": startTime, "endTime": endTime});
    notifyListeners();
  }

  getMileage() {
    mileageStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("mileage")
        .snapshots()
        .listen((event) {
      totalMileage = [];
      totalDistance = 0.0;
      todayDistance = 0.0;
      differences = [];
      for (var element in event.docs) {
        totalMileage.add(MileageModel.fromJson(element.data()));
      }
      var date = DateTime.now();
      for (var element in totalMileage) {
        var elementDate =
        DateTime.fromMillisecondsSinceEpoch(element.startTime);
        num duration = Jiffy(DateTime.now()).diff(elementDate, Units.MINUTE);
        differences.add(duration);
        totalDistance = totalDistance + element.distance;
        if (date.day == elementDate.day) {
          todayDistance = totalDistance + element.distance;
        }
      }
    });
  }

  addExpectedIncome(int amount) async {
    var incomeDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("expectedIncome")
        .doc();
    DateTime now = DateTime.now();
    await incomeDoc.set({
      "Amount": amount,
      "date": now.millisecondsSinceEpoch,
      "incomeId": incomeDoc.id
    });
  }

  updateIncome(int amount, String incomeId) async {
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("expectedIncome")
        .doc(incomeId)
        .update({
      "Amount": amount,
      "date": now.millisecondsSinceEpoch,
      "incomeId": incomeId
    });
  }

  getExpectedIncome({String? currentMonth}) {
    incomesList = [];
    model?.amount = 0;
    percentage = 0;
    percentValue = 0.0;
    remainingAmount = 0;
    model == null;
    currentMonth ??= DateFormat.MMMM().format(DateTime.now()).substring(0, 3);
    expectedIncomeStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("expectedIncome")
        .snapshots()
        .listen((event) {
      for (var document in event.docs) {
        incomesList.add(ExpectedIncomeModel.fromJson(document.data()));
      }
      for (var element in incomesList) {
        var date = DateTime.fromMillisecondsSinceEpoch(element.date);
        String month = DateFormat.MMMM().format(date).substring(0, 3);
        if (month == currentMonth) {
          model = element;
          remainingAmount = model!.amount;
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
    });
    notifyListeners();
  }

  getCategories() async {
    allCategories = [];

    _categories.snapshots().listen((event) {
      for (var element in event.docs) {
        allCategories.add(PublicCategoryModel.fromJson(element.data()));
        notifyListeners();
      }
    });
  }

  fetchTransactions() async {
    totalTransactions = [];
    var user = FirebaseFirestore.instance.collection("transactions");
    transactionStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("transactions")
        .snapshots()
        .listen((event) {
      List<TransactionModel> list = [];
      for (var element in event.docs) {
        list.add(TransactionModel.fromJson(element.data()));
      }
      totalTransactions = list;
    });
  }

  getCustCategories() async {
    custCategoriesStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("categories")
        .snapshots()
        .listen((event) {
      allCustCategories = [];
      dropDownListItems = [];
      for (var element in event.docs) {
        allCustCategories
            .add(PublicCategoryModel.fromJson(element.data())..id = element.id);
      }
      notifyListeners();
      dropDownAllCategories = allCategories + allCustCategories;
    });
    notifyListeners();
  }

  addCustCategories(
      TextEditingController categoryController, colorValue) async {
    catDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("categories")
        .doc();

    await catDoc.set({
      "name": categoryController.text,
      "color": colorValue,
      "id": catDoc.id
    });
    notifyListeners();
  }

  addSubCategories(String subCatTitle, String categoryId) async {
    var subCatDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("subCategories")
        .doc();
    await subCatDoc.set({
      "Category Id": categoryId,
      "Sub title": subCatTitle,
      "subCatId": subCatDoc.id
    });
    notifyListeners();
  }

  deleteCustCategories(String docId) async {
    await deleteSubCategories(docId);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("categories")
        .doc(docId)
        .delete();

    notifyListeners();
  }

  deleteSubCategories(String categoryId) async {
    for (var element in allSubCategories){
      if (element.categoryId == categoryId) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("subCategories")
            .doc(element.subCatId)
            .delete();
      }
    }
  }

  getSubCategories() async {
    allSubCategories = [];
    subCatStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("subCategories")
        .snapshots()
        .listen(
          (event) {
        allSubCategories = [];
        for (var element in event.docs) {
          allSubCategories.add(SubCategoryModel.fromJson(element.data()));
        }
      },
    );
  }

  List<ExpenseModel> getExpenseList({String? currentMonth}) {
    expenses = [];
    currentMonth ??= DateFormat.MMMM().format(DateTime.now()).substring(0, 3);
    for (var element in totalTransactions) {
      var date = DateTime.fromMillisecondsSinceEpoch(element.date!);
      String month = DateFormat.MMMM().format(date).substring(0, 3);
      if (month == currentMonth) {
        bool check = checkCategory(element.categoryId, expenses);
        if (check == false && element.categoryId != null) {
          expenses.add(ExpenseModel(
              id: element.categoryId, categoryTitle: element.categoryTitle));
        }
      }
    }
    totalTransactions.forEach((element) {
      var date = DateTime.fromMillisecondsSinceEpoch(element.date!);
      String month = DateFormat.MMMM().format(date).substring(0, 3);
      for (var value in expenses) {
        if (value.id == element.categoryId && month == currentMonth) {
          value.addTransaction(element);
        }
      }
    });
    return expenses;
  }

  bool checkCategory(String? id, List<ExpenseModel> list) {
    bool check = false;
    for (var element in list) {
      if (element.id == id) {
        check = true;
      }
    }
    return check;
  }

  getDoubleTransactions() {
    for (var value in expenses) {
      doubleExpenses = [];
      doubleExpensePrice = [];
      for (var element in value.transactions) {
        doubleExpensePrice = [];
        subCatPrice = element.price!;
        bool doubleTransCheck = checkTransaction(
          element,
          doubleExpenses,
        );
        if (doubleTransCheck == false) {
          doubleExpenses.add(TransactionModel(
              categoryId: element.categoryId,
              categoryTitle: element.categoryTitle,
              subCatId: element.subCatId,
              subCatTitle: element.subCatTitle,
              color: element.color,
              price: element.price,
              date: element.date,
              transactId: element.transactId));
        } else {
          doubleExpensePrice.add(TransactionModel(
              categoryId: element.categoryId,
              categoryTitle: element.categoryTitle,
              subCatId: element.subCatId,
              subCatTitle: element.subCatTitle,
              color: element.color,
              transactId: element.transactId,
              price: subCatPrice,
              date: element.date));
        }
      }
      for (var element in doubleExpenses) {
        for (var doublePrice in doubleExpensePrice) {
          if (element.subCatId == doublePrice.subCatId) {
            element.price = (element.price! + doublePrice.price!);
          }
        }
        value.doubleTransactions.add(element);
      }
    }
  }

  bool checkTransaction(
      TransactionModel model,
      List<TransactionModel> list,
      ) {
    bool transCheck = false;
    list.forEach((element) {
      if (element.subCatId == model.subCatId) {
        transCheck = true;
      }
    });
    return transCheck;
  }

  findEditAbleSubCategories(String categoryId) async {
    editAbleSubCategories = [];
    for (var element in allSubCategories) {
      if (element.categoryId == categoryId) {
        editAbleSubCategories.add(element);
      }
    }
    notifyListeners();
  }

  editCategory(TextEditingController categoryController, colorValue,
      List newSubCat, String categoryId) async {
    editAbleSubCategories = [];
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("categories")
        .doc(categoryId)
        .update({"Title": categoryController.text, "Color": colorValue});
    for (var element in newSubCat) {
      addSubCategories(element, categoryId);
    }
  }

  getTransaction() async {
    transactionStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("transactions")
        .snapshots()
        .listen((event) {
      totalTransactions = [];
      for (var element in event.docs) {
        totalTransactions.add(TransactionModel.fromJson(element.data()));
      }
      notifyListeners();
    });
  }

  getTotalExpense({String? currentMonth}) {
    totalExpense = 0;
    percentage = 0;
    expenseDetails = [];
    for (var element in expenses) {
      int price = 0;
      int? expenseColor = 0;
      for (var element1 in element.transactions) {
        price = price + element1.price!;
        expenseColor = element1.color;
      }
      expenseDetails.add(ExpenseDetailsModel(
          id: element.id,
          color: expenseColor,
          totalPrice: price,
          expenseTitle: element.categoryTitle));
      totalExpense = totalExpense + price;
      remainingAmount = model!.amount;
      if (totalExpense != 0) {
        percentage = totalExpense * 100 / model!.amount;
        percentValue = percentage / 100;
        remainingAmount = model!.amount - totalExpense;
      }
    }
  }

  addTransaction(
      {String? categoryId,
        String? catTitle,
        String? subCatId,
        int? categoryColor,
        String? subCatTitle,
        int? price}) async {
    DateTime now = DateTime.now();
    if (subCatId!.isNotEmpty) {
      transactId = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("transactions")
          .doc();
      await transactId.set({
        "categoryId": categoryId,
        "categoryTitle": catTitle,
        "subCatId": subCatId,
        "subCatTitle": subCatTitle,
        "price": price,
        "categoryColor": categoryColor,
        "transactId": transactId.id,
        "date": now.millisecondsSinceEpoch
      });
      notifyListeners();
    } else {
      var newSubCatDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("subCategories")
          .doc();
      transactId = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("transactions")
          .doc();
      await newSubCatDoc.set({
        "Category Id": categoryId,
        "Sub title": subCatTitle,
        "subCatId": newSubCatDoc.id
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("transactions")
          .add({
        "categoryId": categoryId,
        "categoryTitle": catTitle,
        "subCatId": newSubCatDoc.id,
        "subCatTitle": subCatTitle,
        "price": price,
        "categoryColor": categoryColor,
        "transactId": transactId.id,
        "date": now.millisecondsSinceEpoch
      });
    }
    notifyListeners();
  }

  addDataToPriceModel() {
    addEditAbleCustSubCat = [];
    editAbleTransactions = [];
    for (var element1 in editAbleSubCategories) {
      for (var element in totalTransactions) {
        var date = DateTime.fromMillisecondsSinceEpoch(element.date!);
        String month = DateFormat.MMMM().format(date).substring(0, 3);
        if (element.subCatId == element1.subCatId && month == currentMonth) {
          price = price + element.price!;
        }
        notifyListeners();
      }
      addEditAbleCustSubCat.add(SubCatPriceModel(
          subCatId: element1.subCatId,
          subCatTitle: element1.subCatTitle,
          price: price));
      price = 0;
    }
    notifyListeners();
  }

  deleteTransaction(String categoryId) async {
    for (var element in totalTransactions) {
      var date = DateTime.fromMillisecondsSinceEpoch(element.date!);
      String month = DateFormat.MMMM().format(date).substring(0, 3);
      if (element.categoryId == categoryId && month == currentMonth) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("transactions")
            .doc(element.transactId)
            .delete();
      }
      notifyListeners();
    }
  }

  updateFund(
      {required String fundName,
        required int fundAmount,
        required int startDate,
        required DateTime dueDate,
        required String duration,
        required String fundId,
        required int paid,
        required double monthlyDeposit}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("funds")
        .doc(fundId)
        .update({
      "fundName": fundName,
      "fundAmount": fundAmount,
      "fundId": fundId,
      "startDate": startDate,
      "dueDate": dueDate.millisecondsSinceEpoch,
      "monthlyDeposit": monthlyDeposit,
      "duration": duration,
      "paid": paid,
    });
    notifyListeners();
  }

  deleteFund(String fundId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("funds")
        .doc(fundId)
        .delete();
    notifyListeners();
    for (var element in totalTransactions) {
      if (element.fundId == fundId) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("transactions")
            .doc(element.transactId)
            .delete();
      }
    }
  }

  addFundTransaction(
      {required String fundName,
        required int goalAmount,
        required String fundId,
        required int price}) async {
    DateTime now = DateTime.now();
    var transactDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("transactions")
        .doc();
    await transactDoc.set({
      "fundName": fundName,
      "goalAmount": goalAmount,
      "fundId": fundId,
      "price": price,
      "date": now.millisecondsSinceEpoch,
      "transactId": transactDoc.id
    });
    notifyListeners();
  }

  getCurrentFundDetails(String fundId) {
    currentFundTransactions = [];
    fundPaid = 0;
    for (var element in totalTransactions) {
      if (element.fundId == fundId) {
        currentFundTransactions.add(element);
      }
    }
    if (currentFundTransactions.isNotEmpty) {
      for (var element in currentFundTransactions) {
        fundPaid = fundPaid + element.price!;
      }
    }
  }

  createFund(
      {required String fundName,
        required int fundAmount,
        required DateTime startDate,
        required DateTime dueDate,
        required String duration,
        required int paid,
        required double monthlyDeposit}) async {
    var fundDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("funds")
        .doc();
    await fundDoc.set({
      "fundName": fundName,
      "fundAmount": fundAmount,
      "startDate": startDate.millisecondsSinceEpoch,
      "dueDate": dueDate.millisecondsSinceEpoch,
      "monthlyDeposit": monthlyDeposit,
      "duration": duration,
      "fundId": fundDoc.id,
      "paid": paid,
    });
    notifyListeners();
  }

  getFunds() {
    fundsStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("funds")
        .snapshots()
        .listen((event) {
      funds = [];
      for (var element in event.docs) {
        funds.add(SinkingModel.fromJson(element.data()));
      }
    });
  }

  getCurrentDebtDetails(String debtId, int debtAmount) {
    currentDebtTransactions = [];
    debtPaid = 0;
    debtPercentValue = 0.0;
    debtColor = ColorsClass.textRed;
    for (var element in totalTransactions) {
      if (element.debtId == debtId) {
        currentDebtTransactions.add(element);
      }
    }
    if (currentDebtTransactions.isNotEmpty) {
      debtPaid = 0;
      debtPercentValue = 0.0;
      for (var element in currentDebtTransactions) {
        debtPaid = debtPaid + element.price!;
      }
      var debtPercentage = debtPaid * 100 / debtAmount;
      debtPercentValue = debtPercentage / 100;
      if (debtPercentValue >= 0.7) {
        debtColor = ColorsClass.green;
      } else if (debtPercentValue >= 0.3) {
        debtColor = ColorsClass.yellow;
      }
    }
  }

  addDebtTransaction(
      {required String debtName,
        required int debtBalance,
        required int price,
        required String debtId}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("transactions")
        .add({
      "debtName": debtName,
      "debtBalance": debtBalance,
      "debtId": debtId,
      "date": DateTime.now().millisecondsSinceEpoch,
      "price": price
    });
    notifyListeners();
  }

  addDebt(
      {required String debtName,
        required int amount,
        required int interestRate,
        required int minPayment}) async {
    var debtDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("debt")
        .doc();
    await debtDoc.set({
      "debtName": debtName,
      "debtAmount": amount,
      "interestRate": interestRate,
      "minPayment": minPayment,
      "debtId": debtDoc.id
    });
    notifyListeners();
  }

  getDebts() {
    debtsStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("debt")
        .snapshots()
        .listen((event) {
      debts = [];
      totalBalance = 0;
      totalMinPayment = 0;
      for (var element in event.docs) {
        debts.add(DebtAccountModel.fromJson(element.data()));
      }
      if (debts.isNotEmpty) {
        for (var element in debts) {
          totalBalance = totalBalance + element.yourBalance;
          totalMinPayment = totalMinPayment + element.minPayment;
        }
      }
    });
  }

  cancelSubscriptions() async {
    await transactionStream?.cancel();
    await custCategoriesStream?.cancel();
    await fundsStream?.cancel();
    await debtsStream?.cancel();
    await mileageStream?.cancel();
    await subCatStream?.cancel();
    await expectedIncomeStream?.cancel();
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}
