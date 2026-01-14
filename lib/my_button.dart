import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onTab;
  final String buttonText;

  const MyButton({super.key, required this.onTab, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTab == null;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTab,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey.shade400
              : Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: isDisabled ? 0 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class MyButton extends StatelessWidget {
//   final VoidCallback? onTab;
//   final String buttonText;
//   final Widget? icon; // optional icon

//   const MyButton({
//     super.key,
//     required this.onTab,
//     required this.buttonText,
//     this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isDisabled = onTab == null;

//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: onTab,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isDisabled
//               ? Colors.grey.shade400
//               : Theme.of(context).primaryColor,
//           foregroundColor: Colors.white,
//           elevation: isDisabled ? 0 : 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (icon != null) ...[
//               icon!,
//               const SizedBox(width: 12),
//             ],
//             Text(
//               buttonText,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
