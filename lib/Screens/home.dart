import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../services/map_services.dart';
import './search.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  List assets=[{"id":1,"image_path":'assets/images/1.jpg'},
               {"id":2,"image_path":'assets/images/2.jpg'},
               {"id":3,"image_path":'assets/images/3.jpg'},
               {"id":4,"image_path":'assets/images/4.jpg'},
               {"id":5,"image_path":'assets/images/4.webp'},
               {"id":6,"image_path":'assets/images/6.jpg'},
               {"id":7,"image_path":'assets/images/7.jpg'}];
  int currentIndex=0;             
  late PageController _pageController;
  List allFavoritePlaces = [];
  late dynamic distancemeter=0 ;
  String placeImg = '';
  String address="";
  var tappedPoint;
  var radiusValue = 9000.0;
  int prevPage = 0;
  dynamic lat,long;
  String tokenKey = '';
  bool pressedNear = false;
  final key = 'AIzaSyDaUG88b5nV0n7Unyjsx0WNzdbVtUaaUpo';
  var tappedPlaceDetail;
  final myController = TextEditingController();
  final CarouselController carouselController=CarouselController();
  Future<void> dista() async {
    final distancemeter=await distance();
  }

  @override
  void initState()  {
    // TODO: implement initState
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
    ..addListener(_onScroll);
    _determinePosition();
    place();
    convertToAddress();
    assets.shuffle();
    super.initState();
  }

 void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      fetchImage();
    }
  }

  convertToAddress() async {
      Dio dio = Dio(); 
      Position position=await _determinePosition();
      lat=position.latitude;
      long=position.longitude; //initilize dio package
      String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$key";
    
      Response response = await dio.get(apiurl); //send get request to API URL

      if(response.statusCode == 200){ //if connection is successful
          Map data = response.data; //get response data
          if(data["status"] == "OK"){ //if status is "OK" returned from REST API
              if(data["results"].length > 0){ //if there is atleast one address
                 Map firstresult = data["results"][0]; //select the first address

                 address = firstresult["formatted_address"]; //get the address

                
                 
                 setState(() {
                    //refresh UI
                 });
              }
          }else{
             print(data["error_message"]);
          }
      }else{
         print("error while fetching geoconding data");
      }  
  }

  void fetchImage() async {
    if (_pageController.page !=
        null) if (allFavoritePlaces[_pageController.page!.toInt()]
    ['photos'] !=
        null) {
      setState(() {
        placeImg = allFavoritePlaces[_pageController.page!.toInt()]['photos'][0]
        ['photo_reference'];
      });
    } else {
      placeImg = '';
    }
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

   

    pressedNear = true;


   if(this.mounted){
    setState(() {});}
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
                  height: 60,
                ),
              

                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child:InkWell(
                    onTap: () {
                      print(currentIndex);
                    },
                    child: CarouselSlider(items: assets
                                           .map(
                                            (item)=>Image.asset(
                                              item['image_path'],
                                              fit:BoxFit.cover ,
                                              width: double.infinity,
                                            ),
                                           ).toList(),
                                carouselController: carouselController,           
                     options:CarouselOptions(
                      scrollPhysics: const BouncingScrollPhysics(),
                      autoPlay: true,
                      height: 230,
                      autoPlayInterval: const Duration(seconds: 3),
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex=index;
                        });
                      },
                     ), 
                     ),
                  ),
                  
                 
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2,bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: assets.asMap().entries.map((entry){
                      print(entry);
                      print(entry.key);
                      return GestureDetector(
                        onTap: () => carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex==entry.key?17:7,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentIndex==entry.key
                            ?HexColor('#18731B')
                            :Colors.teal
                          ),
                        ),
                      );
                    }).toList(),
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
                    ? Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: allFavoritePlaces.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _nearbyPlacesList(index);
                          }),
                    ):Container()

              ],
            ),
            


            
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
              random: false,
              role: 'User',
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 40,
          child:Icon(Icons.location_on_outlined)
        ),
        Positioned(
          left: 33,
          top: 35,
          child:Container(
            height: 50,
            width: 150,
            child: Text(address,maxLines: 2),
          )
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
      
      child: Stack(
        children: [

          Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              height: 145.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 9.0),
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
                      width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(placeImg != ''
                                  ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                  : 'https://media.cnn.com/api/v1/images/stellar/prod/220608193558-02-electric-vehicle-charging-station.jpg?c=original'),
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
                          animationDuration: Duration(milliseconds: 100),
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