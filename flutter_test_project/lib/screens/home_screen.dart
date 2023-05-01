import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_test_project/model/product_model.dart';
import 'package:flutter_test_project/services/product_service.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Future productFuture;
  ProductService _productService = ProductService();
  final CarouselController _controller = CarouselController();
  int _current = 0;
  List<Product> products = [];
  List<Product> displayedProducts = [];
  List<dynamic> displayedImages = [];

  // State For Navbar
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0;
  final iconList = <IconData>[
    Icons.home,
    Icons.shopping_bag,
    Icons.settings,
    Icons.person,
  ];

  final navbarTextList = ["Home", "Product", "Settings", "Profile"];

  // State For Scrolling
  double spaceBetween = 10.0;
  final _duration = Duration(milliseconds: 200);

  _onStartScroll(ScrollMetrics metrics) {}

  _onUpdateScroll(ScrollMetrics metrics) {
    if (spaceBetween == 30.0) return;
    spaceBetween = 30.0;
    setState(() {});
  }

  _onEndScroll(ScrollMetrics metrics) {
    spaceBetween = 10.0;
    setState(() {});
  }

  getProucts() async {
    var response = await _productService.getProduct();
    products = response;
    int increment = 0;
    products.forEach((element) {
      print(increment);
      if (increment != 5) {
        displayedImages.add(element.thumbnail);
        displayedProducts.add(element);
        increment = increment + 1;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
    productFuture = getProucts();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          _onStartScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollUpdateNotification) {
          _onUpdateScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollEndNotification) {
          _onEndScroll(scrollNotification.metrics);
        }
        return true; // see docs
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: productFuture,
                  builder: ((context, snapshot) {
                    Widget child;
                    if (snapshot.connectionState == ConnectionState.done) {
                      child = Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              height: 280,
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            carouselController: _controller,
                            items: displayedImages
                                .map((item) => Stack(
                                      children: [
                                        Container(
                                          height: 280,
                                          color: Colors.black,
                                          child: Image.network(
                                            item,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Container(
                                          height: 280,
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ),
                          Positioned(
                              left: 20,
                              top: 110,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Find the latest\nModel Here",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Shop Now"),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        18.0)))),
                                  )
                                ],
                              )),
                          Positioned(
                            right: 15,
                            top: 10,
                            child: Text(
                              "PhoNie",
                              style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  displayedImages.asMap().entries.map((entry) {
                                return GestureDetector(
                                  onTap: () {
                                    _controller.animateToPage(entry.key);
                                  },
                                  child: Container(
                                    width: 12.0,
                                    height: 12.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(
                                            _current == entry.key ? 0.9 : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      child = Container(
                        height: 280,
                        color: Colors.black.withOpacity(0.4),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return child;
                  })),
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Best Sellers",
                      style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                        future: productFuture,
                        builder: (context, snapshot) {
                          Widget child;
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            child = Container(
                                height: 200,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.vertical,
                                    autoPlay: true,
                                  ),
                                  items: displayedProducts
                                      .map(
                                        (item) => Stack(
                                          children: [
                                            Center(
                                                child: Image.network(
                                                    item.thumbnail,
                                                    fit: BoxFit.cover,
                                                    width: 1000)),
                                            Container(
                                              width: 1000,
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                            ),
                                            Positioned(
                                                bottom: 20,
                                                left: 20,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.title,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      "\$ ${item.price}",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ));
                          } else {
                            child = Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return child;
                        }),
                    const SizedBox(
                      height: 70,
                    ),
                    Text(
                      "Find your most suited phone.\nLike no one ever was \u{1F970}",
                      style: GoogleFonts.lato(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                        future: productFuture,
                        builder: (context, snapshot) {
                          Widget child;
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            child = CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 320,
                                enlargeFactor: 0.2,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                autoPlay: true,
                              ),
                              items: displayedProducts
                                  .map(
                                    (item) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Center(
                                                child: Image.network(
                                              item.thumbnail,
                                              fit: BoxFit.fill,
                                              width: 1000,
                                              height: 200,
                                            )),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            item.title,
                                            style: GoogleFonts.lato(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            item.description,
                                            maxLines: 2,
                                            style: GoogleFonts.lato(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black),
                                          ),
                                        ]),
                                  )
                                  .toList(),
                            );
                          } else {
                            child = Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return child;
                        }),
                  ],
                ),
              ),
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFFF7F27),
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.shopping_cart),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Color(0xFFFF7F27) : Color(0xFFFFFFFF);
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AutoSizeText(
                    navbarTextList[index],
                    maxLines: 1,
                    style: TextStyle(color: color),
                    group: autoSizeGroup,
                  ),
                )
              ],
            );
          },
          backgroundColor: Color(0xFF474747),
          activeIndex: _bottomNavIndex,
          splashColor: Color(0xFFFF7F27),
          notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          hideAnimationController: _hideBottomBarAnimationController,
          shadow: BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 12,
            spreadRadius: 0.5,
            color: Color(0xFF474747),
          ),
        ),
      ),
    );
  }
}
