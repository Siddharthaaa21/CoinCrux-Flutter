import 'dart:io';

import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/repository/signin_firebase.dart';
import 'package:coincrux/routes/app_pages.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/news_feed_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/profile/profile_view.dart';
import 'package:coincrux/screens/dashboard/profile.dart';
import 'package:coincrux/screens/dashboard/settings/pages/about_us.dart';
import 'package:coincrux/screens/dashboard/settings/pages/book_marks_view.dart';
import 'package:coincrux/screens/dashboard/settings/pages/feedback_view.dart';
import 'package:coincrux/screens/dashboard/settings/pages/privacy_policy.dart';
import 'package:coincrux/screens/dashboard/settings/pages/terms_condition.dart';
import 'package:coincrux/screens/dashboard/settings/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../base/widget_utils.dart';
import '../../../resources/resources.dart';
import '../../../routes/app_routes.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isDark = false;
  bool isNotifications = false;
  List<String> pagesNames = [
    "Terms & Conditions",
    "Privacy Policy",
    "About Us",
    "Share App",
    "Rate App",
  ];

  Widget pagesName(index) {
    return GestureDetector(
  onTap: () async {
    if (index == 0) {
      const url = 'https://workdrive.zoho.in/file/k5hed31953f3fd4034aa298842746a0853d7e';
    
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
    } else if (index == 1) {
    const url = 'https://workdrive.zohopublic.in/file/lhv42107d77e2c4d144f9994c9a3603689a85';
    
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  } else if (index == 2) {
      Get.to(AboutUs());
    }
  },
      child: Column(
        children: [
          Row(
            children: [
              index == 0
                  ? getAssetImage(R.images.terms,
                      scale: 25, color: Colors.grey)
                  : index == 1
                      ? getAssetImage(R.images.privacy,
                          scale: 25, color: Colors.grey)
                      : index == 2
                          ? getAssetImage(R.images.info,
                              scale: 25, color: Colors.grey )
                          : index == 3
                              ? getAssetImage(R.images.share,
                                  scale: 4, color:Colors.grey )
                              : getAssetImage(R.images.star,
                                  scale: 25, color:Colors.grey ),
              SizedBox(
                width: FetchPixels.getPixelWidth(10),
              ),
              Text(
                pagesNames[index],
                style: R.textStyle.regularLato().copyWith(
                      fontSize: FetchPixels.getPixelHeight(18),
                      color: R.colors.whiteColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
  backgroundColor: R.colors.bgColor,
  appBar: AppBar(
    iconTheme: IconThemeData(
      color: R.colors.blackColor, // Change your color here
    ),
    elevation: 0.0,
    backgroundColor: R.colors.bgColor,
    centerTitle: true,
    title: Text(
      "Settings",
      style: R.textStyle.mediumLato().copyWith(
        fontSize: FetchPixels.getPixelHeight(21),
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          GoogleSignIn().signOut();
          firebaseAuth.signOut();
          Get.offAllNamed(Routes.loginView);
        },
        icon: Icon(
          Icons.logout,
          color: R.colors.blackColor,
        ),
      )
    ],
    bottom: PreferredSize(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        height: 1.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.4), // Set the color of the line with opacity
              width: 1.0, // Set the width of the line
            ),
          ),
        ),
      ),
      preferredSize: Size.fromHeight(1.0),
    ),
  ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: FetchPixels.getPixelHeight(60),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: R.textStyle.regularLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(17),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                    child: Switch(
                      activeColor: R.colors.theme,
                      value: isNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          isNotifications = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(25),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark mode',
                    style: R.textStyle.regularLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(17),
                          fontWeight: FontWeight.bold,

                        ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                    child: Switch(
                      activeColor: R.colors.theme,
                      value: themeProvider.themeMode == ThemeModeType.Dark,
                      onChanged: (bool value) {
                        setState(() {
                          themeProvider.toggleTheme();
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(25),
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(60),
              ),
             

             
             


    
              SizedBox(
                height: FetchPixels.getPixelHeight(25),
              ),
        Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABOUT COINCRUX',
                      style: R.textStyle.mediumLato().copyWith(
                            fontSize: FetchPixels.getPixelHeight(15),
                            color: Colors.grey,

                          ),
                    ),
                    SizedBox(height: 5), // Adjust spacing as needed

                    // Divider widget for the separator line
          
                  ],
                ),

              ),
              
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: FetchPixels.getPixelHeight(5),
                  ),
                  itemCount: pagesNames.length,
                  
                  //add font color 

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 25),
                      
                      child: pagesName(index),

                    );
                  },
                ),
              ),

              SizedBox(
                height: FetchPixels.getPixelHeight(25),
              ),


            ],
          ),
        ),
        );


  }
}
