library flutter_page_switcher;

import 'package:flutter/material.dart';

class PageSwitcher extends StatefulWidget {
  /// Uses a [PageView] widget to switch between pages provided by the
  /// constructor. The lifecycye is automatically handled which allows this
  /// widget to be completely declarative.
  const PageSwitcher({
    Key? key,
    required this.children,
    required this.pageIndex,
    this.animate = false,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  })  : assert(children.length >= 2),
        assert(
          pageIndex >= 0 && pageIndex < children.length,
          'Page index out of range',
        ),
        super(key: key);

  /// The pages being switched between.
  final List<Widget> children;

  /// The index of the page currently being shown.
  final int pageIndex;

  /// True if the [PageSwitcher] should a animate the transition between pages.
  final bool animate;

  /// The duration of the transition animation.
  final Duration duration;

  /// The animation curve i.e. acceleration of the animation.
  final Curve curve;

  @override
  _PageSwitcherState createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  /// The object used to change the page being shown by the [PageView].
  late final PageController _pageController =
      PageController(initialPage: widget.pageIndex);

  @override
  void didUpdateWidget(PageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Transitions to the new page if the [PageSwitcher] is rebuilt with a
    /// different pageIndex.
    if (oldWidget.pageIndex != widget.pageIndex && _pageController.hasClients) {
      if (widget.animate) {
        // Animated transition.
        _pageController.animateToPage(
          widget.pageIndex,
          duration: widget.duration,
          curve: widget.curve,
        );
      } else {
        // Transition without an animation.
        _pageController.jumpToPage(widget.pageIndex);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Disposes of the page controller once the widget is destroyed.
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,

      /// Prevents the PageView from being scrolled between pages.
      physics: const NeverScrollableScrollPhysics(),
      children: widget.children,
    );
  }
}
