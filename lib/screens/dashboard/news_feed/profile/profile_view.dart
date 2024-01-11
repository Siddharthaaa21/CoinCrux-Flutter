import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/base/widget_utils.dart';
import 'package:coincrux/dialog/imagePicker.dart';
import 'package:coincrux/routes/app_routes.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/home/home_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/news_feed_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/profile/likedPosts.dart';
import 'package:coincrux/screens/dashboard/settings/pages/your_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../../resources/resources.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  List<String> pagesNames = [
    "Bookmarks",
    "Liked Posts",
    "Personalise your feed",
    "Delete Account",
  ];

  List<String> images = [
    R.images.save,
    R.images.like,
    R.images.feed,
    R.images.delete,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderApp>(
      builder: (context, auth, child) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: R.colors.blackColor, // Change your color here
              ),
              elevation: 0.0,
              backgroundColor: R.colors.bgColor,
              centerTitle: true,
              title: Text(
                "Profile",
                style: R.textStyle.mediumLato().copyWith(
                      fontSize: FetchPixels.getPixelHeight(21),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GoogleSignIn().signOut();
                    FirebaseAuth.instance.signOut();
                    Get.offAllNamed(Routes.loginView);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: R.colors.blackColor,
                  ),
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  HomeView();

                },
                icon: Icon(
                  Icons.arrow_back,
                  color: R.colors.blackColor,
                ),
              ),
            ),
            body: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: FetchPixels.getPixelHeight(20)),
                width: FetchPixels.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      FetchPixels.getPixelHeight(5),
                    ),
                    color: R.colors.bgColor),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: FetchPixels.width,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Consumer<AuthProviderApp>(
                                builder: (context, auth, child) {
                                  return Container(
                                      height: FetchPixels.getPixelHeight(125),
                                      width: FetchPixels.getPixelWidth(125),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: auth.userM.image == null ||
                                                    auth.userM.image!.isEmpty
                                                ? Container(
                                                    height: FetchPixels
                                                        .getPixelHeight(125),
                                                    width: FetchPixels
                                                        .getPixelWidth(125),
                                                    decoration: BoxDecoration(
                                                      color: R.colors
                                                              .isDarkTheme
                                                          ? R.colors.whiteColor
                                                              .withOpacity(0.1)
                                                          : R.colors.blackColor
                                                              .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  25)),
                                                    ),
                                                  )
                                                : Container(
                                                    height: FetchPixels
                                                        .getPixelHeight(100),
                                                    width: FetchPixels
                                                        .getPixelWidth(100),
                                                    decoration: BoxDecoration(
                                                        color: R.colors
                                                            .imageBgColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                auth.userM
                                                                    .image!),
                                                            fit: BoxFit.fill)),
                                                  ),
                                          ),
                                          Material(
                                              color: Colors.transparent,

                                              // Replace 'alignment' with an existing named parameter or define a new named parameter

                                              child: InkWell(
                                                onTap: () {
                                                  ImagePickerDialog
                                                      .imagePickerDialog(
                                                          context: context,
                                                          myHeight: FetchPixels
                                                              .height,
                                                          myWidth:
                                                              FetchPixels.width,
                                                          setFile: (f) async {
                                                            Reference ref =
                                                                storage.ref(
                                                                    'pic/${f.path}');
                                                            await ref
                                                                .putFile(f);
                                                            String downloadURL =
                                                                await ref
                                                                    .getDownloadURL();
                                                            firebaseFirestore
                                                                .collection(
                                                                    "users")
                                                                .doc(firebaseAuth
                                                                    .currentUser!
                                                                    .uid)
                                                                .update({
                                                              "image":
                                                                  downloadURL
                                                            }).then((value) {
                                                              auth.update();
                                                            });
                                                          });
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                        color: R
                                                            .colors.whiteColor
                                                            .withOpacity(0.1),
                                                        shape: BoxShape.circle),
                                                    child: Icon(
                                                      Icons.change_circle,
                                                      color:
                                                          R.colors.whiteColor,
                                                    )),
                                              ))
                                        ],
                                      ));
                                },
                              ),
                              SizedBox(height: FetchPixels.getPixelHeight(20)),
                              Text(
                                auth.userM.name ?? 'User Name',
                                style: R.textStyle.mediumLato().copyWith(
                                      fontSize: FetchPixels.getPixelHeight(17),
                                    ),
                              ),
                              SizedBox(height: FetchPixels.getPixelHeight(3)),
                              Text(
                                auth.userM.phone ?? 'Phone Number',
                                style: R.textStyle.regularLato().copyWith(
                                      fontSize: FetchPixels.getPixelHeight(14),
                                    ),
                              ),
                            ],
                          )),
                      SizedBox(height: FetchPixels.getPixelHeight(40)),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            vertical: FetchPixels.getPixelHeight(10),
                          ),
                          itemCount: pagesNames.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: pagesName(index),
                            );
                          },
                        ),
                      ),
                    ]),
              ),
            ));
        // return firebaseAuth.currentUser == null
        //     : FutureBuilder(
        //   future: firebaseFirestore.collection('users').doc(firebaseAuth.currentUser!.uid).get(),
        //     builder: (context,snapshot){
        //       if(snapshot.hasData){
        //         Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
        //         UserModel userModel = UserModel.fromJson(data);
        //         return ListView.builder(
        //           padding: EdgeInsets.symmetric(
        //               vertical: FetchPixels.getPixelHeight(30)),
        //           itemCount: images.length,
        //           itemBuilder: (context, index) {
        //             return pagesName(index);
        //           },
        //         );
        //       }else{
        //         return Center(child: SingleChildScrollView(),);
        //       }
        // });
      },
    );
  }

  Widget pagesName(index) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Get.toNamed(Routes.bookmark);
        } else if (index == 1) {
          Get.to(() => LikedPosts());
        } else if (index == 2) {
          Get.to(YourFeed());
        } else {
          deleteAccount();
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: FetchPixels.getPixelWidth(40),
                height: FetchPixels.getPixelHeight(25),
                child: index == 0
                    ? getAssetImage(R.images.save, scale: 45, color: R.colors.theme)
                    : index == 1
                        ? getAssetImage(R.images.like, scale: 45, color: R.colors.theme)
                        : index == 2
                            ? getAssetImage(R.images.feed, scale: 45, color: R.colors.theme,)
                            : getAssetImage(R.images.delete, scale: 45, color: R.colors.theme),
              ),
              SizedBox(
                width: FetchPixels.getPixelWidth(10),
              ),
              Text(
                pagesNames[index],
                style: R.textStyle.regularLato().copyWith(

                      fontSize: FetchPixels.getPixelHeight(19),
                      // fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteAccount() async {
    AuthProviderApp auth = Provider.of(context, listen: false);
    if (firebaseAuth.currentUser != null) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: CircularProgressIndicator(
              color: R.colors.theme,
            ));
          });
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        await firebaseAuth.currentUser
            ?.reauthenticateWithCredential(credential);
        firebaseFirestore
            .collection("users")
            .doc(firebaseAuth.currentUser!.uid)
            .delete()
            .then((value) {
          firebaseAuth.currentUser!.delete().then((value) {
            auth.userSubscription!.cancel();
            auth.dashCurrentPage = 2;
            auth.update();
            Navigator.pop(context);
          });
        });
      } catch (e) {
        print('Error reauthenticating user: $e');
      }
    }
  }
}
