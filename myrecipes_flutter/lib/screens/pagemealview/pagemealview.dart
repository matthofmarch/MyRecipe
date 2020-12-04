import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PageMealView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: PageView.custom(
        controller: PageController(
          viewportFraction: 1/3,
          initialPage: -4
        ),
          physics: ClampingScrollPhysics(
          ),

        childrenDelegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {

            return Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(width:1, color: Theme.of(context).dividerColor))
              ),
              child: Column(
                children: [
                  menuCard(context, index)
                ],
              ),
            );
          },
          childCount: 200,
        ),
        pageSnapping: true,
      ),
    );
  }

  menuCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network("https://img.derwesten.de/img/essen/crop227459569/058765356-w1200-cv16_9-q85/essen-burger.jpg",
                  fit: BoxFit.fitHeight,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4,),
                  PlatformText("Kebab $index",
                    style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: 8),
                  PlatformText("Greyhound divisively hello coldly w",
                    style: Theme.of(context).textTheme.caption,)
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
