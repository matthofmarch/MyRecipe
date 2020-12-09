import 'package:auth_repository/auth_repository.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/views/members/cubit/memberships_cubit.dart';

class MembershipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MembershipsCubit(RepositoryProvider.of<GroupRepository>(context)),
      child: BlocBuilder<MembershipsCubit, MembershipsState>(
        builder: (context, state) {
          if (state is MembershipsInitial) {
            BlocProvider.of<MembershipsCubit>(context).getOwnGroup();
            return Container();
          }
          if (state is MembershipsProgress) {
            return Container(child: Center(child: CircularProgressIndicator()));
          }
          if (state is MembershipsSuccess) {
            final group = state.group as Group;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Text(
                  "Memberships",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6,
                ),
                Divider(),
                Column(
                  children: [
                    ...group.members.map((member) =>
                        ListTile(
                            title: Text(member.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (member.email == RepositoryProvider.of<AuthRepository>(context).authState.email)Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Chip(label: Text("You"), backgroundColor: Theme.of(context).primaryColor,)
                                ),
                                if(member.isAdmin) Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Chip(label: Text("Admin"), backgroundColor: Theme.of(context).accentColor,)
                                ),
                              ],
                            )))
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
