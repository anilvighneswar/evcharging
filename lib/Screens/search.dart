import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:evcharging/models/auto_complete_result.dart';
import 'package:evcharging/providers/search_places.dart';
import 'package:evcharging/services/map_services.dart';
import 'package:evcharging/Screens/mapbooking.dart';
import 'package:hexcolor/hexcolor.dart';

import 'dart:ui' as ui;

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<SearchPage> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapController;
  late dynamic distancemeter=0 ;

  final myController = TextEditingController();

//Debounce to throttle async calls during search
  Timer? _debounce;

//Toggling UI as we need;
  bool searchToggle = true;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;


//Markers set
  Set<Marker> _markers = Set<Marker>();
  Set<Marker> _markers1 = Set<Marker>();
  Set<Marker> _markersDupe = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  int markerIdCounter = 1;
  int polylineIdCounter = 1;

  var radiusValue = 9000.0;

  var tappedPoint;


  List allFavoritePlaces = [];

  String tokenKey = '';

  //Page controller for the nice pageview
  late PageController _pageController;
  int prevPage = 0;
  var tappedPlaceDetail;
  String placeImg = '';
  var photoGalleryIndex = 0;
  bool showBlankCard = false;
  bool isReviews = true;
  bool isPhotos = false;

  final key = 'AIzaSyDaUG88b5nV0n7Unyjsx0WNzdbVtUaaUpo';


  var selectedPlaceDetails;

//Circle
  Set<Circle> _circles = Set<Circle>();

//Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

//Initial map position on load
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.965068, 76.619654),
    zoom: 15.4746,
  );

  void _setMarker(point) {
    var counter = markerIdCounter++;

    Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
      _markers1.add(marker);



    });
  }


  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('raj'),
          center: point,
          radius: 8000,
          strokeColor: Colors.transparent,
          strokeWidth: 1));
      radiusSlider = true;
    });
  }

  _setNearMarker(LatLng point, String label, List types, String status) async {
    var counter = markerIdCounter++;

    final Uint8List markerIcon;

    if (types.contains('restaurants'))
      markerIcon =
      await getBytesFromAsset('assets/mapicons/restaurants.png', 75);
    else if (types.contains('food'))
      markerIcon = await getBytesFromAsset('assets/mapicons/food.png', 75);
    else if (types.contains('school'))
      markerIcon = await getBytesFromAsset('assets/mapicons/schools.png', 75);
    else if (types.contains('bar'))
      markerIcon = await getBytesFromAsset('assets/mapicons/bars.png', 75);
    else if (types.contains('lodging'))
      markerIcon = await getBytesFromAsset('assets/mapicons/hotels.png', 75);
    else if (types.contains('store'))
      markerIcon =
      await getBytesFromAsset('assets/mapicons/retail-stores.png', 75);
    else if (types.contains('locality'))
      markerIcon =
      await getBytesFromAsset('assets/mapicons/local-services.png', 75);
    else
      markerIcon = await getBytesFromAsset('assets/mapicons/automotive.png', 75);

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);
    _determinePosition();
    super.initState();
  }


  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      cardTapped = false;
      photoGalleryIndex = 1;
      showBlankCard = false;
      goToTappedPlace();
      fetchImage();
    }
  }

  Future<void> dista() async {
    final distancemeter=await distance();
  }

  //Fetch image to place inside the tile in the pageView
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: _markers,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    polylines: _polylines,
                    circles: _circles,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      googleMapController=controller;
                    },
                    onTap: (point) async {
                      tappedPoint = point;
                      _setCircle(point);
                      var placesResult = await MapServices()
                          .getPlaceDetails(tappedPoint,
                          radiusValue.toInt());

                      List<dynamic> placesWithin =
                      placesResult['results'] as List;

                      allFavoritePlaces = placesWithin;

                      tokenKey =
                          placesResult['next_page_token'] ??
                              'none';
                      _markers = {};
                      placesWithin.forEach((element) {
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
                      });
                      _markersDupe = _markers;
                      pressedNear = true;


                    },
                  ),
                ),
                searchToggle
                    ? Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
                  child: Column(children: [
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            border: InputBorder.none,
                            hintText: 'Search',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.text = '';
                                    _markers = {};
                                    if (searchFlag.searchToggle)
                                      searchFlag.toggleSearch();
                                  });
                                },
                                icon: Icon(Icons.close))),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false)
                            _debounce?.cancel();
                          _debounce = Timer(Duration(milliseconds: 700),
                                  () async {
                                if (value.length > 2) {
                                  if (!searchFlag.searchToggle) {
                                    searchFlag.toggleSearch();
                                    _markers = {};
                                  }

                                  List<AutoCompleteResult> searchResults =
                                  await MapServices().searchPlaces(value);

                                  allSearchResults.setResults(searchResults);
                                } else {
                                  List<AutoCompleteResult> emptyList = [];
                                  allSearchResults.setResults(emptyList);
                                }
                              });
                        },
                      ),
                    )
                  ]),
                )
                    : Container(),
                searchFlag.searchToggle
                    ? allSearchResults.allReturnedResults.length != 0
                    ? Positioned(
                    top: 100.0,
                    left: 15.0,
                    child: Container(
                      height: 200.0,
                      width: screenWidth - 30.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: ListView(
                        children: [
                          ...allSearchResults.allReturnedResults
                              .map((e) => buildListItem(e, searchFlag))
                        ],
                      ),
                    ))
                    : Positioned(
                    top: 100.0,
                    left: 15.0,
                    child: Container(
                      height: 200.0,
                      width: screenWidth - 30.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Center(
                        child: Column(children: [
                          Text('No results to show',
                              style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 5.0),
                          Container(
                            width: 125.0,
                            child: ElevatedButton(
                              onPressed: () {
                                searchFlag.toggleSearch();
                              },
                              child: Center(
                                child: Text(
                                  'Close this',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ))
                    : Container(),

                radiusSlider
                    ? Padding(
                  padding: EdgeInsets.fromLTRB(290.0, 95.0, 15.0, 0.0),
                  child: Container(
                    height: 50.0,
                    width: 50,
                    color: Colors.black.withOpacity(0.3),

                    child: Row(
                      children: [
                        /*Expanded(
                                  child: Slider(
                                      max: 7000.0,
                                      min: 1000.0,

                                      value: radiusValue,
                                      onChanged: (newVal) {
                                        radiusValue = newVal;
                                        pressedNear = false;
                                        _setCircle(tappedPoint);
                                      })),
                              !pressedNear
                                  ? /IconButton(
                                      onPressed: () {
                                        if (_debounce?.isActive ?? false)
                                          _debounce?.cancel();
                                        _debounce = Timer(Duration(seconds: 2),
                                            () async {
                                          var placesResult = await MapServices()
                                              .getPlaceDetails(tappedPoint,
                                                  radiusValue.toInt());

                                          List<dynamic> placesWithin =
                                              placesResult['results'] as List;

                                          allFavoritePlaces = placesWithin;

                                          tokenKey =
                                              placesResult['next_page_token'] ??
                                                  'none';
                                          _markers = {};
                                          placesWithin.forEach((element) {
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
                                          });
                                          _markersDupe = _markers;
                                          pressedNear = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.near_me,
                                        color: Colors.blue,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        if (_debounce?.isActive ?? false)
                                          _debounce?.cancel();
                                        _debounce = Timer(Duration(seconds: 2),
                                            () async {
                                          if (tokenKey != 'none') {
                                            var placesResult =
                                                await MapServices()
                                                    .getMorePlaceDetails(
                                                        tokenKey);

                                            List<dynamic> placesWithin =
                                                placesResult['results'] as List;

                                            allFavoritePlaces
                                                .addAll(placesWithin);

                                            tokenKey = placesResult[
                                                    'next_page_token'] ??
                                                'none';

                                            placesWithin.forEach((element) {
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
                                            });
                                          } else {
                                            print('Thats all folks!!');
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.more_time,
                                          color: Colors.blue)):*/
                        IconButton(
                            onPressed: () {
                              setState(() {
                                radiusSlider = false;
                                pressedNear = false;
                                cardTapped = false;
                                /*radiusValue = 6000.0;*/

                                _markers = {};
                                allFavoritePlaces = [];
                              });
                            },
                            icon: Icon(Icons.close, color: Colors.red))
                      ],
                    ),
                  ),
                )
                    : Container(),
                pressedNear
                    ? Positioned(
                    bottom: 20.0,
                    child: Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: allFavoritePlaces.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _nearbyPlacesList(index);
                          }),
                    ))
                    : Container(),
                cardTapped
                    ? Positioned(
                    top: 100.0,
                    left: 15.0,
                    child: FlipCard(
                      front: Container(
                        height: 250.0,
                        width: 175.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0))),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              height: 150.0,
                              width: 175.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(placeImg != ''
                                          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                          : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              padding: EdgeInsets.all(7.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Address: ',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                      width: 105.0,
                                      child: Text(
                                        tappedPlaceDetail[
                                        'formatted_address'] ??
                                            'none given',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w400),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              padding:
                              EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact: ',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                      width: 105.0,
                                      child: Text(
                                        tappedPlaceDetail[
                                        'formatted_phone_number'] ??
                                            'none given',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w400),
                                      ))
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                      back: Container(
                        height: 300.0,
                        width: 225.0,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isReviews = true;
                                        isPhotos = false;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 700),
                                      curve: Curves.easeIn,
                                      padding: EdgeInsets.fromLTRB(
                                          7.0, 4.0, 7.0, 4.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(11.0),
                                          color: isReviews
                                              ? Colors.green.shade300
                                              : Colors.white),
                                      child: Text(
                                        'Reviews',
                                        style: TextStyle(
                                            color: isReviews
                                                ? Colors.white
                                                : Colors.black87,
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isReviews = false;
                                        isPhotos = true;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 700),
                                      curve: Curves.easeIn,
                                      padding: EdgeInsets.fromLTRB(
                                          7.0, 4.0, 7.0, 4.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(11.0),
                                          color: isPhotos
                                              ? Colors.green.shade300
                                              : Colors.white),
                                      child: Text(
                                        'Photos',
                                        style: TextStyle(
                                            color: isPhotos
                                                ? Colors.white
                                                : Colors.black87,
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 250.0,
                              child: isReviews
                                  ? ListView(
                                children: [
                                  if (isReviews &&
                                      tappedPlaceDetail['reviews'] !=
                                          null)
                                    ...tappedPlaceDetail['reviews']!
                                        .map((e) {
                                      return _buildReviewItem(e);
                                    })
                                ],
                              )
                                  : _buildPhotoGallery(
                                  tappedPlaceDetail['photos'] ?? []),
                            )
                          ],
                        ),
                      ),
                    ))
                    : Container()
              ],
            )
          ],
        ),
      ),
      floatingActionButton:FloatingActionButton(

        onPressed: () async {
          {
            Position position=await _determinePosition();
            googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 14)));

            _markers.clear();
            _markers.add(Marker(markerId: const MarkerId('Current Position'),position: LatLng(position.latitude, position.longitude),icon: BitmapDescriptor.defaultMarker));
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

            placesWithin.forEach((element) {
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
            });
            _markersDupe = _markers;
            pressedNear = true;
            radiusSlider=true;


            setState(() {});

          };
        },
        child: Icon(Icons.location_searching),
        backgroundColor: HexColor('#18731B'),) ,


    );



  }

  _buildReviewItem(review) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(review['profile_photo_url']),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 4.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 160.0,
                  child: Text(
                    review['author_name'],
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 3.0),
                RatingStars(
                  value: review['rating'] * 1.0,
                  starCount: 5,
                  starSize: 7,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 9.0),
                  valueLabelRadius: 7,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                  const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  valueLabelMargin: const EdgeInsets.only(right: 4),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                )
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              review['text'],
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Divider(color: Colors.grey.shade600, height: 1.0)
      ],
    );
  }

  _buildPhotoGallery(photoElement) {
    if (photoElement == null || photoElement.length == 0) {
      showBlankCard = true;
      return Container(
        child: Center(
          child: Text(
            'No Photos',
            style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 12.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      var placeImg = photoElement[photoGalleryIndex]['photo_reference'];
      var maxWidth = photoElement[photoGalleryIndex]['width'];
      var maxHeight = photoElement[photoGalleryIndex]['height'];
      var tempDisplayIndex = photoGalleryIndex + 1;

      return Column(
        children: [
          SizedBox(height: 10.0),
          Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photo_reference=$placeImg&key=$key'),
                      fit: BoxFit.cover))),
          SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != 0)
                    photoGalleryIndex = photoGalleryIndex - 1;
                  else
                    photoGalleryIndex = 0;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != 0
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Prev',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Text(
              '$tempDisplayIndex/' + photoElement.length.toString(),
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != photoElement.length - 1)
                    photoGalleryIndex = photoGalleryIndex + 1;
                  else
                    photoGalleryIndex = photoElement.length - 1;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != photoElement.length - 1
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ])
        ],
      );
    }
  }

  gotoPlace(double lat, double lng, double endLat, double endLng,
      Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));

    _setMarker(LatLng(lat, lng));
    _setMarker(LatLng(endLat, endLng));
  }

  Future<void> moveCameraSlightly() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
            ['location']['lat'] +
                0.0125,
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
            ['location']['lng'] +
                0.005),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
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
      child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
          if (cardTapped) {
            tappedPlaceDetail = await MapServices()
                .getPlace(allFavoritePlaces[index]['place_id']);
            setState(() {});
          }
          moveCameraSlightly();
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
      ),
    );
  }

  Future<void> goToTappedPlace() async {
    final GoogleMapController controller = await _controller.future;

    _markers = {};

    var selectedPlace = allFavoritePlaces[_pageController.page!.toInt()];

    _setNearMarker(
        LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        selectedPlace['name'] ?? 'no name',
        selectedPlace['types'],
        selectedPlace['business_status'] ?? 'none');

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 25.0),
            SizedBox(width: 4.0),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
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
      return Future.error('Lcation permissions are Permanently denied');

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