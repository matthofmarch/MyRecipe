import 'package:auth_repository/auth_repository.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:group_repository/group_repository.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/auth_guard/cubit/auth_guard_cubit.dart';
import 'package:myrecipes_flutter/views/members/cubit/memberships_cubit.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Members in " + group.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Column(
                        children: [
                          ...group.members.map(
                            (member) => ListTile(
                              leading: Icon(Icons.person),
                              title: Text(member.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (member.email ==
                                      RepositoryProvider.of<AuthRepository>(
                                              context)
                                          .authState
                                          .email)
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Chip(
                                        label: Text(
                                          "You",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                  if (member.isAdmin)
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Chip(
                                        label: Text(
                                          "Admin",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                        ),
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
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
}
