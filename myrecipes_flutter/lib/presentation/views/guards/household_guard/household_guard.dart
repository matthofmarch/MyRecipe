import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/group_repository/group_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/guards/household_guard/household_guard_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/root_bottom_navigation/root_bottom_navigation.dart';
import 'package:myrecipes_flutter/presentation/views/screens/user_settings/user_settings.dart';

class HouseholdGuard extends StatelessWidget {
  final householdNameController = TextEditingController();
  final householdInviteCodeController = TextEditingController();

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
            return Scaffold(
              appBar: AppBar(
                title: Text("Household"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings_outlined),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserSettings(),
                        ),
                      );
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            "assets/haus.svg",
                            width: 180,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Create or join a household",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _showJoinGroupDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Center(
                                  child: Text(
                                "Join Household",
                                style: TextStyle(fontSize: 17),
                              )),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No household to join?"),
                          TextButton(
                              onPressed: () {
                                _showCreateGroupDialog(context);
                              },
                              child: Text("Create your own!"))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) => showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Create a new Household"),
            content: TextFormField(
              controller: householdNameController,
              decoration: InputDecoration(labelText: "Household Name"),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
              OutlinedButton(
                onPressed: () async {
                  await BlocProvider.of<HouseholdGuardCubit>(context)
                      .createHousehold(householdNameController.text);
                  Navigator.of(context).pop();
                },
                child: Text("Create Household"),
              ),
            ],
          );
        },
      );

  void _showJoinGroupDialog(BuildContext context) => showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Join a household"),
            content: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: householdInviteCodeController,
                    decoration: InputDecoration(labelText: "Invite Code"),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.qr_code),
                    onPressed: () async {
                      String qrCodeResult = await _scan();
                      await BlocProvider.of<HouseholdGuardCubit>(context)
                          .joinWithCode(qrCodeResult);
                      Navigator.of(context).pop();
                    })
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
              OutlinedButton(
                onPressed: () async {
                  await BlocProvider.of<HouseholdGuardCubit>(context)
                      .joinWithCode(householdInviteCodeController.text);
                  Navigator.of(context).pop();
                },
                child: Text("Join"),
              ),
            ],
          );
        },
      );

  Future<String> _scan() async {
    ScanResult result = await BarcodeScanner.scan();
    return result.rawContent;
  }
}
