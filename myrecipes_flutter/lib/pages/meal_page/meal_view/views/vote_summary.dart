import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VoteSummary extends StatelessWidget {
  int upvotes;
  int downvotes;
  Null Function() upvoteCallback;
  Null Function() downvoteCallback;

  VoteSummary(this.upvotes, this.downvotes, {this.upvoteCallback, this.downvoteCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: upvoteCallback,
                    child: Icon(Icons.arrow_drop_up_outlined, color: Colors.green,size: 24)),
                Text("$upvotes"),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: downvoteCallback,
                    child: Icon(Icons.arrow_drop_down_outlined, color: Colors.red,size: 24,)),
                Text("$downvotes"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
