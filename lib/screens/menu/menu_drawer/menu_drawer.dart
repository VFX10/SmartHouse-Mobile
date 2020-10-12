import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/firebase.dart';
import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/states_manager.dart';

import 'package:Homey/screens/login.dart';
import 'package:Homey/states/menu_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuDrawer extends StatelessWidget {
  MenuDrawer(this.state);

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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex:2,
                          child: AspectRatio(
                            aspectRatio: 1/1,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration:const ShapeDecoration(
                                shape:  CircleBorder(),
                                color: ColorsTheme.backgroundDarker,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppDataManager().userData.firstName.substring(0,1).toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorsTheme.accent,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      AppDataManager().userData.lastName.substring(0,1).toUpperCase(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppDataManager().userData.firstName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    AppDataManager().userData.lastName,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Text(
                                AppDataManager().userData.email,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: IconButton(
                            onPressed: () => logout(context),
                            icon: const Icon(MdiIcons.logout),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      color: ColorsTheme.backgroundDarker,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(flex: 2, child: Icon(MdiIcons.homeOutline)),
                        Expanded(
                          flex: 8,
                          child: StreamBuilder<HomeModel>(
                              stream: state.selectedHomeStream$,
                              builder: (BuildContext context,
                                  AsyncSnapshot<HomeModel> snapshot) {
                                return DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  decoration: const InputDecoration.collapsed(
                                    hintStyle: TextStyle(color: ColorsTheme.textColor),
                                      hintText: 'Home'),
                                  onChanged: (int value) {
                                    state.changeHouse(houseId: value);
                                    Navigator.pop(context);
                                  },
                                  value: state.selectedHome.id,
                                  items: houses,
                                  style: const TextStyle(color: ColorsTheme.textColor,),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RawMaterialButton(
                    elevation: 0,
                    onPressed: () {},
                    fillColor: ColorsTheme.backgroundDarker,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            Flexible(
                              flex: 2,
                              child: Icon(MdiIcons.tune,),
                            ),
                             Expanded(
                              flex: 8,
                              child:  Text(
                                'Home management',
                              ),
                            ),
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RawMaterialButton(
                    elevation: 0,
                    onPressed: () {},
                    fillColor: ColorsTheme.backgroundDarker,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: Icon(MdiIcons.playSpeed),
                            ),
                            const Expanded(
                              flex: 8,
                              child:  Text(
                                'Scenes',
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> logout(BuildContext context) async {
    getIt.get<FirebaseHelper>().onLogout();

    await AppDataManager().removeData();
    await Navigator.pushReplacement<dynamic, dynamic>(context,
        MaterialPageRoute<dynamic>(builder: (BuildContext context) => Login()));
  }
}
