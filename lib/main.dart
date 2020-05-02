import 'package:flutter/material.dart';
import 'package:calculator/calculator_core.dart' as calculator;


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final title = 'CALCULATOR';

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLastOper;

  String _visualEquation;
  String _answer;
  String _actualEquation;
  int _openDoorsCount;

  bool _isSecondPage;

  final List<PreparedButton> buttonsPage1 = <PreparedButton>[
    PreparedButton(6, '2nd'),
    PreparedButton(1, '(', visual: '('),
    PreparedButton(1, ')', visual: ')'),
    PreparedButton(3, ''),
    PreparedButton(4, 'AC'),
    PreparedButton(2, '-',visual: '(-)', actual: 'm'),
    PreparedButton(0, '7'),
    PreparedButton(0, '8'),
    PreparedButton(0, '9'),
    PreparedButton(2, '-'),
    PreparedButton(2, '^2',visual: 'x²', actual: '^2'),
    PreparedButton(0, '4'),
    PreparedButton(0, '5'),
    PreparedButton(0, '6'),
    PreparedButton(2, '+'),
    PreparedButton(2, 'ln ', visual: 'ln x',actual: 'l'),
    PreparedButton(0, '1'),
    PreparedButton(0, '2'),
    PreparedButton(0, '3'),
    PreparedButton(2, '*'),
    PreparedButton(2, '√', actual: 'R'),
    PreparedButton(0, '0'),
    PreparedButton(0, '.'),
    PreparedButton(5, '='),
    PreparedButton(2, '/'),
  ];

  final List<PreparedButton> buttonsPage2 = <PreparedButton>[
    PreparedButton(6, '2nd'),
    PreparedButton(1, '('),
    PreparedButton(1, ')'),
    PreparedButton(3, ''),
    PreparedButton(4, 'AC'),
    PreparedButton(2, 'sin', visual: 'sin x', actual: 's'),
    PreparedButton(2, 'cos', visual: 'cos x', actual: 'c'),
    PreparedButton(2, 'tg', visual: 'tg x', actual: 't'),
    PreparedButton(0, 'π',actual: 'p'),
    PreparedButton(0, 'e', actual: 'e'),
    PreparedButton(2, '√',visual:'y√', actual: 'r'),
    PreparedButton(2, '^',visual:'x^y'),
    PreparedButton(2, 'log ', visual: 'log x', actual: 'L'),
    PreparedButton(2, '-',visual: '(-)', actual: 'm'),
    PreparedButton(5, '='),
  ];


  List<Widget> _page1;
  List<Widget> _page2;

  @override
  void initState() {
    super.initState();

    _clear();
    _answer = '';
    _openDoorsCount = 0;

    _isSecondPage = false;

    _page1 = _getButtons(buttonsPage1);
    _page2 = _getButtons(buttonsPage2);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(50)),
                    border: Border.all(
                        width: 5
                    )
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(Icons.history),
                          onPressed: () {}
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {}
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                        width: 10
                    )
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Text(
                            _visualEquation,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                            ),
                          )
                        ],
                      ) ,
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Text(
                            _answer,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                              color: Colors.blueGrey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),
            Expanded(
              flex: 6,
              child: GridView(

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  children: (_isSecondPage)
                      ? _page2
                      : _page1,
              ),
            )

          ],
        ),
      ),

    );
  }

  Widget _buildButton(PreparedButton button) {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: _getColorByType(button.type),
          borderRadius: BorderRadius.all(
              Radius.circular(_getRadiusByType(button.type))
          ),
          border: Border.all(
              width: 3
          )
      ),
      child: FlatButton(
          onPressed: () {
            _append(button);
          },
          child: (button.type != 3)
              ? Text(
                  button.visualSymbol,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: _getFontSizeByLength(
                          button
                              .visualSymbol
                              .trim()
                              .length
                      ),
                      fontWeight: FontWeight.bold
                  )
                )
              : Icon(
                  Icons.arrow_back,
                  size: 30,
                ),

      ),
    );
  }

  void _append(PreparedButton button) {
    setState(() {


    switch(button.type){
      case 0:
        _isLastOper = false;
        _appendSymbol(button);
        break;
      case 1:
        _isLastOper = false;
        _openDoorsCount += (button.visualSymbol=='(')? 1 : -1;
        _appendSymbol(button);
        break;
      case 2:
        var operType = calculator.getPriority(button.actualSymbol)<6;
        if(_isLastOper&&operType){
          _actualEquation = _actualEquation.substring(0,_actualEquation.length-1);
          _visualEquation = _visualEquation.substring(0,_visualEquation.length-1);
        }else{
            if(operType&&button.actualSymbol!='^2') {
              _isLastOper = true;
            }else{
              _isLastOper = false;
            }
        }
        _appendSymbol(button);
        break;
      case 3:
        if(_actualEquation.length>0) {
          _isLastOper = false;
          var index = _actualEquation.length - 1;
          var btn = _getButtonByActualSym(_actualEquation[index]);

          _actualEquation =
              _actualEquation.substring(0,index);
          _visualEquation =
              _visualEquation.substring(0, _visualEquation.length - btn.symbol.length);
        }
        break;
      case 4:
        _clear();
        break;
      case 5:
        try{
          if(_actualEquation==''){
            _answer='0';
          }else if(_actualEquation=='008'){
            _answer = 'Помни памятную дату. Мы вас разность словно в цирке сахарную вату';
          }else if(_openDoorsCount==0){
            var res = calculator.getCalculationResult(_actualEquation);
            _answer = '$res';
          }else {
            _clear();
            _answer = 'Error';
          }

        }catch (e){
          print(e);
          _clear();
          _answer = 'Error';
        }
        break;
      case 6:
        _switchPage();
        break;
    }
    });
  }

  PreparedButton _getButtonByActualSym(String sym){
    for(PreparedButton buttonFromPage1 in buttonsPage1){
      if(sym==buttonFromPage1.actualSymbol){
        return buttonFromPage1;
      }
    }
    for(PreparedButton buttonFromPage2 in buttonsPage2){
      if(sym==buttonFromPage2.actualSymbol){
        return buttonFromPage2;
      }
    }

    return null;

  }

  void _clear() {
    if(_actualEquation == '' && _visualEquation == ''){
      _answer = '';
    }
    _isLastOper = false;
    _actualEquation = '';
    _visualEquation = '';
  }

  void _appendSymbol(PreparedButton button) {
    _actualEquation += button.actualSymbol;
    _visualEquation += button.symbol;
  }

  void _switchPage(){
    setState(() {
      _isSecondPage= !_isSecondPage;
    });
  }

  Color _getColorByType(int type) {
    if (type == 0) {
      return Colors.purple[300];
    } else if (type == 1||type==6) {
      return Colors.orangeAccent[100];
    } else if (type == 2) {
      return Colors.greenAccent;
    } else {
      return Colors.red;
    }
  }

  double _getFontSizeByLength(int length) {
    if(length>4){
      return 11;
    }else if(length>=3){
      return 16;
    }else if(length==2){
      return 20;
    }else{
      return 50;
    }
  }

  double _getRadiusByType(int type) {
    if (type > 4) {
      return 50;
    } else {
      return 20;
    }
  }

  List<Widget> _getButtons(List<PreparedButton> buttons) {
    List<Widget> result = [];
    for (PreparedButton button in buttons) {
      result.add(_buildButton(button));
    }
    return result;
  }


}

class PreparedButton {
  int _type;
  String _symbol;
  String _actualSymbol;
  String _visualSymbol;

  PreparedButton(this._type,
      this._symbol, {
        actual: "",
        visual: ""
      }) {
    _actualSymbol = (actual == "") ? _symbol : actual;
    _visualSymbol = (visual == "") ? _symbol : visual;
  }

  String get visualSymbol => _visualSymbol;

  String get actualSymbol => _actualSymbol;

  String get symbol => _symbol;

  int get type => _type;

}



//p300 ta400 red oa100