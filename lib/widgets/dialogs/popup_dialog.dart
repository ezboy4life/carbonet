import 'package:flutter/material.dart';
import 'package:carbonet/widgets/buttons/gradient_button.dart';
import 'package:carbonet/utils/app_colors.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const PopupDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: const DialogTheme(
          elevation: 0,
        ),
      ),
      child: Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
            color: AppColors.fontDimmed,
          ),
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.2,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 100,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.fontBright,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GradientButton(
                  label: "OK",
                  buttonColors: const [
                    AppColors.defaultDarkAppColor,
                    AppColors.defaultAppColor,
                  ],
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// AlertDialog(
//       title: Row(
//         children: [
//           const Icon(Icons.error, color: Colors.white),
//           const SizedBox(
//             width: 10,
//           ),
//           Text(title, style: const TextStyle(color: Colors.white))
//         ],
//       ),
//       backgroundColor: const Color.fromARGB(255, 15, 15, 15),
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 1,
//         child:
//             Text(message, style: const TextStyle(color: AppColors.fontBright)),
//       ),
//       actions: <Widget>[
//         GradientButton(
//           label: "OK",
//           buttonColors: const [
//             AppColors.defaultDarkAppColor,
//             AppColors.defaultAppColor,
//           ],
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         )
//       ],
//     );
