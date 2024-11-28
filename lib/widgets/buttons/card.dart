import 'package:flutter/material.dart';
import "package:carbonet/utils/app_colors.dart";

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.backgroundColor = AppColors.fontDark,
    this.iconBackgroundColor = AppColors.fontDimmed,
    this.iconColor = Colors.white,
    this.titleColor = Colors.white,
    this.subtitleColor = AppColors.fontBright,
    this.leftArrowColor = Colors.white,
    this.boxShadow,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color leftArrowColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: backgroundColor,
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 44,
                        color: iconColor,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 85,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(26.0, 0.0, 0.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: titleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.0,
                                ),
                              ),
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 85,
                width: 85,
                color: backgroundColor,
                child: Transform.flip(
                  flipX: true,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: leftArrowColor,
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
