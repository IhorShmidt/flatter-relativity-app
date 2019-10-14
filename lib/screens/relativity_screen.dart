import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_relativity/classes/relativity_class.dart';
import 'package:flutter_relativity/utilities/constants.dart';
import 'package:rxdart/rxdart.dart';

class RelativityScreen extends StatefulWidget {
  @override
  _RelativityScreenState createState() => _RelativityScreenState();
}

final gradientColors = [
  Color(0xFF73AEF5),
  Color(0xFF61A4F1),
  Color(0xFF478DE0),
  Color(0xFF398AE5),
];

class _RelativityScreenState extends State<RelativityScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Relativity relativity = new Relativity();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildInput(RelativityMapper counterService, positionName, number) {
    _onChanged(val) {

      counterService.setMappingKeys(number, val);
//      counterService.stateManagement['n'+number] = val;
      print(counterService.stateManagement);

      var res = double.parse(val);
      setState(() {
        print(res);
        print(number);
        if (number == 1) {
          relativity.set1tNumber(res);
        }
        if (number == 2) {
          relativity.set2tNumber(res);
        }
        if (number == 3) {
          relativity.set3tNumber(res);
        }
        if (number == 4) {
          relativity.set4tNumber(res);
        }
      });
    }

//    relativity.onReset(()  {
//
//    })

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(positionName, style: kLabelStyle),
        SizedBox(height: 20.0),
        Container(
          alignment: Alignment.center,
          decoration: kBoxDecorationStyle,
          margin: EdgeInsets.only(bottom: 20.0),
          height: 60.0,
          width: 120.0,
          padding: EdgeInsets.only(left: 35, bottom: 15.0),
          child: TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            onChanged: _onChanged,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
            ),
          ),
        )
      ],
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
        stops: [0.1, 0.4, 0.7, 0.9],
      ),
    );
  }

  _resultBox(snap) {
//    var res = relativity.getResult().toStringAsFixed(2);

    return Container(
        child: ListTile(
            title: Container(
      alignment: Alignment.center,
      child: Text(
        snap.data.toString(),
        style: TextStyle(
            fontFamily: 'OpenSans', fontSize: 30, color: Colors.white),
      ),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
        stream:  counterService.stream$,
        builder: (BuildContext context, AsyncSnapshot snap) {

        return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: buildBoxDecoration(),
                  ),
                  Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 120.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          headingText,
                          SizedBox(height: 60.0),
                          buildFirstRow(counterService),
                          buildSecondRow(counterService),
                          SizedBox(height: 20.0),
                          _resultBox(snap),
                          SizedBox(height: 30.0),
                          buildResetButton(counterService), // todo: implement in future
                        ],
                      ),
                    ),
                  ),
                ])));},
    ));
  }

  Row buildFirstRow(counterService) {
    return Row(children: <Widget>[
      _buildInput(counterService, 'First', 1),
      Spacer(),
      _buildInput(counterService, 'Second', 2),
    ]);
  }

  Row buildSecondRow(counterService) {
    return Row(children: <Widget>[
      _buildInput(counterService, 'Third', 3),
      Spacer(),
      _buildInput(counterService, 'Fourth', 4),
    ]);
  }

  FlatButton buildResetButton(counterService) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.white)),
      padding:
          EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
      child: Text("Reset",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 30,
            color: Colors.white,
          )),
      onPressed: () {
//        counterService.increment();
        counterService.reset();
//        counterService.increment();
//        relativity.reset();
      },
    );
  }
}


class Counter {
  BehaviorSubject _counter = BehaviorSubject.seeded('0');
  Observable get stream$ => _counter.stream;

  String get current => _counter.value.toString();

  increment() {
    _counter.add(int.parse(current) + 1);
  }

}

//Counter counterService = Counter();
RelativityMapper counterService = RelativityMapper();


class RelativityMapper with ChangeNotifier {


  Map _stateManagement = {
    'n1': 0,
    'n2': 0,
    'n3': 0,
    'n4': 0,
  };

  Map get stateManagement => _stateManagement;

  BehaviorSubject _counter = BehaviorSubject.seeded('0');
  Observable get stream$ => _counter.stream;

//  String get current => _counter.value.toString();
  String get current {
//    _counter.value.toString();
    _counter.value = getResult().toString();
   return _counter.value.toString();
  }

  reset() {
    _stateManagement = {
      'n1': 0,
      'n2': 0,
      'n3': 0,
      'n4': 0,
    };
  }

  getResult() {
    var res = 0.0;
    conditions
        .asMap()
        .forEach((index, value) => value ? res = formulas[index] : null);

    return res;
  }


//  increment() {
//    _counter.add(int.parse(current) + 1);
//  }

  setMappingKeys(keyNumber, value) {
    _stateManagement['n' + keyNumber.toString()] = value;
    print(_stateManagement);
  }

//  set stateManagement(value) {
//    print('settingValue');
//    print(value);
//    _stateManagement = value;
//    notifyListeners();
//  }

//  int result = 0;
//  String _state = '0';
//  String get state => _state;


  get conditions {
    return [
      _stateManagement['n1'] == 0,
      _stateManagement['n2'] == 0,
      _stateManagement['n3'] == 0,
      _stateManagement['n4'] == 0
    ];
  }

  get formulas {
    return [
      (_stateManagement['n3'] * _stateManagement['n2']) / _stateManagement['n4'],
      (_stateManagement['n1'] * _stateManagement['n4']) / _stateManagement['n3'],
      (_stateManagement['n1'] * _stateManagement['n4']) / _stateManagement['n2'],
      (_stateManagement['n3'] * _stateManagement['n2']) / _stateManagement['n1']
    ];
  }

}