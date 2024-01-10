import 'package:coincrux/screens/dashboard/news_feed/profile/profile_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import './settings/themeprovider.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../../resources/resources.dart';
import 'home/home_view.dart';
import 'news_feed/news_feed_view.dart';
import 'settings/settings_view.dart';

class DashBoardPage extends StatefulWidget {
  final int index;
  DashBoardPage({Key? key, this.index = 0}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}
// ThemeData customBottomNavBarTheme = ThemeData(
//   canvasColor: R.colors.bgColor, // Set the background color
//   primaryColor: R.colors.theme, // Set the primary color
// );

class _DashBoardPageState extends State<DashBoardPage> {
  int currentPage = 0;
  late PageController pageController;

  @override
  void initState() {
    Provider.of<NewsProvider>(context, listen: false).listenToNews();
    currentPage = 1;
    pageController = PageController(initialPage: 1);
    super.initState();
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? R.colors.navButtonColor : R.colors.whiteColor,
          size: FetchPixels.getPixelHeight(30),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? R.colors.navButtonColor : R.colors.whiteColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<ThemeProvider>(builder: (context, auth, child) {
      return Scaffold(
        backgroundColor: R.colors.bgColor,
        body: SafeArea(
          child: getPaddingWidget(
            EdgeInsets.symmetric(
              horizontal: FetchPixels.getPixelWidth(0),
            ),
            PageView(
              controller: pageController,
              physics: BouncingScrollPhysics(), // Allow swiping
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: [
                HomeView(),
                NewsFeedView(),
                SettingsView(),
                ProfileView()
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Divider
            Divider(
              height: 1,
              color: Colors.grey[300], // You can adjust the color here
              thickness: 1,
            ),
            

            BottomNavigationBar(
              //to set the theme of bottom navigation bar
backgroundColor: R.colors.bgColor,
              selectedItemColor: R.colors.navButtonColor,
              unselectedItemColor: R.colors.whiteColor,
              showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
              currentIndex: currentPage,
              onTap: (index) {
                setState(() {
                  currentPage = index;
                });
                pageController.jumpToPage(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavItem(
                    Icons.home,
                    'Home',
                    currentPage == 0,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem(
                    Icons.newspaper,
                    'News',
                    currentPage == 1,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem(
                    Icons.settings,
                    'Settings',
                    currentPage == 2,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem(
                    Icons.person,
                    'Profile',
                    currentPage == 3,
                  ),
                  label: '',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
