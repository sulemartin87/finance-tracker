import 'dart:convert';

import 'package:flutter/material.dart';
import 'account.dart';

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
    );
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

  final formKey = new GlobalKey<FormState>();
  String _name, _amount;
  List<Account> jj = [];

  //use this with an async function to get from shared preferences
  // List<Account> getAccounts() {
  //   // List<dynamic> data = jsonDecode(fakeData);
  //   List<Account> l = data.map((data) => Account.fromJson(data)).toList();
  //   return l;
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListTile guide')),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: jj.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(horseUrl),
              // ),
              title: Text('${jj[index].name} ${jj[index].goal}'),
              // subtitle: Text('A strong animal'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                print('${accounts[index]}');
              },
              // selected: true,
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
                          Account f = Account(name: _name, goal: _amount);
                          setState(() {
                            jj.add(f);
                          });
                          // String hh  = json.encode(List<dynamic>.from(jj.map((x) => x.toJson()));
                          // String j (List<Account> jj) => );
                          print(json.encode(jj));

                          // List<String> stringList = jj.map(
                          //         (item) => json.encode(item.toMap()
                          //     )).toList();
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
}
