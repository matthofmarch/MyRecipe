import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/views/members/cubit/memberships_cubit.dart';

const kChipDistance = 2.0;

class MembershipsView extends StatelessWidget {
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Card(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 16,bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Members in " + group.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8,),
                      Divider(),
                      Column(
                        children: [
                          ...group.members
                              .map((member) => _makeMemberTile(context, member))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _makeMemberTile(BuildContext context, Member member) {
    return ListTile(
        leading: Icon(Icons.person),
        title: Text(member.email),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (member.email ==
              RepositoryProvider.of<AuthRepository>(context).authState.email)
            Padding(
              padding: const EdgeInsets.all(kChipDistance),
              child: Chip(
                label: Text(
                  "You",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.green),
                ),
                shape: StadiumBorder(
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          if (member.isAdmin)
            Padding(
              padding: const EdgeInsets.all(kChipDistance),
              child: Chip(
                label: Text(
                  "Admin",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                shape: StadiumBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            )
        ]));
  }
}
