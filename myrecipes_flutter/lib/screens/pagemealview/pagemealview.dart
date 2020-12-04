import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PageMealView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.custom(
      controller: PageController(
        viewportFraction: 1 / 3,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              PlatformText("Page ${index}"),
            ],
          );
        },
        childCount: 200,
      ),
      pageSnapping: true,
    );
  }
}
