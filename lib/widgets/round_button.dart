import 'package:flutter/material.dart';
import 'app_color.dart'; // Ensure this import is correct for your project

class RoundButton extends StatefulWidget {
  const RoundButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.color = const Color.fromARGB(255, 4, 16, 30),
    this.height = 50,
    this.width = double.infinity,
    this.radius = 25.0,
    this.icon,  // Add this line
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String label;
  final Color color;
  final double height;
  final double width;
  final double radius;
  final Widget? icon;  // Add this line

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..addListener(() {
        setState(() {});
      });
    _controller.value = 1.0; // Start at normal size
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 + (_controller.value - 1) * 0.2;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _controller.forward(), // Reset to normal size
      onTap: widget.onPressed,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.onPressed == null ? Colors.transparent : widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: AppColors.darkBlueColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: (widget.color == AppColors.whiteColor && widget.onPressed != null)
                      ? AppColors.realWhiteColor
                      : AppColors.darkWhiteColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
