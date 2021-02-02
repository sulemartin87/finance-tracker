// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

List<Account> accountFromJson(String str) => List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));

String accountToJson(List<Account> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Account {
  Account({
    this.name,
    this.goal,
    this.transactions,
  });

  String name;
  String goal;
  List<Transaction> transactions;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    name: json["name"],
    goal: json["goal"],
    transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "goal": goal,
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
  };
}

class Transaction {
  Transaction({
    this.type,
    this.amount,
  });

  String type;
  String amount;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    type: json["type"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "amount": amount,
  };
}
