import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// A Widget that extracts the necessary arguments from the ModalRoute.
class TransactionView extends StatefulWidget {
  static const routeName = '/extractArguments';

  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  SharedPreferences sharedPreferences;
  final formKey = new GlobalKey<FormState>();

  var transactions = [];
  int idx;
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

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void loadData() {
    String listString = sharedPreferences.getString('list');
    setState(() {
      transactions = json.decode(listString)[idx]['transactions'];
    });
  }

  String dropdownValue = 'withdrawal';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    setState(() {
      idx = int.parse(args.message);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: transactions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(horseUrl),
                // ),
                title: Text('${transactions[index]["amount"]} '),
                trailing: Icon(Icons.cancel_outlined),
                onTap: () {
                  setState(() {
                    transactions.removeAt(index);
                    saveData();
                  });
                }
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
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          TextFormField(
                            onSaved: (value) {
                              setState(() {
                                transactions.add(
                                    {"amount": value, "type": dropdownValue});
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
                          final form = formKey.currentState;
                          form.save();
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

  void saveData() {
    // List<String> stringList = list.map(
    //         (item) => json.encode(item.toMap()
    //     )).toList();
    String listString = sharedPreferences.getString('list');

    var tt = json.decode(listString);
    tt[idx]['transactions'] = transactions;
    sharedPreferences.setString('list', json.encode(tt));
  }
}

// A Widget that accepts the necessary arguments via the constructor.

// You can pass any object to the arguments parameter. In this example,
// create a class that contains both a customizable title and message.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
