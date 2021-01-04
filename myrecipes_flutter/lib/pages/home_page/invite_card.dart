import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';

class InviteCodeCard extends StatefulWidget {
  const InviteCodeCard({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InviteCodeCardState();
  }
}

class InviteCodeCardState extends State<InviteCodeCard> {
  bool _showInviteCode = false;
  String _inviteCode;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("InviteCode", style: Theme.of(context).textTheme.subtitle1,),
              FlatButton(
                  onPressed: () async {
                    if (_showInviteCode) {
                      setState(() {
                        _showInviteCode = false;
                      });
                    } else {
                      if (_inviteCode == null)
                        _inviteCode =
                        await RepositoryProvider.of<GroupRepository>(context)
                            .getInviteCode();

                      setState(() {
                        _inviteCode = _inviteCode;
                        _showInviteCode = true;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(_showInviteCode ? _inviteCode : "*****"),
                      SizedBox(
                        width: 8,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.remove_red_eye),
                          if(_showInviteCode) Icon(Icons.close, color: Theme.of(context).colorScheme.error, size: 32,)
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
