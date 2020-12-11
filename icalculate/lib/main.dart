import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:age/age.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "iCalculate",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorForm extends StatefulWidget {
  @override
  _CalculatorFormState createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  var totalInterest = 0.0;
  var total = 0.0;

  final FocusNode _nodeText1 = FocusNode();
  TextEditingController amountTxtController = new TextEditingController();
  TextEditingController interestTxtController = new TextEditingController();
  TextEditingController fromDateTxtController = new TextEditingController();
  TextEditingController toDateTxtController = new TextEditingController();

  bool formValidation() {
    if (amountTxtController.text.isNotEmpty &&
        interestTxtController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  double calculation() {
    var amount = double.parse(amountTxtController.text);
    var interest = double.parse(interestTxtController.text);

    var perMonth = amount * interest / 100;
    print(perMonth);
    print(fromDate);
    print(toDate);

    AgeDuration age;
    // Find out your age
    age = Age.dateDifference(
        fromDate: fromDate, toDate: toDate, includeToDate: false);
    print('Your age is $age');

    var year = age.years * 12 * perMonth;
    var month = age.months * perMonth;
    var days = perMonth / 30 * age.days;

    print('$year, $month, $days');
    setState(() {
      totalInterest = year + month + days;
      total = totalInterest + amount;
    });
    // Period diff = fromDate.periodSince(toDate);
    // print("years: ${diff.years}; months: ${diff.months}; days: ${diff.days}");
    return totalInterest;
  }

  _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      fieldLabelText: 'Choose date',
      fieldHintText: 'Month/Date/Year',
    );
    if (picked != null)
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          // fromDate = LocalDate(picked.year, picked.month, picked.day);
        } else {
          toDate = picked;
          //toDate = LocalDate(picked.year, picked.month, picked.day);
        }
      });
  }

  @override
  // TODO: implement widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'iCalculate',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 40, 5, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: amountTxtController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.go,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(hintText: 'Enter Amount'),
            ),
            TextField(
              controller: interestTxtController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              focusNode: _nodeText1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(hintText: 'Interest rate'),
            ),
            Container(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        onPressed: () => _selectDate(context, true),
                        color: Colors.blue,
                        child: Text(
                          'From Date',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () => _selectDate(context, false),
                        color: Colors.blue,
                        child: Text(
                          'To Date',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "${fromDate.toLocal()}".split(' ')[0],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "${toDate.toLocal()}".split(' ')[0],
                      textAlign: TextAlign.center,
                    ))
                  ],
                )
              ],
            )),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RaisedButton(
                  onPressed: () {
                    if (formValidation()) {
                      calculation();
                    } else {
                      print('not valid from');
                    }
                    //Respond to button pressed
                  },
                  child: Text('Submit'),
                ),
                Text(
                  "Total Interest : ${totalInterest.toStringAsFixed(1)}",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Total Amount : ${total.toStringAsFixed(1)}",
                  textAlign: TextAlign.center,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
