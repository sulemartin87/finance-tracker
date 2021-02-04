import 'dart:convert';

import 'package:fin_goals/TransactionView.dart';
import 'package:flutter/material.dart';
import 'account.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Goals'),
        routes: {
          TransactionView.routeName: (context) => TransactionView(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  List<Account> accounts;
  SharedPreferences sharedPreferences;

  final formKey = new GlobalKey<FormState>();
  final formKey2 = new GlobalKey<FormState>();
  String _name, _amount;
  List<Account> jj = [];
  var accountData = [];

  int getTotal(transactions) {
    var total = 0;
    transactions.forEach((transaction) {
      if (transaction['type'] == 'withdrawal') {
        total -= int.parse(transaction['amount']);
      } else {
        total += int.parse(transaction['amount']);
      }
    });
    return total;
  }

  String dropdownValue = 'withdrawal';

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListTile guide')),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: accountData.length,
          itemBuilder: (BuildContext context, int index) {
            return PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'transactions') {
                  Navigator.pushNamed(
                    context,
                    TransactionView.routeName,
                    arguments: ScreenArguments(
                      '${accountData[index]["name"]}',
                      index.toString(),
                    ),
                  ).then((value) {
                    loadData();
                  });
                } else {
                  return showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text('Add Goal'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: formKey2,
                              child: Column(
                                children: <Widget>[
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>['withdrawal', 'deposit']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  TextFormField(
                                    onSaved: (value) {
                                      setState(() {
                                        accountData[index]['transactions'].add({
                                          "amount": value,
                                          "type": dropdownValue
                                        });
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Goal',
                                      icon: Icon(Icons.account_box),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            RaisedButton(
                                child: Text("Submit"),
                                onPressed: () {
                                  final form = formKey2.currentState;
                                  form.save();
                                  saveData();
                                  Navigator.pop(context, false);
                                })
                          ],
                        );
                      });
                }
              },
              child: ListTile(
                title: Text(
                    '${accountData[index]["name"]} Goal:  ${accountData[index]["goal"]}'),
                subtitle: Text(
                    'Current Total :${getTotal(accountData[index]['transactions'])}'),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'transactions',
                  child: Text('View transactions'),
                ),
                const PopupMenuItem<String>(
                  value: 'add',
                  child: Text('Add transaction'),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        // child: Text("Open Popup"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Add Goal'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) => _name = value,
                            decoration: InputDecoration(
                              labelText: 'Goal',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            onSaved: (value) => _amount = value,
                            decoration: InputDecoration(
                              labelText: 'Cost',
                              icon: Icon(Icons.email),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    RaisedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          final form = formKey.currentState;
                          form.save();
                          var j = {
                            "name": _name,
                            "goal": _amount,
                            "transactions": []
                          };
                          setState(() {
                            accountData.add(j);
                          });
                          print(json.encode(accountData));
                          saveData();
                          Navigator.pop(context, false);
                        })
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  onGoBack() {
    loadData();
    setState(() {});
  }

  void saveData() {
    sharedPreferences.setString('list', json.encode(accountData));
  }

  loadData() {
    String listString = sharedPreferences.getString('list');
    setState(() {
      accountData = json.decode(listString);
    });
  }
}
