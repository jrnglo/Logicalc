import 'package:flutter/material.dart';
import '../result_screen.dart';

class ExpressionInput extends StatefulWidget {
  final String? initialExpression;
  final bool autoConvert; // Auto-trigger conversion when input comes from CaptureFormulaScreen

  const ExpressionInput({super.key, this.initialExpression, this.autoConvert = false});

  @override
  _ExpressionInputState createState() => _ExpressionInputState();
}

class _ExpressionInputState extends State<ExpressionInput> {
  late TextEditingController _controller;
  String? _validationError;
  static const Map<String, String> wordToSymbol = {
    "AND": "•",
    "OR": "+",
    "NOT": "¬",
    "NAND": "↑",
    "NOR": "↓",
    "XOR": "⊕",
    "XNOR": "⊙",
  };
  static const operators = ['•', '+', '↑', '↓', '⊕', '⊙'];

  @override
  void initState() {
    super.initState();
    String convertedExpression = widget.initialExpression ?? "";
    if (widget.initialExpression != null) {
      convertedExpression = _convertToSymbols(widget.initialExpression!);
    }

    _controller = TextEditingController(text: convertedExpression);
    _controller.addListener(_validateExpression);

    // Auto-click "Convert" button if input is from CaptureFormulaScreen
    if (widget.autoConvert && _controller.text.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _convertExpression();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_validateExpression);
    _controller.dispose();
    super.dispose();
  }

  /// Converts word-based Boolean operators to their respective symbols
  String _convertToSymbols(String expression) {
    String result = expression;
    wordToSymbol.forEach((word, symbol) {
      result = result.replaceAll(RegExp(r'\b' + word + r'\b', caseSensitive: false), symbol);
    });
    return result;
  }

  void _validateExpression() {
    final expression = _controller.text;
    setState(() {
      if (expression.isEmpty) {
        _validationError = null;
        return;
      }

      for (int i = 0; i < expression.length - 1; i++) {
        final current = expression[i];
        final next = expression[i + 1];

        if (isVariable(current) && isVariable(next)) {
          _validationError = 'Operands must be separated by operators';
          return;
        }

        if (current == '¬' && (i > 0 && isVariable(expression[i - 1]))) {
          _validationError = 'Negation must be placed before the operand';
          return;
        }
      }

      int parenthesesCount = 0;
      for (var char in expression.characters) {
        if (char == '(') parenthesesCount++;
        if (char == ')') parenthesesCount--;
        if (parenthesesCount < 0) {
          _validationError = 'Invalid parentheses order';
          return;
        }
      }
      if (parenthesesCount != 0) {
        _validationError = 'Incomplete parentheses';
        return;
      }

      if (operators.contains(expression[expression.length - 1])) {
        _validationError = 'Expression ends with an operator';
        return;
      }

      for (int i = 0; i < expression.length - 1; i++) {
        if (operators.contains(expression[i]) &&
            operators.contains(expression[i + 1]) &&
            expression[i] != '¬') {
          _validationError = 'Consecutive operators are not allowed';
          return;
        }
      }

      _validationError = null;
    });
  }

  bool isVariable(String char) {
    return RegExp(r'[A-C]').hasMatch(char);
  }

  void _handleKeyPress(String value) {
    setState(() {
      if (value == 'CLR') {
        _controller.clear();
      } else if (value == 'DEL') {
        final text = _controller.text;
        if (text.isNotEmpty) {
          _controller.text = text.substring(0, text.length - 1);
        }
      } else {
        _controller.text += value;
      }
    });
  }

  void _convertExpression() {
    if (_validationError == null && _controller.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(expression: _controller.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equation Input', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Input your Equation:',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              readOnly: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Equation',
                errorText: _validationError,
              ),
            ),
            const SizedBox(height: 20),
            CustomKeyboard(onKeyPressed: _handleKeyPress),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertExpression,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Convert', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;

  const CustomKeyboard({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildKey('A'),
        _buildKey('B'),
        _buildKey('C'),
        _buildKey('DEL', icon: Icons.backspace_outlined),
        _buildKey('•'),
        _buildKey('+'),
        _buildKey('¬'),
        _buildKey('↑'),
        _buildKey('↓'),
        _buildKey('⊕'),
        _buildKey('⊙'),
        _buildKey('('),
        _buildKey(')'),
        _buildKey('CLR'),
      ],
    );
  }

  Widget _buildKey(String label, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          onKeyPressed(label);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        ),
        child: icon != null
            ? Icon(icon, size: 24)
            : Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
