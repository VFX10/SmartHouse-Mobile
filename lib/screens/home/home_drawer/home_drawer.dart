import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../home_page_state.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomePageState state = Provider.of<HomePageState>(context);
    final List<DropdownMenuItem<int>> houses = List<DropdownMenuItem<int>>.generate(
        AppDataManager().houses.length, (int i) {
      log('houses', error: AppDataManager().houses[i].name);

      return DropdownMenuItem<int>(
        value: AppDataManager().houses[i].id,
        child: Text(AppDataManager().houses[i].name),
      );
    });
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: ColorsTheme.background,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: ColorsTheme.primary,
                    ),
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration.collapsed(hintText: 'Home'),
                      onChanged: (int value) async {
                        log('changed', error: value);
                        for (final HomeModel home in AppDataManager().houses) {
                          if (home.id == value) {
                            await AppDataManager().changeDefaultHome(value);
                            state.selectedHome = AppDataManager().defaultHome;
                            state.selectedRooms = AppDataManager().defaultHome.rooms ?? <RoomModel>[];
                          }
                        }
                      },
                      value: state.selectedHome.id,
                      items: houses,
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: RawMaterialButton(
                  onPressed: () => logout(context),
                  shape: const StadiumBorder(),
                  fillColor: ColorsTheme.primary,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Spacer(
                        flex: 5,
                      ),
                      Icon(MdiIcons.logout),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Logout'),
                      Spacer(
                        flex: 5,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> logout(BuildContext context) async {

   Provider.of<HomePageState>(context, listen: false).setHome(null);
    await AppDataManager().removeData();
    await Navigator.pushReplacement<dynamic, dynamic>(
        context, MaterialPageRoute<dynamic>(builder: (BuildContext context) => Login()));
  }
}
