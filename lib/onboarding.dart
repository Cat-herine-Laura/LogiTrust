import 'package:flutter/material.dart';
// import 'package:flutter/color_extensions.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;

  List infoArr = [
    {
      "title": "Quick search",
      "sub_title": "Set your location to start exploring\nSchools around you",
      "icon": "assets/img/search.mp4"
    },
    {
      "title": "Search for a school",
      "sub_title": "Find the school\naccording to your choice of location",
      "icon": "assets/img/school.mp4"
    },
    {
      "title": "Partnership",
      "sub_title": "We have been parterned with several schools",
      "icon": "assets/img/deal.png"
    },
    {
      "title": "Good services",
      "sub_title":
          "We are here\nto provide with suitable\nresources of finding your suitable school",
      "icon": "images/quality-service.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(children: [
          PageView.builder(
              itemCount: infoArr.length,
              itemBuilder: (context, index) {
                var i0bj = infoArr[index] as Map? ?? {};
                return Column(
                  children: [
                    Image.asset(
                      i0bj["name"].toString(),
                      width: media.width * 0.5,
                      height: media.width * 0.5,
                      fit: BoxFit.fitWidth,
                    )
                  ],
                );
              }),
          const Column(
            children: [],
          )
        ]),
      ),
    );
  }
}