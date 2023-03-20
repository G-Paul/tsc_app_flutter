import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../db/database.dart';
import './custom_rect_tween.dart';

class NavMenu extends StatefulWidget {
  NavMenu({super.key});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  final String _heroNavMenu = "hero-nav-menu";
  final user = auth.currentUser;
  bool _isRendered = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // print(
      //     "lkfsjdalksjflkjsfdlk----------------------------------------------------");
      setState(() {
        _isRendered = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Hero(
          tag: _heroNavMenu,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: Theme.of(context).backgroundColor,
            // elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: AnimatedCrossFade(
              crossFadeState: (!_isRendered)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500),
              firstChild: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              secondChild: Container(
                //add min height and width
                // padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  // scrollDirection: ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        height: 100,
                        child: Image(
                            image: AssetImage(
                                'assets/images/talent_sprint_class_logo_transparent.png')),
                      ),
                      //Student details
                      studentDetails(context, user!),
                      divider(),
                      customListTile(
                          context: context,
                          title: "Details",
                          icon: FontAwesomeIcons.info,
                          ontap: () {}),
                      divider(),
                      customListTile(
                          context: context,
                          title: "Fee Payment",
                          icon: FontAwesomeIcons.indianRupeeSign,
                          ontap: () {}),
                      divider(),
                      customListTile(
                          context: context,
                          title: "Settings",
                          icon: FontAwesomeIcons.gears,
                          ontap: () {}),
                      divider(),
                      customListTile(
                          context: context,
                          title: "Website",
                          icon: FontAwesomeIcons.rocket,
                          ontap: () {}),
                      divider(),
                      customListTile(
                          context: context,
                          title: "Sign Out",
                          icon: FontAwesomeIcons.arrowRightFromBracket,
                          ontap: () {
                            UserAuth().logout();
                            Navigator.pushReplacementNamed(
                                context, '/IntroScreen');
                          }),
                      divider(),
                      customListTile(
                          context: context,
                          title: "About",
                          icon: FontAwesomeIcons.code,
                          ontap: () {}),
                      //menu list

                      // Text("Talent Sprint Classes",
                      //     style: Theme.of(context).textTheme.titleLarge),
                      // SizedBox(height: 20),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       UserAuth().logout();
                      //       Navigator.pushReplacementNamed(
                      //           context, '/IntroScreen');
                      //     },
                      //     child: Text(
                      //       "SignOut",
                      //       // style: Theme.of(context).textTheme.displayMedium,
                      //     )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget studentDetails(BuildContext context, User user) {
  final box_width = MediaQuery.of(context).size.width * 0.9;
  final avatar_radius = box_width / 9;
  final padding = 20.0;
  final userclass = 10;
  final usercourse = "ICSE";
  return Padding(
    padding: EdgeInsets.all(padding),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          radius: avatar_radius,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/cristina_avatar.png'),
            radius: avatar_radius - 4,
          ),
        ),
        SizedBox(
          width: padding,
        ),
        Container(
          // height: avatar_radius * 2,
          // decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // decoration: BoxDecoration(color: Colors.orange),
                width: box_width - avatar_radius * 2 - padding * 3,
                child: Text(
                  user.displayName!,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                // decoration: BoxDecoration(color: Colors.blue),
                width: box_width - avatar_radius * 2 - padding * 3,
                child: Text("Class $userclass \u30fb $usercourse",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              // SizedBox(height: 5),
              // Text(
              //   "Click to Edit",
              //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //       fontSize: 10,
              //       color: Theme.of(context)
              //           .textTheme
              //           .titleLarge!
              //           .color!
              //           .withOpacity(0.5)),
              // )
            ],
          ),
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: FaIcon(FontAwesomeIcons.penToSquare,
        //       color: Theme.of(context).focusColor),
        //   iconSize: 15,
        // )
      ],
    ),
  );
}

Widget divider() {
  return Divider(
    height: 5,
    color: Color.fromARGB(212, 125, 125, 125),
    indent: 20,
    endIndent: 20,
  );
}

Widget customListTile(
    {required BuildContext context,
    required String title,
    required IconData icon,
    required Function ontap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ListTile(
      title: Text(title,
          style:
              Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 17)),
      leading: FaIcon(
        icon,
        color: Theme.of(context).focusColor,
        size: 20,
      ),
      onTap: (() => ontap()),
    ),
  );
}
