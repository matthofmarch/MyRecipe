import 'package:flutter/material.dart';

class FliterOrderRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        color: Colors.grey.shade300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10,),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                child: MaterialButton(
                  color: Colors.white,
                  child: Text("Filter"),
                  onPressed: () {

                  },
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                child: MaterialButton(
                  color: Colors.white,
                  child: Text("Order"),
                  onPressed: () {

                  },
                ),
              ),
            ),
            SizedBox(width: 10,)
          ],
        ));
  }
}
