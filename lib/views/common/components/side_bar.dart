
import 'package:club_model/club_model.dart';
import 'package:club_model/view/common/components/common_text.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  List<Widget> drawerListTile;
  SideBar({required this.drawerListTile});
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Styles.bgSideMenu,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: "Club App",
                    color: Styles.yellow,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  InkWell(
                      onTap: (){
                        // showDialog(context: context, builder: (context){
                        //   return NotificationDialog();
                        // });
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                          child: Icon(Icons.notifications,color: Colors.white,))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:widget.drawerListTile,
            ),
            Spacer(),
            Image.asset("assets/sidebar_image.png")
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  IconData icon;

  final VoidCallback press;

  DrawerListTile({required this.title,required this.icon, required this.press});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: Styles.white,
        size: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Styles.white),
      ),
    );
  }
}
