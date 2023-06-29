import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../services/map_services.dart';
import './search.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mapbooking.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> signUserOut() async {
    FirebaseAuth.instance.signOut();
  }
  late PageController _pageController;
  List allFavoritePlaces = [];
  late dynamic distancemeter=0 ;
  String placeImg = '';
  var tappedPoint;
  var radiusValue = 9000.0;
  String tokenKey = '';
  bool pressedNear = false;
  final key = 'AIzaSyDaUG88b5nV0n7Unyjsx0WNzdbVtUaaUpo';
  var tappedPlaceDetail;
  final myController = TextEditingController();
  Future<void> dista() async {
    final distancemeter=await distance();
  }

  @override
  void initState()  {
    // TODO: implement initState
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85);
    _determinePosition();
    place();
    super.initState();
  }
  Future<void> place() async {
    Position position=await _determinePosition();
    tappedPoint=LatLng(position.latitude, position.longitude);

    var placesResult = await MapServices()
        .getPlaceDetails(tappedPoint,
        radiusValue.toInt());

    List<dynamic> placesWithin =
    placesResult['results'] as List;

    allFavoritePlaces = placesWithin;

    tokenKey =
        placesResult['next_page_token'] ??
            'none';

    /*placesWithin.forEach((element) {
                                            _setNearMarker(
                                              LatLng(
                                                  element['geometry']
                                                      ['location']['lat'],
                                                  element['geometry']
                                                      ['location']['lng']),
                                              element['name'],
                                              element['types'],
                                              element['business_status'] ??
                                                  'not available',
                                            );
                                          });*/

    pressedNear = true;



    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Container(
            child: ListView(
              children: [
                const SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: Center(
                        child: Text(
                          'My Booking',
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ),
                    ),
                    Container(
                      width: 70,
                      child: Center(
                        child: Text(
                          'See All',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.black45, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    height: 240,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 200,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300]),
                          child: Text('My Bookings'),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 200,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300]),
                          child: Text('My Bookings'),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 200,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300]),
                          child: Text('My Bookings'),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '    Near by me',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                pressedNear
                    ? Positioned(
                    bottom: -120.0,
                    child: Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: allFavoritePlaces.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _nearbyPlacesList(index);
                          }),
                    )):Container()

              ],
            ),


            /* Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    height: 150,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 240,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300]),
                        child: Text('Charging Station Name'),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 240,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300]),
                        child: Text('Charging Station Name'),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 240,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300]),
                        child: Text('Charging Station Name'),
                      ),
                    ]),
                  ),
                )*/

          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height:230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            color: HexColor('#BEE5BE'),
          ),
        ),
        Positioned(
          right: 18,
          top: 15,
          child: Container(
            child: ProfilePicture(
              name: 'Abcded Xyz',
              radius: 30,
              fontsize: 25,
              tooltip: true,
              random: true,
              role: 'User',
            ),
          ),
        ),
        Positioned(
          top: 91,
          left: 20,
          child: Text(
            'Choose EV Charger',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        Positioned(
          top: 110,
          left: 20,
          child: Text(
            'Near by you',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        /*pressedNear
                    ? Positioned(
                        bottom: -120.0,
                        child: Container(
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: allFavoritePlaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _nearbyPlacesList(index);
                              }),
                        )):*/
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 140, horizontal: 10),
          child: Container(
            width: 390,
            height: 35,
            child: OutlinedButton.icon(
              label: Align(
                alignment: Alignment.centerLeft,
                child: Text('Search',
                    style: TextStyle(color: Colors.grey[400]),
                    textAlign: TextAlign.start),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const SearchPage();
                }));
              },
              icon: Icon(
                Icons.search,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        /*pressedNear
                    ? Positioned(
                        bottom: -120.0,
                        child: Container(
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: allFavoritePlaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _nearbyPlacesList(index);
                              }),
                        )):*/



      ]
      ),
    );
  }
  _nearbyPlacesList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 190.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      /*child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
          if (cardTapped) {
            tappedPlaceDetail = await MapServices()
                .getPlace(allFavoritePlaces[index]['place_id']);
            setState(() {});
          }
          moveCameraSlightly();
        },*/
      child: Stack(
        children: [

          Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              height: 145.0,
              width: 275.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0)
                  ]),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: Row(
                  children: [
                    _pageController.position.haveDimensions
                        ? _pageController.page!.toInt() == index
                        ? Container(
                      height: 140.0,
                      width: 90.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(placeImg != ''
                                  ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                  : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                              fit: BoxFit.cover)),
                    )
                        : Container(
                      height: 90.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          color: Colors.blue),
                    )

                        : Container(),
                    SizedBox(width: 5.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 170.0,
                          child: Text(allFavoritePlaces[index]['name'],
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold)),
                        ),
                        RatingStars(
                          value: allFavoritePlaces[index]['rating']
                              .runtimeType ==
                              int
                              ? allFavoritePlaces[index]['rating'] * 1.0
                              : allFavoritePlaces[index]['rating'] ?? 0.0,
                          starCount: 5,
                          starSize: 10,
                          valueLabelColor: const Color(0xff9b9b9b),
                          valueLabelTextStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          valueLabelRadius: 10,
                          maxValue: 5,
                          starSpacing: 2,
                          maxValueVisibility: false,
                          valueLabelVisibility: true,
                          animationDuration: Duration(milliseconds: 1000),
                          valueLabelPadding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 8),
                          valueLabelMargin: const EdgeInsets.only(right: 8),
                          starOffColor: const Color(0xffe7e8ea),
                          starColor: Colors.yellow,
                        ),
                        Container(
                          width: 170.0,
                          child: Text(
                            allFavoritePlaces[index]['business_status'] ??
                                'none',
                            style: TextStyle(
                                color: allFavoritePlaces[index]
                                ['business_status'] ==
                                    'OPERATIONAL'
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            width: 120,
                            height: 30,
                            child: TextButton(onPressed: () async {
                              tappedPlaceDetail = await MapServices().getPlace(allFavoritePlaces[index]['place_id']);
                              Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context){
                                return  MapBooking(name:allFavoritePlaces[index]['name'],address: tappedPlaceDetail['formatted_address']);
                              }));
                            },
                                style: TextButton.styleFrom(backgroundColor:HexColor('#18731B'),alignment: Alignment.center),
                                child: Text('Book Now',style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 170,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: TextDirection.rtl,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(

                                      height: 20,
                                      width: 60,
                                      decoration: BoxDecoration(color: Colors.white),
                                      child: TextField(
                                        controller: myController,
                                        readOnly: true,

                                        style: TextStyle(color: Colors.black),
                                      )
                                  ),
                                ),

                                Container(

                                    height: 33,
                                    width: 88,

                                    child: TextButton(onPressed: (){
                                      distance().then((_){
                                        setState(()  {

                                          distance();

                                          String displayName=distancemeter.toStringAsFixed(2);
                                          myController.text=displayName;


                                        });
                                      });




                                    }, style: TextButton.styleFrom(backgroundColor:HexColor('#18731B') ),
                                        child:Center(
                                          child: Text('Distance(KM)',style: TextStyle(color: Colors.white),),
                                        ) )
                                ),



                              ],
                            ),

                          ),
                        ),


                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );

  }


  Future<Position> _determinePosition() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled=await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error('Location services are disabled');
    }

    permission=await Geolocator.checkPermission();

    if(permission ==LocationPermission.denied){
      permission=await Geolocator.requestPermission();

      if(permission ==LocationPermission.denied){
        return Future.error('Location Permission denied');
      }
    }

    if(permission ==LocationPermission.deniedForever){
      return Future.error('Location permissions are Permanently denied');

    }

    Position position=await Geolocator.getCurrentPosition();

    return position;

  }

  Future<double> distance() async {
    Position position=await _determinePosition();


    distancemeter=Geolocator.distanceBetween(position.latitude, position.longitude,  allFavoritePlaces[_pageController.page!.toInt()]['geometry']
    ['location']['lat'],  allFavoritePlaces[_pageController.page!.toInt()]['geometry']
    ['location']['lng']);
    print(distancemeter);
    distancemeter=distancemeter*0.001;
    return distancemeter;
  }
}