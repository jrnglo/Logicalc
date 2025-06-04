import 'package:flutter/material.dart';
import 'package:graphview/graphview.dart';

class CircuitDiagram extends StatelessWidget {
  final String expression;

  const CircuitDiagram({super.key, required this.expression});

  @override
  Widget build(BuildContext context) {
    final Graph graph = Graph()..isTree = false;
    final configuration = SugiyamaConfiguration()
        ..nodeSeparation = 60
        ..levelSeparation = 120
        ..orientation = SugiyamaConfiguration.ORIENTATION_LEFT_RIGHT;
  
      
    final Algorithm algorithm = SugiyamaAlgorithm(configuration);

    Node resultNode = Node.Id(expression);
    graph.addNode(resultNode);

    try {
      _parseExpression(expression, graph, resultNode);
    } catch (e) {
      print('Error parsing expression: $e');
    }

    return SizedBox(
      height: 300,
      child: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.01,
        maxScale: 5.6,
        child: GraphView(
          graph: graph,
          algorithm: algorithm,
          paint: Paint()
            ..color = Colors.black
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
          builder: (Node node) {
            if (node.key?.value == expression) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(node.key?.value.toString() ?? '', style: TextStyle(color: Colors.red)),
              );
            }
            return _buildGateWidget(node);
          },
        ),
      ),
    );
  }

  void _parseExpression(String expr, Graph graph, Node parent) {
    expr = expr.trim();
    
    // Remove outer parentheses recursively
    while (expr.startsWith('(') && expr.endsWith(')')) {
      // Check if these are matching parentheses
      int count = 0;
      bool isMatching = true;
      for (int i = 0; i < expr.length; i++) {
        if (expr[i] == '(') count++;
        if (expr[i] == ')') count--;
        if (count == 0 && i < expr.length - 1) {
          isMatching = false;
          break;
        }
      }
      if (!isMatching) break;
      expr = expr.substring(1, expr.length - 1).trim();
    }

    List<String> operands = _splitOperands(expr);
    if (operands.length > 1) {
      var operator = _findOperator(expr);
      if (operator != null) {
        String gateName = _getGateName(operator);
        Node gateNode = Node.Id('$gateName-${graph.nodeCount()}');
        graph.addNode(gateNode);
        graph.addEdge(gateNode, parent);

        for (String operand in operands) {
          _parseExpression(operand, graph, gateNode);
        }
        return;
      }
    }

    if (expr.startsWith('¬')) {
      Node notGate = Node.Id('NOT');
      graph.addNode(notGate);
      graph.addEdge(notGate, parent);
      _parseExpression(expr.substring(1), graph, notGate);
    } else if (RegExp(r'[A-Z]').hasMatch(expr)) {
      // Remove any remaining parentheses from input nodes
      expr = expr.replaceAll('(', '').replaceAll(')', '').trim();
      Node inputNode = Node.Id(expr);
      graph.addNode(inputNode);
      graph.addEdge(inputNode, parent);
    }
  }

  List<String> _splitOperands(String expr) {
    List<String> operands = [];
    int parenthesesCount = 0;
    int start = 0;
    
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') {
        parenthesesCount++;
      } else if (expr[i] == ')') {
        parenthesesCount--;
      }
      
      if (parenthesesCount == 0) {
        for (var op in ['•', '+', '↑', '↓', '⊕', '⊙']) {
          if (i + op.length <= expr.length && 
              expr.substring(i, i + op.length) == op) {
            operands.add(expr.substring(start, i).trim());
            start = i + op.length;
            i += op.length - 1;
            break;
          }
        }
      }
    }
    
    if (start < expr.length) {
      operands.add(expr.substring(start).trim());
    }
    
    return operands;
  }

  String? _findOperator(String expr) {
    expr = expr.trim();
    int parenthesesCount = 0;
    List<String> operators = ['↑', '↓', '+', '•', '⊕', '⊙'];
    
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') parenthesesCount++;
      else if (expr[i] == ')') parenthesesCount--;
      
      if (parenthesesCount == 0) {
        for (var op in operators) {
          if (i + op.length <= expr.length && 
              expr.substring(i, i + op.length) == op) {
            return op;
          }
        }
      }
    }
    return null;
  }

  String _getGateName(String operator) {
    switch (operator) {
      case '•': return 'AND';
      case '+': return 'OR';
      case '↑': return 'NAND';
      case '↓': return 'NOR';
      case '⊕': return 'XOR';
      case '⊙': return 'XNOR';
      default: return 'UNKNOWN';
    }
  }

  Widget _buildGateWidget(Node node) {
    String nodeId = node.key?.value as String;
    // Extract the gate type by taking everything before the hyphen
    String gateType = nodeId.split('-')[0];
    
    switch (gateType) {
      case 'AND':
        return _GateWidget(
          offset: -20,
          child: CustomPaint(
            painter: AndGatePainter(),
            size: const Size(50, 50),
          ),
        );
      case 'OR':
        return _GateWidget(
          offset: -20,
          child: CustomPaint(
            painter: OrGatePainter(),
            size: const Size(50, 50),
          ),
        );
      case 'NOT':
        return _GateWidget(
          child: CustomPaint(
            painter: NotGatePainter(),
            size: const Size(50, 50),
          ),
        );
      case 'NAND':
        return _GateWidget(
          child: CustomPaint(
            painter: NandGatePainter(),
            size: const Size(50, 50),
          ),
        );
      case 'NOR':
        return _GateWidget(
          child: CustomPaint(
            painter: NorGatePainter(),
            size: const Size(50, 50),
          ),
        );
      case 'XOR':
        return _GateWidget(
          child: CustomPaint(
            painter: XorGatePainter(),
            size: const Size(50, 50),
          ),
        );
      case 'XNOR':
        return _GateWidget(
          child: CustomPaint(
            painter: XnorGatePainter(),
            size: const Size(50, 50),
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(gateType),
        );
    }
  }
}

class _GateWidget extends StatelessWidget {
  final Widget child;
  final double offset;

  const _GateWidget({
    required this.child, 
    this.offset = -10,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        child: child,
      ),
    );
  }
}

// Custom painters for logic gates
class AndGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.5, 0)
      ..arcToPoint(
        Offset(size.width * 0.5, size.height),
        radius: Radius.circular(size.height * 0.5),
        clockwise: true,
      )
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OrGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.5,
        0,
        size.height,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        0,
        0,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NotGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Draw the circle
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.5),
      size.width * 0.15,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NandGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.5, 0)
      ..arcToPoint(
        Offset(size.width * 0.4, size.height),
        radius: Radius.circular(size.height * 0.5),
        clockwise: true,
      )
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

  
    canvas.drawCircle(
      Offset(size.width * 1.10, size.height * 0.5), 
      size.width * 0.1,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NorGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.5,
        0,
        size.height,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width * 0.7,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        0,
        0,
      );

    canvas.drawPath(path, paint);

    // Draw the circle for NOR
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.5),
      size.width * 0.1,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class XorGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the OR gate base
    final mainPath = Path()
      ..moveTo(size.width * 0.2, 0)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.5,
        size.width * 0.2,
        size.height,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.5,
        size.width,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.5,
        size.width * 0.2,
        0,
      );

    // Draw the extra curve that makes it XOR
    final extraCurve = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.5,
        0,
        size.height,
      );

    canvas.drawPath(mainPath, paint);
    canvas.drawPath(extraCurve, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class XnorGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the OR gate base
    final mainPath = Path()
      ..moveTo(size.width * 0.2, 0)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width * 0.2,
        size.height,
      )
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.5,
        size.width * 0.7,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.5,
        size.width * 0.2,
        0,
      );

    // Draw the extra curve that makes it XOR
    final extraCurve = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.5,
        0,
        size.height,
      );

    canvas.drawPath(mainPath, paint);
    canvas.drawPath(extraCurve, paint);

    // Draw the circle for XNOR
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.5),
      size.width * 0.1,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 