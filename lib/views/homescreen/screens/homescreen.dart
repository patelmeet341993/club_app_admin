import 'package:club_app_admin/backend/club_backend/club_provider.dart';
import 'package:club_app_admin/views/brand/screens/brand_list_screen.dart';
import 'package:club_app_admin/views/club/screens/club_list_screen.dart';
import 'package:club_app_admin/views/club_operator/screens/club_operator_screen.dart';
import 'package:club_app_admin/views/product/screens/product_list_screen.dart';
import 'package:club_app_admin/views/system/screens/system_main_screen.dart';
import 'package:club_app_admin/views/users/screens/user_list_screen.dart';
import 'package:club_model/club_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/common/menu_provider.dart';
import '../../common/components/app_response.dart';
import '../../common/components/side_bar.dart';
import '../../notifications/screens/notification_list_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabNumber = 0;

  @override
  void initState() {
    super.initState();
    MyPrint.printOnConsole('On Main Home Page');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, ClubProvider>(
      builder: (BuildContext context, AuthenticationProvider adminProvider, ClubProvider clubProvider,_) {
        AdminUserModel adminUserModel = adminProvider.getAdminUserModel();
        // ClubModel clubModel = clubProvider.getLoggedInClubModel();
        String adminType = "";
        adminType = adminUserModel.adminType;

        // if(adminUserModel.adminType.isEmpty){
        //   if(clubModel.adminType.isNotEmpty){
        //     adminType = clubModel.adminType;
        //   }
        // } else {
        //   adminType = adminUserModel.adminType;
        // }
        MyPrint.printOnConsole("adminType: $adminType");
        MyPrint.printOnConsole("adminUserModel: ${adminUserModel.adminType}");
        return Scaffold(
          drawer: SideBar(
            drawerListTile: [
              DrawerListTile(
                title: "Products",
                icon: Icons.account_box_outlined,
                press: () {
                  setState(() {
                    tabNumber = 0;
                  });
                },
              ),
              DrawerListTile(
                title: "Clubs",
                icon: Icons.view_in_ar_outlined,
                press: () {
                  setState(() {
                    tabNumber = 1;
                  });
                },
              ),
              DrawerListTile(
                title: "Club Operators",
                icon: Icons.person_outline,
                press: () {
                  setState(() {
                    tabNumber = 2;
                  });
                },
              ),
              DrawerListTile(
                title: "Brands",
                icon: Icons.branding_watermark,
                press: () {
                  setState(() {
                    tabNumber = 3;
                  });
                },
              ),
              DrawerListTile(
                title: "Users",
                icon: Icons.person_outline,
                press: () {
                  setState(() {
                    tabNumber = 4;
                  });
                },
              ),
              DrawerListTile(
                title: "System",
                icon: Icons.library_books_outlined,
                press: () {
                  setState(() {
                    tabNumber = 5;
                  });
                },
              ),
              DrawerListTile(
                title: "Notifications",
                icon: Icons.notifications_none,
                press: () {
                  setState(() {
                    tabNumber = 6;
                  });
                },
              ),
            ],
          ),
          key: Provider.of<MenuProvider>(context, listen: false).scaffoldKey,
          backgroundColor: Styles.bgSideMenu,
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (AppResponsive.isDesktop(context))
                  Expanded(
                    child: SideBar(
                      drawerListTile: [
                        DrawerListTile(
                          title: "Products",
                          icon: Icons.account_box_outlined,
                          press: () {
                            setState(() {
                              tabNumber = 0;
                            });
                          },
                        ),
                        DrawerListTile(
                          title: "Clubs",
                          icon: Icons.view_in_ar_outlined,
                          press: () {
                            setState(() {
                              tabNumber = 1;
                            });
                          },
                        ),
                        DrawerListTile(
                          title: "Club Operators",
                          icon: Icons.person_outline,
                          press: () {
                            setState(() {
                              tabNumber = 2;
                            });
                          },
                        ),
                        DrawerListTile(
                          title: "Brands",
                          icon: Icons.branding_watermark,
                          press: () {
                            setState(() {
                              tabNumber = 3;
                            });
                          },
                        ),
                        DrawerListTile(
                          title: "Users",
                          icon: Icons.person_outline,
                          press: () {
                            setState(() {
                              tabNumber = 4;
                            });
                          },
                        ),
                        DrawerListTile(
                          title: "System",
                          icon: Icons.library_books_outlined,
                          press: () {
                            setState(() {
                              tabNumber = 5;
                            });
                          },
                        ),
                        DrawerListTile(
                          title: "Notifications",
                          icon: Icons.notifications_none,
                          press: () {
                            setState(() {
                              tabNumber = 6;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                /// Main Body Part
                Expanded(
                  flex: 4,
                  child: Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Styles.bgColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: getPageWidget(tabNumber)),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget getPageWidget(int number) {
    switch (number) {
      case 0:
        {
          return const ProductScreenNavigator();
        }
      case 1:
        {
          return const ClubScreenNavigator();
        }
      case 2:
        {
          return const ClubOperatorScreenNavigator();
        }
      case 3:
        {
          return const BrandListScreenNavigator();
        }
      case 4:
        {
          return const UserScreenNavigator();
        }
      case 5:
        {
          return const SystemScreenNavigator();
        }
      case 6:
        {
          return const NotificationListScreenNavigator();
        }
      default:
        {
          return const SystemScreenNavigator();
        }
    }
  }
}
