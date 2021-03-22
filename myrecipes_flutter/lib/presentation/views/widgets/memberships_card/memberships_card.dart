import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myrecipes_flutter/domain/models/group.dart';
import 'package:myrecipes_flutter/domain/models/member.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/group_repository/group_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/widgets/memberships_card/memberships_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/inviteView/invite_view.dart';

const kChipDistance = 2.0;

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
              child: Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Members of \n",
                      maxLines: 1,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 25,fontWeight: FontWeight.w100),
                    ),
                    Text(
                      group.name,
                      maxLines: 1,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 40,fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Column(
                      children: [
                        ...group.members
                            .map((member) => _makeMemberTile(context, member)),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            showBarModalBottomSheet(
                                context: context,
                                builder: (context) => InviteView());
                          },
                          splashColor: Colors.transparent,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person_add_alt_1),
                              SizedBox(
                                width: 4,
                              ),
                              Text("Invite User")
                            ],
                          ),
                        )
                      ],
                    ),
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

  Widget _makeMemberTile(BuildContext context, Member member) {
    return ListTile(
        leading: Icon(Icons.person),
        title: Text(member.email,
          maxLines: 2,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.ellipsis,
        ),
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
