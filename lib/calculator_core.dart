import 'package:stack/stack.dart';
import 'dart:math' as math;
import 'package:decimal/decimal.dart';


Decimal _parseDecimal(t){
  return Decimal.tryParse('$t');
}

 String _parseToReversePolishAnnotation(String source) {

   var buffer = StringBuffer();
   var operStack = Stack<String>();

   for (var i = 0; i < source.length; i++) {
     if (_isDigit(source[i])) {
       if (source[i] == 'p') {
         buffer.write(math.pi);
       } else if (source[i] == 'e') {
         buffer.write(math.e);
       } else {
         buffer.write(source[i]);
       }
     } else {
       if (source[i] == '(') {
         operStack.push(source[i]);
       } else if (source[i] == ')') {
         buffer.write(' ');
         var s = operStack.pop();
         while (s != '(') {
           buffer.write('$s ');
           s = operStack.pop();
         }
       } else {
         buffer.write(' ');
         if (operStack.isNotEmpty) {
           if (getPriority(source[i]) <= getPriority(operStack.top())) {
             buffer.write('${operStack.pop()} ');
           }
         }
         operStack.push(source[i]);
       }
     }
   }
   if (operStack.isNotEmpty) {
     buffer.write(' ');
   }
   while (operStack.isNotEmpty) {
     buffer.write('${operStack.pop()} ');
   }

   return buffer.toString().trim();
 }


bool _isDigit(String s) {
  var digits = '1234567890.pe';
  var res = false;
  for (var i = 0; i < digits.length; i++) {
    res = digits[i] == s;
    if (res) break;
  }

  return res;
}


int getPriority(String s)
{
  switch (s)
  {
    case '(': return 0;
    case ')': return 1;
    case '+': return 2;
    case '-': return 3;
    case '*': return 4;
    case '/': return 4;
    case '^': return 5;
    case 'r': return 5;
    case 's': return 7;
    case 'c': return 7;
    case 't': return 7;
    case 'R': return 7;
    case 'l': return 7;
    case 'L': return 7;
    case 'm': return 10;

    default: return 100;
  }
}

bool _isOperator(String s){
   return getPriority(s)<100;
}

double _getResult(String rpaString){
   var res = 0.0;
   var temp = Stack<double>();

   for(var i=0;i<rpaString.length;i++){
      if(_isDigit(rpaString[i])){
        var digitBuilder = StringBuffer();

        while(_isDigit(rpaString[i])){
          digitBuilder.write(rpaString[i]);
          i++;
          if (i == rpaString.length) break;
        }

        temp.push(double.parse(digitBuilder.toString()));
        i--;
      }else if(_isOperator(rpaString[i])){
        if(getPriority(rpaString[i])<6){
          var a = _parseDecimal(temp.pop());
          var b = _parseDecimal(temp.pop());
          var tmp = Decimal.zero;
          switch(rpaString[i]){
            case '+':
              tmp = b + a;
              break;
            case '-':
              tmp = b - a;
              break;
            case '*':
              tmp = b * a;
              break;
            case '/':
              tmp = b / a;
              break;
            case '^':
              if(a%_parseDecimal(1)<=_parseDecimal('0.000000001')){
                var exponent = a.toInt();
                tmp = b.pow(exponent);
              }else {
                res = math.pow(b.toDouble(), a.toDouble());
                tmp = _parseDecimal(res);
              }
              break;
            case 'r':
            res = math.pow(a.toDouble(),(_parseDecimal(1)/b).toDouble());
            tmp = _parseDecimal(res);
            break;
          }
          res = tmp.toDouble();
        }else{
          var a = temp.pop();
          switch(rpaString[i]) {
            case 's':
              res = math.sin(a);
              break;
            case 'c':
              res = math.cos(a);
              break;
            case 't':
              res = math.tan(a);
              break;
            case 'm':
              res = -a;
              break;
            case 'R':
              res = math.sqrt(a);
              break;
            case 'l':
              res = math.log(a);
              if(res==double.negativeInfinity) {
                throw Exception('Log expression mast be more than zero');
              }
              break;
            case 'L':
              res = math.log(a)/math.ln10;
              if(res==double.negativeInfinity) {
                throw Exception('Log expression mast be more than zero');
              }
              break;
          }

        }

        temp.push(res);
      }
   }

   return temp.top();
}

double getCalculationResult(String source){
   String tmp = _parseToReversePolishAnnotation(source);

   return _getResult(tmp);
}



