import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/screens/home_screen.dart';
import 'package:sm3ly/screens/library_screen.dart';
import 'package:sm3ly/screens/challenge_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = 'home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> screens = [
    const ChallengeScreen(),
    const HomeScreen(),
    const LibraryScreen(),
  ];
  int currentIndex = 1;
  bool changePage = true;
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    //  UserCubit.get(context).fetchUserData();
    // LibraryCubit.get(context).fetchLibraryData();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: screens,
          onPageChanged: (index) {
            setState(() {
              if (changePage) {
                currentIndex = index;
              }
            });
          },
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: MyColors.appBar,
          buttonBackgroundColor: MyColors.textButton,
          index: currentIndex,
          items: const [
            Icon(
              Icons.extension,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.home,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.library_add,
              size: 25,
              color: Colors.white,
            ),
          ],
          onTap: (index) async {
            setState(() {
              changePage = false;
              currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            });
            await Future.delayed(const Duration(milliseconds: 500));
            changePage = true;
          },
        ),
      ),
    );
  }
}
