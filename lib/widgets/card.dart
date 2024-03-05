import 'package:flutter/material.dart';
import 'package:carbonet/assets/app_colors.dart';
// import 'package:carbonet/utils/logger.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    // this.trailing,
  });
  // Um Widget que é mostrado antes do
  final IconData icon;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 5),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 85,
                    height: 85,
                    decoration: const BoxDecoration(
                        color: AppColors.defaultBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0))),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(
                            icon,
                            size: 44,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 85,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(26.0, 0.0, 0.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                      fontSize: 16.0,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 85,
                width: 85,
                child: Transform.flip(
                  flipX: true,
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.defaultBlue,
                    size: 35.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
