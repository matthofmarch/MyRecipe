import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:group_repository/group_repository.dart';
import 'package:myrecipes_flutter/content_root/content_root.dart';
import 'package:myrecipes_flutter/household_guard/cubit/household_guard_cubit.dart';

class HouseholdGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HouseholdGuardCubit>(
      create: (context) => HouseholdGuardCubit(RepositoryProvider.of<GroupRepository>(context)),
      child: BlocBuilder<HouseholdGuardCubit, HouseholdGuardState>(
        builder: (context, state) {
          if(state is HouseholdGuardInitial){
            BlocProvider.of<HouseholdGuardCubit>(context).checkHouseholdState();
            return Center(child: CircularProgressIndicator(),);
          }
          if(state is HouseholdGuardInGroup){
            return ContentRoot();
          }
          if(state is HouseholdGuardCreateOrJoin){
            final householdNameController = TextEditingController();
            return Scaffold(
              body: Column(
                children: [
                  TextFormField(
                    controller: householdNameController,
                    decoration: InputDecoration(labelText: "Name of your Household"),
                  ),
                  PlatformButton(
                    materialFlat: (context, platform) => MaterialFlatButtonData(),
                    onPressed: () async {
                      await BlocProvider.of<HouseholdGuardCubit>(context).createHousehold(householdNameController.text);
                    },
                    child: Text("Create Household"),
                  ),

                  TextFormField(
                    controller: householdNameController,
                    decoration: InputDecoration(labelText: "Code of another household"),
                  ),
                  PlatformButton(
                    materialFlat: (context, platform) => MaterialFlatButtonData(),
                    onPressed: () async {
                      await BlocProvider.of<HouseholdGuardCubit>(context).joinWithCode(householdNameController.text);
                    },
                    child: Text("Create Household"),
                  ),

                ],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
