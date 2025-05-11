import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class HealthySplashScreen extends StatefulWidget {
  @override
  _HealthySplashScreenState createState() => _HealthySplashScreenState();
}

class _HealthySplashScreenState extends State<HealthySplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );

    _colorAnimation = ColorTween(
        begin: Color(0xFF2ecc71),
        end: Color(0xFFa5df00)
    ).animate(_controller);

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/splash');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo maison animé
                Transform(
                  transform: Matrix4.identity()
                    ..scale(_scaleAnimation.value)
                    ..rotateZ(_rotationAnimation.value),
                  child: HealthyFoodLogo(color: _colorAnimation.value!),
                ),

                SizedBox(height: 20),

                // Texte avec effet de pulsation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    'GREEN DELIVERY',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _colorAnimation.value,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Loading personnalisé
                Container(
                  width: 120,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _controller.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _colorAnimation.value,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: _colorAnimation.value!.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HealthyFoodLogo extends StatelessWidget {
  final Color color;

  const HealthyFoodLogo({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(150, 150),
      painter: _HealthyFoodLogoPainter(color),
    );
  }
}

class _HealthyFoodLogoPainter extends CustomPainter {
  final Color color;

  _HealthyFoodLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Dessin d'un panier
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width*0.3, size.height*0.5, size.width*0.4, size.height*0.3),
        Radius.circular(10),
      ),
      paint,
    );

    // Poignée du panier
    canvas.drawArc(
      Rect.fromLTWH(size.width*0.25, size.height*0.4, size.width*0.5, size.height*0.2),
      0, 3.14, false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Contenu du panier (fruits/légumes)
    // Pomme
    canvas.drawCircle(
      Offset(size.width*0.4, size.height*0.6),
      size.width*0.08,
      Paint()..color = Colors.red[400]!,
    );

    // Feuille de pomme
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width*0.37, size.height*0.55),
        width: size.width*0.04,
        height: size.width*0.03,
      ),
      Paint()..color = Colors.green[600]!,
    );

    // Banane
    final bananePath = Path()
      ..moveTo(size.width*0.5, size.height*0.65)
      ..quadraticBezierTo(
        size.width*0.55, size.height*0.58,
        size.width*0.6, size.height*0.62,
      )
      ..quadraticBezierTo(
        size.width*0.65, size.height*0.66,
        size.width*0.63, size.height*0.7,
      );

    canvas.drawPath(
      bananePath,
      Paint()
        ..color = Colors.yellow[700]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}