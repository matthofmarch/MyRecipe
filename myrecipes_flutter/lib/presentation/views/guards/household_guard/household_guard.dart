import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/group_repository/group_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/guards/household_guard/household_guard_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/root_bottom_navigation/root_bottom_navigation.dart';

class HouseholdGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HouseholdGuardCubit>(
      create: (context) =>
          HouseholdGuardCubit(RepositoryProvider.of<GroupRepository>(context)),
      child: BlocBuilder<HouseholdGuardCubit, HouseholdGuardState>(
        builder: (context, state) {
          if (state is HouseholdGuardInitial) {
            BlocProvider.of<HouseholdGuardCubit>(context).checkHouseholdState();
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HouseholdGuardInGroup) {
            return RootBottomNavigation();
          }
          if (state is HouseholdGuardCreateOrJoin) {
            final householdNameController = TextEditingController();
            final householdInviteCodeController = TextEditingController();
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create or join household",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: householdNameController,
                                decoration: InputDecoration(labelText: "Name"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await BlocProvider.of<HouseholdGuardCubit>(
                                          context)
                                      .createHousehold(
                                          householdNameController.text);
                                },
                                child: Text("Create Household"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: householdInviteCodeController,
                                decoration:
                                    InputDecoration(labelText: "Invite Code"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await BlocProvider.of<HouseholdGuardCubit>(
                                          context)
                                      .joinWithCode(
                                          householdInviteCodeController.text);
                                },
                                child: Text("Join Household"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
