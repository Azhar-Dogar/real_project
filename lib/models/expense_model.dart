
import 'package:real_project/models/transaction_model.dart';

class ExpenseModel{
  String? id;
  List<TransactionModel> transactions =[];
  List<TransactionModel> doubleTransactions =[];
  String? categoryTitle;
  ExpenseModel({ this.id,this.categoryTitle});

  addTransaction(TransactionModel model){
    transactions.add(model);
  }
}