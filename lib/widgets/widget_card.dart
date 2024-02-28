import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    // this.trailing,
  });
  // Um Widget que é mostrado antes do
  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      color: Color(0xFF0B6FF4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0))),
                  child: Expanded(
                    flex: 2,
                    child: icon,
                  ),
                ),
                SizedBox(
                  height: 85,
                  child: Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(26.0, 0.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24.0,
                              )),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Color(0xFF6E6E6E),
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
            SizedBox(
              height: 85,
              child: Transform.flip(
                flipX: true,
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF0B6FF4),
                  size: 35.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
