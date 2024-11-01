import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator', // "Шапка" калькулятора
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Отображение набранных чисел
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 30),
            alignment: Alignment.centerRight,
            child: Text(
              '$text',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Строки кнопок
          _buildButtonRow(['AC', '^', '/']),
          _buildButtonRow(['7', '8', '9', '*']),
          _buildButtonRow(['4', '5', '6', '-']),
          _buildButtonRow(['1', '2', '3', '+']),
          _buildButtonRow(['0', '.', '=']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
          return _buildButton(button);
      }).toList(),
    );
  }
  //вид кнопки
  Widget _buildButton(String label, {void Function()? onTap}) {
    Color buttonColor;
    Color txtButton;
    if (checkSymbol(label) == 1) {
      buttonColor = Colors.deepOrangeAccent;
      txtButton = Colors.white;
    } else if (checkSymbol(label) == 2) {
      buttonColor = Colors.grey;
      txtButton = Colors.black;
    }
    else {
      buttonColor = Color.fromRGBO(62, 62, 62, 1.0);
      txtButton = Colors.white;
    }

    double buttonWidth = label == '0' || label == 'AC' ? 190 : 85;
    return GestureDetector(
      onTap: onTap ?? () => calculate(label),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(15),
        width: buttonWidth,
        height: 85,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: txtButton,
          ),
        ),
      ),
    );
  }
  //проверка символа
  int checkSymbol(String label) {
    if (label == '=' || label == '/' || label == '*'
        || label == '-' || label == '+') {
      return 1;
    } else if (label == 'AC' || label == 'C' || label == '^') {
      return 2;
    }
    else {
      return 3;
    }
  }

  //Алгоритм калькулятора
  dynamic text ='0';
  double numOne = 0;
  double numTwo = 0;

  dynamic oper = '';
  dynamic preOper = '';
  dynamic ans = '';
  dynamic finalAns = '';

  void calculate (label) {
    if (label == 'AC') {
      ClearAll();
    }
    else if (oper == '=' && label == '=') {
      if (preOper == '+') {
        finalAns = add();
      } else if (preOper == '-') {
        finalAns = sub();
      } else if (preOper == '*') {
        finalAns = mul();
      } else if (preOper == '/') {
        finalAns = div();
      } else if(preOper == '^') {
        finalAns = deg();
      }
    }
    else if (label == '+' || label == '-' || label == '*' || label == '/'
            || label == '^' || label == '=') {
      if (numOne == 0) {
        numOne = double.parse(ans); //перевод строки ans в double
      } else {
        numTwo = double.parse(ans);
      }

      if(oper == '+') {
        finalAns = add();
      } else if( oper == '-') {
        finalAns = sub();
      } else if( oper == '*') {
        finalAns = mul();
      } else if( oper == '/') {
        finalAns = div();
      } else if( oper == '^') {
        finalAns = deg();
      }
      preOper = oper;
      oper = label;
      ans = '';
    }
    else {
      ans = ans + label;
      finalAns = ans;
    }

    setState(() { //изменение состояния, вывод ответа
      text = finalAns;
    });
  }

  String add() {
    ans = (numOne + numTwo).toString();
    numOne = double.parse(ans);
    return doesContainDecimal(ans);
  }
  String sub() {
    ans = (numOne - numTwo).toString();
    numOne = double.parse(ans);
    return doesContainDecimal(ans);
  }
  String mul() {
    ans = (numOne * numTwo).toString();
    numOne = double.parse(ans);
    return doesContainDecimal(ans);
  }
  String div() {
    if (numTwo == 0)
      return 'Делить на 0 нельзя';
    ans = (numOne / numTwo).toString();
    numOne = double.parse(ans);
    return doesContainDecimal(ans);
  }
  String deg() {
    ans = pow(numOne, numTwo).toString();
    numOne = double.parse(ans);
    return doesContainDecimal(ans);
  }

  String doesContainDecimal(dynamic ans) {
    if(ans.toString().contains('.')) { //проверка наличия точки
      List<String> splitDecimal = ans.toString().split('.');
      if(!(int.parse(splitDecimal[1]) > 0)) //если дробная часть ноль, то выводим без неё
        return ans = splitDecimal[0].toString();
    }
    return ans;
  }

  void ClearAll() {   //очистка переменных
    text ='0';
    numOne = 0;
    numTwo = 0;

    oper = '';
    preOper = '';
    ans = '';
    finalAns = '0';
  }
}