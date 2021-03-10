import 'package:flutter/material.dart';

class FliterOrderRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    return Container(
        color: darkModeOn? Theme.of(context).cardColor : Theme.of(context).colorScheme.background,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8,),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                child: MaterialButton(
                  height: 40,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("Filters",
                          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16,fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Icon(Icons.filter_alt_outlined, color: Theme.of(context).primaryColor, size: 18,),
                    ]
                  ),
                  onPressed: () {

                  },
                ),
              ),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                child: MaterialButton(
                  height: 40,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("Order",
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16,fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)
                        ),
                      ),
                      Icon(Icons.reorder_outlined, color: Theme.of(context).primaryColor, size: 18,),
                    ]
                  ),
                  onPressed: () {

                  },
                ),
              ),
            ),
            SizedBox(width: 8,)
          ],
        ));
  }
}
