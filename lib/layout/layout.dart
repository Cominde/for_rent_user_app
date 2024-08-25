
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liliijar/generated/assets.dart';
import 'package:liliijar/layout/bottom_navbar_custom.dart';
import 'package:navigation_view/item_navigation_view.dart';
import 'package:navigation_view/navigation_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Layout extends StatefulWidget {
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<cubit,States>(
        listener: (context, state) {
        },
        builder:(context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,

              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Align(alignment: Alignment.topLeft, child: Text(
                      'Powered By',
                      style: TextStyle(color: Colors.grey, fontSize: 8),
                    ),),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => launchUrl(Uri.parse('https://cominde.onrender.com')),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(Assets.assetsIcon512),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello!',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              'Rent Clothes and Decorations',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: cubit.get(context).screens[cubit.get(context).screenIndex],

            bottomNavigationBar: BottomNavbarCustom(
              onChangePage: (c) {
                setState(() {
                  cubit.get(context).screenIndex=c;
                });
              },
              items: [
                NavigationBarItemCustom(
                    selectedChild: Icon(
                      Icons.home_rounded,
                      color: Colors.green,
                      size: 30,
                    ),
                    unselectedChild: Icon(
                      Icons.home_outlined,
                      color: Colors.grey.withAlpha(60),
                      size: 30,
                    )
                ),
                NavigationBarItemCustom(
                    selectedChild: Icon(
                      Icons.category,
                      color: Colors.green,
                      size: 30,
                    ),
                    unselectedChild: Icon(
                      Icons.category_outlined,
                      color: Colors.grey.withAlpha(60),
                      size: 30,
                    )
                ),
              ],
            )
          );
        },
    );


  }
}
