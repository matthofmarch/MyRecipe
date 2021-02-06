import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InviteView extends StatefulWidget {
  @override
  _InviteViewState createState() => _InviteViewState();
}

class _InviteViewState extends State<InviteView> {
  String _inviteCode;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(initialData: "",future: RepositoryProvider.of<GroupRepository>(context).getInviteCode(),builder: (context, snapshot) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Invite Code"), Icon(Icons.refresh_outlined)],
          ),
          Text(snapshot.data),
          QrImage(
            data: snapshot.data,
            version: QrVersions.auto,
            size: 200.0,
          ),
        Text("Code is one time use only!")
        ]);
      }
    );
  }
}
