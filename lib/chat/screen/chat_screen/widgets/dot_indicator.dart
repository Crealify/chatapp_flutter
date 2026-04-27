import 'package:flutter/material.dart';

// class ThreeDots extends StatefulWidget {
//   const ThreeDots({super.key});

//   @override
//   _ThreeDotsState createState() => _ThreeDotsState();
// }

// class _ThreeDotsState extends State<ThreeDots>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500) * 8,
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Widget _buildDot(int index) {
//     return ScaleTransition(
//       scale: CurvedAnimation(
//         parent: _controller,
//         curve: Interval(index / 3, (index + 1) / 3, curve: Curves.easeInOut),
//       ),
//       child: Container(
//         width: 5,
//         height: 5,
//         decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(3, _buildDot)
//           .map(
//             (dot) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 2),
//               // padding: const EdgeInsetsGeometry.symmetric(horizontal: 2), //geometery le garda na dekhako hola typing
//               child: dot,
//             ),
//           )
//           .toList(),
//     );
//   }
// }
class ThreeDots extends StatefulWidget {
  const ThreeDots({super.key});

  @override
  State<ThreeDots> createState() => _ThreeDotsState();
}

class _ThreeDotsState extends State<ThreeDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double delay = index * 0.2;
        final double value = (_controller.value - delay).clamp(0.0, 1.0);

        return Transform.scale(scale: 0.5 + (value * 0.5), child: child);
      },
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _buildDot(index),
        ),
      ),
    );
  }
}
