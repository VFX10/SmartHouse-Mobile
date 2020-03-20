import 'package:Homey/app_data_manager.dart';
import 'package:Homey/data/menu_state.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';

import 'package:Homey/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer(this.state);
  final MenuState state;

  final AppDataManager adm = AppDataManager();
  final List<DropdownMenuItem<int>> houses =
      List<DropdownMenuItem<int>>.generate(AppDataManager().houses.length,
          (int i) {
    return DropdownMenuItem<int>(
      value: AppDataManager().houses[i].id,
      child: Text(AppDataManager().houses[i].name),
    );
  });

  @override
  Widget build(BuildContext context) {
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
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(),
                      color: ColorsTheme.primary,
                    ),
                    child: StreamBuilder<HomeModel>(
                        stream: state.selectedHomeStream$,
                        builder: (BuildContext context,
                            AsyncSnapshot<HomeModel> snapshot) {
                          return DropdownButtonFormField<int>(
                            decoration: const InputDecoration.collapsed(
                                hintText: 'Home'),
                            onChanged: (int value) {
                              state.changeHouse(houseId: value);
                              Navigator.pop(context);
                            },
                            value: state.selectedHome.id,
                            items: houses,
                          );
                        }),
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
    await AppDataManager().removeData();
    await Navigator.pushReplacement<dynamic, dynamic>(context,
        MaterialPageRoute<dynamic>(builder: (BuildContext context) => Login()));
  }
}
