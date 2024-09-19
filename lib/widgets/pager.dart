import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Pager extends StatefulWidget {
  final List<Widget> pages;
  final List<String> hintTexts;
  final PageController pageViewController;
  final double heightFactor;

  const Pager({
    super.key,
    required this.pages,
    required this.hintTexts,
    required this.pageViewController,
    this.heightFactor = 0.5,
  });

  @override
  State<Pager> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  int _currentPageIndex = 0;
  double _currentProgress = 0.0;

  void _handlePageChanged(int currentPageIndex) {
    _currentProgress = _normalize(0, widget.pages.length - 1, currentPageIndex);
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  double _normalize(int min, int max, int value) {
    return (value - min) / (max - min);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: _currentProgress,
          minHeight: 5,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: AppColors.defaultAppColor,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                widget.pageViewController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Etapa ${_currentPageIndex + 1} de ${widget.pages.length}",
                  style: const TextStyle(
                    color: AppColors.fontDimmed,
                  ),
                ),
                Text(
                  widget.hintTexts[_currentPageIndex],
                  style: const TextStyle(
                    color: AppColors.fontBright,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * widget.heightFactor,
          child: PageView(
            controller: widget.pageViewController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: _handlePageChanged,
            children: widget.pages,
          ),
        ),
      ],
    );
  }
}