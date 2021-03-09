import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/group_repository/group_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InviteView extends StatefulWidget {
  @override
  _InviteViewState createState() => _InviteViewState();
}

class _InviteViewState extends State<InviteView> {
  String _inviteCode;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: "",
        future: RepositoryProvider.of<GroupRepository>(context).getInviteCode(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Invite Code",style: Theme.of(context).textTheme.headline6),
                  IconButton(icon: Icon(Icons.refresh_outlined,size: 28,), onPressed: () {
                    setState(() {

                    });
                  },)
                ],
              ),
              SizedBox(height: 8,),
              Text(snapshot.data, style: Theme.of(context).textTheme.headline4,),
              QrImage(
                data: snapshot.data,
                version: QrVersions.auto,
                size: 200.0,
              ),
              Text("Code is one time use only!", style: Theme.of(context).textTheme.subtitle2,)
            ]),
          );
        });
  }
}
